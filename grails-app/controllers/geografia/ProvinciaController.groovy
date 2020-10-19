package geografia

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
        def sql = ""
        def coord = '', nmbr = '', txto = '', docu, prdo = 0, periodo
        if(!params.id) {
            prdo = 1
        } else {
            prdo = params.id.toInteger()
        }

        sql = "select * from rp_smfr(${prdo})"
        println "sql: $sql"

        cn.eachRow(sql.toString()) {d ->
            coord += (coord? '_' : '') + "${d.cntnlatt} ${d.cntnlong} ${d.smfrcolr}"
            docu = true
            txto = "${d.cntnnmbr} kkPeriodo: ${d.smfrfcds.format('dd-MMM-yyyy')} al ${d.smfrfchs.format('dd-MMM-yyyy')}" +
                    "${(docu  ? 'kkDocumentos: N' : '')}"

            nmbr += (nmbr? '_' : '') + txto
            periodo = "${d.smfrfcds.format('dd-MMM-yyyy')} al ${d.smfrfchs.format('dd-MMM-yyyy')}"
        }

        //${assetPath(src: '/apli/pin-p.png')}
        def semaforos = "${assetPath(src: '/apli/pin-p.png')} ${assetPath(src: '/apli/pin-o.png')} ${assetPath(src: '/apli/pin-p.png')}"
        return [cord: coord, nmbr: nmbr, prdo: prdo, periodo: periodo]

    }
} //fin controller
