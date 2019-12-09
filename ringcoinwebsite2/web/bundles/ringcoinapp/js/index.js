
$(document).ready(function () {
    // body...
    //  Activation des fonctionnalités



    function Horloge() {
        var laDate = new Date();
        var delai = new Date("2018/01/14").setHours(0,0,0);
        var dif = Math.abs(delai - laDate);
        var DateOff = new Date(dif);
        var jours, heures, minutes, secondes;

        jours = DateOff.getDate();
        heures = DateOff.getHours();
        minutes = DateOff.getMinutes();
        secondes = DateOff.getSeconds();

        if (DateOff.getDate().toString().length == 1) { jours = '0'+DateOff.getDate().toString(); }
        if (DateOff.getHours().toString().length == 1) { heures = '0'+DateOff.getHours().toString(); }
        if (DateOff.getMinutes().toString().length == 1) { minutes = '0'+DateOff.getMinutes().toString(); }
        if (DateOff.getSeconds().toString().length == 1) { secondes = '0'+DateOff.getSeconds().toString(); }

        if (delai<=laDate){
            $('#jours').text('00');
            $('#heures').text('00');
            $('#minutes').text('00');
            $('#secondes').text('00');
        }else {
            $('#jours').text(jours);
            $('#heures').text(heures);
            $('#minutes').text(minutes);
            $('#secondes').text(secondes);
        }
        //$('#date-delai').text(delai)
    }

    setInterval(Horloge, 1000);

    /*$.ajax({
        url: 'http://localhost:8000/fr/basicInfos',
        method: "GET",
        success: function (data) {

            var jours=0, heures=0, minutes=0, secondes=0;
            var laDate = new Date(data.date.date).setMinutes(119);
            var delai = new Date("2017/12/04");
            var dif = Math.abs(delai - laDate);
            var DateOff = new Date(dif);

            jours = DateOff.getDate();
            heures = DateOff.getHours();
            minutes = DateOff.getMinutes();
            secondes = DateOff.getSeconds();

            if (DateOff.getDate().toString().length == 1) { jours = '0'+DateOff.getDate().toString(); }
            if (DateOff.getHours().toString().length == 1) { heures = '0'+DateOff.getHours().toString(); }
            if (DateOff.getMinutes().toString().length == 1) { minutes = '0'+DateOff.getMinutes().toString(); }
            if (DateOff.getSeconds().toString().length == 1) { secondes = '0'+DateOff.getSeconds().toString(); }

            setInterval(function () {
                console.log('minu', minutes);


                $('#jours').text(jours);
                $('#heures').text(heures);
                $('#minutes').text(minutes);
                $('#secondes').text(secondes);

                secondes = parseInt(secondes);
                //minutes = parseInt(minutes);

                if(secondes>0 && secondes<60){
                    secondes--;
                    if (secondes<10){
                        secondes='0'+secondes;
                    }
                }else if (secondes===0){
                    secondes=59;
                    if (minutes>0 && minutes<60){
                        minutes--;
                        if(minutes<10){
                            minutes='0'+minutes;
                        }
                    }
                }else if(minutes>0 && minutes<60){
                    minutes--;
                    if (minutes<10){
                        minutes='0'+minutes;
                    }
                }else if (minutes==='00'){
                    minutes=59;
                    if (heures>0 && heures<24){
                        heures--;
                        if (heures<10){
                            heures='0'+heures;
                        }
                    }
                }else if (heures===0){
                    heures=23;
                    if (jours>0 && jours<366){
                        jours--;
                        if (jours<10){
                            jours='0'+jours;
                        }
                    }
                }else if (jours>0 && jours<366){
                    jours--;
                    if (jours<10){
                        jours='0'+jours;
                    }
                }


                console.log('min', minutes);
                // $('#date-delai').text(delai);
            }, 1000);



        },
        error: function (error) {
            console.log(error);
        }
    });*/

 //setInterval(horloge, 1000);



});