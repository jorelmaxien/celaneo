<div>

    <div class="card">
        <div class="card-body">

            <div class="card-header green darken-4">
                <h2 class="white-text h2 h2-responsive my-lg-2 my-md-3 text-center font-weight-bold">
                    ${uiLabelMap.titleListAutLiv}
                </h2>
            </div>

            <table id="dtBasicExample" class="table table-striped table-bordered" cellspacing="0" width="100%">
                <thead class="green darken-4">
                <tr class="white-text">
                    <th class="th-sm white-text">Ref ${uiLabelMap.autLivr}
                    </th>
                    <th class="th-sm white-text">${uiLabelMap.customerLastName}
                    </th>
                    <th class="th-sm white-text">${uiLabelMap.customerFirstName}
                    </th>
                    <th class="th-sm white-text">${uiLabelMap.customerPhone}
                    </th>
                    <th class="th-sm white-text">Nature
                    </th>
                    <th class="th-sm white-text">Pu
                    </th>
                    <th class="th-sm white-text">${uiLabelMap.customerValeurTotal}
                    </th>
                    <th class="th-sm white-text">status
                    </th>
                </tr>
                </thead>
                <tbody>
                <#list autorisationLivraisons as autorisationLivraison>
                    <tr>
                        <td><a href="<@ofbizUrl>autorisationLivraisonOverview</@ofbizUrl>?autorisationLivraisonId=${autorisationLivraison.autorisationLivraisonId}">${autorisationLivraison.autorisationLivraisonId}</a></td>
                        <td>${autorisationLivraison.getRelatedOne("PurchaseOrder").getRelatedOne("Person").get("firstName", locale)}</td>
                        <td>${autorisationLivraison.getRelatedOne("PurchaseOrder").getRelatedOne("Person").get("lastName", locale)}</td>
                        <td>${autorisationLivraison.getRelatedOne("PurchaseOrder").phone}</td>
                        <td>${autorisationLivraison.getRelatedOne("PurchaseOrder").nature}</td>
                        <td>${autorisationLivraison.getRelatedOne("PurchaseOrder").pu}</td>
                        <td>${autorisationLivraison.getRelatedOne("PurchaseOrder").valeurTotal}</td>
                        <td>${autorisationLivraison.getRelatedOne("PurchaseOrderStatus").get("description", locale)}</td>
                    </tr>
                </#list>
                </tbody>
            </table>

        </div>
    </div>

</div>
