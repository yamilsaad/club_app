import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class CuotaController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Rx para el monto de la cuota actual
  var cuotaActual = 0.0.obs;
  var moneda = "ARS".obs;
  var observaciones = "".obs;

  // Leer la última configuración de cuota
  Future<void> fetchCuotaActual() async {
    var snapshot =
        await _db
            .collection("configuracion")
            .orderBy("fechaInicio", descending: true)
            .limit(1)
            .get();

    if (snapshot.docs.isNotEmpty) {
      var data = snapshot.docs.first.data();
      cuotaActual.value = data["montoCuota"]?.toDouble() ?? 0.0;
      moneda.value = data["moneda"] ?? "ARS";
      observaciones.value = data["observaciones"] ?? "";
    }
  }

  // Registrar nueva cuota
  Future<void> registrarNuevaCuota({
    required double monto,
    String moneda = "ARS",
    String observaciones = "",
    required String adminUid,
  }) async {
    await _db.collection("configuracion").add({
      "montoCuota": monto,
      "moneda": moneda,
      "fechaInicio": DateTime.now().toIso8601String(),
      "observaciones": observaciones,
      "creadoEn": DateTime.now().toIso8601String(),
      "creadoPor": adminUid,
    });

    await fetchCuotaActual();
  }
}
