<div class="col-xl-5 col-lg-6 col-md-10 col-sm-12 mx-auto mt-lg-5" id="viewCommande">


    <!--Form with header-->
    <div class="card wow fadeIn animated">
        <div class="card-body">

            <!--Header-->
            <#if autorisationLivraison?has_content>
                <div class="form-header rpn-green-gradient">
                    <h3 class="white-text">authorisation de livraison numero: ${autorisationLivraison.autorisationLivraisonId}</h3>
                </div>

                <div class="step-actions d-md-flex align-items-md-end">
                    <a href="<@ofbizUrl>listAutorisationLivraison</@ofbizUrl>">
                        <i class="fas fa-angle-double-left"></i>
                        retour
                    </a>
                </div>

                <table class="table">
                    <tbody>
                    <tr>
                        <th scope="row">${uiLabelMap.customerFullName}:</th>
                        <td>${autorisationLivraison.getRelatedOne("PurchaseOrder").getRelatedOne("Person").get("firstName", locale)} ${autorisationLivraison.getRelatedOne("PurchaseOrder").getRelatedOne("Person").get("lastName", locale)}</td>
                    </tr>
                    <tr>
                        <th scope="row">${uiLabelMap.customerPhone}:</th>
                        <td>${autorisationLivraison.getRelatedOne("PurchaseOrder").phone}</td>
                    </tr>
                    <tr>
                        <th scope="row">${uiLabelMap.customerZone}:</th>
                        <td>${autorisationLivraison.getRelatedOne("PurchaseOrder").zone}</td>
                    </tr>
                    <tr>
                        <th scope="row">Nature:</th>
                        <td>${autorisationLivraison.getRelatedOne("PurchaseOrder").nature}</td>
                    </tr>
                    <tr>
                        <th scope="row">Pu:</th>
                        <td>${autorisationLivraison.getRelatedOne("PurchaseOrder").pu}</td>
                    </tr>
                    <tr>
                        <th scope="row">${uiLabelMap.customerValeurTotal}:</th>
                        <td>${autorisationLivraison.getRelatedOne("PurchaseOrder").valeurTotal}</td>
                    </tr>
                    <tr>
                        <th scope="row">${uiLabelMap.customerPaymentPlace}:</th>
                        <td>${autorisationLivraison.getRelatedOne("PurchaseOrder").paymentPlace}</td>
                    </tr>
                    <tr>
                        <th scope="row">${uiLabelMap.customerPurchasePaymentMode}</th>
                        <td>${autorisationLivraison.getRelatedOne("PurchaseOrder").getRelatedOne("PurchasePaymentMode").get("description", locale)}</td>
                    </tr>
                    <tr>
                        <th scope="row">Status:</th>
                        <td>${autorisationLivraison.getRelatedOne("PurchaseOrderStatus").get("description", locale)}</td>
                    </tr>

                    </tbody>
                </table>
            </#if>
            <#if validations?has_content>
                <h2 class="green-text h2 h2-responsive my-lg-2 my-md-3 text-center font-weight-bold">signature</h2>
                <#list validations as validation>
                    <li>
                        <ul>${validation.getRelatedOne("Person").get("firstName", locale)} ${validation.getRelatedOne("Person").get("lastName", locale)} ${validation.getRelatedOne("RoleType").get("description", locale)}</ul>

                    </li>

                </#list>
            </#if>
            <#if autorisationLivraison?has_content>
                <#list partyRoles as partyRole>
                    <#if partyRole.roleTypeId == 'Direction des ventes' ||
                    partyRole.roleTypeId == 'Direction des stocks'||
                    partyRole.roleTypeId == 'Direction usine'||
                    partyRole.roleTypeId ==   'Direction poids'
                    >
                        <#if autorisationLivraison.purchaseOrderStatusId == '3'>

                            <div class="step-actions d-md-flex align-items-md-end">
                                <button type="button"
                                        class="waves-effect waves-dark float-right btn btn-rounded btn-sm rpn-green-gradient white-text"
                                        data-toggle="modal" data-target="#basicExampleModalValidation">valider</button>
                            </div>

                            <div class="step-actions d-md-flex align-items-md-end" id="validationCancel">
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
                <form action="<@ofbizUrl>rejetAutorisationLivraison</@ofbizUrl>" id="rejet" method="post">
                    <input type="hidden" value="${autorisationLivraison.autorisationLivraisonId}" name="autorisationLivraisonId">
                    <textarea name="raisonRejet" rows="10" cols="50" style="border-style: solid"></textarea>
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

                <form action="<@ofbizUrl>validationAutorisationLivraison</@ofbizUrl>">
                    <input type="hidden" value="${autorisationLivraison.autorisationLivraisonId}" name="autorisationLivraisonId">
                    <div>
                        <label>entrer votre mot de passe</label>
                        <input type="password" name="pwd" required="required" class="form-control">
                    </div>
                    <div class="step-actions d-md-flex align-items-md-end">
                        <button class="waves-effect waves-dark float-right btn btn-rounded rpn-green-gradient btn-sm btn-primary"  id="buttonValidation">valider</button>
                    </div>
                </form>

            </div>
            <div class="modal-footer">

            </div>
        </div>
    </div>
</div>

