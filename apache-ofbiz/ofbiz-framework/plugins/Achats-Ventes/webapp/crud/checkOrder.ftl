<!--Navbar-->
<nav class="navbar navbar-expand-lg navbar-dark green-nav">
    <!-- Collapse button -->
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#basicExampleNav"
            aria-controls="basicExampleNav" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>

    <!-- Collapsible content -->
    <div class="collapse navbar-collapse" id="basicExampleNav">

        <!-- Links -->

        <form class="form-inline" method="get" action="<@ofbizUrl>checkOrder</@ofbizUrl>">
            <div class="md-form my-0">
                <input class="form-control mr-sm-2" type="text" placeholder="Search" aria-label="Search" name="purchaseOrderId">
            </div>
        </form>
    </div>
    <!-- Collapsible content -->

</nav>
<!--/.Navbar-->
<#if purchaseOrder ? has_content>
    <div class="steptest">
    <ul class="stepper stepper-vertical">

        <!-- First Step -->
        <#if purchaseOrder ? has_content >
            <li class="completed">
            <a href="<@ofbizUrl>commandeOverview</@ofbizUrl>?purchaseOrderId=${purchaseOrder.purchaseOrderId}">
                <span class="circle">1</span>
                <span class="label">pre-commande: ${purchaseOrder.purchaseOrderId}</span>
            </a>

            <div class="step-content grey lighten-3">
                <div
                    <#if purchaseOrder.getRelatedOne("PurchaseOrderStatus").get("description", locale)== 'valider'>
                        class="card border-success mb-3 text-success"
                    <#elseif purchaseOrder.getRelatedOne("PurchaseOrderStatus").get("description", locale)== 'rejetter'>
                         class="card border-danger mb-3 text-danger"
                    <#else >
                         class="card border-dark text-dark"
                    </#if>
                         style="max-width: 20rem;">
                        <div class="card-header">
                            STATUS : ${purchaseOrder.getRelatedOne("PurchaseOrderStatus").get("description", locale)}
                        </div>
                        <div class="card-body">
                            <#if validationsPu?has_content>
                                <h5>signature</h5>
                                <#list validationsPu as validation>
                                    <ul class="list-group list-group-flush">
                                        <li class="list-group-item">${validation.getRelatedOne("Person").get("firstName", locale)} ${validation.getRelatedOne("Person").get("lastName", locale)} ${validation.getRelatedOne("RoleType").get("description", locale)}</li>
                                    </ul>

                                </#list>
                                <#else >
                                    aucune signature
                            </#if>
                            <#if rejetsPu ? has_content>
                                <h5>REJETS</h5>
                                <#list rejetsPu as rejet>
                                    <ul class="list-group list-group-flush">
                                                                <li class="list-group-item">${rejet.getRelatedOne("Person").get("firstName", locale)} ${rejet.getRelatedOne("Person").get("lastName", locale)} ${rejet.getRelatedOne("RoleType").get("description", locale)}</li>
                                    </ul>
                                </#list>
                            </#if>
                        </div>
                </div>
            </div>


        </li>
            <#else>
                <li class="warning">
                    <a href="#!">
                        <span class="circle"><i class="fas fa-exclamation"></i></span>
                        <span class="label">pre-commande</span>
                    </a>
                </li>
        </#if>

        <!-- Second Step -->
        <#if notificationCommande ? has_content>
            <li class="active">

            <!--Section Title -->

            <a href="<@ofbizUrl>notificationOverview</@ofbizUrl>?notificationCommandeId=${notificationCommande.notificationCommandeId}">
                <span class="circle">2</span>
                <span class="label">notification commande: ${notificationCommande.notificationCommandeId}</span>
            </a>

            <!-- Section Description -->
            <div class="step-content grey lighten-3">
                <div
                        <#if notificationCommande.getRelatedOne("PurchaseOrderStatus").get("description", locale)== 'valider'>
                            class="card border-success mb-3 text-success"
                        <#elseif notificationCommande.getRelatedOne("PurchaseOrderStatus").get("description", locale)== 'rejetter'>
                            class="card border-danger mb-3 text-danger"
                        <#else >
                            class="card border-dark text-dark"
                        </#if>
                        style="max-width: 20rem;">
                    <div class="card-header">
                        STATUS : ${notificationCommande.getRelatedOne("PurchaseOrderStatus").get("description", locale)}
                    </div>
                    <div class="card-body">
                        <#if validationsNo?has_content>
                            <h5>signature</h5>
                            <#list validationsNo as validation>
                                <ul class="list-group list-group-flush">
                                        <li class="list-group-item">${validation.getRelatedOne("Person").get("firstName", locale)} ${validation.getRelatedOne("Person").get("lastName", locale)} ${validation.getRelatedOne("RoleType").get("description", locale)}</li>
                                </ul>

                            </#list>
                        <#else >
                            aucune signature
                        </#if>

                        <#if rejetsNo ? has_content>
                            <h5>REJETS</h5>
                            <#list rejetsNo as rejet>
                                <ul class="list-group list-group-flush">
                                                        <li class="list-group-item">${rejet.getRelatedOne("Person").get("firstName", locale)} ${rejet.getRelatedOne("Person").get("lastName", locale)} ${rejet.getRelatedOne("RoleType").get("description", locale)}</li>
                                </ul>
                            </#list>
                        </#if>


                    </div>
                </div>
            </div>
        </li>

        <#else>
            <li class="warning">
                <a href="#!">
                    <span class="circle"><i class="fas fa-exclamation"></i></span>
                    <span class="label">notification commande</span>
                </a>
            </li>

        </#if>

        <!-- Third Step -->
        <#if authentificationPayement ? has_content>
            <li class="active">

                <!--Section Title -->

                <a href="<@ofbizUrl>payementOverview</@ofbizUrl>?authentificationPayementId=${authentificationPayement.authentificationPayementId}">
                    <span class="circle">2</span>
                    <span class="label">authentification de payement: ${authentificationPayement.authentificationPayementId}</span>
                </a>

                <!-- Section Description -->
                <div class="step-content grey lighten-3">
                    <div
                        <#if authentificationPayement.getRelatedOne("PurchaseOrderStatus").get("description", locale)== 'valider'>
                            class="card border-success mb-3 text-success"
                        <#elseif authentificationPayement.getRelatedOne("PurchaseOrderStatus").get("description", locale)== 'rejetter'>
                            class="card border-danger mb-3 text-danger"
                        <#else >
                            class="card border-dark text-dark"
                        </#if>
                        style="max-width: 20rem;">
                    <div class="card-header">
                        STATUS : ${authentificationPayement.getRelatedOne("PurchaseOrderStatus").get("description", locale)}
                    </div>
                    <div class="card-body">
                        <#if validationsPa?has_content>
                            <h5>signature</h5>
                            <#list validationsPa as validation>
                                <ul class="list-group list-group-flush">
                                        <li class="list-group-item">${validation.getRelatedOne("Person").get("firstName", locale)} ${validation.getRelatedOne("Person").get("lastName", locale)} ${validation.getRelatedOne("RoleType").get("description", locale)}</li>
                                </ul>

                            </#list>
                        <#else >
                            aucune signature
                        </#if>

                        <#if rejetsPa ? has_content>
                            <h5>REJETS</h5>
                            <#list rejetsPa as rejet>
                                <ul class="list-group list-group-flush">
                                                        <li class="list-group-item">${rejet.getRelatedOne("Person").get("firstName", locale)} ${rejet.getRelatedOne("Person").get("lastName", locale)} ${rejet.getRelatedOne("RoleType").get("description", locale)}</li>
                                </ul>
                            </#list>
                        </#if>


                    </div>
                </div>
                </div>
            </li>
            <#else >
            <li class="warning">
            <a href="#!">
                <span class="circle"><i class="fas fa-exclamation"></i></span>
                <span class="label">authentification de payement</span>
            </a>
        </li>
        </#if>

        <!-- Fourth Step -->
        <#if autorisationLivraison ? has_content>
            <li class="active">
            <a href="<@ofbizUrl>autorisationLivraisonOverview</@ofbizUrl>?autorisationLivraisonId=${autorisationLivraison.autorisationLivraisonId}">
                <span class="circle">4</span>
                <span class="label">autorisation de livraison: ${autorisationLivraison.autorisationLivraisonId}</span>
            </a>

            <div class="step-content grey lighten-3">
                 <div
                        <#if autorisationLivraison.getRelatedOne("PurchaseOrderStatus").get("description", locale)== 'valider'>
                            class="card border-success mb-3 text-success"
                        <#elseif autorisationLivraison.getRelatedOne("PurchaseOrderStatus").get("description", locale)== 'rejetter'>
                            class="card border-danger mb-3 text-danger"
                        <#else >
                            class="card border-dark text-dark"
                        </#if>
                        style="max-width: 20rem;">
                    <div class="card-header">
                        STATUS : ${authentificationPayement.getRelatedOne("PurchaseOrderStatus").get("description", locale)}
                    </div>
                    <div class="card-body">
                        <#if validationsLi?has_content>
                            <h5>signature</h5>
                            <#list validationsLi as validation>
                                <ul class="list-group list-group-flush">
                                        <li class="list-group-item">${validation.getRelatedOne("Person").get("firstName", locale)} ${validation.getRelatedOne("Person").get("lastName", locale)} ${validation.getRelatedOne("RoleType").get("description", locale)}</li>
                                </ul>

                            </#list>
                        <#else >
                            aucune signature
                        </#if>

                        <#if rejetsLi ? has_content>
                            <h5>REJETS</h5>
                            <#list rejetsLi as rejet>
                                <ul class="list-group list-group-flush">
                                                        <li class="list-group-item">${rejet.getRelatedOne("Person").get("firstName", locale)} ${rejet.getRelatedOne("Person").get("lastName", locale)} ${rejet.getRelatedOne("RoleType").get("description", locale)}</li>
                                </ul>
                            </#list>
                        </#if>


                    </div>
                </div>
            </div>

        </li>
        <#else >
            <li class="warning">
                <a href="#!">
                    <span class="circle"><i class="fas fa-exclamation"></i></span>
                    <span class="label">autorisation de livraison</span>
                </a>

            </li>

        </#if>

        <!-- fifth Step -->
        <#if ticketDePese ? has_content>
            <li

            >
                <a href="<@ofbizUrl>ticketDePeseOverview</@ofbizUrl>?ticketDePeseId=${ticketDePese.ticketDePeseId}">
                    <span class="circle">5</span>
                    <span class="label">ticket de pesee: ${ticketDePese.ticketDePeseId}</span>
                </a>

                <div class="step-content grey lighten-3">
                        <div
                        <#if ticketDePese.getRelatedOne("PurchaseOrderStatus").get("description", locale)== 'valider'>
                            class="card border-success mb-3 text-success"
                        <#elseif ticketDePese.getRelatedOne("PurchaseOrderStatus").get("description", locale)== 'rejetter'>
                            class="card border-danger mb-3 text-danger"
                        <#else >
                            class="card border-dark text-dark"
                        </#if>
                        style="max-width: 20rem;">
                    <div class="card-header">
                        STATUS : ${ticketDePese.getRelatedOne("PurchaseOrderStatus").get("description", locale)}
                    </div>
                    <div class="card-body">
                        <#if validationsTi?has_content>
                            <h5>signature</h5>
                            <#list validationsTi as validation>
                                <ul class="list-group list-group-flush">
                                        <li class="list-group-item">${validation.getRelatedOne("Person").get("firstName", locale)} ${validation.getRelatedOne("Person").get("lastName", locale)} ${validation.getRelatedOne("RoleType").get("description", locale)}</li>
                                </ul>

                            </#list>
                        </#if>

                        <#if rejetsTi ? has_content>

                            <h5>REJETS</h5>
                            <#list rejetsTi as rejet>
                                <ul class="list-group list-group-flush">
                                                        <li class="list-group-item">${rejet.getRelatedOne("Person").get("firstName", locale)} ${rejet.getRelatedOne("Person").get("lastName", locale)} ${rejet.getRelatedOne("RoleType").get("description", locale)}</li>
                                </ul>
                            </#list>
                        </#if>


                    </div>
                </div>
                </div>

            </li>
        <#else >
            <li class="warning">
                <a href="#!">
                    <span class="circle"><i class="fas fa-exclamation"></i></span>
                    <span class="label">ticket de pesee</span>
                </a>

            </li>
        </#if>

    </ul>
</div>
<#elseif purchaseOrderId ? has_content && purchaseOrder ? has_content>
<div class="alert alert-danger" role="alert">
  cette commande hesiste pas !
</div>
</#if>


