$(document).ready(function () {
    $('#dtBasicExample').DataTable();

    $('.alert').alert()

    $('.dataTables_length').addClass('bs-select');

    $( "#showEditForm" ).click(function() {
        $("#viewCommande").attr("hidden","hidden");
        $("#viewEditCommande").removeAttr("hidden")
    });

    $( "#showEditForm2" ).click(function() {
        $("#viewCommande").removeAttr("hidden");
        $("#viewEditCommande").attr("hidden", "hidden");
        });

    $( "#submitEditCommande" ).submit(function() {

        event.preventDefault(); //prevent default action
        var post_url = $(this).attr("action"); //get form action url
        var request_method = $(this).attr("method"); //get form GET/POST method
        var form_data = $(this).serialize(); //Encode form elements for submission

        $.ajax({
            url : post_url,
            type: request_method,
            data : form_data,
            beforeSend: function(){
                $('#loader').removeAttr("hidden");
                $("#vieweditCommande").attr("hidden","hidden");
            },

            success:function(data) {

                $("#viewCommande").html('');
                $("#viewCommande").html(data);

                console.log(data.options);
            },
            complete: function(){
                $('#loader').attr("hidden","hidden");
                $("#viewCommande").removeAttr("hidden");
            }
        });
    });

    $( "#validation" ).submit(function() {

        event.preventDefault(); //prevent default action
        var post_url = $(this).attr("action"); //get form action url
        var request_method = $(this).attr("method"); //get form GET/POST method
        var form_data = $(this).serialize(); //Encode form elements for submission

        // $.ajax({
        //     url : post_url,
        //     type: request_method,
        //     data : form_data,
        //     beforeSend: function(){
        //         $('#loaderValidation').removeAttr("hidden");
        //         $("#buttonValidation").attr("hidden","hidden");
        //     },
        //
        //     success:function(data) {
        //         console.log(data.options);
        //     },
        //     complete: function(){
        //         $('#loaderValidation').attr("hidden","hidden");
        //     }
        // });

        $('.stepper').mdbStepper();
    });


    $('.datepicker').pickadate({
// Escape any “rule” characters with an exclamation mark (!).
        format: 'dd/mm/yyyy',
        formatSubmit: 'dd/mm/yyyy',
        hiddenPrefix: 'prefix__',
        hiddenSuffix: '__suffix'
    })

});