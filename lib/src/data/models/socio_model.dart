import 'package:cloud_firestore/cloud_firestore.dart';

class SocioModel {
  String? idUsuario; // ID del documento en la colección "usuarios"
  String nombre;
  String apellido;
  String email;
  String dni;
  String telefono;
  String direccion;
  String rol; // "admin" o "socio"
  DateTime fechaCreacion;
  final String numeroSocio; // nuevo
  final bool estadoSocio; // nuevo
  final String oficio; // nuevo

  SocioModel({
    this.idUsuario,
    required this.nombre,
    required this.apellido,
    required this.email,
    required this.dni,
    required this.telefono,
    required this.direccion,
    required this.rol,
    required this.numeroSocio,
    required this.estadoSocio,
    required this.oficio,
    DateTime? fechaCreacion,
  }) : fechaCreacion = fechaCreacion ?? DateTime.now();

  /// Convertir de Firestore a modelo
  factory SocioModel.fromMap(Map<String, dynamic> map, String documentId) {
    return SocioModel(
      idUsuario: documentId,
      nombre: map['nombre'] ?? '',
      apellido: map['apellido'] ?? '',
      email: map['email'] ?? '',
      dni: map['dni'] ?? '',
      telefono: map['telefono'] ?? '',
      direccion: map['direccion'] ?? '',
      rol: map['rol'] ?? 'socio',
      numeroSocio: map["numeroSocio"] ?? "",
      estadoSocio: map["estado_socio"] ?? true,
      oficio: map["oficio"] ?? "",
      fechaCreacion: (map['fechaCreacion'] as Timestamp).toDate(),
    );
  }

  /// Convertir modelo a Map para guardar en Firestore
  Map<String, dynamic> toMap() {
    return {
      'id_usuario': idUsuario,
      'nombre': nombre,
      'apellido': apellido,
      'email': email,
      'dni': dni,
      'telefono': telefono,
      'direccion': direccion,
      'rol': rol,
      "numeroSocio": numeroSocio,
      "estado_socio": estadoSocio,
      "oficio": oficio,
      'fechaCreacion': fechaCreacion,
    };
  }
}
