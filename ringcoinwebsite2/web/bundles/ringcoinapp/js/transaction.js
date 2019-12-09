

$(document).ready(function () {
	$('[data-toggle="popover"]').popover();
	//$('.vertical-icon img').popover({container: 'body'});
	$('.vertical-icon img').popover('show');

	const TR_REGEX = /^[0-9]{1,11}$/;
	const BTC_VAL = 6000;
	const ETH_VAL = 200;
	const LTC_VAL = 100;

	$("#btc-li").on('click', function () {
        $( "body" )
			.off( "keyup", "#mt-dl-eth, #mt-eq-eth, #mt-dl-ltc, #mt-eq-ltc", false )
			.find("#mt-dl-eth, #mt-eq-eth, #mt-dl-ltc, #mt-eq-ltc")
			.val('');
    });

    $("#eth-li").on('click', function () {
        $( "body" )
			.off( "keyup", "#mt-dl-btc, #mt-eq-btc, #mt-dl-ltc, #mt-eq-ltc", false )
            .find("#mt-dl-btc, #mt-eq-btc, #mt-dl-ltc, #mt-eq-ltc")
            .val('');
    });

    $("#ltc-li").on('click', function () {
        $( "body" )
			.off( "keyup", "#mt-dl-eth, #mt-eq-eth, #mt-dl-btc, #mt-eq-btc", false )
            .find("#mt-dl-eth, #mt-eq-eth, #mt-dl-btc, #mt-eq-btc")
            .val('');
    });


    $("#mt-dl-btc").on("keyup", function(evt) {
        if (TR_REGEX.test($(this).val())) {

            $("#mt-eq-btc").focus().val( parseInt($(this).val())/BTC_VAL +" BTC" );
            $(this).focus();

        } else {
            if ($(this).val() === '' || $(this).val() === ' ') {
                $("#mt-eq-btc").val("").blur();
                $(this).focus();

            } else {
                $("#mt-eq-btc").focus().val("Erreur montant");
                $(this).focus();
            }
        }
    });


  $("#mt-dl-eth").on("keyup", function(evt) {
  	if (TR_REGEX.test($(this).val())) {

  		$("#mt-eq-eth").focus().val( parseInt($(this).val())/ETH_VAL +" ETH" );
  		$(this).focus();

  	} else {
  		if ($(this).val() === '' || $(this).val() === ' ') {
  			$("#mt-eq-eth").val("").blur();
  			$(this).focus();

  		} else {
  			$("#mt-eq-eth").focus().val("Erreur montant");
  			$(this).focus();
  		}
  	}
  });


  $("#mt-dl-ltc").on("keyup", function(evt) {
  	if (TR_REGEX.test($(this).val())) {

  		$("#mt-eq-ltc").focus().val( parseInt($(this).val())/LTC_VAL +" LTC" );
  		$(this).focus();

  	} else {
  		if ($(this).val() === '' || $(this).val() === ' ') {
  			$("#mt-eq-ltc").val("").blur();
  			$(this).focus();

  		} else {
  			$("#mt-eq-ltc").focus().val("Erreur montant");
  			$(this).focus();
  		}
  	}
  });

});
