<div class="col-xl-5 col-lg-6 col-md-10 col-sm-12 mx-auto mt-lg-5" id="viewCommande">


    <!--Form with header-->
    <div class="card wow fadeIn animated">
        <div class="card-body">

            <!--Header-->
            <#if purchaseOrder?has_content>
                <div class="form-header rpn-green-gradient">
                    <h3 class="white-text">${uiLabelMap.preCommande}: ${purchaseOrder.purchaseOrderId}</h3>
                </div>

                <div class="step-actions d-md-flex align-items-md-end">
                    <a href="<@ofbizUrl>listCommande</@ofbizUrl>">
                        <i class="fas fa-angle-double-left"></i>
                        retour
                    </a>
                </div>

                <div class="step-actions d-md-flex align-items-md-end">
                    <button class="waves-effect waves-dark float-right btn btn-rounded orange darken-4 btn-sm white-text"
                            id="showEditForm">
                        <i class="fas fa-pencil-alt"></i>
                        modifier</button>
                </div>

                <table class="table">
                    <tbody>
                    <tr>
                        <th scope="row">${uiLabelMap.customerFullName}:</th>
                        <td>${purchaseOrder.getRelatedOne("Person").get("firstName", locale)} ${purchaseOrder.getRelatedOne("Person").get("lastName", locale)}</td>
                    </tr>
                    <tr>
                        <th scope="row">${uiLabelMap.customerPhone}:</th>
                        <td>${purchaseOrder.phone}</td>
                    </tr>
                    <tr>
                        <th scope="row">${uiLabelMap.customerZone}:</th>
                        <td>${purchaseOrder.zone}</td>
                    </tr>
                    <tr>
                        <th scope="row">Nature:</th>
                        <td>${purchaseOrder.nature}</td>
                    </tr>
                    <tr>
                        <th scope="row">Pu:</th>
                        <td>${purchaseOrder.pu}</td>
                    </tr>
                    <tr>
                        <th scope="row">${uiLabelMap.customerValeurTotal}:</th>
                        <td>${purchaseOrder.valeurTotal}</td>
                    </tr>
                    <tr>
                        <th scope="row">${uiLabelMap.customerPaymentPlace}:</th>
                        <td>${purchaseOrder.paymentPlace}</td>
                    </tr>
                    <tr>
                        <th scope="row">${uiLabelMap.customerPurchasePaymentMode}</th>
                        <td>${purchaseOrder.getRelatedOne("PurchasePaymentMode").get("description", locale)}</td>
                    </tr>
                    <tr>
                        <th scope="row">Status:</th>
                        <td>${purchaseOrder.getRelatedOne("PurchaseOrderStatus").get("description", locale)}</td>
                    </tr>

                    </tbody>
                </table>
            </#if>
            <#if validationsPu?has_content>
                <h2>signature</h2>
                <#list validationsPu as validation>
                    <tr>
                        <td>${validation.getRelatedOne("Person").get("firstName", locale)}</td>
                        <td>${validation.getRelatedOne("Person").get("lastName", locale)}</td>
                    </tr>

                </#list>
            </#if>
            <#if purchaseOrder?has_content>
            <#list partyRoles as partyRole>
                <#if partyRole.roleTypeId == 'Direction des ventes'>
                    <#if purchaseOrder.purchaseOrderStatusId == '3'>


                        <div class="step-actions d-md-flex align-items-md-end">
                            <button type="button"
                                    class="waves-effect waves-dark float-right btn btn-rounded btn-sm rpn-green-gradient white-text"
                                    data-toggle="modal" data-target="#basicExampleModalValidation">valider</button>
                        </div>

                        <div class="step-actions d-md-flex align-items-md-end">
                            <button type="button"
                                    class="waves-effect waves-dark float-right btn btn-rounded btn-sm btn-danger"
                                    data-toggle="modal" data-target="#basicExampleModal">rejetter</button>
                        </div>


                    <div hidden="hidden" id="loaderValidation">
                        <div class="d-flex justify-content-center">
                            <div class="spinner-border" role="status">
                                <span class="sr-only">Loading...</span>
                            </div>
                        </div>
                    </div>
                    </#if>
                </#if>
            </#list>
            </#if>
        </div>
    </div>

</div>


<!-- Modal -->
<div class="modal fade" id="basicExampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
     aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">raison du refus</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form action="<@ofbizUrl>rejet</@ofbizUrl>" method="post">
                    <input type="hidden" value="${purchaseOrder.purchaseOrderId}" name="purchaseOrderId">
                    <textarea name="raisonRejet" rows="10" cols="50" style="border-style: solid"></textarea>
                    <div>
                        <label>entrer votre mot de passe</label>
                        <input type="password" name="pwd" required="required" class="form-control">
                    </div>
                    <button type="button" class="btn btn-rounded btn-sm btn-danger" data-dismiss="modal">annuler</button>
                    <button type="submit" class="btn btn-primary btn-rounded btn-sm ">Enregister</button>
                </form>
            </div>
            <div class="modal-footer">

            </div>
        </div>
    </div>
</div>

<!-- Modal validation-->
<div class="modal fade" id="basicExampleModalValidation" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
     aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h2>${uiLabelMap.pwd}</h2>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form action="<@ofbizUrl>validation</@ofbizUrl>" method="post">
                    <input type="hidden" value="${purchaseOrder.purchaseOrderId}" name="purchaseOrderId">
                    <div>
                        <label>entrer votre mot de passe</label>
                        <input type="password" name="pwd" required="required" class="form-control">
                    </div>
                    <div class="step-actions d-md-flex align-items-md-end">
                        <button type="button" class="btn btn-rounded btn-sm btn-danger" data-dismiss="modal">annuler</button>
                        <button class="waves-effect waves-dark float-right btn btn-rounded rpn-green-gradient btn-sm btn-primary"  id="buttonValidation">valider</button>
                    </div>
                </form>
            </div>
            <div class="modal-footer">

            </div>
        </div>
    </div>
</div>
<!--/Form edite-->

<#if purchaseOrder?has_content>
    <div class="container mt-lg-5 pt-lg-4" id="viewEditCommande" hidden="hidden">

        <div class="card">
            <div class="card-body">
                <h2 class="green-text h2 h2-responsive my-lg-2 my-md-3 text-center font-weight-bold">
                    ${uiLabelMap.preCommande}: ${purchaseOrder.purchaseOrderId}
                </h2>
                <hr>

                <div class="step-actions d-md-flex align-items-md-end">
                    <button class="waves-effect waves-dark float-right btn btn-rounded orange darken-4 btn-sm white-text"
                            id="showEditForm2">
                        <i class="fas fa-angle-double-left"></i>
                        retour</button>
                </div>

                <form id="submitEditCommande" method="post" action="<@ofbizUrl>editCommande</@ofbizUrl>?purchaseOrderId=${purchaseOrder.purchaseOrderId}">

                            <div class="step-new-content" style="left: 0%; display: block;">
                                <div class="row px-md-5 ">

                                    <div class="col-md-4 form-group">
                                        <label for="phone" class="title">${uiLabelMap.customerPhone}</label>
                                        <input type="text" id="phone" name="phone" required="required" class="form-control" length="10" value="${purchaseOrder.phone}">
                                    </div>

                                    <div class="col-md-4 form-group">
                                        <label for="zone" class="title">${uiLabelMap.customerZone}</label>
                                        <input type="text" id="zone" name="zone" required="required" class="form-control" aria-describedby="help-nbreMembres" value="${purchaseOrder.zone}">
                                    </div>

                                    <div class="col-md-4 form-group">
                                        <label for="nature" class="title">${uiLabelMap.customerNature}</label>
                                        <input type="text" id="nature" name="nature" required="required" class="form-control" aria-describedby="help-bp" value="${purchaseOrder.nature}">
                                    </div>

                                    <div class="col-md-4 form-group">
                                        <label for="quantite" class="title">${uiLabelMap.customerQt}</label>
                                        <input type="number" id="quantite" name="quantite" required="required" class="form-control" aria-describedby="help-ville" value="${purchaseOrder.quantite}">
                                    </div>

                                    <div class="col-md-4 form-group">
                                        <label for="pu" class="title">${uiLabelMap.customerPu}</label>
                                        <input type="number" id="pu" name="pu" required="required" class="form-control" aria-describedby="help-ville" value="${purchaseOrder.pu}">
                                    </div>

                                    <div class="col-md-4 form-group">
                                        <label for="pu" class="title">${uiLabelMap.customerValeurTotal}</label>
                                        <input type="number" id="valeurTotal" name="valeurTotal" required="required" class="form-control" aria-describedby="help-ville" value="${purchaseOrder.valeurTotal}">
                                    </div>

                                    <div class="col-md-4 form-group">
                                        <label for="paymentPlace" class="title">${uiLabelMap.customerPaymentPlace}</label>
                                        <input type="text" id="paymentPlace" name="paymentPlace" required="required" class="form-control" aria-describedby="help-ville" value="${purchaseOrder.paymentPlace}">
                                    </div>

                                    <div class="col-md-4">
                                        <select class="browser-default custom-select md-form" name="purchasePaymentModeId" >
                                            <option  value="${purchaseOrder.getRelatedOne("PurchasePaymentMode").get("purchasePaymentModeId", locale)}" selected>${purchaseOrder.getRelatedOne("PurchasePaymentMode").get("description", locale)}</option>
                                            <#list purchasePaymentMode as modeType>
                                                <option value='${modeType.purchasePaymentModeId}'>${modeType.description}</option>
                                            </#list>
                                        </select>
                                    </div>
                                    <div class="col-md-4">
                                        <label for="image">image de la facture</label>
                                        <input type="file" id="image" name="image">
                                        <small id="help-adresse" class="form-text text-danger text-bold">

                                        </small>
                                    </div>



                                </div>
                                <div class="step-actions d-md-flex align-items-md-end">
                                    <button class="waves-effect waves-dark float-right btn btn-rounded rpn-green-gradient btn-sm btn-primary" type="submit">Enregister</button>
                                </div>
                            </div>
            </div>
        </div>

    </div>
</#if>

<div hidden="hidden" id="loader">
    <div class="d-flex justify-content-center">
        <div class="spinner-border" role="status">
            <span class="sr-only">Loading...</span>
        </div>
    </div>
</div>



