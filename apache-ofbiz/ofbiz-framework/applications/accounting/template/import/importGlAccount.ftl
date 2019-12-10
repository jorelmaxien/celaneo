<#--
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
-->
<div class="row">
    <#--<#if security.hasPermission("PERIOD_MAINT", session)>-->
    <div class="card col-sm-8 offset-sm-2 ">
        <div class="card-header h3 green darken-4 white-text text-darken-4 w-100 font-weight-bolder" >
            ${uiLabelMap.AccountingGlAccountImportTitle} ${organizationPartyId}
        </div>
        <div class="card-body">
            <form method="post" class="row" action="<@ofbizUrl>importChartOfAccount</@ofbizUrl>" name="importChartOfAccountForm" enctype="multipart/form-data">
                <#--            <input type="hidden" name="currentCustomTimePeriodId" value="${currentCustomTimePeriodId!}" />-->
                <#--            <span class="label">${uiLabelMap.AccountingShowOnlyPeriodsWithOrganization}</span>-->
                <#--            <input type="file" name="orgchartofAccount" value="${findOrganizationPartyId!}" />-->

                <input name="organizationPartyId" value="${organizationPartyId}" type="hidden"/>
                <div class="md-form col-sm-12" >
                    <div class="file-field">
                        <div class="btn green darken-4 btn-sm float-left white-text" >
                            <i class="fas fa-paperclip"></i>
                            <span> ${uiLabelMap.CommonSelectFile}</span>
                            <input type="file" name="filename" required>
                        </div>
                        <div class="file-path-wrapper text-wrap" style="border-bottom: 1px solid grey">
                            <input class="file-path validate text-wrap" type="text" placeholder='${uiLabelMap.CommonSelectFileLabel}' style="width: 18rem;">
                        </div>
                    </div>-
                </div>
                <div class="text-center mb-4 col-sm-6 offset-sm-3">
                    <button type="submit" name="upload_cmd" class="btn orange darken-4 btn-block z-depth-2 white-text">${uiLabelMap.CommonImport} <i class="fas fa-upload fa-lg ml-1"></i></button>
                </div>
            </form>
        </div>
    </div>


    <#--<#else>-->
    <#--    <h3>${uiLabelMap.AccountingPermissionPeriod}.</h3>-->
    <#--</#if>-->

</div>

