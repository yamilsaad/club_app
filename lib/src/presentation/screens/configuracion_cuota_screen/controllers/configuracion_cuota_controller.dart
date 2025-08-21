import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
//Importacion de archivos de modelo
import '../../../../data/models/model.dart';

class ConfiguracionCuotaController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  var cuotas = <CuotaMensual>[].obs;
  var pagos = <PagoSocio>[].obs;

  Future<void> loadCuotas() async {
    var snapshot =
        await _db.collection("configuracion_cuota").orderBy("mes").get();
    cuotas.value =
        snapshot.docs
            .map((d) => CuotaMensual.fromJson(d.data(), d.id))
            .toList();
  }

  Future<void> saveCuota(CuotaMensual cuota) async {
    await _db
        .collection("configuracion_cuota")
        .doc(cuota.id)
        .set(cuota.toJson());
    await loadCuotas();
  }

  Future<void> registrarPago(PagoSocio pago) async {
    await _db.collection("pagos").add(pago.toJson());
  }

  Future<void> loadPagosSocio(String socioId) async {
    var snapshot =
        await _db
            .collection("pagos")
            .where("socioId", isEqualTo: socioId)
            .orderBy("fechaPago", descending: true)
            .get();
    pagos.value =
        snapshot.docs.map((d) => PagoSocio.fromJson(d.data(), d.id)).toList();
  }
}
