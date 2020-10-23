<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 22/10/20
  Time: 16:58
--%>



<table class="table table-condensed table-hover table-striped table-bordered">
    <thead>
    <tr>
        <th style="width: 40%">Fecha Desde</th>
        <th style="width: 38%">Fecha Hasta</th>
        <th style="width: 22%">Acciones</th>
    </tr>
    </thead>
</table>

<div class=""  style="width: 99.7%;height: 350px; overflow-y: auto;float: right; margin-top: -20px">
    <table id="tablaB" class="table-bordered table-condensed table-hover" width="100%">
        <tbody>
        <g:each in="${periodos}" var="periodo">
            <tr style="text-align: center">
                <td style="width: 40%">${periodo?.fechaDesde?.format("dd-MM-yyyy")}</td>
                <td style="width: 40%">${periodo?.fechaHasta?.format("dd-MM-yyyy")}</td>
                <td style="width: 20%;">
                    <div class="btn-group" role="group">

                        %{--                    <a href="#" class="btn btn-xs btn-success btnDownDoc" data-id="${documento.id}" title="Descargar">--}%
                        %{--                        <i class="fa fa-download"></i>--}%
                        %{--                    </a>--}%
                        %{--                    <g:if test="${sesion}">--}%
                        %{--                        <a href="#" class="btn btn-xs btn-info btnEditDoc" data-id="${documento.id}" title="Editar">--}%
                        %{--                            <i class="fa fa-edit"></i>--}%
                        %{--                        </a>--}%
                        <a href="#" class="btn btn-xs btn-danger btnBorrarPeriodo" data-id="${periodo.id}" title="Eliminar período">
                            <i class="fa fa-trash"></i>
                        </a>
                        %{--                    </g:if>--}%
                    </div>
                </td>
            </tr>
        </g:each>
        </tbody>
    </table>
</div>

<script type="text/javascript">

    $(".btnBorrarPeriodo").click(function () {
        var id = $(this).data("id");

        bootbox.confirm({
            message: "<i class='fa fa-3x fa-exclamation-triangle text-danger'></i> <strong style='font-size: 14px'>  Está seguro de eliminar este período? </strong>",
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
                        url:'${createLink(controller: 'periodo', action: 'borrarPeriodo_ajax')}',
                        data:{
                            id: id
                        },
                        success:function(msg){
                            var parts = msg.split("_");
                            if(parts[0] == 'ok'){
                                log("Período borrado correctamente","success");
                                setTimeout(function () {
                                    location.reload(true);
                                }, 1000);
                            }else{
                                if(parts[0] == 'er'){
                                    bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                                    return false;
                                }else{
                                    log("Error al borrar el período","error")
                                }
                            }
                        }
                    })
                }
            }
        });
    });


</script>