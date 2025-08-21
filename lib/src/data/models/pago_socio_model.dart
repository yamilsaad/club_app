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
