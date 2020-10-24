package monitor


class PeriodoController {
    def dbConnectionService

    def list () {

    }

    def tablaPeriodos_ajax(){
//        def periodos = Periodo.list().sort{it.fechaDesde}
        def periodos = Periodo.list([sort: 'fechaDesde', order: 'Desc'])
        return[periodos:periodos, total: periodos.size()]
    }

    def formPeriodo_ajax(){
        def periodo

        if(params.id){
            periodo = Periodo.get(params.id)
        }else{
            periodo = new Periodo()
        }

        return[periodo:periodo]
    }

    def save_ajax (){
//        println("params gp " + params)
        def cn = dbConnectionService.getConnection()
        def fd = new Date().parse("dd-MM-yyyy",params.fechaDesde)
        def fh = new Date().parse("dd-MM-yyyy",params.fechaHasta)

        def existe = Periodo.findAllByFechaHastaBetween(fd,fh)
        def existeFechaD = Periodo.findAllByFechaDesde(fd)
        def existeFechaH = Periodo.findAllByFechaHasta(fh)
        def periodo
        def sql = ""

//        println("existe " + existe)
//        println("existeFechaD " + existeFechaD)
//        println("existeFechaH " + existeFechaH)

        if(fd > fh){
            render "er_La fecha inicial es mayor a la fecha final"
        }else{
            if(existeFechaD || existeFechaH){
                render "er_La fecha seleccionada ya se encuentra en períodos anteriores"
            }else{
                if(existe){
                    render "er_No se puede crear el período entre las fechas seleccionadas"
                }else{
                    periodo = new Periodo()
                    /* copiar los semáforos del periodo anterior */
                    periodo.fechaDesde = fd
                    periodo.fechaHasta = fh

                    if(!periodo.save(flush:true)){
                        println("error al guardar el periodo " + periodo.errors)
                        render "no_Error al guardar el período"
                    }else{
                        periodo.refresh()
                        sql = "insert into smfr(cntn__id, smfrcolr, prdo__id) select cntn__id, smfrcolr, ${periodo.id} " +
                                "from smfr where prdo__id = (select max(prdo__id) from smfr)"
//                        println "sql: ${sql}"
                        cn.execute(sql.toString())
                        render "ok_Período guardado correctamente<br>Se copiaron además todos los semáforos del último periodo"
                    }
                }
            }
        }
    }

    def borrarPeriodo_ajax(){
        def periodo = Periodo.get(params.id)
        def existeSemaforo = Semaforo.findAllByPeriodo(periodo)
        if(existeSemaforo){
            render "er_El período ya se encuentra en uso, no puede ser borrado"
        }else{
            try{
                periodo.delete(flush:true)
                render "ok"
            }catch(e){
                println("error al borrar el periodo") + periodo.errors
                render "no"
            }
        }
    }

}
