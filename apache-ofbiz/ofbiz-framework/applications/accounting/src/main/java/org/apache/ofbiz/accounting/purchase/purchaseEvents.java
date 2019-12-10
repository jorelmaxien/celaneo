package org.apache.ofbiz.accounting.purchase;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.ofbiz.base.crypto.HashCrypt;
import org.apache.ofbiz.base.util.Debug;
import org.apache.ofbiz.base.util.UtilMisc;
import org.apache.ofbiz.base.util.UtilValidate;
import org.apache.ofbiz.common.authentication.AuthHelper;
import org.apache.ofbiz.common.authentication.api.AuthenticatorException;
import org.apache.ofbiz.common.login.LoginServices;
import org.apache.ofbiz.entity.Delegator;
import org.apache.ofbiz.entity.GenericEntityException;
import org.apache.ofbiz.entity.GenericValue;
import org.apache.ofbiz.entity.util.EntityQuery;
import org.apache.ofbiz.entity.util.EntityUtilProperties;
import org.apache.ofbiz.service.GenericServiceException;
import org.apache.ofbiz.service.LocalDispatcher;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;


import org.apache.ofbiz.service.ServiceUtil;
import org.apache.poi.ss.usermodel.*;

public class purchaseEvents {



    public static final String module = purchaseEvents.class.getName();

    public static String uploadPurchase(HttpServletRequest request, HttpServletResponse response) {
        Delegator delegator = (Delegator) request.getAttribute("delegator");
        LocalDispatcher dispatcher = (LocalDispatcher) request.getAttribute("dispatcher");
        GenericValue userLogin = (GenericValue) request.getSession().getAttribute("userLogin");

        String ofbizDemoTypeId = request.getParameter("ofbizDemoTypeId");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");

        if (UtilValidate.isEmpty(firstName) || UtilValidate.isEmpty(lastName)) {
            String errMsg = "First Name and Last Name are required fields on the form and can't be empty.";
            request.setAttribute("_ERROR_MESSAGE_", errMsg);
            return "error";
        }
        String comments = request.getParameter("comments");

        try {
            Debug.logInfo("=======Creating OfbizDemo record in event using service createOfbizDemoByGroovyService=========", module);
            dispatcher.runSync("createOfbizDemoByGroovyService", UtilMisc.toMap("ofbizDemoTypeId", ofbizDemoTypeId,
                    "firstName", firstName, "lastName", lastName, "comments", comments, "userLogin", userLogin));
        } catch (GenericServiceException e) {
            String errMsg = "Unable to create new records in OfbizDemo entity: " + e.toString();
            request.setAttribute("_ERROR_MESSAGE_", errMsg);
            return "error";
        }
        request.setAttribute("_EVENT_MESSAGE_", "OFBiz Demo created succesfully.");
        return "success";
    }

    public static String validationOrder(HttpServletRequest request, HttpServletResponse response) {
        Delegator delegator = (Delegator) request.getAttribute("delegator");
        LocalDispatcher dispatcher = (LocalDispatcher) request.getAttribute("dispatcher");
        GenericValue userLogin = (GenericValue) request.getSession().getAttribute("userLogin");

        String url = (String) request.getRequestURI();

        String pwd0 =  (String) request.getParameter("pwd");

        String username = userLogin.getString("userLoginId");

        String[] routes ={"/ar/control/validation","/ar/control/validationNotificationCommande",
                "/ar/control/validationPayement","/ar/controlvalidationAutorisationLivraison/",
                "/ar/control/validationTicketDePese"};

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
}
