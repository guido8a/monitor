<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 19/10/20
  Time: 12:27
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Semáforo perteneciente al Cantón: ${canton?.nombre}</title>
</head>

<body>

<div class="panel panel-primary col-md-7">
    <h3>Semáforo perteneciente al Cantón: ${canton?.nombre}</h3>
    <div class="panel-info" style="padding: 3px; margin-top: 2px">
        <div class="btn-toolbar toolbar">
            <div class="btn-group">
                <g:link controller="semaforo" action="arbol" class="btn btn-sm btn-default">
                    <i class="fa fa-arrow-left"></i> Regresar
                </g:link>
            </div>

            <div class="btn-group">
                <a href="#" class="btn btn-sm btn-success" id="btnAgregarSemaforo">
                    <i class="fa fa-plus"></i> Nuevo registro
                </a>
            </div>

%{--            <div class="btn-group col-md-3 pull-right">--}%
%{--                <div class="input-group input-group-sm">--}%
%{--                    <input type="text" class="form-control input-sm " id="searchDoc" placeholder="Buscar"/>--}%
%{--                    <span class="input-group-btn">--}%
%{--                        <a href="#" class="btn btn-default" id="btnSearchDoc"><i class="fa fa-search"></i></a>--}%
%{--                    </span>--}%
%{--                </div><!-- /input-group -->--}%
%{--            </div>--}%
        </div>
    </div>
    <div id="tablaSemaforos" style="width: 100%">

    </div>
</div>


<script type="text/javascript">

    cargarTablaSemaforos();

    function cargarTablaSemaforos(){
        $.ajax({
            type: 'GET',
            url:'${createLink(controller: 'semaforo', action: 'tablaSemaforo_ajax')}',
            data:{
                id: '${canton?.id}'
            },
            success: function(msg){
                $("#tablaSemaforos").html(msg)
            }
        })
    }

    function submitFormSemaforo() {
        var $form = $("#frmSemaforo");
        var $btn = $("#dlgCreateEdit").find("#btnSave");
        if ($form.valid()) {
            var data = $form.serialize();
            $btn.replaceWith(spinner);
            var dialog = cargarLoader("Guardando...");
            $.ajax({
                type    : "POST",
                url     : $form.attr("action"),
                data    : data,
                success : function (msg) {
                    dialog.modal('hide');
                    var parts = msg.split("_");
                    if(parts[0] == 'ok'){
                        log("Registro agregado correctamente", "success");
                        setTimeout(function () {
                            location.reload(true);
                        }, 1000);
                    }else{
                        if(parts[0] == 'er'){
                            bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                            return false;
                        }else{
                            log("Error al agregar el registro","error")
                        }

                    }
                }
            });
        } else {
            return false;
        }
    }

    $("#btnAgregarSemaforo").click(function () {
            agregarSemaforo();
    });

    function agregarSemaforo(id){
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'semaforo', action: 'form_ajax')}',
            data:{
                canton:'${canton?.id}',
                id: id
            },
            success: function (msg) {
                var b = bootbox.dialog({
                    id    : "dlgSemaforo",
                    title : "Nuevo semáforo",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        guardar  : {
                            id        : "btnSave",
                            label     : "<i class='fa fa-save'></i> Guardar",
                            className : "btn-success",
                            callback  : function () {
                                submitFormSemaforo();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
            }
        })
    }

    function borrarSemaforo(id){
        bootbox.confirm({
            message: "<i class='fa fa-3x fa-exclamation-triangle text-danger'></i> <strong style='font-size: 14px'>  Está seguro de eliminar este semáforo? </strong>",
            buttons: {
                confirm: {
                    label: 'Borrar',
                    className: 'btn-success'
                },
                cancel: {
                    label: 'Cancelar',
                    className: 'btn-danger'
                }
            },
            callback: function (result) {
                if(result){
                    $.ajax({
                        type:'POST',
                        url:'${createLink(controller: 'semaforo', action: 'borrarSemaforo_ajax')}',
                        data:{
                            id: id
                        },
                        success:function(msg){
                            var parts = msg.split("_");
                            if(parts[0] == 'ok'){
                                log("Semáforo borrado correctamente","success");
                                setTimeout(function () {
                                    location.reload(true);
                                }, 1000);
                            }else{
                                if(parts[0] == 'er'){
                                    bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                                    return false;
                                }else{
                                    log("Error al borrar el semáforo","error")
                                }
                            }
                        }
                    })
                }
            }
        });
    }

    function createContextMenu(node) {
        var $tr = $(node);

        var items = {
            header: {
                label: "Acciones",
                header: true
            }
        };

        var id = $tr.data("id");

        var editar = {
            label: 'Editar',
            icon: "fa fa-edit",
            action: function (e) {
                agregarSemaforo(id)
            }
        };

        var borrar = {
            label: 'Borrar',
            icon: "fa fa-trash",
            action: function (e) {
                borrarSemaforo(id)
            }
        };

        items.editar = editar;
        items.borrar = borrar;

        return items
    }


</script>

</body>
</html>