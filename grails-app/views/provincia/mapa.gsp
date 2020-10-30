<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <link href='${resource(dir: "css", file: "print.css")}' rel='stylesheet' type='text/css' media="print"/>

    <script type="text/javascript"
            src="http://maps.googleapis.com/maps/api/js?key=AIzaSyBpasnhIQUsHfgCvC3qeJpEgcB9_ppWQI0&sensor=true">

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

    .abajo {
        position: fixed;
        left: 0;
        bottom: 40px;
        width: 100%;
        text-align: center;
    }

    @media print
    {
        @page {
            size: A4; /* DIN A4 standard, Europe */
            /*margin:0;*/
            /*arriba derecha abajo izquierda*/
            margin: 0mm 0mm 0mm 15mm;
        }
        html, body {
            width: 297mm;
            height: 180mm;
            /*height: 282mm;*/
            font-size: 11px;
            background: #FFF;
            overflow: visible;
        }
        body {
            padding-top:0mm;
        }
    }

    </style>

    <title>Semáforos Covid-19</title>
</head>

<body>

<elm:flashMessage tipo="${flash.tipo}" clase="${flash.clase}">${flash.message}</elm:flashMessage>

<div class="row hide" id="divError">
    <div class="span12 alert alert-error" id="spanError">
    </div>
</div>

<div class="datosObra col-md-12" style="margin-bottom: 0px; width: 100%; text-align: center; margin-top: 0px;">
    <input type="hidden" id="siguiente" value="${siguiente}">
    <input type="hidden" id="anterior" value="${anterior}">
    <input type="hidden" id="visita" value="${visita}">
    <div class="col-md-7" id="titulo"><h3>COVID-19 Semáforos del Período: ${periodo}</h3></div>
    <div class="col-md-1"   id="divSel" style="text-align: right">
        Seleccione el Período:
    </div>
    <div class="col-md-3" id="divCombo">
        <g:select name="periodo" from="${monitor.Periodo.list().sort{it.fechaDesde}.reverse()}" class="form-control text-info"
                  optionKey="id" optionValue="${{'Del ' + it.fechaDesde.format("dd-MMM-yyyy") + " al " + it.fechaHasta.format("dd-MMM-yyyy")}}" value="${pr?.id}"/>
    </div>

    <div class="col-md-1 btn-group" id="divVer" style="margin-left: -20px">
        <a href="#" class="btn btn-info" id="btnIr"><i class="fa fa-search"></i> Visualizar</a>
    </div>
</div>

<div>
    <div id="mapa" style="width: 920px; height: 640px; margin-left: 0px; float: left; margin-bottom: 20px;"></div>
</div>



<g:if test="${siguiente}">
    <div class="btn-group" id="divAvanza" style="margin-top: 30px; margin-left: 10px">
        <a href="#" class="btn btn-success" id="btnAdelante" style="width: 130px"><i class="fa fa-arrow-right"></i> Siguiente Período</a>
    </div>
</g:if>
<g:else>
    <div class="btn-group" id="divAvanza" style="margin-top: 30px; margin-left: 10px">
        <a href="#" class="btn btn-success disabled" style="width: 130px"><i class="fa fa-arrow-right"></i> Siguiente Período</a>
    </div>
</g:else>

<g:if test="${anterior}">
    <div class="btn-group" id="divAtras" style="margin-top: 10px; margin-left: 10px">
        <a href="#" class="btn btn-success" id="btnAtras" style="width: 130px"><i class="fa fa-arrow-left"></i> Período Anterior</a>
    </div>
</g:if>
<g:else>
    <div class="btn-group" id="divAtras" style="margin-top: 10px; margin-left: 10px">
        <a href="#" class="btn btn-success disabled" style="width: 130px"><i class="fa fa-arrow-left"></i> Período Anterior</a>
    </div>
</g:else>


<g:if test="${session?.usuario}">
    <div class="btn-group" id="divGuardar" style="margin-top: 20px; margin-left: 10px">
        <a href="#" class="btn btn-info" id="btnGuardar"><i class="fa fa-save"></i> Guardar</a>
    </div>

    <p id="longitud" style="margin-left: 940px; height: 30px" class="text-info">Posición: Longitud y Latitud</p>
</g:if>



<div id="nota" style="float: left; width: 180px;" >
    <div style="margin: 20px; margin-top: 40px;" >
        <b>Nota:</b>

        <p>Para "Imprimir", use la configuración de página definir la hoja en tamaño A4,
        orientación del papel horizontal y una escala de 92%. Verifique que la opción
        "Ignorar el escalado y ajustar a la página" no este seleccionada.</p>

        <p>Se puede usar también la opción "Vista preliminar" desde el menú de Firefox: <span style="color: #000">Archivo -> Imprimir
        -> Vista preliminar</span>, para fijar la horientación del papel a horizontal y
        la escala que desee según sus requerimientos</p>
    </div>

</div>

%{--<div class="btn-group" style="margin-top: 10px; margin-left: 20px">--}%
%{--    <a href="#" class="btn btn-info hidden" id="btnVolver"><i class="fa fa-arrow-left"></i> Regresar </a>--}%
%{--</div>--}%

<div class="btn-group" id="divGuardar"  style="margin-left: 25px">
    <a href="#" class="btn btn-primary" id="btnImprimir"><i class="fa fa-print"></i> Imprimir </a>
</div>

%{--<div class="btn-group" style="margin-top: 10px; margin-left: 10px">--}%
%{--    <a href="#" class="btn btn-danger hidden" id="btnAuto"><i class="fa fa-car"></i> Mapa Automático </a>--}%
%{--    <a href="#" class="btn btn-info" id="btnManual"><i class="fa fa-map-marker"></i> Mapa Manual </a>--}%
%{--</div>--}%

%{--
<g:if test="${!session?.usuario}">
    <div class="btn-group" id="divAtras" style="margin-top: 30px; margin-left: 10px">
        <a href= "${createLink(controller:'login', action: 'login')}" class="btn btn-info btn-sm" style="width: 130px">
            Ingresar <i class="fas fa-user-check"></i></a>
    </div>
</g:if>
--}%

<g:if test="${!session?.usuario}">
    <div class="btn-group" id="btnSalir" style="margin-top: 50px; margin-left: 10px">
        <a href= "${createLink(controller:'login', action: 'login')}" class="btn btn-info btn-sm" style="width: 130px">
            Salir &nbsp; <i class="fas fa-sign-out-alt"></i></a>
    </div>
</g:if>

<p class="soloPrint" id="tedein">
    Recopilación de información COLECTIVO ECUADOR CON GESTIÓN DE RIESGOS  - Impreso desde: www.tedein.com.ec/monitor  &nbsp; TEDEIN S.A. <i>Tecnología para el Desarrollo Integral</i>
</p>


<g:hiddenField name="latitudFinal" value="${0}"/>
<g:hiddenField name="longitudFinal" value="${0}"/>

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

    // var l1 = retornaCoordenadas()
    // var l2

   function retornaCoordenadas (lat, long){
        console.log("111 " + lat)
        console.log("222 " + long)
        // l1 = lat
        // l2 = long
        return lat
    }


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

        %{--var path = '${assetPath(src: '/apli/marca.png')}';--}%
        var path = '${assetPath(src: '/apli/pin-p.png')}';
        if('${session?.usuario?.id}'){
            var marcador = new google.maps.Marker({
            map: map,
            position: new google.maps.LatLng(-0.6, -74),
            icon: path,
            draggable : true
            });
        }

/*
        map.addListener('click', function(e) {
            // map.setCenter(e.latLng);
            // marcador.setPosition(e.latLng);
            console.log('coords', e.latLng.lat(), e.latLng.lng())
            $("#longitud").html('Long: ' + e.latLng.lat() + '<br/>Lat: ' + e.latLng.lng() )
        });
*/
        if(marcador){
            marcador.addListener('drag', function(e) {
                // map.setCenter(e.latLng);
                // marcador.setPosition(e.latLng);
                console.log('coords', e.latLng.lat(), e.latLng.lng());
                // retornaCoordenadas(e.latLng.lat(), e.latLng.lng());
                $("#longitud").html('Longitud: ' + Math.round(e.latLng.lat()*1000000)/1000000 + '<br/>Latitud: ' +
                    Math.round(e.latLng.lng()*1000000)/1000000)

                $("#latitudFinal").val(Math.round(e.latLng.lat()*1000000)/1000000)
                $("#longitudFinal").val(Math.round(e.latLng.lng()*1000000)/1000000)

            });
        };

         // console.log("--- " + latLng.lat())

        /* maneja los datos */
        var cord = '${cord}'.split('_');
        var nmbr = '${nmbr}'.split('_');
        var cntn = '${cntn}'.split('_');
        var link = "";
        // console.log('ruta:', ruta);

        // poneMarcas(cord, path, nmbr);
        for (var i = 0; i <= cord.length; ++i) {
            var cr = cord[i].split(' ');
            var path = '';

            path = '${assetPath(src: '/apli/pin-o.png')}';
            if(cr[2] == '1') {
                path = '${assetPath(src: '/apli/pin-v.png')}';
            } else if(cr[2] == '2') {
                path = '${assetPath(src: '/apli/pin-a.png')}';
            } else {
                path = '${assetPath(src: '/apli/pin-r.png')}';
            }

            %{--console.log('usuario:', '${session?.usuario?.length()}');--}%
            var marker = new google.maps.Marker({
                map: map,
                position: new google.maps.LatLng(parseFloat(cr[0]), parseFloat(cr[1])),
                icon: path
            });
            if(nmbr[i].contains('Documentos')) {
                link = "${createLink(controller: 'documento', action: 'listDocumento')}/"+cntn[i]
                poneMensaje(marker, nmbr[i].strReplaceAll('kk', '<br>') + "<br><a href=" + link + ">Ir a documentos</a>");
            } else {
                poneMensaje(marker, nmbr[i].strReplaceAll('kk', '<br>'));
            }
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
        var prdo = $("#anterior").val();
        var visita = $("#visita").val();
        location.href="${createLink(controller: 'provincia', action: 'mapa')}/" + prdo + "?visita=" + visita
    });

    $("#btnAdelante").click(function (){
        var prdo = $("#siguiente").val();
        var visita = $("#visita").val();
        location.href="${createLink(controller: 'provincia', action: 'mapa')}/" + prdo + "?visita=" + visita
    });

    $("#btnIr").click(function () {
        var visita = $("#visita").val();
        location.href="${createLink(controller: 'provincia', action: 'mapa')}/" + $("#periodo option:selected").val() + "?visita=" + visita
    });

    $("#btnImprimir").click(function () {
        $("#divAvanza").addClass("noprint");
        $("#divAtras").addClass("noprint");
        $("#btnSalir").addClass("noprint");
        $("#divSel").addClass("noprint");
        $("#divCombo").addClass("noprint");
        $("#divVer").addClass("noprint");
        $("#titulo").removeClass("col-md-7");
        $("#titulo").addClass("col-md-12");

        $("#nota").addClass('noprint');
        $("#btnVolver").addClass('noprint');
        $("#btnImprimir").addClass('noprint');
        $("#btnAuto").addClass('noprint');
        $("#btnManual").addClass('noprint');
        $("#btnGuardar").addClass('noprint');
        $("#longitud").addClass('noprint');
        $("#tedein").removeClass('soloPrint');
        $("#tedein").addClass('abajo');
        window.print()
        $("#nota").removeClass('noprint');
        $("#btnVolver").removeClass('noprint');
        $("#btnImprimir").removeClass('noprint');
        $("#btnAuto").removeClass('noprint');
        $("#btnManual").removeClass('noprint');
        $("#btnGuardar").removeClass('noprint');
        $("#longitud").removeClass('noprint');

        $("#divAvanza").removeClass("noprint");
        $("#divAtras").removeClass("noprint");
        $("#btnSalir").removeClass("noprint");
        $("#divSel").removeClass("noprint");
        $("#divCombo").removeClass("noprint");
        $("#divVer").removeClass("noprint");

        $("#titulo").removeClass("col-md-12");
        $("#titulo").addClass("col-md-7");
        $("#tedein").addClass('soloPrint');
        $("#tedein").removeClass('abajo');
    });

    $("#btnGuardar").click(function () {

        var la = $("#latitudFinal").val();
        var lo = $("#longitudFinal").val();

        if(!la && !lo){
          bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Seleccione las coordenadas usando el marcador P en el mapa" + '</strong>');
        }else{
            $.ajax({
                type: "POST",
                url: "${createLink(controller: 'provincia', action: 'provincia_ajax')}",
                data: {
                    lat: la,
                    long: lo
                },
                success: function (msg) {
                    var b = bootbox.dialog({
                        id: "dlgSelCanton",
                        title: "Guardar cantón",
                        message: msg,
                        buttons: {
                            cancelar: {
                                label: "Cancelar",
                                className: "btn-primary",
                                callback: function () {
                                }
                            },
                            guardar: {
                                id: "btnSave",
                                label: "<i class='fa fa-save'></i> Guardar",
                                className: "btn-success",
                                callback: function () {
                                        guardarMarcador();
                                } //callback
                            } //guardar
                        } //buttons
                    }); //dialog
                    setTimeout(function () {
                        b.find(".form-control").first().focus()
                    }, 500);
                } //success
            }); //ajax
        }
    });

    function guardarMarcador(){
        var la = $("#latitudFinal").val();
        var lo = $("#longitudFinal").val();
        var canton = $("#canton").val();
        $.ajax({
            type:'POST',
            url: '${createLink(controller: 'provincia', action: 'guardarCanton_ajax')}',
            data:{
                latitud: la,
                longitud: lo,
                canton: canton
            },
            success: function (msg) {
                if(msg == 'ok'){
                    log("Información guardada correctamente","success");
                    setTimeout(function () {
                        location.reload(true)
                    }, 800);
                }else{
                    log("Error al guardar la información");
                }
            }
        })
    }


</script>

</body>
</html>