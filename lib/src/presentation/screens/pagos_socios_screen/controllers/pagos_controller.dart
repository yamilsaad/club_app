// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class PagosController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Observables
  var pagos = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  /// Registrar un nuevo pago
  Future<void> registrarPago({
    required String socioId,
    required String numeroSocio,
    required double monto,
    required String mesCorrespondiente,
    required String metodoPago,
  }) async {
    try {
      await _db.collection('pagos').add({
        'socioId': socioId,
        'numeroSocio': numeroSocio,
        'monto': monto,
        'fechaPago': FieldValue.serverTimestamp(),
        'mesCorrespondiente': mesCorrespondiente,
        'estado': 'pagado',
        'metodoPago': metodoPago,
      });
    } catch (e) {
      print("Error registrando pago: $e");
      rethrow;
    }
  }

  /// Obtener todos los pagos de un socio
  Future<void> obtenerPagosPorSocio(String socioId) async {
    try {
      isLoading.value = true;
      final snapshot =
          await _db
              .collection('pagos')
              .where('socioId', isEqualTo: socioId)
              .orderBy('fechaPago', descending: true)
              .get();

      pagos.value =
          snapshot.docs.map((doc) {
            return {'id': doc.id, ...doc.data()};
          }).toList();
    } catch (e) {
      print("Error obteniendo pagos: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Obtener todos los pagos (para admin)
  Future<void> obtenerTodosLosPagos() async {
    try {
      isLoading.value = true;
      final snapshot =
          await _db
              .collection('pagos')
              .orderBy('fechaPago', descending: true)
              .get();

      pagos.value =
          snapshot.docs.map((doc) {
            return {'id': doc.id, ...doc.data()};
          }).toList();
    } catch (e) {
      print("Error obteniendo todos los pagos: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
