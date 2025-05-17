import materias.*


class MateriaDeProgramacion inherits Materia(carrera = programacion) {}
class MateriaDeMedicina inherits Materia(carrera = medicina) {}
class MateriaDeDerecho inherits Materia(carrera = derecho) {}


const programacion = new Carrera (materias = #{elementos, matematicaI, objetosI, objetosII, objetosIII, tpFinal, basesDeDatos })
const elementos    = new MateriaDeProgramacion (nombre = "Elementos de Programación")
const matematicaI  = new MateriaDeProgramacion (nombre = "Matemática 1")
const objetosI     = new MateriaDeProgramacion (nombre = "Objetos 1")
const objetosII    = new MateriaDeProgramacion (nombre = "Objetos 2")    
const objetosIII   = new MateriaDeProgramacion (nombre = "Objetos 3")
const tpFinal      = new MateriaDeProgramacion (nombre = "TP Final")
const basesDeDatos = new MateriaDeProgramacion (nombre = "Bases de Datos")

const medicina     = new Carrera(materias = #{quimica, biologiaI, biologiaII, anatomia})
const quimica      = new MateriaDeMedicina (nombre = "Química")
const biologiaI    = new MateriaDeMedicina (nombre = "Biología 1")
const biologiaII   = new MateriaDeMedicina (nombre = "Biología 2")    
const anatomia     = new MateriaDeMedicina (nombre = "Anatomía General")

const derecho     = new Carrera()
