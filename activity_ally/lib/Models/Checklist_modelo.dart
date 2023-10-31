class Tareas {
  List<Map<String, dynamic>> _tareas = [];

  static final Tareas _instancia = Tareas.privado();

  Tareas.privado() {
    _tareas = [];
  }

  factory Tareas() {
    return _instancia;
  }

  List<Map<String, dynamic>> get tareas {
    return _tareas;
  }

  void agregarTarea(Map<String, dynamic> nuevaTarea) {
    _tareas.add(nuevaTarea);
  }
}
