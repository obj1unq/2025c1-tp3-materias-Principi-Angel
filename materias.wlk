// ObjI - TP3: Materias
class Carrera {
    const inscriptos = #{}
    const materias = #{}

    method inscribirC(estudiante) {
        inscriptos.add(estudiante)
    }

    method estaEnLaCarrera(estudiante) {
        return inscriptos.contains(estudiante)
    }

    method materiasApto(estudiante) {
        return materias.filter({
            materia => materia.puedeInscribirse(estudiante)
        })
    }

    method registrarAprobada(estudiante, materia, nota) {
        validacionInscripto.validar(materia.estaInscripto(estudiante))
        estudiante.foja().registrar(materia, nota)
        materia.darDeBaja(estudiante)
    }

    method materiasInscripto(estudiante) {
        return materias.filter({
            materia => materia.estaInscripto(estudiante)
        })
    }
}
class Materia {
    const carrera
    const property alumnos = #{}
    const tieneCorrelativas = false
    const correlativas = #{}
    const cupo = null
    var listaDeEspera = []

    method listaDeEspera() {
        return listaDeEspera
    }
    
    method inscribirA(estudiante) {
        self.validarInscribirA(estudiante)
        self.inscribirOEsperar(estudiante)
    }

    method inscribirOEsperar(estudiante) { 
        if (self.tieneCupo()){
            alumnos.add(estudiante)
        } else {
            listaDeEspera.add(estudiante)
        }
    } 

    method tieneCupo() {
        return self.cantDeRegulares() < cupo
    }

    method cantDeRegulares() {
        return alumnos.size()
    }

    method validarInscribirA(estudiante) {
        validacionEstudianteEnCarrera.validar(carrera.estaEnLaCarrera(estudiante)) 
        validacionCumpleCorrelativas.validar(self.cumpleCorrelativas(estudiante))
        validacionAprobada.validar(not self.aprobo(estudiante)) 
        validacionInscripto.validar(not self.estaInscripto(estudiante))
    }        

    method aprobo(estudiante) {
        return estudiante.estaAprobada(self)
    }

    method estaInscripto(estudiante) {
        return self.esRegular(estudiante) or self.estaEnEspera(estudiante)
    }

    method esRegular(estudiante) {
        return alumnos.contains(estudiante)
    }

    method estaEnEspera(estudiante) {
        return listaDeEspera.contains(estudiante)
    }

    method cumpleCorrelativas(estudiante) {
        return not tieneCorrelativas or self.estanAprobadasCorrelativas(estudiante)      
    }
    
    method estanAprobadasCorrelativas(estudiante) {
        return correlativas.all({
            correlativa => estudiante.foja().estaAprobada(correlativa)
        })
    }

    method darDeBaja(estudiante) {
        validacionDeBaja.validar(self.estaInscripto(estudiante))
        self.darBaja(estudiante)
    }

    method hayEnEspera() {
        return not listaDeEspera.isEmpty()
    }

    method darBaja(estudiante) {
        if(self.esRegular(estudiante)) {
            alumnos.remove(estudiante)
            self.pasarEsperaARegular()
        } else {
            listaDeEspera.remove(estudiante)
        }
    }

    method pasarEsperaARegular() {  
        if (self.hayEnEspera()) {
            self.pasarARegular(listaDeEspera.first())
        }
    } 

    method pasarARegular(primListaEspera) {
        alumnos.add(primListaEspera)
        listaDeEspera = listaDeEspera.drop(1)
    }

    method puedeInscribirse(estudiante) {
        return self.cumpleCorrelativas(estudiante) and not self.aprobo(estudiante) and not self.estaInscripto(estudiante)
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
object validacionEstudianteEnCarrera inherits Validador(mensaje = "No está inscripta/o en la carrera."){ }
object validacionCumpleCorrelativas inherits Validador(mensaje = "No cumple correlativas."){ }
object validacionAprobada inherits Validador(mensaje = "Ya aprobó esta materia."){ }
object validacionInscripto inherits Validador(mensaje = "Ya está inscripta/o  en esta materia."){ }
object validacionDeBaja inherits Validador(mensaje = "No está inscripta/o en la materia para poder efectuar baja."){ }
class Estudiante {
    
   const property foja = new Foja()
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

    method materiasInscripto() {
        const materias = carreras.map({ 
            carrera => carrera.materiasInscripto(self)
            })
        return materias.flatten().asSet()
    }

    method inscribirEnCarrera(carrera) {
        carrera.inscribirC(self)
        carreras.add(carrera)
    }

    method inscribirEn(materia) {
        materia.inscribirA(self)
    }

    method materiasAlumnoRegular(){
        return self.materiasInscripto().filter({
            materia => materia.esRegular(self)
        })
    }

    method materiasEnListaDeEspera(){
        return self.materiasInscripto().filter({
            materia => materia.estaEnEspera(self)
        })
    }

    method darseDeBaja(materia) {
        materia.darDeBaja(self)
    }

    method materiasQueSePuedeInscribir(carrera) {
        validacionEstudianteEnCarrera.validar(carrera.estaEnLaCarrera(self)) 
        return carrera.materiasApto(self)
    }

    method nota(materia) {
        return foja.nota(materia)
    }
}
class Foja {
    const actas = #{} 
    
    method registrar(materia, nota) {
        self.validarRegistrar(materia)
        const acta = new Acta (materia = materia , nota = nota)
        actas.add(acta)
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

    method nota(materia) {
        return actas.find({
            acta => acta.esMateria(materia)
        }).nota()
    }
}
class Acta {
    var property materia = null
    var property nota = null

    method esMateria(materiaBuscada) {
        return materia == materiaBuscada
    }
}