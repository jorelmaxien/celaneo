</div>

<#list layoutSettings.javaScripts as javaScript>
    <script type="text/javascript" src="${StringUtil.wrapString(javaScript)}"></script>
</#list>
<script>
    new WOW().init();

</script>
</body>
</html>