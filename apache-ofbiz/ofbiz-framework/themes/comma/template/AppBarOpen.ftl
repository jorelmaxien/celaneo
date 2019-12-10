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
<#if (requestAttributes.externalLoginKey)??><#assign externalKeyParam = "?externalLoginKey=" + requestAttributes.externalLoginKey!></#if>
<#if (externalLoginKey)??><#assign externalKeyParam = "?externalLoginKey=" + requestAttributes.externalLoginKey!></#if>
<#assign ofbizServerName = application.getAttribute("_serverId")?default("default-server")>
<#assign contextPath = request.getContextPath()>
<#assign displayApps = Static["org.apache.ofbiz.webapp.control.LoginWorker"].getAppBarWebInfos(security, userLogin, ofbizServerName, "main")>
<#assign displaySecondaryApps = Static["org.apache.ofbiz.webapp.control.LoginWorker"].getAppBarWebInfos(security, userLogin, ofbizServerName, "secondary")>

<#assign appModelMenu = Static["org.apache.ofbiz.widget.model.MenuFactory"].getMenuFromLocation(applicationMenuLocation,applicationMenuName,visualTheme)>
<#if appModelMenu.getModelMenuItemByName(headerItem)??>
  <#if headerItem!="main">
    <#assign show_last_menu = true>
  </#if>
</#if>

<#--<div class="tabbar">-->
<#--    <div class="breadcrumbs<#if show_last_menu??> menu_selected</#if>">-->
<#--    <div class="breadcrumbs-start">-->
<#--      <div id="main-navigation">-->
<#--        <h2>${uiLabelMap.CommonApplications}</h2>-->

<#--          <ul>-->
<#--          <li>-->
<#--            <ul><li><ul class="primary">-->
<#--            &lt;#&ndash; Primary Applications &ndash;&gt;-->
<#--            <#list displayApps as display>-->
<#--              <#assign thisApp = display.getContextRoot()>-->
<#--              <#assign selected = false>-->
<#--              <#if thisApp == contextPath || contextPath + "/" == thisApp>-->
<#--                <#assign selected = true>-->
<#--              </#if>-->
<#--              <#assign thisApp = StringUtil.wrapString(thisApp)>-->
<#--              <#assign thisURL = thisApp>-->
<#--              <#if thisApp != "/">-->
<#--                <#assign thisURL = thisURL + "/control/main">-->
<#--              </#if>-->
<#--              <#if layoutSettings.suppressTab?? && display.name == layoutSettings.suppressTab>-->
<#--                <!-- do not display this component&ndash;&gt;-->
<#--              <#else>-->
<#--                  <li <#if selected>class="selected"</#if>><a href="${thisURL + externalKeyParam}" <#if uiLabelMap??> title="${uiLabelMap[display.description]}">${uiLabelMap[display.title]}<#else> title="${display.description}">${display.title}</#if></a></li>-->
<#--              </#if>-->
<#--            </#list>-->
<#--           </ul></li>-->
<#--           <li><ul class="secondary">-->
<#--            &lt;#&ndash; Secondary Applications &ndash;&gt;-->
<#--            <#list displaySecondaryApps as display>-->
<#--              <#assign thisApp = display.getContextRoot()>-->
<#--              <#assign selected = false>-->
<#--              <#if thisApp == contextPath || contextPath + "/" == thisApp>-->
<#--                <#assign selected = true>-->
<#--              </#if>-->
<#--              <#assign thisApp = StringUtil.wrapString(thisApp)>-->
<#--              <#assign thisURL = thisApp>-->
<#--              <#if thisApp != "/">-->
<#--                <#assign thisURL = thisURL + "/control/main">-->
<#--              </#if>-->
<#--              <#if layoutSettings.suppressTab?? && display.name == layoutSettings.suppressTab>-->
<#--                <!-- do not display this component&ndash;&gt;-->
<#--              <#else>-->
<#--                <li <#if selected>class="selected"</#if>><a href="${thisURL + externalKeyParam}" <#if uiLabelMap??> title="${uiLabelMap[display.description]}">${uiLabelMap[display.title]}<#else> title="${display.description}">${display.title}</#if></a></li>-->
<#--              </#if>-->
<#--            </#list>-->
<#--            </ul>-->
<#--          </li>-->
<#--        </ul>-->
<#--        </li>-->
<#--        </ul>-->
<#--      </div>-->


<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark green darken-4">

    <!-- Navbar brand -->
    <a class="navbar-brand text-uppercase" href="#">${uiLabelMap.CommonApplications}</a>

    <!-- Collapse button -->
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent2"
            aria-controls="navbarSupportedContent2" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>

    <!-- Collapsible content -->
    <div class="collapse navbar-collapse" id="navbarSupportedContent2">

        <!-- Links -->
        <ul class="navbar-nav ml-0">
            <li class="nav-item">
                <div class="dropdown ">


                    <!--Trigger-->
                    <a class="btn btn-sm  dropdown-toggle white  teal-text" type="button" id="dropdownMenu2" data-toggle="dropdown"
                       aria-haspopup="true" aria-expanded="false">${uiLabelMap.CommonApplications}</a>


                    <!--Menu-->
                    <div class="dropdown-menu dropdown-comma  p-0">
                        <#list displayApps as display>
                        <#assign thisApp = display.getContextRoot()>
                        <#assign selected = false>
                        <#if thisApp == contextPath || contextPath + "/" == thisApp>
                            <#assign selected = true>
                        </#if>
                        <#assign thisApp = StringUtil.wrapString(thisApp)>
                        <#assign thisURL = thisApp>
                        <#if thisApp != "/">
                            <#assign thisURL = thisURL + "/control/main">
                        </#if>
                        <#if layoutSettings.suppressTab?? && display.name == layoutSettings.suppressTab>
                        <!-- do not display this component-->
                        <#else>
                            <a class="dropdown-item m-0 p-1  <#if selected>active</#if>" href="${thisURL + externalKeyParam}" <#if uiLabelMap??> title="${uiLabelMap[display.description]}">${uiLabelMap[display.title]}<#else> title="${display.description}">${display.title}</#if></a>
                        </#if>
                        </#list>
                    </div>
                </div>

            </li>


        </ul>
        <!-- Links -->

        <!-- Search form -->
        <form class="form-inline mr-0">
            <div class="md-form my-0">
                <input class="form-control mr-sm-2" disabled type="text" placeholder="Search" aria-label="Search">
            </div>
        </form>

    </div>
    <!-- Collapsible content -->

</nav>
<!-- Navbar -->
