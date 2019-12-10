<div>

        <div class="card">

            <div class="card-body">

                <div class="card-header green darken-4">
                    <h2 class="white-text h2 h2-responsive my-lg-2 my-md-3 text-center font-weight-bold">
                        ${uiLabelMap.titleAddPreOrder}
                    </h2>
                </div>

                <div class="step-actions d-md-flex align-items-md-end">
                    <a class="btn btn-rounded orange darken-4 btn-sm white-text " href="<@ofbizUrl>listCommande</@ofbizUrl>">
                        <i class="fas fa-angle-double-left"></i>
                        retour
                    </a>
                </div>

                <form name="app_registration" method="post" action="<@ofbizUrl>createCommande</@ofbizUrl>">


                            <div class="step-new-content" style="left: 0%; display: block;">
                                <div class="row px-md-5 ">
                                    <div class="col-md-4 md-form">
                                        <span class="field-lookup">
                                            <label for="0_lookupId_PurchaseFroms_partyIdTo" class="title">id client</label>
                                            <input type="text"
                                                   name="partyId" size="25" id="0_lookupId_PurchaseFroms_partyIdTo"
                                                   data-lookup-ajax-enabled="true" data-lookup-presentation=""
                                                   data-lookup-request-url="LookupPartyName" data-lookup-form-name="PurchaseFroms"
                                                   data-lookup-optional-target="" data-lookup-width="640" data-lookup-height="500"
                                                   data-lookup-position="top-left" data-lookup-modal="false"
                                                   data-lookup-show-description="true" data-lookup-default-minlength="2"
                                                   data-lookup-default-delay="300" data-lookup-args=""
                                                   data-lookup-ajax-url="PurchaseFroms_partyIdTo,https://localhost:8443/Achats-Ventes/control/LookupPartyName,ajaxLookup=Y&amp;searchValueFieldName=partyId" autocomplete="off"
                                            >
                                        </span>
                                    </div>


                                    <div class="col-md-4 md-form">
                                        <input type="text" id="phone" name="phone" required="required" class="form-control" length="10" ">
                                        <label for="phone" class="title">${uiLabelMap.customerPhone}</label>
                                    </div>

                                    <div class="col-md-4 md-form">
                                        <input type="text" id="zone" name="zone" required="required" class="form-control" aria-describedby="help-nbreMembres">
                                        <label for="zone" class="title">${uiLabelMap.customerZone}</label>
                                    </div>

                                    <div class="col-md-4 md-form">
                                        <input type="text" id="nature" name="nature" required="required" class="form-control" aria-describedby="help-bp">
                                        <label for="nature" class="title">${uiLabelMap.customerNature}</label>
                                    </div>

                                    <div class="col-md-4 md-form">
                                        <input type="text" id="quantite" name="quantite" required="required" class="form-control" aria-describedby="help-ville">
                                        <label for="quantite" class="title">${uiLabelMap.customerQt}</label>
                                    </div>
                                    <div class="col-md-4 md-form">
                                        <input type="text" id="pu" name="pu" required="required" class="form-control" aria-describedby="help-ville">
                                        <label for="pu" class="title">${uiLabelMap.customerPu}</label>
                                    </div>
                                    <div class="col-md-4 md-form">
                                        <input type="text" id="valeurTotal" name="valeurTotal" required="required" class="form-control" aria-describedby="help-ville">
                                        <label for="pu" class="title">${uiLabelMap.customerValeurTotal}</label>
                                    </div>
                                    <div class="col-md-4 md-form">
                                        <input type="text" id="paymentPlace" name="paymentPlace" required="required" class="form-control" aria-describedby="help-ville">
                                        <label for="paymentPlace" class="title">${uiLabelMap.customerPaymentPlace}</label>
                                    </div>
                                    <div class="col-md-4">
                                        <select class="browser-default custom-select md-form" name="purchasePaymentModeId">
                                            <option selected>${uiLabelMap.customerPurchasePaymentMode}</option>
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
                                <div class=" d-md-flex align-items-md-end">
                                    <button class="waves-effect waves-dark btn btn-rounded rpn-green-gradient btn-sm btn-primary" type="submit">Enregistrer</button>
                                </div>
                            </div>

            </div>
    </div>


</div>
