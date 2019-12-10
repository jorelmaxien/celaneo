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

<div class="screenlet">
  <div class="screenlet-title-bar">
    <ul>
      <li class="h3">
          ${uiLabelMap.newCustomerTitle}
      </li>
<#--      <li><a href="<@ofbizUrl>NewCustomer</@ofbizUrl>">${uiLabelMap.Save}</a></li>-->
    </ul>
  </div>
</div>

<#if security.hasEntityPermission("ACCOUNTING", "_CREATE", session) || security.hasEntityPermission("ACCOUNTING", "_PURCHASE_CREATE", session)>
  <div class="screenlet-body">
      <table width="100%" border="0" cellspacing="0" cellpadding="0" class="boxbottom">
        <form name="checkoutsetupform" method="post" action="<@ofbizUrl>createCustomer</@ofbizUrl>">
        <input type="hidden" name="finalizeMode" value="cust" />
        <input type="hidden" name="finalizeReqNewShipAddress" value="true" />
        <tr>
          <td>
            <table width="100%" border="0" cellpadding="1" cellspacing="0">
              <tr>
                <td width="26%" align="right"><div>${uiLabelMap.CommonTitle}</div></td>
                <td width="5">&nbsp;</td>
                <td width="74%">
                  <select name="personalTitle">
                    <#if requestParameters.personalTitle!? has_content>
                        <option value="${requestParameters.personalTitle!}" selected="selected">${requestParameters.personalTitle!}</option>
                    </#if>
                    <option value="Mr">Mr</option>
                    <option value="Mne">Mne</option>
                    <option value="Mlle">Mlle</option>
                  </select>
                </td>
              </tr>
              <tr>
                <td width="26%" align="right"><div>${uiLabelMap.PartyFirstName}</div></td>
                <td width="5">&nbsp;</td>
                <td width="74%">
                  <input type="text" name="firstName" value="${requestParameters.firstName!}" size="30" maxlength="30"/>
                *</td>
              </tr>
              <tr>
                <td width="26%" align="right"><div>${uiLabelMap.PartyLastName}</div></td>
                <td width="5">&nbsp;</td>
                <td width="74%">
                  <input type="text" name="lastName" value="${requestParameters.lastName!}" size="30" maxlength="30"/>
                *</td>
              </tr>
              <tr>
                <td colspan="3">&nbsp;</td>
              </tr>


                  <input type="hidden" name="homeAreaCode" value="+224" size="4" maxlength="10"/>


              <tr>
                <td width="26%" align="right"><div>GSM1</div></td>
                <td width="5">&nbsp;</td>
                <td width="74%">
                <input type="text" name="homeContactNumber" value="${requestParameters.homeContactNumber!}" size="15" maxlength="15"/>*
                <input type="hidden" name="homeSol" value="Y" size="15" maxlength="15"/>
                  <br/>
                </td>
              </tr>

              <tr>
                <td colspan="3">&nbsp;</td>
              </tr>


                 <input type="hidden" name="workAreaCode" value="+224" size="4" maxlength="10"/>


              <tr>
                <td width="26%" align="right"><div>GSM2</div></td>
                <td width="5">&nbsp;</td>
                <td width="74%">
                  <input type="text" name="workContactNumber" value="${requestParameters.CUSTOMER_WORK_CONTACT!}" size="15" maxlength="15"/>
                  <input type="hidden" name="workContactNumber" value="Y"/>
                  <br/>
                </td>
              </tr>


              <tr>
                <td colspan="3">&nbsp;</td>
              </tr>
              <tr>
                <td width="26%" align="right"><div>${uiLabelMap.PartyEmailAddress}</div></td>
                <td width="5">&nbsp;</td>
                <td width="74%">
                  <input type="text" name="emailAddress" value="" size="60" maxlength="255" />
                  <input type="hidden" name="emailSol" value="Y" />
                  <br/>
                </td>
              </tr>
              <tr>
                <td colspan="3">&nbsp;</td>
              </tr>
              <tr>
                <td width="26%" align="right"><div>${uiLabelMap.CommonUsername}</div></td>
                <td width="5">&nbsp;</td>
                <td width="74%">
                  <input type="text" name="userLoginId" value="${requestParameters.USERNAME!}" size="20" maxlength="250"/>
                </td>
              </tr>
              <tr><td colspan="3"><hr /></td></tr>
              <tr>
                <td width="26%" align="right"><div></div></td>
                <td width="5">&nbsp;</td>
                <td width="74%">
                  <input type="submit" value="${uiLabelMap.save}"/>
                </td>
              </tr>
              </form>
            </table>
          </td>
        </tr>
      </table>
   </div>
<br />
<#else>
  <h3>${uiLabelMap.OrderViewPermissionError}</h3>
</#if>
