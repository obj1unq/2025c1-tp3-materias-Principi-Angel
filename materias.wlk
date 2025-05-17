
class Carrera {
    const inscriptos = #{}
    const materias = #{}

    method inscribirA(estudiante) {
        self.validarIncripcion(estudiante)
        inscriptos.add(estudiante)
    }

    method validarIncripcion(estudiante) {
        if (! self.estaEnLaCarrera(estudiante)) {}
    }

    method estaEnLaCarrera(estudiante) {
        return inscriptos.contains(estudiante)
    }

    method materiasApto(estudiante) {
        self.validarIncripcion(estudiante)
        materias.filter({
            materia => materia.validoInscribirse(estudiante)
        })
    }

    method materiasInscripto(estudiante) {
        return materias.filter({
            materia => materia.estaInscripto(estudiante)
        })
    }
}
class Materia {
    const carrera
    const nombre = null
    const property alumnos = #{}
    const tieneCorrelativas = false
    const correlativas = []
    var cupo = 0
    const property listaDeEspera = []

    method carrera() {
        return carrera
    }

    method nombre(){
        return nombre
    }

    method cupo(_cupo) {
        cupo = _cupo
    }
    
    method inscribirA(estudiante) {
        self.validarInscribirA(estudiante)
        self.inscribirOEsperar(estudiante)
    }

    method inscribirOEsperar(estudiante) { 
        if (! self.tieneCupoLleno()){
            alumnos.add(estudiante)
            estudiante.quedarInscripto(self)
        } else {
            listaDeEspera.add(estudiante)
            estudiante.quedarEnEspera(self)
        }
    } 

    method tieneCupoLleno() {
        return self.cantDeInscriptos() <= cupo
    }

    method cantDeInscriptos() {
        return alumnos.size()
    }

    method validarInscribirA(estudiante) {
        validacionEstudianteEnCarrera.validar(carrera.estaEnLaCarrera(estudiante)) 
        validacionCumpleCorrelativas.validar(self.cumpleCorrelativas(estudiante))
        validacionAprobada.validar(not self.aprobo(estudiante)) 
        validacionInscripto.validar(not self.estaInscripto(estudiante))
    }        

    method aprobo(estudiante) {
        return estudiante.foja().estaAprobada(self)
    }

    method estaInscripto(estudiante) {
        return alumnos.contains(estudiante) or listaDeEspera.contains(estudiante)
    }

    method cumpleCorrelativas(estudiante) {
        return if (tieneCorrelativas) {
                self.estanAprobadasCorrelativas(estudiante) 
            } else {
                true
            }
    }
    
    method estanAprobadasCorrelativas(estudiante) {
        return correlativas.all({
            correlativa => estudiante.foja().estaAprobada(correlativa)
        })
    }

    method darDeBaja(estudiante) {
        self.validarEstudianteSeaAlumno(estudiante)
        alumnos.remove(estudiante)
        if (self.hayEnEspera()) {
            self.inscribirA(listaDeEspera.first())
            listaDeEspera.drop(1)
        }
    }

    method hayEnEspera() {
        return ! listaDeEspera.isEmpty()
    }

    method validarEstudianteSeaAlumno(estudiante) {
        if (! self.estaInscripto(estudiante)) {}
    }
}

class Validador {
    const mensaje = null

    method validar(condicion) {
        if (not condicion) {
            self.error(mensaje)
        }
    }
}

object validacionEstudianteEnCarrera inherits Validador(mensaje = "No está inscripto en la carrera."){ }
object validacionCumpleCorrelativas inherits Validador(mensaje = "No cumple correlativas."){ }
object validacionAprobada inherits Validador(mensaje = "Ya aprobó esta materia."){ }
object validacionInscripto inherits Validador(mensaje = "Ya está inscripto en esta materia."){ }



class Estudiante {
    
   const property foja = new Foja()
   const property materiasInscripto = #{}
   const property materiasEnListaDeEspera = #{}
   const property carreras = #{}

   method cantidadDeAprobadas() {
        return foja.cantAprobadas()
   }

    method promedio() {
        return foja.promedio()
    }

    method estaAprobada(materia) {
        return foja.estaAprobada(materia)
    }

    method materiasInscriptoTodas() {
        return carreras.find({
            carrera => carrera.materiasInscripto(self)
        }).flatten()
    }

    method inscribirEn(carrera) {
        carrera.inscribirA(self)
        carreras.add(carrera)
    }

    method inscribirA(materia) {
        materia.inscribirA(self)
    }

    method quedarEnEspera(materia) {
        materiasInscripto.add(materia)
    }

    method quedarInscripto(materia) {
        materiasEnListaDeEspera.add(materia)
    }

    method materiasQueSePuedeInscribir(carrera) {
        return carrera.materiasApto(self)
    }
}
class Foja {
    const actas = #{} 
    //const materiasAprobadas = #{} 
    //const notas = #{}
    
    method registrar(materia, nota) {
        self.validarRegistrar(materia)
        const acta = new Acta (materia = materia , nota = nota)
        actas.add(acta)
        //materiasAprobadas.add(materia)
        //notas.add(nota)
    }

    method validarRegistrar(materia) {
        if (self.estaAprobada(materia)) {
            self.error("Esta materia ya se encuentra registrada como aprobada.")
        }
    }

    method cantAprobadas() { 
        return actas.size()
    }

    method estaAprobada(materia) {
        return actas.any({
            acta => acta.esMateria(materia)
        })
    }

    method promedio() {
        return self.sumaNotas() / self.cantAprobadas()
    }

    method sumaNotas() {
        return actas.sum({
            acta => acta.nota()
        })
    }
}
class Acta {
    var property materia = null
    var property nota = null

    method esMateria(materiaBuscada) {
        return materia.nombre() == materiaBuscada.nombre()
    }

}