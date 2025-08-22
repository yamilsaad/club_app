import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../../data/models/beneficio_model.dart';

class BeneficiosController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'beneficios';

  // Observables
  final RxList<Beneficio> _beneficios = <Beneficio>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;

  // Getters
  List<Beneficio> get beneficios => _beneficios;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;

  // Beneficios activos (no vencidos)
  List<Beneficio> get beneficiosActivos => 
      _beneficios.where((beneficio) => beneficio.estaActivo).toList();

  // Beneficios vencidos
  List<Beneficio> get beneficiosVencidos => 
      _beneficios.where((beneficio) => beneficio.estaVencido).toList();

  // Beneficios próximos a vencer
  List<Beneficio> get beneficiosProximosAVencer => 
      _beneficios.where((beneficio) => beneficio.proximoAVencer).toList();

  // Beneficios por tipo
  List<Beneficio> getBeneficiosPorTipo(String tipo) =>
      _beneficios.where((beneficio) => beneficio.tipoBeneficio == tipo).toList();

  @override
  void onInit() {
    super.onInit();
    cargarBeneficios();
  }

  // Cargar todos los beneficios desde Firebase
  Future<void> cargarBeneficios() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      final QuerySnapshot snapshot = await _firestore
          .collection(_collectionName)
          .orderBy('fechaCreacion', descending: true)
          .get();

      final List<Beneficio> beneficios = snapshot.docs.map((doc) {
        return Beneficio.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      _beneficios.assignAll(beneficios);
    } catch (e) {
      _errorMessage.value = 'Error al cargar beneficios: $e';
      print('Error al cargar beneficios: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  // Crear nuevo beneficio
  Future<bool> crearBeneficio(Beneficio beneficio) async {
    try {
      // Verificar límite de 5 beneficios
      if (_beneficios.length >= 5) {
        _errorMessage.value = 'No se pueden crear más de 5 beneficios. Elimina uno antes de crear uno nuevo.';
        return false;
      }

      _isLoading.value = true;
      _errorMessage.value = '';

      // Crear documento en Firebase
      final DocumentReference docRef = await _firestore
          .collection(_collectionName)
          .add(beneficio.toMap());

      // Crear beneficio con ID generado
      final Beneficio beneficioCreado = beneficio.copyWith(id: docRef.id);
      
      // Agregar a la lista local
      _beneficios.insert(0, beneficioCreado);

      Get.snackbar(
        'Éxito',
        'Beneficio creado correctamente',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.primaryColor,
        colorText: Get.theme.primaryColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,
      );

      return true;
    } catch (e) {
      _errorMessage.value = 'Error al crear beneficio: $e';
      print('Error al crear beneficio: $e');
      
      Get.snackbar(
        'Error',
        'No se pudo crear el beneficio',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  // Actualizar beneficio existente
  Future<bool> actualizarBeneficio(Beneficio beneficio) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      // Actualizar en Firebase
      await _firestore
          .collection(_collectionName)
          .doc(beneficio.id)
          .update(beneficio.toMap());

      // Actualizar en la lista local
      final int index = _beneficios.indexWhere((b) => b.id == beneficio.id);
      if (index != -1) {
        _beneficios[index] = beneficio;
        _beneficios.refresh();
      }

      Get.snackbar(
        'Éxito',
        'Beneficio actualizado correctamente',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.primaryColor,
        colorText: Get.theme.primaryColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,
      );

      return true;
    } catch (e) {
      _errorMessage.value = 'Error al actualizar beneficio: $e';
      print('Error al actualizar beneficio: $e');
      
      Get.snackbar(
        'Error',
        'No se pudo actualizar el beneficio',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  // Eliminar beneficio
  Future<bool> eliminarBeneficio(String id) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      // Eliminar de Firebase
      await _firestore
          .collection(_collectionName)
          .doc(id)
          .delete();

      // Eliminar de la lista local
      _beneficios.removeWhere((beneficio) => beneficio.id == id);

      Get.snackbar(
        'Éxito',
        'Beneficio eliminado correctamente',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.primaryColor,
        colorText: Get.theme.primaryColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,
      );

      return true;
    } catch (e) {
      _errorMessage.value = 'Error al eliminar beneficio: $e';
      print('Error al eliminar beneficio: $e');
      
      Get.snackbar(
        'Error',
        'No se pudo eliminar el beneficio',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  // Obtener beneficio por ID
  Beneficio? obtenerBeneficioPorId(String id) {
    try {
      return _beneficios.firstWhere((beneficio) => beneficio.id == id);
    } catch (e) {
      return null;
    }
  }

  // Verificar si se puede crear más beneficios
  bool get puedeCrearBeneficio => _beneficios.length < 5;

  // Obtener cantidad de beneficios
  int get cantidadBeneficios => _beneficios.length;

  // Limpiar mensajes de error
  void limpiarError() {
    _errorMessage.value = '';
  }

  // Refrescar datos
  Future<void> refrescarDatos() async {
    await cargarBeneficios();
  }
}
