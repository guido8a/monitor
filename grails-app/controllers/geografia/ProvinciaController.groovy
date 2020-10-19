package geografia

class ProvinciaController {

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
//        def cn = dbConnectionService.getConnection()
//        def sql = "select * from rp_orgn() order by unejplns desc"
//
//        def coord = '', nmbr = '', txto = '', con_plan = '', plns, pfi, cnvn, cnvnfida, cnvnasap
//        println "sql: $sql"
//
//        cn.eachRow(sql.toString()) {d ->
//            coord += (coord? '_' : '') + "${d.unejlatt} ${d.unejlong}"
//            plns = d.unejplns.toInteger() > 0
//            pfi  = d.nmro_pfi.toInteger() > 0
//            cnvn = d.cnvnmnto?.toInteger() > 0
//            cnvnfida = d.cnvnfida?.toInteger() > 0
//            cnvnasap = d.cnvnasap?.toInteger() > 0
//            txto = "${d.unejnmbr} kkTalleres realizados: ${d.nmrotllr} " +
//                    "kkPersonas capacitadas: ${d.nmroprtl} " +
//                    "kkHombres: ${d.nmrohomb} Mujeres: ${d.nmromuje} Total: ${d.nmrobenf} " +
//                    (pfi ? 'kkSi cuenta con un PFI' :'') +
//                    (plns ? 'kkSi cuenta con un PNS' : '') +
//                    (cnvn ? "kkMonto del convenio: ${d.cnvnmnto}" : "") +
//                    (cnvnfida ? "kkAporte FIDA: ${d.cnvnfida}" : "") +
//                    (cnvnasap ? "kkAporte ASAP: ${d.cnvnasap}" : "")
//            if(d.unej__id == 200) println"unej: ${d.unejnmbr} --> ${plns}"
//            con_plan += (con_plan? '_' : '') + (plns ? 'S' : ' ')
//            nmbr += (nmbr? '_' : '') + txto
//
//        }
////        println "data: ${con_plan.split('_')}"
//
//        return [cord: coord, nmbr: nmbr, plns: con_plan]

    }
} //fin controller
