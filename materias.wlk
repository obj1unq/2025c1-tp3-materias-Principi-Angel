
class Carerra {

}

object programacion inherits Carerra {}
class Materia {
    const carrera = null
}


class Estudiante {
    const property idSIU = null
    
    method cantAprobadas() {
        return siu.cantAprobadas(self)
    }

    method promedio() {
        return siu.promedio(idSIU)
    }

    method estaAprobada(materia) {
        return siu.estaAprobada(idSIU, materia)
    }
}

object siu {

    const notaDeAprobacion = 4
    var registroEnProseso = null

    method registrarAcreditada(estudiante, materia, nota) {
        const registroTemp = new RegistroAcreditacion()
        registroTemp.registrar(materia, nota) 
        estudiante.idSIU(registroTemp.identity())
        registroEnProseso = registroTemp
    }

    method aprobadaPor(materia, estudiante) {
        const registroTemp = estudiante.idSIU()
        return registroTemp.nota(materia) >= notaDeAprobacion
    }

    method cantAprobadas(estudiante) {
        return estudiante.idSIU().cantAprobadas()
    }

    method promedio(idSIU) {
        return idSIU.promedio()
    }

    method estaAprobada(idSIU, materia) {
        return idSIU.nota(materia) >= notaDeAprobacion
    }
    
}

class RegistroAcreditacion {

    const materias = #{} 
    
    method registrar(materia, nota) {
        const materiaYNota = new ParMateriaNota (materia = materia, nota = nota)
        materias.add(materiaYNota)
    }

    method nota(materia) {
        return self.materia(materia).nota()
    }

    method materia(materia){ 
        return materias.find({
            par => par.materia() == (materia)
        })
    }

    method cantAprobadas() {
        return self.materiasAprobadas().size()
    }

    method materiasAprobadas() {
        return materias
    }

    method promedio() {
        return self.sumaNotas() / self.cantAprobadas()
    }
    
    method sumaNotas() {
        return materias.sum({
            par => par.nota()
        })
    }
}

class ParMateriaNota {
    const materia = null
    const nota = null
    
    method crear() {
        new Pair (x = materia, y = nota)
    } 

    method nota(){
        return nota
    }
}

