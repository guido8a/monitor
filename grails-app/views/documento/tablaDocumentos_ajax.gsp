

<table id="tblDocumentos" class="table table-condensed table-hover table-striped table-bordered">
    <thead>
        <tr>
            <th>Fuente</th>
            <th>Descripción</th>
            <th>Palabras Clave</th>
            <th>Resumen</th>
            <th>Fecha</th>
        </tr>
    </thead>
    <tbody id="tbDoc">
        <g:each in="${documentos}" var="documento">
            <tr data-id="${documento?.id}" style="width: 100%">
                <td style="width: 15%">${documento.fuente.descripcion}</td>
                <td style="width: 40%"><elm:textoBusqueda busca="${params.search}">${documento.descripcion}</elm:textoBusqueda></td>
                <td style="width: 10%"><elm:textoBusqueda busca="${params.search}">${documento.clave}</elm:textoBusqueda></td>
                <td style="width: 25%"><elm:textoBusqueda busca="${params.search}">${documento.resumen}</elm:textoBusqueda></td>
                <td style="width: 10%; text-align: center">${documento?.fecha?.format("dd-MM-yyyy")}</td>

            </tr>
        </g:each>
    </tbody>
</table>

<script type="text/javascript">
    $(function () {
        $(".btnDelDoc").click(function () {
            deleteDocumento($(this).data("id"));
        });
        $(".btnDownDoc").click(function () {
            downloadDocumento($(this).data("id"));
        });
        $(".btnEditDoc").click(function () {
            createEditDocumento($(this).data("id"));
        });

        $("tr").contextMenu({
            items  : createContextMenu,
            onShow : function ($element) {
                $element.addClass("trHighlight");
            },
            onHide : function ($element) {
                $(".trHighlight").removeClass("trHighlight");
            }
        });

    });
</script>