<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 15/10/20
  Time: 12:02
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <link href='${resource(dir: "css", file: "print.css")}' rel='stylesheet' type='text/css' media="print"/>

    <script type="text/javascript"
            src="http://maps.googleapis.com/maps/api/js?key=AIzaSyBpasnhIQUsHfgCvC3qeJpEgcB9_ppWQI0&sensor=true">
        // src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBpasnhIQUsHfgCvC3qeJpEgcB9_ppWQI0&callback=initMap">

    </script>

    <style>

    #mapa img {
        max-width : none;;
    }

    .control-label {
        font-weight : bold;
    }

    .soloPrint {
        display : none;
    }
    .noprint {
        display : none;
    }
    </style>

    <title>Semáforos covid-19</title>
</head>

<body>

<div class="row hide" id="divError">
    <div class="span12 alert alert-error" id="spanError">
    </div>
</div>

<div class="datosObra col-md-12" style="margin-bottom: 0px; width: 100%; text-align: center">
    <input type="hidden" id="prdo" value="${prdo}">
    <h3>Pandemia COVID-19 Semáforos Período: ${periodo}</h3>
</div>

<div>
    <div id="mapa" style="width: 920px; height: 640px; margin-left: 10px; float: left; margin-bottom: 20px;"></div>
</div>

<div class="btn-group" id="divAvanza" style="margin-top: 30px; margin-left: 10px">
    <a href="#" class="btn btn-success" id="btnAdelante"><i class="fa fa-arrow-right"></i> Siguiente Período</a>
</div>
<div class="btn-group" id="divAtras" style="margin-top: 30px; margin-left: 10px">
    <a href="#" class="btn btn-success" id="btnAtras"><i class="fa fa-arrow-left"></i> Período Anterior</a>
</div>


<div id="nota" style="float: left; width: 180px;" >
    <div style="margin: 20px; margin-top: 80px;" >
        <b>Nota:</b>

        <p>Si usa el botón "Imprimir", use la configuración de página definir la horientación del papel horizontal y
        una escala de 100% para cubrir toda la hoja en tamaño A4</p>

        <p>Se puede usar también la opción "Vista preliminar" desde el menú de Firefox: <span style="color: #000">Archivo -> Imprimir
        -> Vista preliminar</span>, para fijar la horientación del papel a horizontal y
        la escala que desee según sus requerimientos</p>
    </div>

</div>

%{--<div class="btn-group" style="margin-top: 10px; margin-left: 20px">--}%
%{--    <a href="#" class="btn btn-info hidden" id="btnVolver"><i class="fa fa-arrow-left"></i> Regresar </a>--}%
%{--</div>--}%

<div class="btn-group" style="margin-top: 10px; margin-left: 10px">
    <a href="#" class="btn btn-primary" id="btnImprimir"><i class="fa fa-print"></i> Imprimir </a>
</div>

%{--<div class="btn-group" style="margin-top: 10px; margin-left: 10px">--}%
%{--    <a href="#" class="btn btn-danger hidden" id="btnAuto"><i class="fa fa-car"></i> Mapa Automático </a>--}%
%{--    <a href="#" class="btn btn-info" id="btnManual"><i class="fa fa-map-marker"></i> Mapa Manual </a>--}%
%{--</div>--}%



<script type="text/javascript">
    //            window.onbeforeprint = preparar;
    //            window.onafterprint = despues;

    var map;
    var lat;
    var longitud;
    var latorigen;
    var longorigen;
    var lastValidCenter;
    //    var allowedBounds;

    var countryCenter = new google.maps.LatLng(-0.15, -78.35);

    var allowedBounds = new google.maps.LatLngBounds(
        new google.maps.LatLng(-0.41, -79.56),
        new google.maps.LatLng(-0.50, -76.44),
        new google.maps.LatLng(-0.28690, -76.59190)
    );

    var marker = new google.maps.Marker({
        position  : countryCenter,
        draggable : true
    });

    function initialize() {

        var myOptions = {
            // center             : countryCenter,
            center             :  {lat: -1.7, lng: -78},
            zoom               : 7,
            maxZoom            : 16,
            minZoom            : 5,
            panControl         : false,
            zoomControl        : true,
            mapTypeControl     : false,
            scaleControl       : false,
            streetViewControl  : false,
            overviewMapControl : false,
            mapTypeId : google.maps.MapTypeId.ROADMAP //SATELLITE, ROADMAP, HYBRID, TERRAIN
        };

        map = new google.maps.Map(document.getElementById('mapa'), myOptions);

        /* maneja los datos */
        var cord = '${cord}'.split('_');
        var nmbr = '${nmbr}'.split('_');
        var ruta = '${ruta}'.split(' ');

        console.log('ruta:', ruta);

        // poneMarcas(cord, path, nmbr);
        for (var i = 0; i <= cord.length; ++i) {
            var cr = cord[i].split(' ')
            var path = '';
            var link = "${createLink(controller: 'provincia', action: 'mapa')}/1"

            path = '${assetPath(src: '/apli/pin-o.png')}';
            console.log('ruta:', path);
            if(cr[2] == '1') {
                path = '${assetPath(src: '/apli/pin-v.png')}';
            } else if(cr[2] == '2') {
                path = '${assetPath(src: '/apli/pin-a.png')}';
            } else {
                path = '${assetPath(src: '/apli/pin-r.png')}';
            }
            var marker = new google.maps.Marker({
                map: map,
                position: new google.maps.LatLng(parseFloat(cr[0]), parseFloat(cr[1])),
                icon: path
            });
            poneMensaje(marker, nmbr[i].strReplaceAll('kk', '<br>') + "<a href=link>Doc</a>");
        }
    }

    function poneMensaje(marker, secretMessage) {
        var infowindow = new google.maps.InfoWindow({
            content: secretMessage
        });

        marker.addListener('click', function() {
            infowindow.open(marker.get('map'), marker);
        });
    }


    $(function () {
        initialize();
    });



    function cargarManual(){
        clearTimeout(timer);
    }

    $("#btnAuto").click(function () {
        $(this).addClass("hidden");
        $("#divAvanza").addClass("hidden");
        $("#divAtras").addClass("hidden");
        $("#btnManual").removeClass("hidden");
        cargarMapasAutomaticos();
    });

    $("#btnManual").click(function () {
        $(this).addClass("hidden");
        $("#btnAuto").removeClass("hidden");
        $("#divAvanza").removeClass("hidden");
        $("#divAtras").removeClass("hidden");
        cargarManual();
    });

    $("#btnAtras").click(function (){
        var prdo = $("#prdo").val();
        prdo = parseInt(prdo) - 1;
        if(prdo < 1) prdo = 1;
        location.href="${createLink(controller: 'provincia', action: 'mapa')}/" + prdo
    });

    $("#btnAdelante").click(function (){
        var prdo = $("#prdo").val();
        prdo = parseInt(prdo) + 1;
        location.href="${createLink(controller: 'provincia', action: 'mapa')}/" + prdo
    });

    $("#btnImprimir").click(function () {
        $("#divAvanza").addClass("hidden");
        $("#divAtras").addClass("hidden");

        $("#nota").addClass('noprint')
        $("#btnVolver").addClass('noprint')
        $("#btnImprimir").addClass('noprint')
        $("#btnAuto").addClass('noprint')
        $("#btnManual").addClass('noprint')
        window.print()
        $("#nota").removeClass('noprint')
        $("#btnVolver").removeClass('noprint')
        $("#btnImprimir").removeClass('noprint')
        $("#btnAuto").removeClass('noprint')
        $("#btnManual").removeClass('noprint')
    });

</script>

</body>
</html>