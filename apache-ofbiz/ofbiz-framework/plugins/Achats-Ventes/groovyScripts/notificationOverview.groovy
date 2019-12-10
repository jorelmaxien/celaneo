notificationCommandeId = parameters.get("notificationCommandeId")

userLogin = parameters.get("userLogin")

notificationCommande = from('NotificationCommande').where('notificationCommandeId', notificationCommandeId).queryOne()
context.notificationCommande = notificationCommande

partyRole = from('PartyRole').where('partyId', userLogin.partyId).queryList()
context.partyRoles = partyRole

validations = from('ValidationNotificationCommande').where('notificationCommandeId', notificationCommandeId).queryList()
context.validations = validations

context.userLogin = userLogin
