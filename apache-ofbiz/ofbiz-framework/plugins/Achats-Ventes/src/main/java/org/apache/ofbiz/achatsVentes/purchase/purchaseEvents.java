package org.apache.ofbiz.achatsVentes.purchase;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.ofbiz.base.util.Debug;
import org.apache.ofbiz.base.util.UtilMisc;
import org.apache.ofbiz.base.util.UtilValidate;
import org.apache.ofbiz.common.login.LoginServices;
import org.apache.ofbiz.entity.Delegator;
import org.apache.ofbiz.entity.GenericEntityException;
import org.apache.ofbiz.entity.GenericValue;
import org.apache.ofbiz.entity.util.EntityQuery;
import org.apache.ofbiz.entity.util.EntityUtilProperties;
import org.apache.ofbiz.service.GenericServiceException;
import org.apache.ofbiz.service.LocalDispatcher;

public class purchaseEvents {

    public static final String module = purchaseEvents.class.getName();

    public static String validationOrder(HttpServletRequest request, HttpServletResponse response) {

        Delegator delegator = (Delegator) request.getAttribute("delegator");
        LocalDispatcher dispatcher = (LocalDispatcher) request.getAttribute("dispatcher");
        GenericValue userLogin = (GenericValue) request.getSession().getAttribute("userLogin");

        String url = (String) request.getRequestURI();

        String pwd0 =  (String) request.getParameter("pwd");

        String username = userLogin.getString("userLoginId");

        String[] routes ={
                "/Achats-Ventes/control/validation",
                "/Achats-Ventes/control/validationNotificationCommande",
                "/Achats-Ventes/control/validationPayement",
                "/Achats-Ventes/control/validationAutorisationLivraison",
                "/Achats-Ventes/control/validationTicketDePese"
        };

        try {

            GenericValue    userLogin1 = EntityQuery.use(delegator).from("UserLogin")
                    .where("userLoginId", username)
                    .queryOne();

            boolean useEncryption = "true".equals(EntityUtilProperties
                    .getPropertyValue("security", "password.encrypt", delegator));

            boolean externalAuth = LoginServices.checkPassword(userLogin1
                    .getString("currentPassword"), useEncryption, pwd0);

            if (externalAuth) {
                if (url.equals(routes[0])) {

                    String purchaseOrderId =  (String) request.getParameter("purchaseOrderId");

                    dispatcher.runSync("validation",
                            UtilMisc.toMap("purchaseOrderId", purchaseOrderId,"userLogin", userLogin));
                    return "success";
                }
                if (url.equals(routes[1])) {

                    String notificationCommandeId =  (String) request.getParameter("notificationCommandeId");

                    dispatcher.runSync("validationNotificationCommande",
                            UtilMisc.toMap("notificationCommandeId", notificationCommandeId,"userLogin", userLogin));

                    return "success";
                }
                if (url.equals(routes[2])) {

                    String authentificationPayementId =  (String) request.getParameter("authentificationPayementId");

                    dispatcher.runSync("validationPayement",
                            UtilMisc.toMap("authentificationPayementId", authentificationPayementId,"userLogin", userLogin));

                    return "success";
                }
                if (url.equals(routes[3])) {

                    String autorisationLivraisonId =  (String) request.getParameter("autorisationLivraisonId");

                    dispatcher.runSync("validationAutorisationLivraison",
                            UtilMisc.toMap("autorisationLivraisonId", autorisationLivraisonId,"userLogin", userLogin));

                    return "success";
                }
               if (url.equals(routes[4])) {

                    String ticketDePeseId =  (String) request.getParameter("ticketDePeseId");

                    dispatcher.runSync("ValidationTicket",
                            UtilMisc.toMap("ticketDePeseId", ticketDePeseId,"userLogin", userLogin));

                    return "success";
                }

            } else {
                request.setAttribute("_ERROR_MESSAGE_", "invalid password");
                return "error";
            }

        }
        catch (GenericEntityException e) {
            e.printStackTrace();

        }catch (GenericServiceException e) {
            String errMsg = "imposible de lancer le service: " + e.toString();
            request.setAttribute("_ERROR_MESSAGE_", errMsg);
            return "error";
        }
        request.setAttribute("_ERROR_MESSAGE_", "invalid password");
        return "error";
    }

    public static String rejetOrder(HttpServletRequest request, HttpServletResponse response) {

        Delegator delegator = (Delegator) request.getAttribute("delegator");
        LocalDispatcher dispatcher = (LocalDispatcher) request.getAttribute("dispatcher");
        GenericValue userLogin = (GenericValue) request.getSession().getAttribute("userLogin");

        String url = (String) request.getRequestURI();

        String pwd0 =  (String) request.getParameter("pwd");

        String raisonRejet =  (String) request.getParameter("raisonRejet");

        String username = userLogin.getString("userLoginId");

        String[] routes ={
                "/Achats-Ventes/control/rejet",
                "/Achats-Ventes/control/rejetNotification",
                "/Achats-Ventes/control/rejetPayement",
                "/Achats-Ventes/control/rejetAutorisationLivraison",
                "/Achats-Ventes/control/rejetTicketDePese"
        };

        try {

            GenericValue    userLogin1 = EntityQuery.use(delegator).from("UserLogin")
                    .where("userLoginId", username)
                    .queryOne();

            boolean useEncryption = "true".equals(EntityUtilProperties
                    .getPropertyValue("security", "password.encrypt", delegator));

            boolean externalAuth = LoginServices.checkPassword(userLogin1
                    .getString("currentPassword"), useEncryption, pwd0);

            if (externalAuth) {
                if (url.equals(routes[0])) {

                    String purchaseOrderId =  (String) request.getParameter("purchaseOrderId");

                    dispatcher.runSync("rejet",
                            UtilMisc.toMap("purchaseOrderId", purchaseOrderId,"userLogin", userLogin,
                                    "raisonRejet",raisonRejet));
                    return "success";
                }
                if (url.equals(routes[1])) {

                    String notificationCommandeId =  (String) request.getParameter("notificationCommandeId");

                    dispatcher.runSync("rejetNotification",
                            UtilMisc.toMap("notificationCommandeId", notificationCommandeId,"userLogin", userLogin,
                                    "raisonRejet",raisonRejet));

                    return "success";
                }
                if (url.equals(routes[2])) {

                    String authentificationPayementId =  (String) request.getParameter("authentificationPayementId");

                    dispatcher.runSync("rejetPayement",
                            UtilMisc.toMap("authentificationPayementId", authentificationPayementId,"userLogin", userLogin
                            ,"raisonRejet",raisonRejet));

                    return "success";
                }
                if (url.equals(routes[3])) {

                    String autorisationLivraisonId =  (String) request.getParameter("autorisationLivraisonId");

                    dispatcher.runSync("rejetAutorisationLivraison",
                            UtilMisc.toMap("autorisationLivraisonId", autorisationLivraisonId,"userLogin", userLogin
                            ,"raisonRejet",raisonRejet));

                    return "success";
                }
                if (url.equals(routes[4])) {

                    String ticketDePeseId =  (String) request.getParameter("ticketDePeseId");

                    dispatcher.runSync("rejetTicket",
                            UtilMisc.toMap("ticketDePeseId", ticketDePeseId,"userLogin", userLogin
                                    ,"raisonRejet",raisonRejet));

                    return "success";
                }
                else {
                    request.setAttribute("_ERROR_MESSAGE_", "route inconnue");
                    return "error";
                }

            } else {
                request.setAttribute("_ERROR_MESSAGE_", "invalid password");
                return "error";
            }

        }
        catch (GenericEntityException e) {
            e.printStackTrace();

        }catch (GenericServiceException e) {
            String errMsg = "imposible de lancer le service: " + e.toString();
            request.setAttribute("_ERROR_MESSAGE_", errMsg);
            return "error";
        }
        request.setAttribute("_ERROR_MESSAGE_", "invalid password");
        return "error";
    }
}
