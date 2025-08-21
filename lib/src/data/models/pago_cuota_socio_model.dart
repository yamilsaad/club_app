class PagoCuotaSocio {
  final String id;
  final String socioId; // ID del socio que pago
  final String cuotaId; // ID de la cuota mensual
  final int mes; // Mes al que corresponde (1-12)
  final int anio; // Anio de la cuota
  final double montoPagado; // Monto que realmente pago
  final DateTime fechaPago; // Cuando pago
  final String metodoPago; // Efectivo, transferencia, etc.
  final String? notas; // Notas adicionales
  final bool pagoCompleto; // Si pago el monto completo o parcial

  // Campos de relacion para facilitar consultas
  final String nombreSocio; // Nombre completo del socio
  final String numeroSocio; // Numero de socio
  final double montoCuota; // Monto que debia pagar segun la cuota
  final DateTime fechaVencimiento; // Fecha de vencimiento de la cuota

  PagoCuotaSocio({
    required this.id,
    required this.socioId,
    required this.cuotaId,
    required this.mes,
    required this.anio,
    required this.montoPagado,
    required this.fechaPago,
    required this.metodoPago,
    this.notas,
    required this.pagoCompleto,
    required this.nombreSocio,
    required this.numeroSocio,
    required this.montoCuota,
    required this.fechaVencimiento,
  });

  /// Convertir a JSON para guardar en Firestore
  Map<String, dynamic> toJson() {
    return {
      "socioId": socioId,
      "cuotaId": cuotaId,
      "mes": mes,
      "anio": anio,
      "montoPagado": montoPagado,
      "fechaPago": fechaPago.toIso8601String(),
      "metodoPago": metodoPago,
      "notas": notas,
      "pagoCompleto": pagoCompleto,
      "nombreSocio": nombreSocio,
      "numeroSocio": numeroSocio,
      "montoCuota": montoCuota,
      "fechaVencimiento": fechaVencimiento.toIso8601String(),
    };
  }

  /// Crear desde JSON de Firestore
  factory PagoCuotaSocio.fromJson(Map<String, dynamic> json, String id) {
    return PagoCuotaSocio(
      id: id,
      socioId: json["socioId"] ?? "",
      cuotaId: json["cuotaId"] ?? "",
      mes: json["mes"] ?? 1,
      anio: json["anio"] ?? DateTime.now().year,
      montoPagado: (json["montoPagado"] ?? 0).toDouble(),
      fechaPago: DateTime.parse(json["fechaPago"]),
      metodoPago: json["metodoPago"] ?? "Efectivo",
      notas: json["notas"],
      pagoCompleto: json["pagoCompleto"] ?? false,
      nombreSocio: json["nombreSocio"] ?? "",
      numeroSocio: json["numeroSocio"] ?? "",
      montoCuota: (json["montoCuota"] ?? 0).toDouble(),
      fechaVencimiento: DateTime.parse(json["fechaVencimiento"]),
    );
  }

  /// Crear una copia con cambios
  PagoCuotaSocio copyWith({
    String? id,
    String? socioId,
    String? cuotaId,
    int? mes,
    int? anio,
    double? montoPagado,
    DateTime? fechaPago,
    String? metodoPago,
    String? notas,
    bool? pagoCompleto,
    String? nombreSocio,
    String? numeroSocio,
    double? montoCuota,
    DateTime? fechaVencimiento,
  }) {
    return PagoCuotaSocio(
      id: id ?? this.id,
      socioId: socioId ?? this.socioId,
      cuotaId: cuotaId ?? this.cuotaId,
      mes: mes ?? this.mes,
      anio: anio ?? this.anio,
      montoPagado: montoPagado ?? this.montoPagado,
      fechaPago: fechaPago ?? this.fechaPago,
      metodoPago: metodoPago ?? this.metodoPago,
      notas: notas ?? this.notas,
      pagoCompleto: pagoCompleto ?? this.pagoCompleto,
      nombreSocio: nombreSocio ?? this.nombreSocio,
      numeroSocio: numeroSocio ?? this.numeroSocio,
      montoCuota: montoCuota ?? this.montoCuota,
      fechaVencimiento: fechaVencimiento ?? this.fechaVencimiento,
    );
  }

  /// Obtener el nombre del mes en espanol
  String get nombreMes {
    switch (mes) {
      case 1:
        return "Enero";
      case 2:
        return "Febrero";
      case 3:
        return "Marzo";
      case 4:
        return "Abril";
      case 5:
        return "Mayo";
      case 6:
        return "Junio";
      case 7:
        return "Julio";
      case 8:
        return "Agosto";
      case 9:
        return "Septiembre";
      case 10:
        return "Octubre";
      case 11:
        return "Noviembre";
      case 12:
        return "Diciembre";
      default:
        return "Mes desconocido";
    }
  }

  /// Verificar si el pago fue tardio
  bool get pagoTardio {
    return fechaPago.isAfter(fechaVencimiento);
  }

  /// Calcular dias de retraso
  int get diasRetraso {
    if (!pagoTardio) return 0;
    return fechaPago.difference(fechaVencimiento).inDays;
  }

  /// Obtener estado del pago
  String get estadoPago {
    if (pagoTardio) {
      return "Pago tardio (${diasRetraso} dias)";
    } else if (fechaPago.isBefore(fechaVencimiento)) {
      return "Pago anticipado";
    } else {
      return "Pago a tiempo";
    }
  }

  /// Verificar si el pago cubre toda la cuota
  bool get pagoParcial {
    return montoPagado < montoCuota;
  }

  /// Calcular monto pendiente
  double get montoPendiente {
    return (montoCuota - montoPagado).clamp(0, double.infinity);
  }
}
