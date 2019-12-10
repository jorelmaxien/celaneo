package org.apache.ofbiz.achatsVentes.purchase;

import org.apache.ofbiz.achatsVentes.services.SendMail;
import org.apache.ofbiz.base.util.*;
import org.apache.ofbiz.entity.Delegator;
import org.apache.ofbiz.entity.GenericEntityException;
import org.apache.ofbiz.entity.GenericValue;
import org.apache.ofbiz.entity.condition.EntityCondition;
import org.apache.ofbiz.entity.condition.EntityOperator;
import org.apache.ofbiz.entity.util.EntityQuery;
import org.apache.ofbiz.service.DispatchContext;
import org.apache.ofbiz.service.LocalDispatcher;
import org.apache.ofbiz.service.ServiceUtil;

import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;


import java.util.*;
import java.util.stream.Collectors;

public class PurchaseServices {

    private Session session = null;
    private Transport transport = null;

    public static final String resource = "AccountingUiLabels";

    public static final String module = PurchaseServices.class.getName();

    public static Map<String, Object> createPurchaseOrder(DispatchContext dctx, Map<String, Object> context){
        Map<String, Object> result = ServiceUtil.returnSuccess();

        String partyId = (String) context.get("partyId");

        Delegator delegator = dctx.getDelegator();
        SendMail sendMail = new SendMail();


        try {

            GenericValue customer = EntityQuery.use(delegator)
                    .from("Person")
                    .where("partyId", partyId)
                    .queryOne();

            if (customer != null) {
                GenericValue purchaseOrder = delegator.makeValue("PurchaseOrder");

                purchaseOrder.setNextSeqId();

                purchaseOrder.setNonPKFields(context);
                purchaseOrder.put("purchaseOrderStatusId", "3");

                purchaseOrder = delegator.create(purchaseOrder);

                List<GenericValue> partyRole = EntityQuery.use(delegator).from("PartyRole").where("roleTypeId", "cd").queryList();

                if( partyRole.size() > 0) {

                    GenericValue test = null;

                    for (int i = 0; i < partyRole.size (); i++){

                        test = partyRole.get(i);

                        List<GenericValue> partyContactMech = EntityQuery.use(delegator).from("PartyContactMech").where("partyId", test.getString("partyId")).queryList();

                        if( partyContactMech.size() > 0) {

                            GenericValue test1 = null;

                            for (int a = 0; a < partyContactMech.size (); a++){

                                test1 = partyContactMech.get(a);

                                GenericValue contactMech = EntityQuery.use(delegator).from("ContactMech").where("contactMechId", test1.getString("contactMechId")).queryOne();

                                sendMail.sendConf(contactMech.getString("infoString"), "nouvelle commande", "nouvelle commande de "+
                                        purchaseOrder.getRelatedOne("Person").get("firstName")+" "+
                                        purchaseOrder.getRelatedOne("Person").get("lastName") +" \n" +
                                        "numero de commande :"+ purchaseOrder.getString("purchaseOrderId") );
                            }

                        }

                    }

                }
                return ServiceUtil.returnSuccess("la commande a ete creer ");
            }
            return ServiceUtil.returnError("it's customer not existe ........");
        } catch (GenericEntityException e) {
            Debug.logError(e, module);
            e.printStackTrace();
            return ServiceUtil.returnError("Error creating Pre-Order entity ........");
        }

        catch (MessagingException ex) {
            Debug.logError(ex, "mail errorr**************************************************************");
            return ServiceUtil.returnError("Error mail send ........");
        }

    }

    public static Map<String, Object> validationOrder(DispatchContext dctx, Map<String, Object> context){
        String purchaseOrderId = (String) context.get("purchaseOrderId");
        GenericValue userLogin = (GenericValue) context.get("userLogin");
        Delegator delegator = dctx.getDelegator();
        try {
            List<GenericValue> partyRoles = EntityQuery.use(delegator)
                    .from("PartyRole")
                    .where("partyId", userLogin.getString("partyId"))
                    .queryList();

            partyRoles = partyRoles.stream()
                    .filter(x->x.getString("roleTypeId")
                    .equals("Direction des ventes"))
                    .collect(Collectors.toList());


           if (partyRoles.size()>0){

               GenericValue purchaseOrder = EntityQuery.use(delegator)
                       .from("PurchaseOrder")
                       .where("purchaseOrderId", purchaseOrderId)
                       .queryOne();

               if (purchaseOrderId != null && purchaseOrder != null){
               GenericValue val = EntityQuery.use(delegator)
                   .from("validation")
                   .where(EntityCondition.makeCondition("purchaseOrderId", EntityOperator.EQUALS, purchaseOrderId),
                           EntityCondition.makeCondition("partyId", EntityOperator.EQUALS, userLogin.get("partyId")))
                   .queryOne();

               if(val != null){
                   return ServiceUtil.returnError("vous avez deja signe le doc........");
               }
               if(purchaseOrder.getString("purchaseOrderStatusId")
                           .equals("1") ||
                 purchaseOrder.getString("purchaseOrderStatusId")
                           .equals("2")
               ){
                   return ServiceUtil.returnError("vous ne pouvez pas effectuer........");
               }

               GenericValue validation = delegator.makeValue("validation");

               validation.setNextSeqId();

               validation.setNonPKFields(context);

               validation.set("roleTypeId",partyRoles.get(0).getString("roleTypeId"));

               validation.set("partyId", userLogin.getString("partyId"));

               delegator.create(validation);

               purchaseOrder.put("purchaseOrderStatusId", "1");
               purchaseOrder.store();

               GenericValue notificationCommande = delegator.makeValue("NotificationCommande");
               notificationCommande.setNextSeqId();
               notificationCommande.set("purchaseOrderId", purchaseOrderId);
               notificationCommande.set("purchaseOrderStatusId", "3");

               delegator.create(notificationCommande);
               return ServiceUtil.returnSuccess("le document a ete signer avec succes");
           }
            }

        } catch (GenericEntityException e) {
            return ServiceUtil.returnError("erreur de requet a la base de donnee ........");
        }

        return ServiceUtil.returnError("acces refuser");
    }

    public static Map<String, Object> rejetOrder(DispatchContext dctx, Map<String, Object> context){
        String purchaseOrderId = (String) context.get("purchaseOrderId");
        GenericValue userLogin = (GenericValue) context.get("userLogin");
        Delegator delegator = dctx.getDelegator();
        try {
            List<GenericValue> partyRoles = EntityQuery.use(delegator).from("PartyRole")
                    .where("partyId", userLogin.getString("partyId"))
                    .queryList();

            partyRoles = partyRoles.stream()
                    .filter(x->x.getString("roleTypeId")
                            .equals("Direction des ventes"))
                    .collect(Collectors.toList());


            if (partyRoles.size()>0){

                GenericValue purchaseOrder = EntityQuery.use(delegator).from("PurchaseOrder")
                        .where("purchaseOrderId", purchaseOrderId)
                        .queryOne();

                if (purchaseOrderId != null && purchaseOrder != null){
                    GenericValue val = EntityQuery.use(delegator)
                            .from("RejetOrder")
                            .where(EntityCondition.makeCondition("purchaseOrderId", EntityOperator.EQUALS, purchaseOrderId),
                                    EntityCondition.makeCondition("partyId", EntityOperator.EQUALS, userLogin.get("partyId")))
                            .queryOne();

                    if(val != null){
                        return ServiceUtil.returnError("vous avez deja rejetter le doc........");
                    }
                    if(purchaseOrder.getString("purchaseOrderStatusId")
                            .equals("1") ||
                            purchaseOrder.getString("purchaseOrderStatusId")
                                    .equals("2")
                    ){
                        return ServiceUtil.returnError("vous ne pouvez pas effectuer........");
                    }

                    GenericValue rejet = delegator.makeValue("RejetOrder");

                    rejet.setNextSeqId();

                    rejet.setNonPKFields(context);

                    rejet.set("roleTypeId",partyRoles.get(0).getString("roleTypeId"));

                    rejet.set("partyId", userLogin.getString("partyId"));

                    delegator.create(rejet);

                    purchaseOrder.put("purchaseOrderStatusId", "2");
                    purchaseOrder.store();

                    return ServiceUtil.returnSuccess("le document a ete rejeter avec succes");
                }
            }

        } catch (GenericEntityException e) {
            return ServiceUtil.returnError("erreur a la base de donnee ........");
        }

        return ServiceUtil.returnError("acces refuser");
    }

    public static Map<String, Object> updatePurchase(DispatchContext dctx, Map<String, Object> context) {
        Delegator delegator = dctx.getDelegator();
        String purchaseOrderId = (String) context.get("purchaseOrderId");
        try {
            GenericValue purchaseOrder = EntityQuery.use(delegator)
                    .from("PurchaseOrder")
                    .where("purchaseOrderId", purchaseOrderId)
                    .queryOne();

            GenericValue purchaseOrder2 = delegator.makeValue("PurchaseOrder");

            purchaseOrder2.setNonPKFields(context);

            if (purchaseOrder == null) {
                return ServiceUtil.returnError("la commande existe pas"+purchaseOrderId);
            }
            if(purchaseOrder.getString("purchaseOrderStatusId")
                    .equals("1") ||
                    purchaseOrder.getString("purchaseOrderStatusId")
                            .equals("2")
            ){
                return ServiceUtil.returnError("vous ne pouvez pas effectuer........");
            }
           purchaseOrder.put("phone", purchaseOrder2.get("phone"));
           purchaseOrder.put("zone", purchaseOrder2.get("zone"));
           purchaseOrder.put("nature", purchaseOrder2.get("nature"));
           purchaseOrder.put("quantite", purchaseOrder2.get("quantite"));
           purchaseOrder.put("pu", purchaseOrder2.get("pu"));
           purchaseOrder.put("valeurTotal", purchaseOrder2.get("valeurTotal"));
           purchaseOrder.put("purchasePaymentModeId", purchaseOrder2.get("purchasePaymentModeId"));
           purchaseOrder.put("paymentPlace", purchaseOrder2.get("paymentPlace"));
           purchaseOrder.store();

            return ServiceUtil.returnSuccess("la commande a ete modifier avec succes.......");

        } catch (GenericEntityException e) {
            Debug.logError(e, module);
            return ServiceUtil.returnError("Error in creating record in PurchaseServices entity ........" +module);
        }

    }

    public static Map<String, Object> rejetNotification(DispatchContext dctx, Map<String, Object> context){

        SendMail sendMail = new SendMail();
        GenericValue userLogin = (GenericValue) context.get("userLogin");
        String notificationCommandeId = (String) context.get("notificationCommandeId");
        Delegator delegator = dctx.getDelegator();

        try {

            List<GenericValue> partyRoles = EntityQuery.use(delegator).from("PartyRole")
                    .where("partyId", userLogin.getString("partyId"))
                    .queryList();


            partyRoles = partyRoles.stream()
                    .filter(x->x.getString("roleTypeId").equals("Direction de gestion") ||
                            x.getString("roleTypeId").equals("Direction commercial"))
                    .collect(Collectors.toList());

            if (partyRoles.size()>0){

                GenericValue notificationCommande2 = delegator.makeValue("NotificationCommande");

                GenericValue notificationCommande = EntityQuery.use(delegator)
                        .from("NotificationCommande")
                        .where("notificationCommandeId", notificationCommandeId)
                        .queryOne();

                notificationCommande2.setNonPKFields(context);

                if (notificationCommande != null && notificationCommandeId != null){
                    GenericValue val = EntityQuery.use(delegator)
                            .from("RejetNotificationCommande")
                            .where(EntityCondition.makeCondition("notificationCommandeId", EntityOperator.EQUALS, notificationCommandeId),
                                    EntityCondition.makeCondition("partyId", EntityOperator.EQUALS, userLogin.get("partyId")))
                            .queryOne();

                    if(val != null){
                        return ServiceUtil.returnError("vous avez deja rejetter le doc........");
                    }
                    if(notificationCommande.getString("purchaseOrderStatusId")
                            .equals("1") ||
                            notificationCommande.getString("purchaseOrderStatusId")
                                    .equals("2")
                    ){
                        return ServiceUtil.returnError("cette notificationCommande ne peut etre modifier........");
                    }

                    GenericValue rejet = delegator.makeValue("RejetNotificationCommande");

                    rejet.setNextSeqId();

                    rejet.setNonPKFields(context);

                    rejet.set("partyId", userLogin.getString("partyId"));

                    rejet.set("notificationCommandeId", notificationCommandeId);

                    rejet.set("roleTypeId", partyRoles.get(0).getString("roleTypeId"));

                    delegator.create(rejet);
                    notificationCommande.put("purchaseOrderStatusId", "2");

                    notificationCommande.store();

                    return ServiceUtil.returnSuccess("la commande notification de commande numero:"+notificationCommandeId+"a ete rejeter avec succes");
                }

                return ServiceUtil.returnError("cette NotificationCommande existe pas........");
            }

            return ServiceUtil.returnError("vous avez pas les droits pour cette action  ........");
        } catch (GenericEntityException e) {
            Debug.logError(e, module);
            return ServiceUtil.returnError("Error in creating record in PurchaseServices entity ........" +module);
        }


    }

    public static Map<String, Object> validationNotification(DispatchContext dctx, Map<String, Object> context){
        String notificationCommandeId = (String) context.get("notificationCommandeId");
        GenericValue userLogin = (GenericValue) context.get("userLogin");
        Delegator delegator = dctx.getDelegator();

        try {

            List<GenericValue> partyRoles = EntityQuery.use(delegator)
                    .from("PartyRole")
                    .where("partyId", userLogin.getString("partyId"))
                    .queryList();

            partyRoles = partyRoles.stream()
                    .filter(x->x.getString("roleTypeId").equals("Direction de gestion") ||
                            x.getString("roleTypeId").equals("Direction commercial"))
                    .collect(Collectors.toList());

            if (partyRoles.size()>0){

                GenericValue notificationCommande = EntityQuery.use(delegator)
                        .from("NotificationCommande")
                        .where("notificationCommandeId",notificationCommandeId)
                        .queryOne();
                if (notificationCommandeId != null && notificationCommande != null){
                    GenericValue val = EntityQuery.use(delegator)
                            .from("ValidationNotificationCommande")
                            .where(EntityCondition.makeCondition("notificationCommandeId", EntityOperator.EQUALS, notificationCommandeId),
                                    EntityCondition.makeCondition("partyId", EntityOperator.EQUALS, userLogin.get("partyId")))
                            .queryOne();
                    if(val != null ||
                            notificationCommande.getString("purchaseOrderStatusId")
                                    .equals("2") ||
                            notificationCommande.getString("purchaseOrderStatusId")
                                    .equals("1")
                    ){
                        return ServiceUtil.returnError("vous avez deja signe le doc........");
                    }

                    GenericValue validation = delegator.makeValue("ValidationNotificationCommande");

                    validation.setNextSeqId();

                    validation.set("partyId", userLogin.getString("partyId"));

                    validation.set("notificationCommandeId", notificationCommandeId);
                    validation.set("roleTypeId", partyRoles.get(0).getString("roleTypeId"));

                    delegator.create(validation);

                    GenericValue validationNots1 = EntityQuery.use(delegator)
                            .from("ValidationNotificationCommande")
                            .where(EntityCondition.makeCondition("notificationCommandeId", EntityOperator.EQUALS, notificationCommandeId),
                                    EntityCondition.makeCondition("roleTypeId", EntityOperator.EQUALS, "Direction commercial"))
                            .queryOne();
                    GenericValue validationNots2 = EntityQuery.use(delegator)
                            .from("ValidationNotificationCommande")
                            .where(EntityCondition.makeCondition("notificationCommandeId", EntityOperator.EQUALS, notificationCommandeId),
                                    EntityCondition.makeCondition("roleTypeId", EntityOperator.EQUALS, "Direction de gestion"))
                            .queryOne();

                    if (validationNots1 != null && validationNots2 != null ){
                        notificationCommande.put("purchaseOrderStatusId","1");
                        notificationCommande.store();
                        GenericValue authentificationPayement = delegator.makeValue("AuthentificationPayement");
                        authentificationPayement.setNextSeqId();
                        authentificationPayement.set("purchaseOrderId", notificationCommande.getString("purchaseOrderId"));
                        authentificationPayement.set("notificationCommandeId", notificationCommande.getString("notificationCommandeId"));
                        authentificationPayement.set("purchaseOrderStatusId", "3");
                        delegator.create(authentificationPayement);

                    }

                    return ServiceUtil.returnSuccess("la commande notification de commande numero:"+notificationCommandeId+"a ete valider avec succes");
                }

                return ServiceUtil.returnError("la NotificationCommande id: "+notificationCommandeId+"existe pas .........");

            }
            return ServiceUtil.returnError("vous avez pas les droits pour cette action  ........");


        } catch (GenericEntityException e) {
            return ServiceUtil.returnError("Error in creating record in OfbizDemo entity ........");
        }
    }

    public static Map<String, Object> validationPayement(DispatchContext dctx, Map<String, Object> context){
        Map<String, Object> result = ServiceUtil.returnSuccess();
        String authentificationPayementId = (String) context.get("authentificationPayementId");
        GenericValue userLogin = (GenericValue) context.get("userLogin");
        Delegator delegator = dctx.getDelegator();

        try {

            List<GenericValue> partyRoles = EntityQuery.use(delegator).from("PartyRole")
                    .where("partyId", userLogin.getString("partyId")).queryList();

            partyRoles = partyRoles.stream()
                    .filter(x->x.getString("roleTypeId").equals("Direction financière"))
                    .collect(Collectors.toList());

            if (partyRoles.size()>0){

                GenericValue authentificationPayement = EntityQuery.use(delegator)
                        .from("AuthentificationPayement")
                        .where("authentificationPayementId",authentificationPayementId).queryOne();

                if (authentificationPayementId != null && authentificationPayement != null){
                    GenericValue val = EntityQuery.use(delegator)
                            .from("ValidationAuthentificationPayement")
                            .where(EntityCondition.makeCondition("authentificationPayementId", EntityOperator.EQUALS, authentificationPayementId),
                                    EntityCondition.makeCondition("partyId", EntityOperator.EQUALS, userLogin.get("partyId")))
                            .queryOne();

                    if(val != null ||
                            authentificationPayement.getString("purchaseOrderStatusId")
                                    .equals("2") ||
                            authentificationPayement.getString("purchaseOrderStatusId")
                                    .equals("1")
                    ){
                        return ServiceUtil.returnError("vous avez deja signe le doc........");
                    }

                    GenericValue validation = delegator.makeValue("ValidationAuthentificationPayement");

                    validation.setNextSeqId();

                    validation.set("partyId", userLogin.getString("partyId"));

                    validation.set("authentificationPayementId", authentificationPayementId);
                    validation.set("roleTypeId", partyRoles.get(0).getString("roleTypeId"));

                    delegator.create(validation);

                    authentificationPayement.put("purchaseOrderStatusId","1");
                    authentificationPayement.store();

                    GenericValue autorisationLivraison = delegator.makeValue("AutorisationLivraison");
                    autorisationLivraison.setNextSeqId();
                    autorisationLivraison.set("purchaseOrderId", authentificationPayement.getString("purchaseOrderId"));
                    autorisationLivraison.set("purchaseOrderStatusId","3");
                    autorisationLivraison.set("notificationCommandeId", authentificationPayement.getString("notificationCommandeId"));
                    autorisationLivraison.set("authentificationPayementId", authentificationPayement.getString("authentificationPayementId"));
                    delegator.create(autorisationLivraison);

                    return ServiceUtil.returnSuccess("la commande notification de commande numero:"+authentificationPayementId+"a ete valider avec succes");

                }

                return ServiceUtil.returnError("id notification de commande erroner........");

            }
            return ServiceUtil.returnError("vous avez pas les droits pour cette action  ........");


        } catch (GenericEntityException e) {
            return ServiceUtil.returnError("Error in creating record in OfbizDemo entity ........");
        }
    }

    public static Map<String, Object> rejetPayement(DispatchContext dctx, Map<String, Object> context){
        Map<String, Object> result = ServiceUtil.returnSuccess();
        String authentificationPayementId = (String) context.get("authentificationPayementId");
        String raisonRejet = (String) context.get("raisonRejet");
        GenericValue userLogin = (GenericValue) context.get("userLogin");
        Delegator delegator = dctx.getDelegator();

        try {


            List<GenericValue> partyRoles = EntityQuery.use(delegator).from("PartyRole")
                    .where("partyId", userLogin.getString("partyId")).queryList();

            partyRoles = partyRoles.stream()
                    .filter(x->x.getString("roleTypeId").equals("Direction financière"))
                    .collect(Collectors.toList());

            if (partyRoles.size()>0){


                GenericValue authentificationPayement = EntityQuery.use(delegator)
                        .from("AuthentificationPayement")
                        .where("authentificationPayementId",authentificationPayementId).queryOne();

                if (authentificationPayementId != null && authentificationPayement != null){
                    GenericValue val = EntityQuery.use(delegator)
                            .from("RejetAuthentificationPayement")
                            .where("authentificationPayementId", authentificationPayementId)
                            .queryOne();

                    if(val != null ||
                            authentificationPayement.getString("purchaseOrderStatusId")
                                    .equals("2")
                    ){
                        return ServiceUtil.returnError("vous avez deja rejet le doc........");
                    }

                    if(authentificationPayement.getString("purchaseOrderStatusId")
                            .equals("1")
                    ){
                        return ServiceUtil.returnError(" le doc a deja ete valider........");
                    }

                    GenericValue validation = delegator.makeValue("RejetAuthentificationPayement");

                    validation.setNextSeqId();

                    validation.set("partyId", userLogin.getString("partyId"));
                    validation.set("raisonRejet", raisonRejet);

                    validation.set("authentificationPayementId", authentificationPayementId);
                    validation.set("roleTypeId", partyRoles.get(0).getString("roleTypeId"));

                    delegator.create(validation);

                    authentificationPayement.put("purchaseOrderStatusId","2");
                    authentificationPayement.store();


                    return ServiceUtil.returnSuccess("la commande notification de commande numero:"+authentificationPayementId+"a ete valider avec succes");


                }

                return ServiceUtil.returnError("id notification de commande erroner........");

            }
            return ServiceUtil.returnError("vous avez pas les droits pour cette action  ........");


        } catch (GenericEntityException e) {
            return ServiceUtil.returnError("Error in creating record in OfbizDemo entity ........");
        }
    }

    public static Map<String, Object> validationAutorisationLivraison(DispatchContext dctx, Map<String, Object> context){
        Map<String, Object> result = ServiceUtil.returnSuccess();
        String autorisationLivraisonId = (String) context.get("autorisationLivraisonId");
        GenericValue userLogin = (GenericValue) context.get("userLogin");
        Delegator delegator = dctx.getDelegator();

        try {

            List<GenericValue> partyRoles = EntityQuery.use(delegator)
                    .from("PartyRole").where("partyId", userLogin.getString("partyId"))
                    .queryList();

             partyRoles =  partyRoles.stream()
                    .filter(a->a.getString("roleTypeId").equals("Direction des ventes") ||
                            a.getString("roleTypeId").equals("Direction des stocks")||
                            a.getString("roleTypeId").equals("Direction usine")||
                            a.getString("roleTypeId").equals("Direction poids"))
                    .collect(Collectors.toList());

            if (partyRoles.size()>=1){
                GenericValue autorisationLivraison = EntityQuery.use(delegator)
                        .from("AutorisationLivraison")
                        .where("autorisationLivraisonId",autorisationLivraisonId).queryOne();

                if (autorisationLivraisonId != null && autorisationLivraison != null){
                    GenericValue val = EntityQuery.use(delegator)
                            .from("ValidationAutorisationLivraison")
                            .where(EntityCondition.makeCondition("autorisationLivraisonId", EntityOperator.EQUALS, autorisationLivraisonId),
                                    EntityCondition.makeCondition("partyId", EntityOperator.EQUALS, userLogin.get("partyId")))
                            .queryOne();

                    if(val != null ||
                            autorisationLivraison.getString("purchaseOrderStatusId")
                                    .equals("2") ||
                            autorisationLivraison.getString("purchaseOrderStatusId")
                                    .equals("1")
                    ){
                        return ServiceUtil.returnError("vous avez deja signe le doc........");
                    }

                        GenericValue validation = delegator.makeValue("ValidationAutorisationLivraison");

                        validation.setNextSeqId();

                        validation.set("partyId", userLogin.getString("partyId"));

                        validation.set("autorisationLivraisonId", autorisationLivraisonId);
                        validation.set("roleTypeId", partyRoles.get(0).getString("roleTypeId"));

                        delegator.create(validation);

                    List<GenericValue> validationLiv= EntityQuery.use(delegator)
                            .from("ValidationAutorisationLivraison")
                            .where("autorisationLivraisonId", autorisationLivraisonId)
                            .queryList();

                    if (validationLiv.stream()
                                    .filter(x->x.getString("roleTypeId").equals("Direction des ventes"))
                                    .collect(Collectors.toList())
                                    .size()
                                        >=1){
                        if (validationLiv.stream()
                                .filter(x->x.getString("roleTypeId").equals("Direction des stocks"))
                                .collect(Collectors.toList())
                                .size()
                                >=1){
                            if (validationLiv.stream()
                                    .filter(x->x.getString("roleTypeId").equals("Direction usine"))
                                    .collect(Collectors.toList())
                                    .size()
                                    >=1){
                                if (validationLiv.stream()
                                        .filter(x->x.getString("roleTypeId").equals("Direction poids"))
                                        .collect(Collectors.toList())
                                        .size()
                                        >=1){
                                    autorisationLivraison.put("purchaseOrderStatusId","1");
                                    autorisationLivraison.store();
                                    GenericValue ticket = delegator.makeValue("TicketDePese");
                                    ticket.setNextSeqId();
                                    ticket.set("purchaseOrderStatusId","3");
                                    ticket.set("authentificationPayementId", autorisationLivraison.getString("authentificationPayementId"));
                                    ticket.set("purchaseOrderId",autorisationLivraison.getString("purchaseOrderId"));
                                    delegator.create(ticket);
                                }
                            }
                        }
                    }


                        return ServiceUtil.returnSuccess("la commande notification de commande numero:"+autorisationLivraisonId+"a ete valider avec succes");

                }

                return ServiceUtil.returnError("id notification de commande erroner........");
        }
            return ServiceUtil.returnError("vous avez pas les droit pour cette action ........");

        } catch (GenericEntityException e) {
            return ServiceUtil.returnError("Error in creating record in OfbizDemo entity ........");
        }
    }

    public static Map<String, Object> rejetAutorisationLivraison(DispatchContext dctx, Map<String, Object> context){
        Map<String, Object> result = ServiceUtil.returnSuccess();
        String autorisationLivraisonId = (String) context.get("autorisationLivraisonId");
        String raisonRejet = (String) context.get("raisonRejet");
        GenericValue userLogin = (GenericValue) context.get("userLogin");
        Delegator delegator = dctx.getDelegator();

        try {

            List<GenericValue> partyRoles = EntityQuery.use(delegator).from("PartyRole").where("partyId", userLogin.getString("partyId")).queryList();
            partyRoles.stream()
                    .filter(a->a.getString("roleTypeId").equals("Direction de vente") ||
                            a.getString("roleTypeId").equals("Direction des stock")||
                            a.getString("roleTypeId").equals("Direction usine")||
                            a.getString("roleTypeId").equals("Direction poids"))
                    .collect(Collectors.toList());

            if (partyRoles.size()>=1) {
                GenericValue autorisationLivraison = EntityQuery.use(delegator)
                        .from("AutorisationLivraison")
                        .where("autorisationLivraisonId",autorisationLivraisonId).queryOne();

                if (autorisationLivraisonId != null && autorisationLivraison != null){
                    GenericValue val = EntityQuery.use(delegator)
                            .from("ValidationAutorisationLivraison")
                            .where(EntityCondition.makeCondition("autorisationLivraisonId", EntityOperator.EQUALS, autorisationLivraisonId),
                                    EntityCondition.makeCondition("partyId", EntityOperator.EQUALS, userLogin.get("partyId")))
                            .queryOne();

                    if(val != null ||
                            autorisationLivraison.getString("purchaseOrderStatusId")
                                    .equals("2") ||
                            autorisationLivraison.getString("purchaseOrderStatusId")
                                    .equals("1")
                    ){
                        return ServiceUtil.returnError("vous avez deja signe le doc........");
                    }

                        GenericValue rejet = delegator.makeValue("RejetAutorisationLivraison");

                        rejet.setNextSeqId();

                        rejet.set("partyId", userLogin.getString("partyId"));

                        rejet.set("autorisationLivraisonId", autorisationLivraisonId);

                        rejet.set("raisonRejet", raisonRejet);

                        rejet.set("roleTypeId", partyRoles.get(0).getString("roleTypeId"));

                        delegator.create(rejet);

                        autorisationLivraison.put("purchaseOrderStatusId","2");
                        autorisationLivraison.store();

                        return ServiceUtil.returnSuccess("la commande notification de commande numero:"+autorisationLivraisonId+"a ete valider avec succes");

                }

                return ServiceUtil.returnError("id notification de commande erroner........");
        }
            return ServiceUtil.returnError("vous avez pas les droit pour cette action ........");

        } catch (GenericEntityException e) {
            return ServiceUtil.returnError("Error in creating record in OfbizDemo entity ........");
        }
    }

    public static Map<String, Object> ValidationTicketDePese(DispatchContext dctx, Map<String, Object> context){
        Map<String, Object> result = ServiceUtil.returnSuccess();
        String ticketDePeseId = (String) context.get("ticketDePeseId");
        GenericValue userLogin = (GenericValue) context.get("userLogin");
        Delegator delegator = dctx.getDelegator();

        try {

            List<GenericValue> partyRoles = EntityQuery.use(delegator)
                    .from("PartyRole")
                    .where("partyId", userLogin.getString("partyId"))
                    .queryList();
            partyRoles = partyRoles.stream()
                    .filter(a->a.getString("roleTypeId").equals("Direction poids"))
                    .collect(Collectors.toList());

            if (partyRoles.size()>=1) {
                GenericValue ticketPese = EntityQuery.use(delegator)
                        .from("TicketDePese")
                        .where("ticketDePeseId",ticketDePeseId).queryOne();

                if (ticketDePeseId != null && ticketPese != null){
                    GenericValue val = EntityQuery.use(delegator)
                            .from("ValidationTicketDePese")
                            .where(EntityCondition.makeCondition("ticketDePeseId", EntityOperator.EQUALS, ticketDePeseId),
                                    EntityCondition.makeCondition("partyId", EntityOperator.EQUALS, userLogin.get("partyId")))
                            .queryOne();

                    if(val != null ||
                            ticketPese.getString("purchaseOrderStatusId")
                                    .equals("2") ||
                            ticketPese.getString("purchaseOrderStatusId")
                                    .equals("1")
                    ){
                        return ServiceUtil.returnError("vous avez deja signe le doc........");
                    }

                        GenericValue validation = delegator.makeValue("ValidationTicketDePese");

                        validation.setNextSeqId();

                        validation.set("partyId", userLogin.getString("partyId"));

                        validation.set("ticketDePeseId", ticketDePeseId);

                        validation.set("roleTypeId", partyRoles.get(0).getString("roleTypeId"));

                        delegator.create(validation);

                        ticketPese.put("purchaseOrderStatusId","1");
                        ticketPese.store();

                        return ServiceUtil.returnSuccess("la commande notification de commande numero:"+ticketDePeseId+"a ete valider avec succes");

                }

                return ServiceUtil.returnError("id notification de commande erroner........");
        }
            return ServiceUtil.returnError("vous avez pas les droit pour cette action ........");

        } catch (GenericEntityException e) {
            return ServiceUtil.returnError("Error in creating record in OfbizDemo entity ........");
        }
    }

    public static Map<String, Object> rejetTicketDePese(DispatchContext dctx, Map<String, Object> context){
        Map<String, Object> result = ServiceUtil.returnSuccess();
        String ticketDePeseId = (String) context.get("ticketDePeseId");
        String raisonRejet = (String) context.get("raisonRejet");
        GenericValue userLogin = (GenericValue) context.get("userLogin");
        Delegator delegator = dctx.getDelegator();

        try {

            List<GenericValue> partyRoles = EntityQuery.use(delegator).from("PartyRole").where("partyId", userLogin.getString("partyId")).queryList();
            partyRoles = partyRoles.stream()
                    .filter(a->a.getString("roleTypeId").equals("Direction poids"))
                    .collect(Collectors.toList());

            if (partyRoles.size()>=1) {
                GenericValue ticketPese = EntityQuery.use(delegator)
                        .from("TicketDePese")
                        .where("ticketDePeseId",ticketDePeseId).queryOne();

                if (ticketDePeseId != null && ticketPese != null){
                    GenericValue val = EntityQuery.use(delegator)
                            .from("RejetTicketDePese")
                            .where(EntityCondition.makeCondition("ticketDePeseId", EntityOperator.EQUALS, ticketDePeseId),
                                    EntityCondition.makeCondition("partyId", EntityOperator.EQUALS, userLogin.get("partyId")))
                            .queryOne();

                    if(val != null ||
                            ticketPese.getString("purchaseOrderStatusId")
                                    .equals("2") ||
                            ticketPese.getString("purchaseOrderStatusId")
                                    .equals("1")
                    ){
                        return ServiceUtil.returnError("vous avez deja signe le doc........");
                    }

                        GenericValue rejet = delegator.makeValue("RejetTicketDePese");

                        rejet.setNextSeqId();

                        rejet.set("partyId", userLogin.getString("partyId"));

                        rejet.set("ticketDePeseId", ticketDePeseId);

                        rejet.set("raisonRejet", raisonRejet);

                        rejet.set("roleTypeId", partyRoles.get(0).getString("roleTypeId"));

                        delegator.create(rejet);

                        ticketPese.put("purchaseOrderStatusId","2");
                        ticketPese.store();

                        return ServiceUtil.returnSuccess("la commande notification de commande numero:"+ticketDePeseId+"a ete valider avec succes");

                }

                return ServiceUtil.returnError("id notification de commande erroner........");
        }
            return ServiceUtil.returnError("vous avez pas les droit pour cette action ........");

        } catch (GenericEntityException e) {
            return ServiceUtil.returnError("Error in creating record in OfbizDemo entity ........");
        }
    }

}

