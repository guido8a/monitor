

<table id="tblDocumentos" class="table table-condensed table-hover table-striped table-bordered">
    <thead>
        <tr>
            <th>Fuente</th>
            <th>Descripción</th>
            <th>Palabras Clave</th>
            <th>Resumen</th>
            <th>Acciones</th>
        </tr>
    </thead>
    <tbody id="tbDoc">
        <g:each in="${documentos}" var="documento">
            <tr>
                <td>${documento.fuente.descripcion}</td>
                <td><elm:textoBusqueda busca="${params.search}">${documento.descripcion}</elm:textoBusqueda></td>
                <td><elm:textoBusqueda busca="${params.search}">${documento.clave}</elm:textoBusqueda></td>
                <td><elm:textoBusqueda busca="${params.search}">${documento.resumen}</elm:textoBusqueda></td>
                <td style="width: 90px;">
                    <div class="btn-group" role="group">

                        <a href="#" class="btn btn-xs btn-success btnDownDoc" data-id="${documento.id}" title="Descargar">
                            <i class="fa fa-download"></i>
                        </a>
                        <a href="#" class="btn btn-xs btn-info btnEditDoc" data-id="${documento.id}" title="Editar">
                            <i class="fa fa-edit"></i>
                        </a>
                        <a href="#" class="btn btn-xs btn-danger btnDelDoc" data-id="${documento.id}" title="Eliminar">
                            <i class="fa fa-trash"></i>
                        </a>
                    </div>
                </td>
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
    });
</script>