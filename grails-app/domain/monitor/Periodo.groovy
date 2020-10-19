package monitor

class Periodo {

    Date fechaDesde
    Date fechaHasta

    static mapping = {
        table 'prdo'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'prdo__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'prdo__id'
            fechaDesde column: 'prdofcds'
            fechaHasta column: 'prdofchs'
        }
    }
    static constraints = {
        fechaDesde(blank:false, nullable: false)
        fechaHasta(blank:false, nullable: false)
    }
}
