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

<#--<#if requestAttributes.uiLabelMap??><#assign uiLabelMap = requestAttributes.uiLabelMap></#if>-->
<#--<#assign useMultitenant = Static["org.apache.ofbiz.base.util.UtilProperties"].getPropertyValue("general.properties", "multitenant")>-->

<#--<#assign username = requestParameters.USERNAME?default((sessionAttributes.autoUserLogin.userLoginId)?default(""))>-->
<#--<#if username != "">-->
<#--  <#assign focusName = false>-->
<#--<#else>-->
<#--  <#assign focusName = true>-->
<#--</#if>-->
<#--<center>-->
<#--  <div class="screenlet login-screenlet">-->
<#--    <div class="screenlet-title-bar">-->
<#--      <h3>${uiLabelMap.CommonRegistered}</h3>-->
<#--    </div>-->
<#--    <div class="screenlet-body">-->
<#--      <form method="post" action="<@ofbizUrl>login</@ofbizUrl>" name="loginform">-->
<#--        <table class="basic-table" cellspacing="0">-->
<#--          <tr>-->
<#--            <td class="label">${uiLabelMap.CommonUsername}</td>-->
<#--            <td><input type="text" name="USERNAME" value="${username}" size="20"/></td>-->
<#--          </tr>-->
<#--          <tr>-->
<#--            <td class="label">${uiLabelMap.CommonPassword}</td>-->
<#--            <td><input type="password" name="PASSWORD" autocomplete="off" value="" size="20"/></td>-->
<#--          </tr>-->
<#--          <#if ("Y" == useMultitenant) >-->
<#--            <#if !requestAttributes.userTenantId??>-->
<#--              <tr>-->
<#--                <td class="label">${uiLabelMap.CommonTenantId}</td>-->
<#--                <td><input type="text" name="userTenantId" value="${parameters.userTenantId!}" size="20"/></td>-->
<#--              </tr>-->
<#--            <#else>-->
<#--                <input type="hidden" name="userTenantId" value="${requestAttributes.userTenantId!}"/>-->
<#--            </#if>-->
<#--          </#if>-->
<#--          <tr>-->
<#--            <td colspan="2" align="center">-->
<#--              <input type="submit" value="${uiLabelMap.CommonLogin}"/>-->
<#--            </td>-->
<#--          </tr>-->
<#--        </table>-->
<#--        <input type="hidden" name="JavaScriptEnabled" value="N"/>-->
<#--        <br />-->
<#--        <a href="<@ofbizUrl>forgotPassword_step1</@ofbizUrl>">${uiLabelMap.CommonForgotYourPassword}?</a>-->
<#--      </form>-->
<#--    </div>-->
<#--  </div>-->
<#--</center>-->

<#--<script type="application/javascript">-->
<#--  document.loginform.JavaScriptEnabled.value = "Y";-->
<#--  <#if focusName>-->
<#--    document.loginform.USERNAME.focus();-->
<#--  <#else>-->
<#--    document.loginform.PASSWORD.focus();-->
<#--  </#if>-->
<#--</script>-->



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

<#if requestAttributes.uiLabelMap??><#assign uiLabelMap = requestAttributes.uiLabelMap></#if>
<#assign useMultitenant = Static["org.apache.ofbiz.base.util.UtilProperties"].getPropertyValue("general.properties", "multitenant")>

<#assign username = requestParameters.USERNAME?default((sessionAttributes.autoUserLogin.userLoginId)?default(""))>
<#if username != "">
  <#assign focusName = false>
<#else>
  <#assign focusName = true>
</#if>



<!-- Material form subscription -->
<div class="card card-cascade z-depth-3 narrower col-sm-5 mx-auto mt-6 pt-8">


  <h5 class="mt-2 view view-cascade gradient-card-header rpn-green-gradient  white-text text-center p-3">
    <strong>${uiLabelMap.CommonRegistered}</strong>
  </h5>

  <!--Card content-->

  <!-- Form -->
    <form method="post"  class="card-body " action="<@ofbizUrl>login</@ofbizUrl>" name="loginform">

    <p class="text-center small" >
      <a href="" target="_blank"  style="color: #1b5e20">l'Impossible, Notre motivation</a>
    </p>

    <!-- Name -->
    <div class="md-form mt-4">
      <i class="fa fa-user prefix grey-text"></i>
      <input type="text" name="USERNAME" value="${username}" id="materialSubscriptionFormUser" class="form-control" autofocus>
      <label for="materialSubscriptionFormUser">${uiLabelMap.CommonUsername}</label>
    </div>

    <!-- E-mai -->
    <div class="md-form mt-4">
      <i class="fa fa-lock prefix grey-text small"></i>

      <input type="password" name="PASSWORD" autocomplete="off" id="materialSubscriptionFormPassword" class="form-control">
      <label for="materialSubscriptionFormPassword">${uiLabelMap.CommonPassword}</label>
    </div>

    <#if ("Y" == useMultitenant) >
      <#if !requestAttributes.userTenantId??>

        <!-- E-mai -->
        <div class="md-form mt-4">
          <i class="fa fa-user prefix grey-text"></i>
          <input type="text" name="userTenantId" id="materialSubscriptionFormTenantId" value="${parameters.userTenantId!}" class="form-control">
          <label for="materialSubscriptionFormTenantId">${uiLabelMap.CommonTenantId}</label>
        </div>
      <#else>
        <input  type="hidden" name="userTenantId" value="${requestAttributes.userTenantId!}"/>
      </#if>
    </#if>
    <!-- Sign in button -->
    <button class="btn rpn-green-gradient col-sm-7 mx-auto  white-text btn-rounded btn-block z-depth-2 my-4 waves-effect "  style="border-radius: 10em" type="submit">${uiLabelMap.CommonLogin}<i class="fa fa-sign-in-alt suffix pl-2"></i></button>

    <input type="hidden" name="JavaScriptEnabled" value="N"/>
    <br />
    <a  style="color: #1b5e20" class="small mt-0" href="<@ofbizUrl>forgotPassword_step1</@ofbizUrl>">${uiLabelMap.CommonForgotYourPassword}?</a>
  </form>
  <!-- Form -->


</div>


<script type="application/javascript">
  document.loginform.JavaScriptEnabled.value = "Y";
  <#if focusName>
  document.loginform.USERNAME.focus();
  <#else>
  document.loginform.PASSWORD.focus();
  </#if>
</script>
<!-- Material form subscription -->


