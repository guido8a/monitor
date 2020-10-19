package monitor

import geografia.Canton

class Semaforo {

    Canton canton
    Periodo periodo
    int color

    static mapping = {
        table 'smfr'
        cache usage: 'read-write', include: 'non-lazy'
        id column: 'smfr__id'
        id generator: 'identity'
        version false
        columns {
            id column: 'smfr__id'
            canton column: 'cntn__id'
            periodo column: 'prdo__id'
            color column: 'smfrcolr'
        }
    }
    static constraints = {
        canton(blank:false, nullable: false)
        periodo(blank:false, nullable: false)
        color(blank:false, nullable: false)
    }
}
