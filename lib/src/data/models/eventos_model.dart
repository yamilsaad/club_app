class Evento {
  final String id;
  final String titulo;
  final String detalle;
  final DateTime fecha;
  final String urlImagen;
  final String tipoEvento; // "destacado" o "programado"
  final DateTime fechaCreacion;
  final String creadoPor; // ID del usuario que lo creó

  Evento({
    required this.id,
    required this.titulo,
    required this.detalle,
    required this.fecha,
    required this.urlImagen,
    required this.tipoEvento,
    required this.fechaCreacion,
    required this.creadoPor,
  });

  // Validaciones
  static bool esTipoValido(String tipo) {
    return tipo == 'destacado' || tipo == 'programado';
  }

  static int obtenerLimiteMaximo(String tipo) {
    switch (tipo) {
      case 'destacado':
        return 3;
      case 'programado':
        return 24;
      default:
        return 0;
    }
  }

  // Convertir a JSON para Firebase
  Map<String, dynamic> toJson() => {
    'titulo': titulo,
    'detalle': detalle,
    'fecha': fecha.toIso8601String(),
    'urlImagen': urlImagen,
    'tipoEvento': tipoEvento,
    'fechaCreacion': fechaCreacion.toIso8601String(),
    'creadoPor': creadoPor,
  };

  // Crear desde JSON de Firebase
  factory Evento.fromJson(Map<String, dynamic> json, String id) => Evento(
    id: id,
    titulo: json['titulo'] ?? '',
    detalle: json['detalle'] ?? '',
    fecha: DateTime.parse(json['fecha']),
    urlImagen: json['urlImagen'] ?? '',
    tipoEvento: json['tipoEvento'] ?? 'programado',
    fechaCreacion: DateTime.parse(json['fechaCreacion']),
    creadoPor: json['creadoPor'] ?? '',
  );

  // Crear copia con cambios
  Evento copyWith({
    String? id,
    String? titulo,
    String? detalle,
    DateTime? fecha,
    String? urlImagen,
    String? tipoEvento,
    DateTime? fechaCreacion,
    String? creadoPor,
  }) {
    return Evento(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      detalle: detalle ?? this.detalle,
      fecha: fecha ?? this.fecha,
      urlImagen: urlImagen ?? this.urlImagen,
      tipoEvento: tipoEvento ?? this.tipoEvento,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      creadoPor: creadoPor ?? this.creadoPor,
    );
  }

  // Validar que el evento sea válido
  bool esValido() {
    return titulo.isNotEmpty && 
           detalle.isNotEmpty && 
           urlImagen.isNotEmpty && 
           esTipoValido(tipoEvento);
  }

  // Obtener el límite máximo para este tipo de evento
  int get limiteMaximo => obtenerLimiteMaximo(tipoEvento);

  // Verificar si es un evento destacado
  bool get esDestacado => tipoEvento == 'destacado';

  // Verificar si es un evento programado
  bool get esProgramado => tipoEvento == 'programado';
}
