import materias.*
class MateriaDeProgramacion inherits Materia(carrera = programacion) {}
class MateriaDeMedicina inherits Materia(carrera = medicina) {}
class MateriaDeDerecho inherits Materia(carrera = derecho) {}

const programacion = new Carrera (materias = #{elementos, matematicaI, objetosI, objetosII, objetosIII, tpFinal, basesDeDatos, progConcurrente })

const elementos       = new MateriaDeProgramacion (cupo = 15)
const matematicaI     = new MateriaDeProgramacion (cupo = 15)
const objetosI        = new MateriaDeProgramacion (cupo = 10)
const objetosII       = new MateriaDeProgramacion (cupo = 3, tieneCorrelativas = true, correlativas = #{objetosI, matematicaI})    
const objetosIII      = new MateriaDeProgramacion (tieneCorrelativas = true, correlativas = #{objetosII, basesDeDatos})
const progConcurrente = new MateriaDeProgramacion ( tieneCorrelativas = true, correlativas = #{objetosI, basesDeDatos})
const tpFinal         = new MateriaDeProgramacion (tieneCorrelativas = true, correlativas = #{objetosIII})
const basesDeDatos    = new MateriaDeProgramacion (cupo = 10)

const medicina = new Carrera(materias = #{quimica, biologiaI, biologiaII, anatomia})

const quimica      = new MateriaDeMedicina ()
const biologiaI    = new MateriaDeMedicina ()
const biologiaII   = new MateriaDeMedicina ( tieneCorrelativas = true, correlativas = #{biologiaI})    
const anatomia     = new MateriaDeMedicina ( tieneCorrelativas = true, correlativas = #{biologiaII})

const derecho = new Carrera()