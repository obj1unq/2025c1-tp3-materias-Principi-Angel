
class Carerra {

}
class Materia {

    method carrera()
}

// class MateriaDeProgramacion inherits Materia {
//     override method carrera() {
//         return programacion
//     }
// }
// 
// class MateriaDeMedicina inherits Materia {
//     override method carrera() {
//         return medicina
//     }
// }
// 
// class MateriaDeDerecho inherits Materia {
//     override method carrera() {
//         return derecho
//     }
// }

class Estudiante {

    const materiasAprobadas = #{}

    method materiaAprobadaCon(materia, nota) {
        siu.materiaAprobadaCon(self, materia, nota)
        materiasAprobadas.add(materia)
    }

    method materiasAprobadas() {
        return materiasAprobadas
    }

    method cantidadDeMateriasAprobadas() {
        return materiasAprobadas.size()
    }

    method promedio() {
        return self.sumaNotasAprobadas() / self.cantidadDeMateriasAprobadas()
    }

    method sumaNotasAprobadas() {
        return siu.sumaNotasAprobadas(self)
    }

    method tieneAprobada(materia) {
        return materiasAprobadas.contains(materia)
    }

    method materiasInscripto() {

    }
}

object siu {
    const estudiantesConAprobadas = new Dictionary()
    const materiasConNota = new Dictionary()

    method materiaAprobadaCon(estudiante, materia, nota) {
        if (! estaAprobadaPor(materia, estudiante)) {
             estudiantesConAprobadas.put(estudiante, materiasConNota.put(materia, nota))
        } else { 
            self.error("El estudiante ya aprobó esta materia.")
        } 
    }

    method estaAprobadaPor(materia, estudiante) {
        return self.materiasDe(estudiante).containsKey(materia)
    }

    method materiasDe(estudiante) {
        return estudiantesConAprobadas.get(estudiante)
    }

    method sumaNotasAprobadas(estudiante) {
        const materias = estudiantesConAprobadas.get(estudiante)
        return self.sumaNotas(materias)
    }

    method sumaNotas(materias) {
        return materias.values().sum()
    }  
}