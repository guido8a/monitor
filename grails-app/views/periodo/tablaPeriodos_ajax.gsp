<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 22/10/20
  Time: 16:58
--%>



<table class="table table-condensed table-hover table-striped table-bordered">
    <thead>
    <tr>
        <th style="width: 35%">Fecha Desde</th>
        <th style="width: 35%">Fecha Hasta</th>
        <th style="width: 30%">Acciones</th>
    </tr>
    </thead>
</table>

<div class=""  style="width: 99.7%;height: 300px; overflow-y: auto;float: right; margin-top: -20px">
    <table id="tablaB" class="table-bordered table-condensed table-hover" width="100%">
<tbody>
<g:each in="${periodos}" var="periodo">
    <tr>
        <td style="width: 35%">${periodo?.fechaDesde?.format("dd-MM-yyyy")}</td>
        <td style="width: 35%">${periodo?.fechaHasta?.format("dd-MM-yyyy")}</td>
        <td style="width: 30%;">
            <div class="btn-group" role="group">

                %{--                    <a href="#" class="btn btn-xs btn-success btnDownDoc" data-id="${documento.id}" title="Descargar">--}%
                %{--                        <i class="fa fa-download"></i>--}%
                %{--                    </a>--}%
                %{--                    <g:if test="${sesion}">--}%
                %{--                        <a href="#" class="btn btn-xs btn-info btnEditDoc" data-id="${documento.id}" title="Editar">--}%
                %{--                            <i class="fa fa-edit"></i>--}%
                %{--                        </a>--}%
                %{--                        <a href="#" class="btn btn-xs btn-danger btnDelDoc" data-id="${documento.id}" title="Eliminar">--}%
                %{--                            <i class="fa fa-trash"></i>--}%
                %{--                        </a>--}%
                %{--                    </g:if>--}%
            </div>
        </td>
    </tr>
</g:each>
</tbody>
       </table>



%{--<script type="text/javascript">--}%
%{--    $(function () {--}%
%{--        $(".btnDelDoc").click(function () {--}%
%{--            deleteDocumento($(this).data("id"));--}%
%{--        });--}%
%{--        $(".btnDownDoc").click(function () {--}%
%{--            downloadDocumento($(this).data("id"));--}%
%{--        });--}%
%{--        $(".btnEditDoc").click(function () {--}%
%{--            createEditDocumento($(this).data("id"));--}%
%{--        });--}%
%{--    });--}%
%{--</script>--}%