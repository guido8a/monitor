<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 22/10/20
  Time: 12:11
--%>
<div class="row">
    <div class="col-md-4">
        <label>
            Latitud: ${latitud}
        </label>
    </div>
    <div class="col-md-4">
        <label>
            Longitud: ${longitud}
        </label>
    </div>
</div>

<div class="row">
    <div class="col-md-2">
        <label>
            Provincia
        </label>
    </div>
    <div class="col-md-6">
        <g:select name="provincia" from="${geografia.Provincia.list().sort{it.nombre}}" optionValue="nombre" optionKey="id" class="form-control"/>
    </div>
</div>

<div class="row" id="divCanton">

</div>

<script type="text/javascript">

    cargarCanton($("#provincia option:selected").val());

    $("#provincia").change(function () {
        var pr = $("#provincia option:selected").val();
        cargarCanton(pr);
    });

    function cargarCanton(provincia){
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'provincia', action: 'canton_ajax')}',
            data:{
                id: provincia
            },
            success: function (msg) {
                $("#divCanton").html(msg)
            }
        });
    }


</script>