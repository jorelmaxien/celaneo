

$(document).ready(function () {
    $('.custom-select').on('change', function () {
        if($(this).val()==='Orange money'){
            $('#tel').text('+237690936820');
        }else {
            $('#tel').text('+237683752282');
        }
    });

    $('#typeCreditation').on('change', function () {
        if($(this).val()==='mobile'){
            $("#1").text('Numero de telephone');
            $("#2").text('Type de paiement');
        }else {
            $("#1").text('Adresse de depot');
            $("#2").text('Type adresse');
        }
    });

});

var createSnackbar = (function() {
    // Any snackbar that is already shown
    var previous = null;

    return function(message, actionText, action) {
        if (previous) {
            previous.dismiss();
        }
        var snackbar = document.createElement('div');
        snackbar.className = 'paper-snackbar';
        snackbar.dismiss = function() {
            this.style.opacity = 0;
        };
        var text = document.createTextNode(message);
        snackbar.appendChild(text);
        if (actionText) {
            if (!action) {
                action = snackbar.dismiss.bind(snackbar);
            }
            var actionButton = document.createElement('button');
            actionButton.className = 'action';
            actionButton.innerHTML = "<span class='fa fa-remove float-right'></span>";
            actionButton.addEventListener('click', action);
            snackbar.appendChild(actionButton);
        }
        setTimeout(function() {
            if (previous === this) {
                previous.dismiss();
            }
        }.bind(snackbar), 5000);

        snackbar.addEventListener('transitionend', function(event, elapsed) {
            if (event.propertyName === 'opacity' && this.style.opacity == 0) {
                this.parentElement.removeChild(this);
                if (previous === this) {
                    previous = null;
                }
            }
        }.bind(snackbar));



        previous = snackbar;
        document.body.appendChild(snackbar);
        // In order for the animations to trigger, I have to force the original style to be computed, and then change it.
        getComputedStyle(snackbar).bottom;
        snackbar.style.bottom = '0px';
        snackbar.style.opacity = 1;
    };
})();

function checkpayment(url, urlprofile, typePaiement, urlgif) {
    $.ajax({
        url: url,
        success: function (data, status) {

            if(urlprofile!==null)
            loaderRequest(urlprofile, urlgif, $('.tr-bdy'), $('.tr-bdy'), 2000, 'GET', '');
        },
        error: function (error) {
            console.log(error);
        }
    });
}

function stat(url) {
    $.ajax({
        url: url,
        method: 'GET',
        dataType: "json",
        success: function (data) {
            console.log(data.dateInscr);
            for (var i=0; i<data.dateInscr.length; i++){
                console.log(data.dateInscr[i]);
            }

            charts(data.dateInscr, data.nbreInscr);
        },
        error: function (error) {
            console.log(error);
        }
    });
}

function charts(tableau_classes, tableau_effectif_classes) {
    //var tableau_classes=[], tableau_effectif_classes=[], i=0;



    // Initialisation des Charts
    var dataLineChart = {
        labels: tableau_classes,
        datasets: [
            {
                label: "Graphe des utilisateurs",
                fillColor: "rgba(151,187,205,0.2)",
                strokeColor: "rgba(151,187,205,1)",
                pointColor: "rgba(151,187,205,1)",
                pointStrokeColor: "#fff",
                pointHighlightFill: "#fff",
                pointHighlightStroke: "rgba(220,220,220,1)",
                data: tableau_effectif_classes
            }
        ]
    };

    var dataPieChart = [
        {
            value: 80,
            color:"#F7464A",
            highlight: "#FF5A5E",
            label: "6 eme"
        },
        {
            value: 50,
            color: "#46BFBD",
            highlight: "#5AD3D1",
            label: "5 eme"
        },
        {
            value: 100,
            color: "#FDB45C",
            highlight: "#FFC870",
            label: "4 eme"
        },
        {
            value: 80,
            color:"#F7464A",
            highlight: "#FF5A5E",
            label: "3 eme"
        },
        {
            value: 50,
            color: "#46BFBD",
            highlight: "#5AD3D1",
            label: "2 nde"
        },
        {
            value: 100,
            color: "#FDB45C",
            highlight: "#FFC870",
            label: "1 ere"
        }
        ,
        {
            value: 180,
            color: "#FF5A5E",
            highlight: "#FFC870",
            label: "T le"
        }
    ];



    var option = {
        responsive: true
    };

    // Get the context of the canvas element we want to select
    var linectx = document.getElementById("usr-gph-linechart").getContext('2d');
    var myLineChart = new Chart(linectx).Line(dataLineChart, option); //'Line' defines type of the chart.

    var piectx = document.getElementById("trs-gph-piechart").getContext('2d');
    var myDoughnutChart = new Chart(piectx).Doughnut(dataPieChart,option);

    $('#date-end').bootstrapMaterialDatePicker({ format : 'DD/MM/YYYY', lang : 'fr', weekStart : 1, cancelText : 'ANNULER', time: false  });
    $('#date-start').bootstrapMaterialDatePicker({ format : 'DD/MM/YYYY', lang : 'fr', weekStart : 1, cancelText : 'ANNULER', time: false  }).on('change', function(e, date)
    {
        $('#date-end').bootstrapMaterialDatePicker('setMinDate', date);
    });
}

/**
 * chargement simple d'une requette depuis le serveur
 * @param url
 * @param selHtml  selecteur pour inserer le resultat de la requette ds la DOM
 * @param selLoader selecteur precisant ou afficher le loader
 * @param timeout duree de la requette
 * @param method  methode de la requette
 * @param urlJs  url du js
 */
function loaderRequest(urlReq, urlImg, selHtml, selLoader, timeout, method, urlJs) {
    var loader = $('<img />', {
        class: 'loader mt-4 pt-4',
        src: urlImg,
        width: '150px',
        height: '170px'
    });

    $.ajax({
        url: urlReq,
        method: method,
        dataType: "html",
        beforeSend: function () {
            selLoader.addClass('text-center').html(loader);
        },
        success: function (data) {
            setTimeout(function () {
                selHtml.removeClass('text-center').html(data);

            }, timeout)
        },
        error: function (error) {
            console.log(error);
        }
    });
}

// Copies a string to the clipboard. Must be called from within an
// event handler such as click. May return false if it failed, but
// this is not always possible. Browser support for Chrome 43+,
// Firefox 42+, Safari 10+, Edge and IE 10+.
// IE: The clipboard feature may be disabled by an administrator. By
// default a prompt is shown the first time the clipboard is
// used (per session).
function copyToClipboard (text, msg) {
    if (window.clipboardData && window.clipboardData.setData) {
        // IE specific code path to prevent textarea being shown while dialog is visible.
        clipboardData.setData("Text", text);
        console.log(text+ " ok");
        return createSnackbar(msg, 'Dismiss');

    } else if (document.queryCommandSupported && document.queryCommandSupported("copy")) {
        var textarea = document.createElement("textarea");
        textarea.textContent = text;
        textarea.style.position = "fixed";  // Prevent scrolling to bottom of page in MS Edge.
        document.body.appendChild(textarea);
        textarea.select();
        try {
            document.execCommand("copy");  // Security exception may be thrown by some browsers.
            return createSnackbar(msg, 'Dismiss');
        } catch (ex) {
            console.warn("Copy to clipboard failed.", ex);
            return false;
        } finally {
            document.body.removeChild(textarea);
        }
    }
};


$(document).ready(function() {

    $('.fab').on('click', function(){
        $('.body,.body .fab, .wrap').toggleClass('active');

        return false;
    });

    const TR_REGEX = /^[0-9]{1,11}$/;
    const BTC_VAL = 6000;
    const ETH_VAL = 200;
    const LTC_VAL = 100;

    var  // Traductions
        link_cp = '', adr_cp = '',
        btn_svt = '', btn_prc = '',
        btn_val = '';

    if ($(".locale").attr('locale') === "en") {
        link_cp = "Le lien a été copié.";
        adr_cp  = "L'adresse a été copié.";
        btn_svt = "Suivant";
        btn_val = "Valider";

    } else {
        link_cp = "Link copied.";
        adr_cp  = "Adress copied.";
        btn_svt = "Next";
        btn_val = "Validate";
    }

    $("#pr-btn-cp").click(function(event) {
        copyToClipboard($("#pr-link").text(), link_cp);
    });

    $("#btn-cp-btc").click(function(event) {
        copyToClipboard($("#adr-btcc").text(), adr_cp);
    });


    $("#btc-li").on('click', function(event) {
        $("#panel8, #panel9").attr('aria-expanded', 'false').removeClass('active').removeClass('show');
        testInputCur("#mt-dl-btc", "#mt-dl-btc, #mt-eq-btc");
    });

    $("#eth-li").on('click', function(event) {
        $("#panel7, #panel9").attr('aria-expanded', 'false').removeClass('active').removeClass('show');
        testInputCur("#mt-dl-eth", "#mt-dl-eth, #mt-eq-eth");
    });

    $("#ltc-li").on('click', function(event) {
        $("#panel7, #panel8").attr('aria-expanded', 'false').removeClass('active').removeClass('show');
        testInputCur("#mt-dl-ltc", "#mt-dl-ltc, #mt-eq-ltc");
    });


    $("#mt-dl-btc").on("keyup", function(evt) {
        currencyConvert("#mt-dl-btc", TR_REGEX, "#mt-eq-btc", BTC_VAL, "BTC");
    });

    $("#mt-dl-eth").on("keyup", function(evt) {
        currencyConvert("#mt-dl-eth", TR_REGEX, "#mt-eq-eth", ETH_VAL, "ETH");
    });

    $("#mt-dl-ltc").on("keyup", function(evt) {
        currencyConvert("#mt-dl-ltc", TR_REGEX, "#mt-eq-ltc", LTC_VAL, "LTC");
    });

    switchView("#btn-btc-sb", "#btn-btc-prc", "#sub-btc", "#form-btc", "#btn-btc-ds");
    switchView("#btn-eth-sb", "#btn-eth-prc", "#sub-eth", "#form-eth", "#btn-eth-ds");
    switchView("#btn-ltc-sb", "#btn-ltc-prc", "#sub-ltc", "#form-ltc", "#btn-ltc-ds");

    /*$("#btn-btc-sb").on('click', function(event) {
      $("#sub-btc, #btn-btc-prc").removeClass('hidden');
      $("#form-btc, #btn-btc-ds").addClass('hidden');
      $(this).text(btn_val);
    });

    $("#btn-btc-prc").on('click', function(event) {
      $("#form-btc, #btn-btc-ds").removeClass('hidden');
      $("#btn-btc-sb").text(btn_svt);
      $("#sub-btc").addClass('hidden');
      $(this).addClass('hidden');
    });*/


    function switchView(btnSvt, btnPrec, subCur, formC, btnDismiss) {
        $(btnSvt).on('click', function(event) {
            $(subCur).removeClass('hidden');
            $(btnPrec).removeClass('hidden');
            $(formC).addClass('hidden');
            $(btnDismiss).addClass('hidden');
            $(btnSvt).text(btn_val);
        });

        $(btnPrec).on('click', function(event) {
            $(formC).removeClass('hidden');
            $(btnDismiss).removeClass('hidden');
            $(btnSvt).text(btn_svt);
            $(subCur).addClass('hidden');
            $(btnPrec).addClass('hidden');
        });
    }

    function testInputCur(elt, elts) {
        if ($(elt).val() !== "") {
            setTimeout(function () {
                $(elts).focus();
            }, 500);
        }
    }

    function currencyConvert(elt, reg, ouput, c, currency) {
        if (reg.test($(elt).val())) {
            $(ouput).focus().val( parseInt($(elt).val())/c +" "+currency);
            $(elt).focus();

        } else {
            if ($(elt).val() === '' || $(elt).val() === ' ') {
                $(ouput).val("").blur();
                $(elt).focus();
            } else {
                $(ouput).focus().val("Invalid amount.");
                $(elt).focus();
            }
        }
    }

});