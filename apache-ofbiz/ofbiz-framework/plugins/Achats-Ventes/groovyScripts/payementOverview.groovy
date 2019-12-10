authentificationPayementId = parameters.get("authentificationPayementId")

userLogin = parameters.get("userLogin")

authentificationPayement = from('AuthentificationPayement').where('authentificationPayementId', authentificationPayementId).queryOne()
context.authentificationPayement = authentificationPayement

partyRole = from('PartyRole').where('partyId', userLogin.partyId).queryList()
context.partyRoles = partyRole

validations = from('ValidationAuthentificationPayement').where('authentificationPayementId', authentificationPayementId).queryList()
context.validations = validations

context.userLogin = userLogin