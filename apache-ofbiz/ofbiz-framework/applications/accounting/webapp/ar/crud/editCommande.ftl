<div class="card wow fadeIn animated">
    <div class="card-body">

        <!--Header-->
        <#if purchaseOrder?has_content>
            <div class="form-header rpn-green-gradient">
                <h3 class="white-text">commande numero: ${purchaseOrder.purchaseOrderId}</h3>
            </div>

            <div class="step-actions d-md-flex align-items-md-end">
                <button class="waves-effect waves-dark float-right btn btn-rounded rpn-green-gradient btn-sm btn-primary" id="showEditForm">modifier</button>
            </div>

            <table class="table">
                <tbody>
                <tr>
                    <th scope="row">nom complet:</th>
                    <td>${purchaseOrder.getRelatedOne("Person").get("firstName", locale)} ${purchaseOrder.getRelatedOne("Person").get("lastName", locale)}</td>
                </tr>
                <tr>
                    <th scope="row">telephone:</th>
                    <td>${purchaseOrder.phone}</td>
                </tr>
                <tr>
                    <th scope="row">zone:</th>
                    <td>${purchaseOrder.zone}</td>
                </tr>
                <tr>
                    <th scope="row">nature:</th>
                    <td>${purchaseOrder.nature}</td>
                </tr>
                <tr>
                    <th scope="row">pu:</th>
                    <td>${purchaseOrder.pu}</td>
                </tr>
                <tr>
                    <th scope="row">valeur total:</th>
                    <td>${purchaseOrder.valeurTotal}</td>
                </tr>
                <tr>
                    <th scope="row">lieux de payement:</th>
                    <td>${purchaseOrder.paymentPlace}</td>
                </tr>
                <tr>
                    <th scope="row">methode de payement:</th>
                    <td>${purchaseOrder.getRelatedOne("PurchasePaymentMode").get("description", locale)}</td>
                </tr>
                </tbody>
            </table>

            <div class="step-actions d-md-flex align-items-md-end">
                <button class="waves-effect waves-dark float-right btn btn-rounded rpn-green-gradient btn-sm btn-primary" type="submit">valider</button>
            </div>
        </#if>

    </div>
</div>