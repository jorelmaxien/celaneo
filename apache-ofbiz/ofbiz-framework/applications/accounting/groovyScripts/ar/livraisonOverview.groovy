autorisationLivraisonId = parameters.get("autorisationLivraisonId")

userLogin = parameters.get("userLogin")

autorisationLivraison = from('AutorisationLivraison').where('autorisationLivraisonId', autorisationLivraisonId).queryOne()
context.autorisationLivraison = autorisationLivraison

partyRole = from('PartyRole').where('partyId', userLogin.partyId).queryList()
context.partyRoles = partyRole

validations = from('ValidationAutorisationLivraison').where('autorisationLivraisonId', autorisationLivraisonId).queryList()
context.validations = validations

context.userLogin = userLogin