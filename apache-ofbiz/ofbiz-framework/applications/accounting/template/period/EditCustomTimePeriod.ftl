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

<h1>${uiLabelMap.AccountingEditCustomTimePeriods}</h1>
<br />
<#if security.hasPermission("PERIOD_MAINT", session)>
   <div class="screenlet">
     <div class="screenlet-title-bar">
         <ul>
           <li class="h3">${uiLabelMap.AccountingShowOnlyPeriodsWithOrganization}</li>
         </ul>
         <br class="clear"/>
     </div>
     <form method="post" action="<@ofbizUrl>EditCustomTimePeriod</@ofbizUrl>" name="setOrganizationPartyIdForm">
         <input type="hidden" name="currentCustomTimePeriodId" value="${currentCustomTimePeriodId!}" />
         <span class="label">${uiLabelMap.AccountingShowOnlyPeriodsWithOrganization}</span>
         <input type="text" size="20" name="findOrganizationPartyId" value="${findOrganizationPartyId!}" />
         <input type="submit" value='${uiLabelMap.CommonUpdate}' />
     </form>
   </div>

  <div class="screenlet">
    <div class="screenlet-title-bar">
      <#if currentCustomTimePeriod?has_content>
        <ul>
          <li class="h3">${uiLabelMap.AccountingCurrentCustomTimePeriod}</li>
          <li><a href="<@ofbizUrl>EditCustomTimePeriod?findOrganizationPartyId=${findOrganizationPartyId!}</@ofbizUrl>">${uiLabelMap.CommonClearCurrent}</a></li>
        </ul>
      <#else>
        <h3>${uiLabelMap.AccountingCurrentCustomTimePeriod}</h3>
      </#if>
    </div>
    <#if currentCustomTimePeriod?has_content>
      <table class="basic-table" cellspacing="0">
        <tr class="header-row">
          <td>${uiLabelMap.CommonId}</td>
          <td>${uiLabelMap.CommonParent}</td>
          <td>${uiLabelMap.AccountingOrgPartyId}</td>
          <td>${uiLabelMap.AccountingPeriodType}</td>
          <td>${uiLabelMap.CommonNbr}</td>
          <td>${uiLabelMap.AccountingPeriodName}</td>
          <td>${uiLabelMap.CommonFromDate}</td>
          <td>${uiLabelMap.CommonThruDate}</td>
          <td colspan="2">&nbsp;</td>
        </tr>
        <tr>
          <form method="post" action="<@ofbizUrl>updateCustomTimePeriod</@ofbizUrl>" name="updateCustomTimePeriodForm">
            <input type="hidden" name="findOrganizationPartyId" value="${findOrganizationPartyId!}" />
            <input type="hidden" name="customTimePeriodId" value="${currentCustomTimePeriodId!}" />
            <td>${currentCustomTimePeriod.customTimePeriodId}</td>
            <td>
              <select name="parentPeriodId">
                <option value=''>&nbsp;</option>
                <#list allCustomTimePeriods as allCustomTimePeriod>
                  <#assign allPeriodType = allCustomTimePeriod.getRelatedOne("PeriodType", true)>
                  <#assign isDefault = false>
                  <#if (currentCustomTimePeriod.parentPeriodId)??>
                    <#if currentCustomTimePeriod.customTimePeriodId = allCustomTimePeriod.customTimePeriodId>
                      <#assign isDefault = true>
                    </#if>
                  </#if>
                  <option value='${allCustomTimePeriod.customTimePeriodId}'<#if isDefault> selected="selected"</#if>>
                    ${allCustomTimePeriod.organizationPartyId}
                    <#if allPeriodType??>${allPeriodType.description}:</#if>
                    ${allCustomTimePeriod.periodNum!}
                    [${allCustomTimePeriod.customTimePeriodId}]
                  </option>
                </#list>
              </select>
              <#if (currentCustomTimePeriod.parentPeriodId)??>
                <a href='<@ofbizUrl>EditCustomTimePeriod?currentCustomTimePeriodId=${currentCustomTimePeriod.parentPeriodId}&amp;findOrganizationPartyId=${findOrganizationPartyId!}</@ofbizUrl>'>
                ${uiLabelMap.CommonSetAsCurrent}</a>
              </#if>
            </td>
            <td><input type="text" size='12' name="currentCustomTimePeriod" value="${currentCustomTimePeriod.organizationPartyId!}" /></td>
            <td>
              <select name="periodTypeId">
                <#list periodTypes as periodType>
                  <#assign isDefault = false>
                  <#if (currentCustomTimePeriod.periodTypeId)??>
                    <#if currentCustomTimePeriod.periodTypeId = periodType.periodTypeId>
                      <#assign isDefault = true>
                    </#if>
                  </#if>
                  <option value='${periodType.periodTypeId}'<#if isDefault> selected="selected"</#if>>
                    ${periodType.description} [${periodType.periodTypeId}]
                  </option>
                </#list>
              </select>
            </td>
            <td><input type="text" size='4' name="periodNum" value="${currentCustomTimePeriod.periodNum!}" /></td>
            <td><input type="text" size='10' name="periodName" value="${currentCustomTimePeriod.periodName!}" /></td>
            <td>
              <#assign hasntStarted = false>
              <#assign compareDate = currentCustomTimePeriod.getTimestamp("fromDate")>
              <#if compareDate?has_content>
                <#if nowTimestamp.before(compareDate)><#assign hasntStarted = true></#if>
              </#if>
              <input type="text" size='13' name="fromDate" value="${currentCustomTimePeriod.fromDate?string("yyyy-MM-dd")}"<#if hasntStarted> class="alert"</#if> />
            </td>
            <td>
              <#assign hasExpired = false>
              <#assign compareDate = currentCustomTimePeriod.getTimestamp("thruDate")>
              <#if compareDate?has_content>
                <#if nowTimestamp.after(compareDate)><#assign hasExpired = true></#if>
              </#if>
              <input type="text" size='13' name="thruDate" value="${currentCustomTimePeriod.thruDate?string("yyyy-MM-dd")}"<#if hasntStarted> class="alert"</#if> />
            </td>
            <td class="button-col">
              <input type="submit" value='${uiLabelMap.CommonUpdate}'/>
            </td>
          </form>
          <td class="button-col">
            <form method="post" action='<@ofbizUrl>deleteCustomTimePeriod</@ofbizUrl>' name='deleteCustomTimePeriodForm'>
              <input type="hidden" name="customTimePeriodId" value="${currentCustomTimePeriod.customTimePeriodId!}" />
              <input type="submit" value='${uiLabelMap.CommonDelete}'/>
            </form>
          </td>
        </tr>
      </table>
    <#else>
      <div class="screenlet-body">${uiLabelMap.AccountingNoCurrentCustomTimePeriodSelected}</div>
    </#if>
  </div>

  <div class="screenlet">
    <div class="screenlet-title-bar">
      <ul>
        <li class="h3">${uiLabelMap.AccountingChildPeriods}</li>
      </ul>
      <br class="clear"/>
    </div>
    <#if customTimePeriods?has_content>
      <table class="basic-table" cellspacing="0">
        <tr class="header-row">
          <td>${uiLabelMap.CommonId}</td>
          <td>${uiLabelMap.CommonParent}</td>
          <td>${uiLabelMap.AccountingOrgPartyId}</td>
          <td>${uiLabelMap.AccountingPeriodType}</td>
          <td>${uiLabelMap.CommonNbr}</td>
          <td>${uiLabelMap.AccountingPeriodName}</td>
          <td>${uiLabelMap.CommonFromDate}</td>
          <td>${uiLabelMap.CommonThruDate}</td>
          <td colspan="3">&nbsp;</td>
        </tr>
        <#assign line = 0>
        <#list customTimePeriods as customTimePeriod>
          <#assign line = line + 1>
          <#assign periodType = customTimePeriod.getRelatedOne("PeriodType", true)>
          <tr>
            <form method="post" action='<@ofbizUrl>updateCustomTimePeriod</@ofbizUrl>' onsubmit="return validateForm('lineForm${line}')" name='lineForm${line}'>
              <input type="hidden" name="customTimePeriodId" value="${customTimePeriod.customTimePeriodId!}" />
              <td>${customTimePeriod.customTimePeriodId}</td>
              <td>
                <select name="parentPeriodId">
                  <option value=''>&nbsp;</option>
                  <#list allCustomTimePeriods as allCustomTimePeriod>
                    <#assign allPeriodType = allCustomTimePeriod.getRelatedOne("PeriodType", true)>
                    <#assign isDefault = false>
                    <#if (currentCustomTimePeriod.parentPeriodId)??>
                      <#if currentCustomTimePeriod.customTimePeriodId = allCustomTimePeriod.customTimePeriodId>
                        <#assign isDefault = true>
                      </#if>
                    </#if>
                    <option value='${allCustomTimePeriod.customTimePeriodId}'<#if isDefault> selected="selected"</#if>>
                      ${allCustomTimePeriod.organizationPartyId}
                      <#if allPeriodType??> ${allPeriodType.description}: </#if>
                      ${allCustomTimePeriod.periodNum!}
                      [${allCustomTimePeriod.customTimePeriodId}]
                    </option>
                  </#list>
                </select>
              </td>
              <td><input type="text" size='12' name="organizationPartyId" value="${customTimePeriod.organizationPartyId!}" /></td>
              <td>
                <select name="periodTypeId">
                  <#list periodTypes as periodType>
                    <#assign isDefault = false>
                    <#if (customTimePeriod.periodTypeId)??>
                      <#if customTimePeriod.periodTypeId = periodType.periodTypeId>
                       <#assign isDefault = true>
                      </#if>
                    </#if>
                    <option value='${periodType.periodTypeId}'<#if isDefault> selected="selected"</#if>>${periodType.description} [${periodType.periodTypeId}]</option>
                  </#list>
                </select>
              </td>
              <td><input type="text" size='4' name="periodNum" value="${customTimePeriod.periodNum!}" /></td>
              <td><input type="text" size='10' name="periodName" value="${customTimePeriod.periodName!}" /></td>
              <td>
                <#assign hasntStarted = false>
                <#assign compareDate = customTimePeriod.getTimestamp("fromDate")>
                <#if compareDate?has_content>
                  <#if nowTimestamp.before(compareDate)><#assign hasntStarted = true></#if>
                </#if>
                <input type="text" size='13' id name="fromDate" value="${customTimePeriod.fromDate?string("yyyy-MM-dd")}"<#if hasntStarted> class="alert"</#if> />
              </td>
              <td>
                <#assign hasExpired = false>
                <#assign compareDate = customTimePeriod.getTimestamp("thruDate")>
                <#if compareDate?has_content>
                  <#if nowTimestamp.after(compareDate)><#assign hasExpired = true></#if>
                </#if>
                <input type="text" size='13' id="thru" name="thruDate" value="${customTimePeriod.thruDate?string("yyyy-MM-dd")}"<#if hasExpired> class="alert"</#if> />
              </td>
              <td class="button-col">
                <input type="submit" value='${uiLabelMap.CommonUpdate}'/>
              </td>
            </form>
            <td class="button-col">
              <form method="post" action='<@ofbizUrl>deleteCustomTimePeriod</@ofbizUrl>' name='lineForm${line}'>
                <input type="hidden" name="customTimePeriodId" value="${customTimePeriod.customTimePeriodId!}" />
                <input type="submit" value='${uiLabelMap.CommonDelete}'/>
              </form>
            </td>
            <td class="button-col">
              <a href='<@ofbizUrl>EditCustomTimePeriod?currentCustomTimePeriodId=${customTimePeriod.customTimePeriodId!}&amp;findOrganizationPartyId=${findOrganizationPartyId!}</@ofbizUrl>'>
              ${uiLabelMap.CommonSetAsCurrent}</a>
            </td>
          </tr>
        </#list>
      </table>
    <#else>
      <div class="screenlet-body">${uiLabelMap.AccountingNoChildPeriodsFound}</div>
    </#if>
  </div>

  <div class="row m-2">
    <div class="card col-sm-8 offset-sm-2 ">
      <div class="card-header h3 green darken-4 white-text text-darken-4 w-100 font-weight-bolder" >
        ${uiLabelMap.AccountingAddCustomTimePeriod}
      </div>
      <div class="card-body">
        <form method="post" class="row p-0" action="<@ofbizUrl>createCustomTimePeriod</@ofbizUrl>" onsubmit="return validateForm2()" name="createCustomTimePeriodForm"  >
          <input type="hidden" name="findOrganizationPartyId" value="${findOrganizationPartyId!}" />
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

          <div class="col-sm-12" style="text-align: left !important;">
            <!-- Default input -->
            <label for="organizationPartyId" >${uiLabelMap.AccountingOrgPartyId}</label>
            <input type="text" size='20' required id="organizationPartyId" name='organizationPartyId' class="form-control">
          </div>

          <label    class="mb-0 mt-2 ml-3">${uiLabelMap.AccountingPeriodType}</label>
          <div class="md-form col-sm-12 mt-0" >

          <select class="browser-default custom-select" name="periodTypeId">
              <option selected value=''>${uiLabelMap.AccountingPeriodType}</option>
              <#list periodTypes as periodType>
                <#assign isDefault = false>
                <#if newPeriodTypeId??>
                  <#if newPeriodTypeId = periodType.periodTypeId>
                    <#assign isDefault = true>
                  </#if>
                </#if>
                <option value="${periodType.periodTypeId}" <#if isDefault>selected="selected"</#if>>${periodType.description} [${periodType.periodTypeId}]</option>
              </#list>
            </select>
          </div>


          <div class="col-sm-6" style="text-align: left !important;">
            <!-- Default input -->
            <label for="periodNum" >${uiLabelMap.AccountingPeriodNumber}</label>
            <input type="text" size='4'  id="periodNum" name='periodNum' class="form-control">
          </div>

          <div class="col-sm-6" style="text-align: left !important;">
            <!-- Default input -->
            <label for="periodName" >${uiLabelMap.AccountingPeriodName}</label>
            <input type="text" size='10' required="required" name='periodName' class="form-control">
          </div>
          <div class="col-sm-6" style="text-align: left !important;">

          <div class="md-form">
            <input type="text" size='14'  id="fromDate" name='fromDate'  class="form-control datepicker">
            <label for="fromDate">${uiLabelMap.CommonFromDate}</label>
          </div>
          </div>

          <div class="col-sm-6" style="text-align: left !important;">

            <div class="md-form">
              <input type="text" size='14' id="thruDate"  name='thruDate'  class="form-control datepicker">
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

<#else>
  <h3>${uiLabelMap.AccountingPermissionPeriod}.</h3>
</#if>
