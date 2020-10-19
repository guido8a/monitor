<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 19/10/20
  Time: 15:45
--%>
<asset:javascript src="/apli/jquery.switcher.js"/>
<asset:stylesheet src="/apli/switcher.css"/>


<g:form class="form-horizontal" name="frmSemaforo" action="saveSemaforo_ajax">
    <g:hiddenField name="canton" value="${canton?.id}"/>
    <div class="form-group">
        <span class="grupo">
            <label class="col-md-2 control-label text-info" style="font-size: 14px">
                Color
            </label>
            <div class="col-md-9">
                <div class="form-check form-check-inline col-md-3">
                 Verde   <input class="form-check-input" checked type="radio" name="color" id="inlineRadio1" value="${1}">
                </div>
                <div class="form-check form-check-inline col-md-3">
                 Amarillo   <input class="form-check-input" type="radio" name="color" id="inlineRadio2" value="${2}">
                </div>
                <div class="form-check form-check-inline col-md-3">
                 Rojo   <input class="form-check-input" type="radio" name="color" id="inlineRadio3" value="${3}">
                </div>
                <p class="help-block ui-helper-hidden"></p>
            </div>
        </span>
    </div>
    <div class="form-group" style="margin-top: 10px">
        <span class="grupo">
            <label class="col-md-2 control-label text-info" style="font-size: 14px">
                Período
            </label>
            <div class="col-md-9">
                <g:select name="periodo" from="${monitor.Periodo.list().sort{it.fechaDesde}}" class="form-control"
                          optionKey="id" optionValue="${{"Desde: " + it.fechaDesde.format("dd-MM-yyyy") + " Hasta: " + it.fechaHasta.format("dd-MM-yyyy")}}"/>
            </div>
        </span>
    </div>
</g:form>

<script type="text/javascript">


    $.switcher('input[type=radio]');


    var validator = $("#frmIva").validate({
        errorClass     : "help-block",
        errorPlacement : function (error, element) {
            if (element.parent().hasClass("input-group")) {
                error.insertAfter(element.parent());
            } else {
                error.insertAfter(element);
            }
            element.parents(".grupo").addClass('has-error');
        },
        success        : function (label) {
            label.parents(".grupo").removeClass('has-error');
        }
    });
</script>