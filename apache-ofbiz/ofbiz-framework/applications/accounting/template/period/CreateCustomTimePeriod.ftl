
<#if customPeriod?has_content>
    <#assign  customTimePeriod= customPeriod>
    <#assign  fromDate1= customTimePeriod.fromDate>
    <#assign  thruDate1= customTimePeriod.thruDate>
    <#assign  periodNum1= customTimePeriod.periodNum>
    <#assign  periodName1= customTimePeriod.periodName>
<#else>

    <#assign  fromDate1="">
    <#assign  thruDate1= "">
    <#assign  periodNum1= "">
    <#assign  periodName1= "">

</#if>

<div class="row m-2">
    <div class="card col-sm-8 offset-sm-2 ">
        <div class="card-header h3 green darken-4 white-text text-darken-4 w-100 font-weight-bolder" >
            ${uiLabelMap.AccountingAddCustomTimePeriod}
        </div>
        <div class="card-body">
            <form method="post" class="row p-0" action="<@ofbizUrl>createCustomTimePeriod</@ofbizUrl>" onsubmit="return validateForm2()" name="CreateTimePeriod"  >
                <input type="hidden" name="findOrganizationPartyId" value="${findOrganizationPartyId!}" />
                <#if customTimePeriod?has_content>
                    <input type="hidden" name="organizationPartyId" value="${customTimePeriod.organizationPartyId}" />
                <#else>
                    <input type="hidden" name="organizationPartyId" value="${organizationPartyId}" />
                </#if>
                <input type="hidden" name="currentCustomTimePeriodId" value="${currentCustomTimePeriodId!}" />
                <input type="hidden" name="useValues" value="true" />


                <div class="md-form col-sm-12" >
                    <select class="browser-default custom-select" name="parentPeriodId">
                        <option selected value=''>${uiLabelMap.CommonParent}</option>
                        <#list allCustomTimePeriods as allCustomTimePeriod>
                            <#assign allPeriodType = allCustomTimePeriod.getRelatedOne("PeriodType", true)>
                            <#assign isDefault = false>
                            <#if currentCustomTimePeriod??>
                                <#if currentCustomTimePeriod.customTimePeriodId = allCustomTimePeriod.customTimePeriodId>
                                    <#assign isDefault = true>
                                </#if>
                            </#if>
                            <option value="${allCustomTimePeriod.customTimePeriodId}"<#if isDefault> selected="selected"</#if>>
                                ${allCustomTimePeriod.organizationPartyId}
                                <#if (allCustomTimePeriod.parentPeriodId)??>Par:${allCustomTimePeriod.parentPeriodId}</#if>
                                <#if allPeriodType??> ${allPeriodType.description}:</#if>
                                ${allCustomTimePeriod.periodNum!}
                                [${allCustomTimePeriod.customTimePeriodId}]
                            </option>
                        </#list>
                    </select>
                </div>

                <div class="md-form col-sm-12" >
                    <select class="browser-default custom-select" name="isClosed">
                        <option selected >Is Closed</option>

                            <option  value="N">${uiLabelMap.CommonNo}
                            </option>
                            <option  value="Y">${uiLabelMap.CommonYes}
                            </option>

                    </select>
                </div>

                <label    class="mb-0 mt-2 ml-3">${uiLabelMap.AccountingPeriodType}</label>
                <div class="md-form col-sm-12 mt-0" >

                    <select class="browser-default custom-select" name="periodTypeId">
                        <option selected value=''>${uiLabelMap.AccountingPeriodType}</option>
                        <#list periodTypes as periodType>
                            <#assign isDefault = false>
                            <#if customTimePeriod?has_content>

                            <#if customTimePeriod.periodTypeId??>
                                <#if customTimePeriod.periodTypeId = periodType.periodTypeId>
                                    <#assign isDefault = true>
                                </#if>
                            </#if>
                            </#if>
                            <option value="${periodType.periodTypeId}" <#if isDefault>selected="selected"</#if>>${periodType.description} [${periodType.periodTypeId}]</option>
                        </#list>
                    </select>
                </div>


                <div class="col-sm-6" style="text-align: left !important;">
                    <!-- Default input -->
                    <label for="periodNum" >${uiLabelMap.AccountingPeriodNumber}</label>

                    <input type="text" size='4'  id="periodNum" value="${periodNum1}"  name='periodNum' class="form-control">
                </div>

                <div class="col-sm-6" style="text-align: left !important;">
                    <!-- Default input -->
                    <label for="periodName" >${uiLabelMap.AccountingPeriodName}</label>
                    <input type="text" size='10' required="required" value="${periodName1}" name='periodName' class="form-control">
                </div>
                <div class="col-sm-6" style="text-align: left !important;">

                    <div class="md-form">
                        <#if fromDate1?has_content>
                            <input type="text" size='14'  id="fromDate" name='fromDate'  value="${fromDate1?string('dd/MM/yyyy')}" class="form-control datepicker">
                        <#else>
                            <input type="text" size='14'  id="fromDate" name='fromDate'  value="${fromDate1}" class="form-control datepicker">
                        </#if>
                        <label for="fromDate">${uiLabelMap.CommonFromDate}</label>
                    </div>
                </div>

                <div class="col-sm-6" style="text-align: left !important;">

                    <div class="md-form">
                        <#if fromDate1?has_content>
                            <input type="text" size='14' id="thruDate"  name='thruDate' value="${thruDate1?string('dd/MM/yyyy')}" class="form-control datepicker">
                        <#else>
                            <input type="text" size='14' id="thruDate"  name='thruDate' value="${thruDate1}" class="form-control datepicker">
                        </#if>
                        <label for="thruDate">${uiLabelMap.CommonThruDate}</label>
                    </div>
                </div>

                <div class="text-center mb-4 col-sm-6 offset-sm-3">
                    <button type="submit" class="btn orange darken-4 btn-block z-depth-2 white-text rounded">${uiLabelMap.CommonAdd}<i class="fas fa-save fa-lg ml-2"></i></button>
                </div>

            </form>
        </div>
    </div>

</div>
