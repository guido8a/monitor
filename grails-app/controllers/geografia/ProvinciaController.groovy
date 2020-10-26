package geografia

import monitor.Periodo
import seguridad.Visita

class ProvinciaController {

    def dbConnectionService

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

    def index() {
        redirect(action: "list", params: params)
    } //index

    def list() {
        params.max = Math.min(params.max ? params.int('max') : 10, 100)
        [provinciaInstanceList: Provincia.list(params), provinciaInstanceTotal: Provincia.count(), params: params]
    } //list

    def form_ajax() {
        def provinciaInstance = new Provincia(params)
        if(params.id) {
            provinciaInstance = Provincia.get(params.id)
            if(!provinciaInstance) {
                flash.clase = "alert-error"
                flash.message =  "No se encontró Provincia con id " + params.id
                redirect(action:  "list")
                return
            } //no existe el objeto
        } //es edit
        return [provinciaInstance: provinciaInstance]
    } //form_ajax

    def save() {

        def provinciaInstance

        params.nombre = params.nombre.toUpperCase()

        if(params.id) {
            provinciaInstance = Provincia.get(params.id)
            if(!provinciaInstance) {
                render "no_No se encontró la provincia"
                return
            }//no existe el objeto

            if(provinciaInstance?.numero.toInteger() == params.numero.toInteger()){
                provinciaInstance.properties = params
            }else{
                if(Provincia.findAllByNumero(params.numero.toInteger())){
                    render "no_Ya existe una provincia registrada con este número!"
                    return
                }else{
                    provinciaInstance.properties = params
                }
            }
        }//es edit
        else {
            if(Provincia.findAllByNumero(params.numero.toInteger())){
                render "no_Ya existe una provincia registrada con este número!"
                return
            }else{
                provinciaInstance = new Provincia(params)
            }
        } //es create
        if (!provinciaInstance.save(flush: true)) {
            render "no_Error al guardar la provincia"
            return
        }else{
            if(params.id) {
                render  "ok_Se ha actualizado correctamente la Provincia "
            } else {
                render "ok_Se ha creado correctamente la Provincia "
            }
        }
    } //save

    def show_ajax() {
        def provinciaInstance = Provincia.get(params.id)
        if (!provinciaInstance) {
            flash.clase = "alert-error"
            flash.message =  "No se encontró Provincia con id " + params.id
            redirect(controller: 'canton', action: 'arbol')
            return
        }
        [provinciaInstance: provinciaInstance]
    } //show


    def borrarProvincia_ajax () {

            def provincia = Provincia.get(params.id)

            try{
                provincia.delete(flush: true)
                render "ok"
            }catch(e){
                println("error al borrar la provincia " + e)
                render "no"
            }
    }


    def mapa(){
        println "mapa: $params"
        def cn = dbConnectionService.getConnection()
        def sql = "", sql1, sql2
        def coord = '', nmbr = '', txto = '', docu, prdo = 0, periodo, dcmt, cntn = ""
        def visita
        if(params.id == '-1') {
            params.id = 1
            /* registra ingreso directo sin hacer login */
            println  "visita desde ip: ${request.getRemoteAddr()}"  //activo
            visita = new Visita()
            visita.fecha = new Date()
            visita.dirIP = request.getRemoteAddr()
            visita.save()
            sql = "insert into vist(vist__id, vistfcha, vistdrip, vistclic) values(default, " +
                    "${new Date().format('yyyy-mm-dd')}"
        } else if(params.visita) {
            println "incremente visita"
            visita = Visita.get(params.visita)
            visita.clics++
            visita.save(flush: true)
        }
        if(!params.id) {
            prdo = 1
        } else {
            prdo = params.id
        }
        println "prdo: $prdo"
        sql1 = "select max(prdo__id) prdo from prdo where prdofchs < " +
                "(select prdofcds from prdo where prdo__id = ${prdo})"
        sql2 = "select min(prdo__id) prdo from prdo where prdofcds > " +
                "(select prdofchs from prdo where prdo__id = ${prdo})"
//        println "sql1: $sql1"
//        println "sql2: $sql2"
        def anterior = cn.rows(sql1.toString())[0]?.prdo
        def siguiente = cn.rows(sql2.toString())[0]?.prdo
//        println "prdo: $prdo --> siguiente: $siguiente, <-- $anterior"

        sql = "select * from rp_smfr(${prdo})"
//        println "sql: $sql"

        cn.eachRow(sql.toString()) { d ->
            coord += (coord ? '_' : '') + "${d.cntnlatt} ${d.cntnlong} ${d.smfrcolr}"
//            docu = d.nmrodcmt > 0
            docu = d.dcmtnmro > 0
            dcmt += (coord ? '_' : '') + "${d.cntnlatt} ${d.cntnlong} ${d.smfrcolr}"
            cntn += (cntn ? '_' : '') + "${d.cntn__id}"
            txto = "${d.cntnnmbr} kkPeriodo: ${d.smfrfcds.format('dd-MMM-yyyy')} al ${d.smfrfchs.format('dd-MMM-yyyy')}" +
                    "${(docu ? 'kkDocumentos: ' + d.dcmtnmro : '')}"

            nmbr += (nmbr ? '_' : '') + txto
            periodo = "${d.smfrfcds.format('dd-MMM-yyyy')} al ${d.smfrfchs.format('dd-MMM-yyyy')}"
        }

        //${assetPath(src: '/apli/pin-p.png')}
//        println "--> cntn: $cntn"
        return [cord: coord, nmbr: nmbr, prdo: prdo, periodo: periodo, cntn: cntn, anterior: anterior,
                siguiente: siguiente, visita: visita?.id, pr: Periodo.get(prdo)]

    }

    def provincia_ajax(){
        return[latitud:params.lat, longitud:params.long]
    }

    def canton_ajax(){
        def provincia = Provincia.get(params.id)
        def cantones = Canton.findAllByProvincia(provincia).sort{it.nombre}
        return[cantones: cantones]
    }


    def guardarCanton_ajax(){
//        println("params gc " + params)
        def canton = Canton.get(params.canton)
        canton.latitud = params.latitud.toDouble()
        canton.longitud = params.longitud.toDouble()

        if(!canton.save(flush:true)){
            println("error al guardar el canton desde mapa " + canton.errors)
            render "no"
        }else{
            render "ok"
        }
    }
} //fin controller
