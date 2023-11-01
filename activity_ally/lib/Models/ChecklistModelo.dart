class ChecklistItem {
  int id; // ID único de cada elemento
  String nombre;
  bool completado;

  ChecklistItem(
      {required this.id, required this.nombre, required this.completado});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'completado': completado ? 1 : 0, // 1 si está completado, 0 si no lo está
    };
  }

  // Método para crear un objeto desde un mapa
  factory ChecklistItem.fromMap(Map<String, dynamic> map) {
    return ChecklistItem(
      id: map['id'],
      nombre: map['nombre'],
      completado: map['completado'] == 1,
    );
  }
  Map<String, dynamic> toSqlite() {
    return {
      'nombre': nombre,
      'completado': completado ? 1 : 0,
    };
  }
}
