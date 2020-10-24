package monitor

import geografia.Canton
import org.springframework.dao.DataIntegrityViolationException

import javax.imageio.ImageIO
import java.awt.image.BufferedImage

import static java.awt.RenderingHints.KEY_INTERPOLATION
import static java.awt.RenderingHints.VALUE_INTERPOLATION_BICUBIC


class DocumentoController {

    def listDocumento(){
        def canton = Canton.get(params.id)
        def existeSesion = session?.usuario?.id
        return[canton:canton, sesion: existeSesion]
    }

    def tablaDocumentos_ajax(){
        def canton = Canton.get(params.id)
        def existeSesion = session?.usuario?.id
        def documentos = Documento.withCriteria {
            eq("canton", canton)
            if (params.search && params.search != "") {
                or {
                    ilike("descripcion", "%" + params.search + "%")
                    ilike("clave", "%" + params.search + "%")
                    ilike("resumen", "%" + params.search + "%")
                }
            }
            order("descripcion", "asc")
        }

        return[canton:canton, documentos:documentos, sesion: existeSesion]
    }

    def formDocumento_ajax(){

        def canton = Canton.get(params.canton)
        def documentoInstance

        if(params.id){
            documentoInstance = Documento.get(params.id)
        }else{
            documentoInstance = new Documento()
        }

        return [documentoInstance: documentoInstance, canton: canton]
    }

    def save_ajax() {
        println "save_ajax: $params"
        def canton
        def cantonName

        if (params.canton) {
            canton = Canton.get(params.canton.toLong())
            cantonName = canton.nombre.tr(/áéíóúñÑÜüÁÉÍÓÚàèìòùÀÈÌÒÙÇç .!¡¿?&#°"'/, "aeiounNUuAEIOUaeiouAEIOUCc_")
        }

        def anio = new Date().format("yyyy")
        def pathSave = "${cantonName}/"
        def path = "/var/monitor/documentosCanton/" + pathSave

        //web-app/archivos
        new File(path).mkdirs()
        def f = request.getFile('ruta')  //archivo = name del input type file

            def imageContent = ['image/png': "png", 'image/jpeg': "jpeg", 'image/jpg': "jpg"]
            def okContents = [
                    'image/png'                                                                : "png",
                    'image/jpeg'                                                               : "jpeg",
                    'image/jpg'                                                                : "jpg",

                    'application/pdf'                                                          : 'pdf',
                    'application/download'                                                     : 'pdf',
                    'application/vnd.ms-pdf'                                                   : 'pdf',

                    'application/excel'                                                        : 'xls',
                    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'        : 'xlsx',

                    'application/mspowerpoint'                                                 : 'pps',
                    'application/vnd.ms-powerpoint'                                            : 'pps',
                    'application/powerpoint'                                                   : 'ppt',
                    'application/x-mspowerpoint'                                               : 'ppt',
                    'application/vnd.openxmlformats-officedocument.presentationml.slideshow'   : 'ppsx',
                    'application/vnd.openxmlformats-officedocument.presentationml.presentation': 'pptx',

                    'application/msword'                                                       : 'doc',
                    'application/vnd.openxmlformats-officedocument.wordprocessingml.document'  : 'docx',

                    'application/vnd.oasis.opendocument.text'                                  : 'odt',

                    'application/vnd.oasis.opendocument.presentation'                          : 'odp',

                    'application/vnd.oasis.opendocument.spreadsheet'                           : 'ods'
            ]

            if (f && !f.empty) {
                def fileName = f.getOriginalFilename() //nombre original del archivo
                def ext

                def parts = fileName.split("\\.")
                fileName = ""
                parts.eachWithIndex { obj, i ->
                    if (i < parts.size() - 1) {
                        fileName += obj
                    }
                }

                if (okContents.containsKey(f.getContentType())) {
                    ext = okContents[f.getContentType()]
                    fileName = fileName.size() < 40 ? fileName : fileName[0..39]
                    fileName = fileName.tr(/áéíóúñÑÜüÁÉÍÓÚàèìòùÀÈÌÒÙÇç .!¡¿?&#°"'/, "aeiounNUuAEIOUaeiouAEIOUCc_")

                    def nombre = fileName + "." + ext
                    def pathFile = path + nombre
                    def fn = fileName
                    def src = new File(pathFile)
                    def i = 1
                    println "---> $pathFile"
                    while (src.exists()) {
                        nombre = fn + "_" + i + "." + ext
                        pathFile = path + nombre
                        src = new File(pathFile)
                        i++
                    }
                    try {
                        f.transferTo(new File(pathFile)) // guarda el archivo subido al nuevo path
                    } catch (e) {
                        println "????????\n" + e + "\n???????????"
                    }

                    if (imageContent.containsKey(f.getContentType())) {
                        /* RESIZE */
                        def img = ImageIO.read(new File(pathFile))

                        def scale = 0.5

                        def minW = 200
                        def minH = 200

                        def maxW = minW * 4
                        def maxH = minH * 4

                        def w = img.width
                        def h = img.height

                        if (w > maxW || h > maxH) {
                            int newW = w * scale
                            int newH = h * scale
                            int r = 1
                            if (w > h) {
                                r = w / maxW
                                newW = maxW
                                newH = h / r
                            } else {
                                r = h / maxH
                                newH = maxH
                                newW = w / r
                            }

                            new BufferedImage(newW, newH, img.type).with { j ->
                                createGraphics().with {
                                    setRenderingHint(KEY_INTERPOLATION, VALUE_INTERPOLATION_BICUBIC)
                                    drawImage(img, 0, 0, newW, newH, null)
                                    dispose()
                                }
                                ImageIO.write(j, ext, new File(pathFile))
                            }
                        }
                        /* fin resize */
                    } //si es imagen hace resize para que no exceda 800x800
//                println "llego hasta aca"

                    //aqui guarda el obj en la base
                    def documentoInstance = new Documento()
                    if (params.id) {
                        documentoInstance = Documento.get(params.id)
                        if (!documentoInstance) {
                            documentoInstance = new Documento()
                            println "ERROR*No se encontró Documento."
                        }
                    }
                    params.remove("ruta")
                    documentoInstance.properties = params
                    documentoInstance.ruta = pathSave + nombre

                    println "archivo --> $pathSave  + $nombre"

                    if (!documentoInstance.save(flush: true)) {
                        render "ERROR*Ha ocurrido un error al guardar Documento: " + renderErrors(bean: documentoInstance)
                        def file = new File(pathFile)
                        file.delete()
                        return
                    }
                    render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Documento exitosa."
                    return
                } //ok contents
                else {
                    println "llego else no se acepta"
                    render "ERROR*Extensión no permitida."
                    return
                }
            } //f && !f.empty
            else {
                if (params.id) {
//                def documentoInstance = new Documento()
                    def documentoInstance = Documento.get(params.id)
                    if (!documentoInstance) {
                        documentoInstance = new Documento()
                        println "ERROR*No se encontró Documento."
                    }
                    params.remove("ruta")
                    documentoInstance.properties = params
                    if (!documentoInstance.save(flush: true)) {
                        render "ERROR*Ha ocurrido un error al guardar Documento: " + renderErrors(bean: documentoInstance)
                        return
                    }
                    render "SUCCESS*${params.id ? 'Actualización' : 'Creación'} de Documento exitosa."
                    return
                } else {
                    render "ERROR*No se encontró un Documento que modificar"
                    return
                }
            }

    } //save para grabar desde ajax

    def existeDoc_ajax() {
        println "existeDoc_ajax $params"
        def doc = Documento.get(params.id)
        def path = "/var/monitor/documentosCanton/" + doc.ruta

//        println "--> ${path}"
        def file = new File(path)
        if (file.exists()) {
            render "OK"
        } else {
            render "NO"
        }
    }

    def downloadDoc() {
        def doc = Documento.get(params.id)
        def path = "/var/monitor/documentosCanton/" + doc.ruta
        def nombre = doc.ruta.split("/").last()
        def parts = nombre.split("\\.")
        def tipo = parts[1]
        switch (tipo) {
            case "jpeg":
            case "gif":
            case "jpg":
            case "bmp":
            case "png":
                tipo = "application/image"
                break;
            case "pdf":
                tipo = "application/pdf"
                break;
            case "doc":
            case "docx":
            case "odt":
                tipo = "application/msword"
                break;
            case "xls":
            case "xlsx":
                tipo = "application/vnd.ms-excel"
                break;
            default:
                tipo = "application/pdf"
                break;
        }
        try {
            def file = new File(path)
            def b = file.getBytes()
            response.setContentType(tipo)
            response.setHeader("Content-disposition", "attachment; filename=" + (nombre))
            response.setContentLength(b.length)
            response.getOutputStream().write(b)
        } catch (e) {
            response.sendError(404)
        }
    }

    def delete_ajax() {
        if (params.id) {
            def documentoInstance = Documento.get(params.id)
            if (!documentoInstance) {
                render "ERROR*No se encontró Documento."
                return
            }
            try {
                def path = "/var/monitor/documentosCanton/" + documentoInstance.ruta
                documentoInstance.delete(flush: true)
                println path
                def f = new File(path)
                println f.delete()
                render "SUCCESS*Eliminación de Documento exitosa."
                return
            } catch (DataIntegrityViolationException e) {
                render "ERROR*Ha ocurrido un error al eliminar Documento"
                return
            }
        } else {
            render "ERROR*No se encontró Documento."
            return
        }
    } //delete para eliminar via ajax



}
