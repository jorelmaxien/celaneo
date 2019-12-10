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
<#assign externalKeyParam = "&amp;externalLoginKey=" + requestAttributes.externalLoginKey!>

<#if (requestAttributes.person)??><#assign person = requestAttributes.person></#if>
<#if (requestAttributes.partyGroup)??><#assign partyGroup = requestAttributes.partyGroup></#if>
<#assign docLangAttr = locale.toString()?replace("_", "-")>
<#assign langDir = "ltr">
<#if "ar.iw"?contains(docLangAttr?substring(0, 2))>
    <#assign langDir = "rtl">
</#if>
<html lang="${docLangAttr}" dir="${langDir}" xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <title>${layoutSettings.companyName?replace("OFBiz","COMMA")}: <#if (titleProperty)?has_content>${uiLabelMap[titleProperty]}<#else>${title!}</#if></title>
    <#if layoutSettings.shortcutIcon?has_content>
      <#assign shortcutIcon = layoutSettings.shortcutIcon/>
    <#elseif layoutSettings.VT_SHORTCUT_ICON?has_content>
      <#assign shortcutIcon = layoutSettings.VT_SHORTCUT_ICON   />
    </#if>
    <#if shortcutIcon?has_content>
        <link rel="shortcut icon" href="<@ofbizContentUrl>${StringUtil.wrapString(shortcutIcon)+".ico"}</@ofbizContentUrl>" type="image/x-icon">
        <link rel="icon" href="<@ofbizContentUrl>${StringUtil.wrapString(shortcutIcon)+".png"}</@ofbizContentUrl>" type="image/png">
        <link rel="icon" sizes="32x32" href="<@ofbizContentUrl>${StringUtil.wrapString(shortcutIcon)+"-32.png"}</@ofbizContentUrl>" type="image/png">
        <link rel="icon" sizes="64x64" href="<@ofbizContentUrl>${StringUtil.wrapString(shortcutIcon)+"-64.png"}</@ofbizContentUrl>" type="image/png">
        <link rel="icon" sizes="96x96" href="<@ofbizContentUrl>${StringUtil.wrapString(shortcutIcon)+"-96.png"}</@ofbizContentUrl>" type="image/png">
    </#if>
    <#if layoutSettings.VT_HDR_JAVASCRIPT?has_content>
        <#list layoutSettings.VT_HDR_JAVASCRIPT as javaScript>
            <script src="<@ofbizContentUrl>${StringUtil.wrapString(javaScript)}</@ofbizContentUrl>" type="application/javascript"></script>
        </#list>
    </#if>
    <#if layoutSettings.javaScripts?has_content>
      <#--layoutSettings.javaScripts is a list of java scripts. -->
      <#-- use a Set to make sure each javascript is declared only once, but iterate the list to maintain the correct order -->
      <#assign javaScriptsSet = Static["org.apache.ofbiz.base.util.UtilMisc"].toSet(layoutSettings.javaScripts)/>
      <#list layoutSettings.javaScripts as javaScript>
        <#if javaScriptsSet.contains(javaScript)>
          <#assign nothing = javaScriptsSet.remove(javaScript)/>
          <script src="<@ofbizContentUrl>${StringUtil.wrapString(javaScript)}</@ofbizContentUrl>" type="application/javascript"></script>
        </#if>
      </#list>
    </#if>

    <#if layoutSettings.styleSheets?has_content>
        <#--layoutSettings.styleSheets is a list of style sheets. So, you can have a user-specified "main" style sheet, AND a component style sheet.-->
        <#list layoutSettings.styleSheets as styleSheet>
            <link rel="stylesheet" href="<@ofbizContentUrl>${StringUtil.wrapString(styleSheet)}</@ofbizContentUrl>" type="text/css"/>
        </#list>
    </#if>
    <#if layoutSettings.VT_STYLESHEET?has_content>
        <#list layoutSettings.VT_STYLESHEET as styleSheet>
            <link rel="stylesheet" href="<@ofbizContentUrl>${StringUtil.wrapString(styleSheet)}</@ofbizContentUrl>" type="text/css"/>
        </#list>
    </#if>
    <#if layoutSettings.rtlStyleSheets?has_content && "rtl" == langDir>
        <#--layoutSettings.rtlStyleSheets is a list of rtl style sheets.-->
        <#list layoutSettings.rtlStyleSheets as styleSheet>
            <link rel="stylesheet" href="<@ofbizContentUrl>${StringUtil.wrapString(styleSheet)}</@ofbizContentUrl>" type="text/css"/>
        </#list>
    </#if>
    <#if layoutSettings.VT_RTL_STYLESHEET?has_content && "rtl" == langDir>
        <#list layoutSettings.VT_RTL_STYLESHEET as styleSheet>
            <link rel="stylesheet" href="<@ofbizContentUrl>${StringUtil.wrapString(styleSheet)}</@ofbizContentUrl>" type="text/css"/>
        </#list>
    </#if>
    <#if layoutSettings.VT_EXTRA_HEAD?has_content>
        <#list layoutSettings.VT_EXTRA_HEAD as extraHead>
            ${extraHead}
        </#list>
    </#if>
    <#if layoutSettings.WEB_ANALYTICS?has_content>
      <script type="application/javascript">
        <#list layoutSettings.WEB_ANALYTICS as webAnalyticsConfig>
          ${StringUtil.wrapString(webAnalyticsConfig.webAnalyticsCode!)}
        </#list>
      </script>
    </#if>
</head>
<#if layoutSettings.headerImageLinkUrl??>
  <#assign logoLinkURL = "${layoutSettings.headerImageLinkUrl}">
<#else>
  <#assign logoLinkURL = "${layoutSettings.commonHeaderImageLinkUrl}">
</#if>
<#assign organizationLogoLinkURL = "${layoutSettings.organizationLogoLinkUrl!}">

<#if person?has_content>
  <#assign userName = (person.firstName!) + " " + (person.middleName!) + " " + person.lastName!>
<#elseif partyGroup?has_content>
  <#assign userName = partyGroup.groupName!>
<#elseif userLogin??>
  <#assign userName = userLogin.userLoginId>
<#else>
  <#assign userName = "">
</#if>

<#if defaultOrganizationPartyGroupName?has_content>
  <#assign orgName = " - " + defaultOrganizationPartyGroupName!>
<#else>
  <#assign orgName = "">
</#if>

<body class="container-fluid grey lighten-4 " style=" width: 100vw; height: 100vh; position: absolute; left:0; right:0 ; border: 1px solid black;">
  <#include "component://common-theme/template/ImpersonateBanner.ftl"/>
  <div id="wait-spinner" style="display:none">
    <div id="wait-spinner-image"></div>
  </div>
  <div class="page-container container-fluid " style="position: absolute; left:0; right:0 ; width: 100vw; height: 100vh;">
    <div class="hidden">
      <a href="#column-container" title="${uiLabelMap.CommonSkipNavigation}" accesskey="2">
        ${uiLabelMap.CommonSkipNavigation}
      </a>
    </div>
      <!--Navbar -->
      <nav class="mb-2 navbar fixed-top navbar-expand-lg navbar-dark white green-darken-text p-0  pl-0 z-depth-3" >
          <a class="navbar-brand green-darken-text" href="#"><img src="<@ofbizContentUrl>/images/comma_logo.png</@ofbizContentUrl>" height="60" width="190" alt="mdb logo"></a>
          <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent-4"
                  aria-controls="navbarSupportedContent-4" aria-expanded="false" aria-label="Toggle navigation">
              <span class="navbar-toggler-icon"></span>
          </button>
          <div class="collapse navbar-collapse " id="navbarSupportedContent-4">
              <ul class="navbar-nav mr-0 align-middle mt-1" style="font-size: 0.8rem">
                  <#if userLogin??>
                      <#if userLogin.partyId??>
                          <#assign size = companyListSize?default(0)>
                          <#if size &gt; 1>
                              <#assign currentCompany = delegator.findOne("PartyNameView", {"partyId" : organizationPartyId}, false)>
                              <#if currentCompany?exists>
                                  <li class="nav-item">
                                      <a class="nav-link green-darken-text" style="font-size: 0.8rem" href="<@ofbizUrl>ListSetCompanies</@ofbizUrl>">
                                          <i class="fas fa-building fa-lg"></i> ${currentCompany.groupName}</a>
                                  </li>
                              </#if>
                          </#if>

<#--                          <li class="nav-item">-->
<#--                              <a class="nav-link green-darken-text" href="/partymgr/control/viewprofile?partyId=${userLogin.partyId}${externalKeyParam!}">-->
<#--                                  <i class="fab fa-instagram"></i> ${userName}</a>-->
<#--                          </li>-->
                      <#else>
<#--                          <li class="nav-item">-->
<#--                              <a class="nav-link green-darken-text" href="#">-->
<#--                                  <i class="fab fa-instagram"></i> ${userName}</a>-->
<#--                          </li>-->
                      </#if>
                      <#if orgName?has_content>
<#--                          <li class="nav-item">-->
<#--                              <div class="btn-group">-->
<#--                                  <button type="button" class="btn btn-danger">Danger</button>-->
<#--                                  <button type="button" class="btn btn-danger dropdown-toggle px-3" data-toggle="dropdown" aria-haspopup="true"-->
<#--                                          aria-expanded="false">-->
<#--                                      <span class="sr-only">Toggle Dropdown</span>-->
<#--                                  </button>-->
<#--                                  <div class="dropdown-menu">-->
<#--                                      <div class="dropdown-item">-->
<#--                                          <form action="changeAccountingOrganization" method="post">-->
<#--                                              <input type="hidden" name="organizationPartyId" value="Primary">-->
<#--                                              <button type="submit">Primary</button>-->
<#--                                          </form>-->
<#--                                      </div>-->
<#--                                      <div class="dropdown-item">-->
<#--                                          <form action="changeAccountingOrganization" method="post">-->
<#--                                              <input type="hidden" name="organizationPartyId" value="Secondary">-->
<#--                                              <button type="submit">Secondary</button>-->
<#--                                          </form>-->
<#--                                      </div>-->

<#--                                  </div>-->
<#--                              </div>-->
<#--                          </li>-->

                          <li class="nav-item">
                              <a class="nav-link green-darken-text" href="#" style="font-size: 0.8rem">
                                  <i class="far fa-building fa-lg"></i>${orgName}</a>
                          </li>
                      </#if>
                  </#if>
                  <li class="nav-item">
                      <a class="nav-link green-darken-text" href="<@ofbizUrl>ListLocales</@ofbizUrl>">
                          <i class="fas fa-language fa-lg"></i> ${uiLabelMap.CommonLanguageTitle} : ${locale.getDisplayName(locale)}</a>
                  </li>
                  <#if userLogin??>
<#--                      <li class="nav-item">-->
<#--                          <a class="nav-link green-darken-text" href="<@ofbizUrl>ListVisualThemes</@ofbizUrl>">-->
<#--                              <i class="fas fa-desktop fa-lg"></i>${uiLabelMap.CommonVisualThemes}</a>-->
<#--                      </li>-->

                      <li class="nav-item ml-auto left" >
                          <div class="dropdown ">
                              <a class="nav-link dropdown-toggle green-darken-text" id="navbarDropdownMenuLink-4" data-toggle="dropdown"
                                 aria-haspopup="true" style="font-size: 0.9rem" aria-expanded="false">
                                  <i class="fas fa-user fa-lg"></i> ${userName}</a>
                              <div class="dropdown-menu  dropdown-menu-right dropdown-comma" aria-labelledby="navbarDropdownMenuLink-4">
                                  <a class="dropdown-item" href="<@ofbizUrl>logout</@ofbizUrl>">${uiLabelMap.CommonLogout}</a>
                                  <#if userLogin.partyId?has_content>
                                  <a class="dropdown-item" href="/partymgr/control/viewprofile?partyId=${userLogin.partyId}${externalKeyParam!}">${uiLabelMap.CommonMyProfile}</a>
                                  </#if>

                              </div>
                          </div>

                      </li>
                  <#else>
                      <li class="nav-item">
                          <a class="nav-link green-darken-text"  href="<@ofbizUrl>${checkLoginUrl}</@ofbizUrl>">
                              <i class="fab fa-instagram"></i> ${uiLabelMap.CommonLogin}</a>
                      </li>
                  </#if>
                  <#--if webSiteId?? && requestAttributes._CURRENT_VIEW_?? && helpTopic??-->
                  <#if parameters.componentName?? && requestAttributes._CURRENT_VIEW_?? && helpTopic??>
                      <#include "component://common-theme/template/includes/HelpLink.ftl" />
                      <li class="nav-item <#if pageAvail?has_content> alert</#if>">
                          <a class="nav-link green-darken-text"  href="javascript:lookup_popup1('showHelp?helpTopic=${helpTopic}&amp;portalPageId=${(parameters.portalPageId!)?html}','help' ,500,500);"  title="${uiLabelMap.CommonHelp}">
                          </a>
                      </li>
                  </#if>

              </ul>
          </div>
      </nav>
      <div class="container-fluid mt-4 pt-5 white pl-0 pr-0 pr-0" style="width: 100vw; height: 100vh ; position: absolute; left:0">




      <!--/.Navbar -->

