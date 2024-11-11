class Actividad { 
  const property idiomas = #{}

  method dias() 
  method implicaEsfuerzo() = true
  method sirveParaBroncearse() 
  method esInteresante() = idiomas.count({i => i.size() >= 2})
  method esRecomendada(unSocio) {
    self.esInteresante() and unSocio.leAtrae(self) and not unSocio.actividades().contains(self)
  }
}

class Playa inherits Actividad {
  const largo 

  override method implicaEsfuerzo() = largo > 1200
  override method sirveParaBroncearse() = true
  override method dias() = largo / 500 
}

class Ciudad inherits Actividad {
  var property atracciones 

  override method dias() = atracciones / 2
  override method implicaEsfuerzo() = atracciones.between(5, 8)
  override method sirveParaBroncearse() = false  
  override method esInteresante() = super() or atracciones == 5
  
}

class CiudadTropical inherits Ciudad {
  override method dias() = super() + 1
  override method sirveParaBroncearse() = true  
}

class SalidaTrekking inherits Actividad {
  const km 
  const diasSol 

  override method dias() = km / 50
  override method implicaEsfuerzo() = km > 80
  override method sirveParaBroncearse() {
    return km > 200 or diasSol.between(100, 200) and km > 120
  } 
  override method esInteresante() = super() and diasSol > 140 
}

class ClaseGym inherits Actividad {
  method initialize() {
    idiomas.clear()
    idiomas.add("español")
    if (idiomas != ["español"]) self.error("Solo permite el español.")
  }
  override method dias() = 1
  override method implicaEsfuerzo() = true
  override method sirveParaBroncearse() = false
  override method esRecomendada(unSocio) {
    unSocio.edad().between(20, 30)
  } 
}

class TallerLiteratio inherits Actividad {
  const libros = #{}

  method initialize() {
    idiomas.clear()
    idiomas.addAll(libros.map({ l => l.idiomas()}))
  }
  override method dias() = libros.size() + 1
  override method implicaEsfuerzo() =
    libros.any({l => l.cantPag() > 500}) or
    (libros.size() > 1 and libros.map({ l => l.nombreAutor()}).asSet().size() == 1)  
  
  override method sirveParaBroncearse() = false
  override method esRecomendada(unSocio) {
    unSocio.idiomas().size() > 1
  } 
}

class Libro {
  const property idioma 
  const property cantPag 
  const property nombreAutor 
}

class Socio {
  const property actividades = []
  const maxActividades 
  var property edad
  const  idiomas = #{}

  method edad() = edad
  method esAdoradorDelSol() = actividades.all({a => a.sirveParaBroncearse()})
  method actividadesEsforzadas() = actividades.filter({a => a.implicaEsfuerzo()})
  method registrarActividad(unaAct) {
    if (maxActividades == actividades.size()) self.error("Alcanzó el maximo de actividades.")
    actividades.add(unaAct)
  }
  method leAtrae(unaAct) 
}

class Tranquilo inherits Socio {
  override method leAtrae(unaAct) = unaAct.dias() >= 4
}

class Coherente inherits Socio {
  override method leAtrae(unaAct){ 
    return
    if (self.esAdoradorDelSol()) {unaAct.sirveParaBroncearse()}
    else {unaAct.implicaEsfuerzo()}
  }
}

class Relajado inherits Socio {
  override method leAtrae(unaAct){
    return 
    not idiomas.intersection(unaAct.idiomas()).isEmpty()
  }
}