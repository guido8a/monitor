package monitor


class PeriodoController {

    def list () {


    }

    def tablaPeriodos_ajax(){
        def periodos = Periodo.list().sort{it.fechaDesde}
        return[periodos:periodos]
    }

}
