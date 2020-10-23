package monitor

import geografia.Canton
import geografia.Provincia

class SemaforoController {

    def arbol () {

    }

    def loadTreePart_ajax() {
        render(makeTreeNode(params))
    }

    def makeTreeNode(params) {
        println "makeTreeNode.. $params"
        def id = params.id
        def tipo = ""
        def liId = ""
        def ico = ""

        if(id.contains("_")) {
            id = params.id.split("_")[1]
            tipo = params.id.split("_")[0]
        }

        if (!params.order) {
            params.order = "asc"
        }

        String tree = "", clase = "", rel = ""
        def padre
        def hijos = []

        if (id == "#") {
            //root
            def hh = Provincia.count()
            if (hh > 0) {
                clase = "hasChildren jstree-closed"
            }
            tree = "<li id='root' class='root ${clase}' data-jstree='{\"type\":\"root\"}' data-level='0' >" +
                    "<a href='#' class='label_arbol'>División Geográfica</a>" +
                    "</li>"
        } else {
            if(id == 'root'){
                hijos = Provincia.findAll().sort{it.nombre}
                def data = ""
                ico = ", \"icon\":\"fa fa-parking text-success\""
                hijos.each { hijo ->
                    clase = Canton.findByProvincia(hijo) ? "jstree-closed hasChildren" : "jstree-closed"
                    tree += "<li id='prov_" + hijo.id + "' class='" + clase + "' ${data} data-jstree='{\"type\":\"${"principal"}\" ${ico}}' >"
                    tree += "<a href='#' class='label_arbol'>" + hijo?.nombre + "</a>"
                    tree += "</li>"
                }
            }else{
                switch(tipo) {
                    case "prov":
                        hijos = Canton.findAllByProvincia(Provincia.get(id), [sort: params.sort])
                        liId = "cntn_"
                        ico = ", \"icon\":\"fa fa-copyright text-info\""
                        hijos.each { h ->
                            clase = "jstree-closed hasChildren"
                            tree += "<li id='" + liId + h.id + "' class='" + clase + "' data-jstree='{\"type\":\"${"canton"}\" ${ico}}'>"
                            tree += "<a href='#' class='label_arbol'>" + h.nombre + "</a>"
                            tree += "</li>"
                        }
                        break
                    case "cntn":
                        break
                }
            }
        }
        return tree
    }

    /**
     * Acción llamada con ajax que permite realizar búsquedas en el árbol
     */
    def arbolSearch_ajax() {
        println "arbolSearch_ajax $params"
        def search = params.str.trim()
        if (search != "") {
            def c = Canton.createCriteria()
            def find = c.list(params) {
                or {
                    ilike("nombre", "%" + search + "%")
                    provincia {
                        or {
                            ilike("nombre", "%" + search + "%")
                        }
                    }
                }
            }
            def provincias = []
            find.each { pers ->
                if (pers.provincia && !provincias.contains(pers.provincia)) {
                    provincias.add(pers.provincia)
                    def dep = pers.provincia
                }
            }
            provincias = provincias.reverse()
            def ids = "["
            if (find.size() > 0) {
                ids += "\"#root\","
                provincias.each { dp ->
                    ids += "\"#lidep_" + dp.id + "\","
                }
                ids = ids[0..-2]
            }
            ids += "]"
            render ids
        } else {
            render ""
        }
    }

    def list(){
        def canton = Canton.get(params.id)
        return[canton: canton]
    }

    def tablaSemaforo_ajax(){
        def canton = Canton.get(params.id)
        def semaforos = Semaforo.findAllByCanton(canton).sort{it.periodo.fechaDesde}
        return[semaforos:semaforos]
    }

    def form_ajax(){
        def canton = Canton.get(params.canton)
        def semaforo
        if(params.id){
            semaforo = Semaforo.get(params.id)
        }else{
            semaforo = new Semaforo()
        }
        return[canton: canton, semaforo: semaforo]
    }

    def saveSemaforo_ajax(){
//        println("params ss " + params)

        def canton = Canton.get(params.canton)
        def periodo = Periodo.get(params.periodo)
        def semaforo

        def existe = Semaforo.findByCantonAndPeriodo(canton,periodo)
        def band

        if(existe?.id == (params.id ? params.id.toInteger() : null)){
            band = 0
        }else{
            band = 1
        }

        if(band == 1){
            render "er_Ya existe un registro creado en ese período"
        }else{

            if(params.id){
                semaforo = Semaforo.get(params.id)
            }else{
                semaforo = new Semaforo()
            }

            semaforo.canton = canton
            semaforo.periodo = periodo
            semaforo.color = params.color.toInteger()

            if(!semaforo.save(flush:true)){
                println("error al guardar el semaforo " + semaforo.errors)
                render "no"
            }else{
                render "ok"
            }
        }
    }

    def borrarSemaforo_ajax(){
        def semaforo = Semaforo.get(params.id)

        try{
            semaforo.delete(flush:true)
            render "ok"
        }catch(e){
            println("error al borrar el semaforo" ) + semaforo.errors
            render "no"
        }
    }

}
