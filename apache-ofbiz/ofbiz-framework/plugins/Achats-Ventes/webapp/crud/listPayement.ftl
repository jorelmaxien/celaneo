<div>

    <div class="card">
        <div class="card-body">
            <div class="card-header green darken-4">
                <h2 class="white-text h2 h2-responsive my-lg-2 my-md-3 text-center font-weight-bold">
                    ${uiLabelMap.titleListPaVer}
                </h2>
            </div>

            <div class="step-actions d-md-flex align-items-md-end">
                <a href="<@ofbizUrl>listPayement</@ofbizUrl>">
                    <i class="fas fa-angle-double-left"></i>
                    retour
                </a>
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
                <#list authentificationPayements as authentificationPayement>
                    <tr>
                        <td><a href="<@ofbizUrl>payementOverview</@ofbizUrl>?authentificationPayementId=${authentificationPayement.authentificationPayementId}">${authentificationPayement.authentificationPayementId}</a></td>
                        <td>${authentificationPayement.getRelatedOne("PurchaseOrder").getRelatedOne("Person").get("firstName", locale)}</td>
                        <td>${authentificationPayement.getRelatedOne("PurchaseOrder").getRelatedOne("Person").get("lastName", locale)}</td>
                        <td>${authentificationPayement.getRelatedOne("PurchaseOrder").zone}</td>
                        <td>${authentificationPayement.getRelatedOne("PurchaseOrder").nature}</td>
                        <td>${authentificationPayement.getRelatedOne("PurchaseOrder").pu}</td>
                        <td>${authentificationPayement.getRelatedOne("PurchaseOrder").valeurTotal}</td>
                        <td>${authentificationPayement.getRelatedOne("PurchaseOrderStatus").get("description", locale)}</td>
                    </tr>

                </#list>
                </tbody>
            </table>

        </div>
    </div>

</div>
