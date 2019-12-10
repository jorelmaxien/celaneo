<div>

    <div class="card">
        <div class="card-header green darken-4">
            <h2 class="white-text h2 h2-responsive my-lg-2 my-md-3 text-center font-weight-bold">
                ${uiLabelMap.titleListPreOrder}
            </h2>
        </div>
        <div class="card-body">

            <a href="<@ofbizUrl>newCommande</@ofbizUrl>" class="btn btn-rounded rpn-green-gradient btn-sm btn-primary">
                ${uiLabelMap.preCommande}
            </a>

            <table id="dtBasicExample" class="table table-striped table-bordered" cellspacing="0" width="100%">
                <thead class="green darken-4">
                <tr class="white-text">
                    <th class="th-sm white-text">Ref ${uiLabelMap.preCommande}
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
                <#list purchaseOrder as purchas>
                    <tr>
                        <td><a href="<@ofbizUrl>commandeOverview</@ofbizUrl>?purchaseOrderId=${purchas.purchaseOrderId}">${purchas.purchaseOrderId}</a></td>
                        <td>${purchas.getRelatedOne("Person").get("firstName", locale)}</td>
                        <td>${purchas.getRelatedOne("Person").get("lastName", locale)}</td>
                        <td>${purchas.phone}</td>
                        <td>${purchas.nature}</td>
                        <td>${purchas.pu}</td>
                        <td>${purchas.valeurTotal}</td>
                        <td>${purchas.getRelatedOne("PurchaseOrderStatus").get("description", locale)}</td>
                    </tr>

                </#list>
                </tbody>
            </table>

        </div>
    </div>

</div>