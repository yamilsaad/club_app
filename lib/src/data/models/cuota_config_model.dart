class CuotaConfig {
  final String id;
  final double montoMensual;
  final DateTime fechaVencimiento;
  final String? notas;

  CuotaConfig({
    required this.id,
    required this.montoMensual,
    required this.fechaVencimiento,
    this.notas,
  });

  Map<String, dynamic> toJson() {
    return {
      "montoMensual": montoMensual,
      "fechaVencimiento": fechaVencimiento.toIso8601String(),
      "notas": notas,
    };
  }

  factory CuotaConfig.fromJson(Map<String, dynamic> json, String id) {
    return CuotaConfig(
      id: id,
      montoMensual: (json["montoMensual"] ?? 0).toDouble(),
      fechaVencimiento: DateTime.parse(json["fechaVencimiento"]),
      notas: json["notas"],
    );
  }
}

class PagoSocio {
  final String id;
  final String socioId;
  final double monto;
  final DateTime fechaPago;
  final String? metodo;

  PagoSocio({
    required this.id,
    required this.socioId,
    required this.monto,
    required this.fechaPago,
    this.metodo,
  });

  Map<String, dynamic> toJson() {
    return {
      "socioId": socioId,
      "monto": monto,
      "fechaPago": fechaPago.toIso8601String(),
      "metodo": metodo,
    };
  }

  factory PagoSocio.fromJson(Map<String, dynamic> json, String id) {
    return PagoSocio(
      id: id,
      socioId: json["socioId"],
      monto: (json["monto"] ?? 0).toDouble(),
      fechaPago: DateTime.parse(json["fechaPago"]),
      metodo: json["metodo"],
    );
  }
}
