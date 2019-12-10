<html>
<head>
    <title>
        <#if layoutSettings.companyName?has_content>

        ${layoutSettings.companyName}
        <#else>
            Company
        </#if>
    </title>
    <meta name="viewport" content="width=device-width, user-scalable=no"/>

    <#if webSiteFaviconContent?has_content>
        <link rel="shortcut icon" href="">
    </#if>
    <#list layoutSettings.styleSheets as styleSheet>
        <link rel="stylesheet" href="${StringUtil.wrapString(styleSheet)}" type="text/css"/>
    </#list>

</head>
<body data-offset="125" class="grey lighten-4">
<!-- Image and text -->
<nav class="navbar navbar-dark white-color p-0" style="background-color: #fff">
    <a class="navbar-brand ml-2" href="#">
        <img src="<@ofbizContentUrl>/images/comma_logo.png</@ofbizContentUrl>" height="55" width="175" class="d-inline-block align-top" alt="mdb logo"/> Bootstrap
    </a>
</nav>
<div class="container menus mt-4" id="container" >
    <div class="row ">