purchaseOrderId = parameters.get("purchaseOrderId")

if (purchaseOrderId) {
    userLogin = parameters.get("userLogin")

    purchaseOrder = from('PurchaseOrder').where('purchaseOrderId', purchaseOrderId).queryOne()
    context.purchaseOrder = purchaseOrder

    if (purchaseOrder) {
        validationsPu = from('validation').where('purchaseOrderId', purchaseOrderId).queryList()
        context.validationsPu = validationsPu

        rejetsPu = from('RejetOrder').where('purchaseOrderId', purchaseOrderId).queryList()
        context.rejetsPu = rejetsPu
    }

    notificationCommande = from('NotificationCommande').where('purchaseOrderId', purchaseOrderId).queryOne()
    context.notificationCommande = notificationCommande

    if (notificationCommande) {
        validationsNo = from('ValidationNotificationCommande').where('notificationCommandeId',notificationCommande.notificationCommandeId).queryList()
        context.validationsNo = validationsNo
        rejetsNo = from('RejetNotificationCommande').where('notificationCommandeId',notificationCommande.notificationCommandeId).queryList()
        context.rejetsNo = rejetsNo
    }

    authentificationPayement = from('AuthentificationPayement').where('purchaseOrderId', purchaseOrderId).queryOne()
    context.authentificationPayement = authentificationPayement

    if (authentificationPayement) {
        validationsPa = from('ValidationAuthentificationPayement').where('authentificationPayementId',authentificationPayement.authentificationPayementId).queryList()
        context.validationsPa = validationsPa
        rejetsPa = from('RejetAuthentificationPayement').where('authentificationPayementId', authentificationPayement.authentificationPayementId).queryList()
        context.rejetsPa = rejetsPa
    }

    autorisationLivraison = from('AutorisationLivraison').where('purchaseOrderId', purchaseOrderId).queryOne()
    context.autorisationLivraison = autorisationLivraison

    if (autorisationLivraison) {
        validationsLi = from('ValidationAutorisationLivraison').where('autorisationLivraisonId', autorisationLivraison.autorisationLivraisonId).queryList()
        context.validationsLi = validationsLi
        rejetsLi = from('RejetAutorisationLivraison').where('autorisationLivraisonId', autorisationLivraison.autorisationLivraisonId).queryList()
        context.rejetsLi = rejetsLi
    }

    ticketDePese = from('TicketDePese').where('purchaseOrderId', purchaseOrderId).queryOne()
    context.ticketDePese = ticketDePese

    if (ticketDePese) {
        validationsTi = from('ValidationTicketDePese').where('ticketDePeseId', ticketDePese.ticketDePeseId).queryList()
        context.validationsTi = validationsTi
        rejetsTi = from('RejetTicketDePese').where('ticketDePeseId', ticketDePese.ticketDePeseId).queryList()
        context.rejetsTi = rejetsTi

    }

    context.userLogin = userLogin
}