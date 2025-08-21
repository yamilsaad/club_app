class CuotaMensual {
  final String id;
  final int mes; // 1 = Enero, 2 = Febrero, ...
  final double monto;
  final DateTime fechaVencimiento;
  final double? recargo; // opcional
  final String? notas;

  CuotaMensual({
    required this.id,
    required this.mes,
    required this.monto,
    required this.fechaVencimiento,
    this.recargo,
    this.notas,
  });

  Map<String, dynamic> toJson() => {
    "mes": mes,
    "monto": monto,
    "fechaVencimiento": fechaVencimiento.toIso8601String(),
    "recargo": recargo,
    "notas": notas,
  };

  factory CuotaMensual.fromJson(Map<String, dynamic> json, String id) =>
      CuotaMensual(
        id: id,
        mes: json["mes"],
        monto: (json["monto"] ?? 0).toDouble(),
        fechaVencimiento: DateTime.parse(json["fechaVencimiento"]),
        recargo:
            json["recargo"] != null
                ? (json["recargo"] as num).toDouble()
                : null,
        notas: json["notas"],
      );
}
