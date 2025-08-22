// lib/controllers/socio_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
//Importaciones de archivos necesarios
import '../../../../data/models/model.dart';

class SocioController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Lista reactiva de socios
  RxList<SocioModel> sociosList = <SocioModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchSocios(); // Cargar socios cuando se inicia el controlador
  }

  /// ===========================
  /// Crear un nuevo socio
  /// ===========================
  Future<void> addSocio(SocioModel socio) async {
    try {
      DocumentReference docRef = await _firestore
          .collection('usuarios')
          .add(socio.toMap());
      // Guardar el id del documento generado
      socio.idUsuario = docRef.id;
      sociosList.add(socio);
      Get.snackbar("Éxito", "Socio agregado correctamente");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  /// ===========================
  /// Traer todos los socios
  /// ===========================
  void fetchSocios() {
    _firestore.collection('usuarios').snapshots().listen((snapshot) {
      sociosList.clear();
      for (var doc in snapshot.docs) {
        SocioModel socio = SocioModel.fromMap(doc.data(), doc.id);
        sociosList.add(socio);
      }
    });
  }

  /// ===========================
  /// Buscar socio por DNI
  /// ===========================
  SocioModel? getSocioByDni(String dni) {
    try {
      return sociosList.firstWhere((socio) => socio.dni == dni);
    } catch (e) {
      return null;
    }
  }

  /// ===========================
  /// Actualizar un socio
  /// ===========================
  Future<void> updateSocio(SocioModel socio) async {
    if (socio.idUsuario == null) return;
    try {
      await _firestore
          .collection('usuarios')
          .doc(socio.idUsuario)
          .update(socio.toMap());
      int index = sociosList.indexWhere((s) => s.idUsuario == socio.idUsuario);
      if (index != -1) sociosList[index] = socio;
      Get.snackbar("Éxito", "Socio actualizado correctamente");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  /// ===========================
  /// Eliminar un socio
  /// ===========================
  Future<void> deleteSocio(String idUsuario) async {
    try {
      await _firestore.collection('usuarios').doc(idUsuario).delete();
      sociosList.removeWhere((s) => s.idUsuario == idUsuario);
      Get.snackbar("Éxito", "Socio eliminado");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  /// ===========================
  /// Actualizar un socio (alias para updateSocio)
  /// ===========================
  Future<bool> actualizarSocio(SocioModel socio) async {
    try {
      await updateSocio(socio);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// ===========================
  /// Eliminar un socio (alias para deleteSocio)
  /// ===========================
  Future<bool> eliminarSocio(String idUsuario) async {
    try {
      await deleteSocio(idUsuario);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// ===========================
  /// Cambiar estado del socio (activo/inactivo)
  /// ===========================
  Future<bool> actualizarEstadoSocio(String idUsuario, bool nuevoEstado) async {
    try {
      await _firestore
          .collection('usuarios')
          .doc(idUsuario)
          .update({'estado_socio': nuevoEstado});
      
      // Actualizar en la lista local
      int index = sociosList.indexWhere((s) => s.idUsuario == idUsuario);
      if (index != -1) {
        sociosList[index] = sociosList[index].copyWith(estadoSocio: nuevoEstado);
      }
      
      Get.snackbar(
        "Éxito", 
        "Estado del socio actualizado correctamente",
        backgroundColor: nuevoEstado ? Colors.green : Colors.orange,
        colorText: Colors.white,
      );
      return true;
    } catch (e) {
      Get.snackbar("Error", "No se pudo actualizar el estado: $e");
      return false;
    }
  }
}
