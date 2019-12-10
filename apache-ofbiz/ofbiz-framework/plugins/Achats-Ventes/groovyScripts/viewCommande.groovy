purchaseOrderId = parameters.get("purchaseOrderId")

userLogin = parameters.get("userLogin")

purchaseOrder = from('PurchaseOrder').where('purchaseOrderId', purchaseOrderId).queryOne()
context.purchaseOrder = purchaseOrder

partyRole = from('PartyRole').where('partyId', userLogin.partyId).queryList()
context.partyRoles = partyRole

validations = from('validation').where('purchaseOrderId', purchaseOrderId).queryList()
context.validations = validations

context.userLogin = userLogin

purchasePaymentMode = delegator.findList("PurchasePaymentMode", null, null, null, null, false);
context.purchasePaymentMode = purchasePaymentMode;