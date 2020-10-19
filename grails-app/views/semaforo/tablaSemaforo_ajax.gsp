<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 19/10/20
  Time: 13:46
--%>

<div>
    <table class="table table-condensed table-hover table-striped table-bordered" style="width: 100%">
        <thead>
        <tr style="width: 100%">
            <th style="width: 40%">Color</th>
            <th style="width: 30%">Fecha Desde</th>
            <th style="width: 30%">Fecha Hasta</th>
        </tr>
        </thead>
    </table>
</div>

<div class="" style="width: 100%;height: ${semaforos.size() > 5 ? 350 : 150}px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-condensed table-hover" style="width: 100%">
        <tbody>
        <g:each in="${semaforos}" var="semaforo">
            <tr style="width: 100%">
                <td style="width:40%; background-color: ${semaforo.color == 3 ? '#c42623 ' : (semaforo.color == 2 ? '#FFE61F' : '#89B674')}"></td>
                <td style="width:30%; text-align: center">${semaforo.periodo.fechaDesde.format("dd-MM-yyyy")}</td>
                <td style="width:30%; text-align: center">${semaforo.periodo.fechaHasta.format("dd-MM-yyyy")}</td>
            </tr>
        </g:each>
        </tbody>
    </table>
</div>

<script type="text/javascript">

</script>