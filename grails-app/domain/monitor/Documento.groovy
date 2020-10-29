package monitor

import audita.Auditable
import geografia.Canton

/*Es toda documentación importante que debe ser archivada en el proyecto. Este comprende el archivo de proyecto o el archivo de casos de proyecto.
Se usará preferentemente formato pdf, pero pueden incluirse otros formatos aunque no puedan ser visualizados desde el sistema.*/
/**
 * Clase para conectar con la tabla 'dcmt' de la base de datos<br/>
 * Es toda documentación importante que debe ser archivada en el proyecto.
 * Esta comprende el archivo de proyecto o el archivo de casos de proyecto.
 * Se usará preferentemente formato pdf, pero pueden incluirse otros formatos aunque no puedan ser visualizados desde el sistema.
 */
class Documento implements Auditable {

    Canton canton
    Fuente fuente

    /**
     * Descripción del documento
     */
    String descripcion
    /**
     * Palabras claves del documento
     */
    String clave
    /**
     * Resumen del documento
     */
    String resumen
    /**
     * Path del archivo del documento
     */
    String ruta
    /**
     * fecha de creación del documento
     */
    Date fecha

    /**
     * Define los campos que se van a ignorar al momento de hacer logs
     */
    static auditable = true

    /**
     * Define el mapeo entre los campos del dominio y las columnas de la base de datos
     */
    static mapping = {
        table 'dcmt'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'dcmt__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'dcmt__id'
            canton column: 'cntn__id'
            fuente column: 'fnte__id'
            descripcion column: 'dcmtdscr'
            clave column: 'dcmtclve'
            resumen column: 'dcmtrsmn'
            ruta column: 'dcmtruta'
            fecha column: 'dcmtfcha'
        }
    }

    /**
     * Define las restricciones de cada uno de los campos
     */
    static constraints = {
        descripcion(size: 1..63, blank: true, nullable: true, attributes: [mensaje: 'Descripción del documento'])
        clave(size: 1..63, blank: true, nullable: true, attributes: [mensaje: 'Palabras clave'])
        resumen(size: 1..1024, blank: true, nullable: true, attributes: [mensaje: 'Resumen'])
        ruta(size: 1..255, blank: true, nullable: true, attributes: [mensaje: 'Ruta'])
        fecha(blank: true, nullable: true)
    }

    /**
     * Genera un string para mostrar
     * @return la descripción
     */
    String toString() {
        return this.descripcion
    }
}