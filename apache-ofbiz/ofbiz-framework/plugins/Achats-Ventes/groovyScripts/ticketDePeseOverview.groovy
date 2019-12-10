ticketDePeseId = parameters.get("ticketDePeseId")

userLogin = parameters.get("userLogin")

ticketDePese = from('TicketDePese').where('ticketDePeseId', ticketDePeseId).queryOne()
context.ticketDePese = ticketDePese

partyRole = from('PartyRole').where('partyId', userLogin.partyId).queryList()
context.partyRoles = partyRole

validations = from('ValidationTicketDePese').where('ticketDePeseId', ticketDePeseId).queryList()
context.validations = validations

context.userLogin = userLogin