class Beneficio {
  final String id;
  final String titulo;
  final String detalle;
  final String tipoBeneficio;
  final DateTime fechaCreacion;
  final DateTime fechaVencimiento;

  Beneficio({
    required this.id,
    required this.titulo,
    required this.detalle,
    required this.tipoBeneficio,
    required this.fechaCreacion,
    required this.fechaVencimiento,
  });

  // Convertir a Map para Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'detalle': detalle,
      'tipoBeneficio': tipoBeneficio,
      'fechaCreacion': fechaCreacion.millisecondsSinceEpoch,
      'fechaVencimiento': fechaVencimiento.millisecondsSinceEpoch,
    };
  }

  // Crear desde Map de Firebase
  factory Beneficio.fromMap(Map<String, dynamic> map, String documentId) {
    return Beneficio(
      id: documentId,
      titulo: map['titulo'] ?? '',
      detalle: map['detalle'] ?? '',
      tipoBeneficio: map['tipoBeneficio'] ?? '',
      fechaCreacion: DateTime.fromMillisecondsSinceEpoch(map['fechaCreacion'] ?? 0),
      fechaVencimiento: DateTime.fromMillisecondsSinceEpoch(map['fechaVencimiento'] ?? 0),
    );
  }

  // Crear copia con cambios
  Beneficio copyWith({
    String? id,
    String? titulo,
    String? detalle,
    String? tipoBeneficio,
    DateTime? fechaCreacion,
    DateTime? fechaVencimiento,
  }) {
    return Beneficio(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      detalle: detalle ?? this.detalle,
      tipoBeneficio: tipoBeneficio ?? this.tipoBeneficio,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaVencimiento: fechaVencimiento ?? this.fechaVencimiento,
    );
  }

  // Verificar si el beneficio está vencido
  bool get estaVencido => DateTime.now().isAfter(fechaVencimiento);

  // Verificar si el beneficio está próximo a vencer (7 días)
  bool get proximoAVencer {
    final ahora = DateTime.now();
    final diferencia = fechaVencimiento.difference(ahora);
    return diferencia.inDays <= 7 && diferencia.inDays > 0;
  }

  // Verificar si el beneficio está activo
  bool get estaActivo => !estaVencido;

  @override
  String toString() {
    return 'Beneficio(id: $id, titulo: $titulo, tipoBeneficio: $tipoBeneficio, fechaVencimiento: $fechaVencimiento)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Beneficio && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
