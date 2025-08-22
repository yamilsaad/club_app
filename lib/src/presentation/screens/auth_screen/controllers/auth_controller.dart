import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../../data/models/model.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Rx<User?> firebaseUser = Rx<User?>(null);

  // ⚡ Nuevo: Usuario logueado con todos los datos del socio
  Rx<SocioModel?> currentUser = Rx<SocioModel?>(null);

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges());

    // Si firebaseUser cambia, actualizar currentUser
    ever(firebaseUser, (User? user) {
      if (user != null) {
        loadCurrentUser(user.uid);
      } else {
        currentUser.value = null;
      }
    });
  }

  /// ====================
  /// Cargar datos de socio desde Firestore
  /// ====================
  Future<void> loadCurrentUser(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection("usuarios").doc(uid).get();
      if (userDoc.exists) {
        currentUser.value = SocioModel.fromMap(
          userDoc.data() as Map<String, dynamic>,
          userDoc.id,
        );
      }
    } catch (e) {
      Get.snackbar("Error", "No se pudo cargar el usuario: $e");
    }
  }

  /// ====================
  /// Registro
  /// ====================
  Future<void> registerUser({
    required String nombre,
    required String apellido,
    required String dni,
    required String domicilio,
    required String oficio,
    required String numeroSocio,
    required String email,
    required String telefono,
    required String rol,
    required String password,
  }) async {
    try {
      // Guardar el usuario actual (admin) antes de crear el nuevo
      final adminUser = currentUser.value;
      final adminEmail = adminUser?.email;
      
      // Crear la cuenta en Firebase Auth
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = cred.user!.uid;

      // Crear el modelo del socio
      SocioModel newSocio = SocioModel(
        idUsuario: uid,
        nombre: nombre,
        apellido: apellido,
        dni: dni,
        email: email,
        telefono: telefono,
        direccion: domicilio,
        rol: rol,
        fechaCreacion: DateTime.now(),
        numeroSocio: numeroSocio,
        estadoSocio: true,
        oficio: oficio,
      );

      // Guardar en Firestore (incluyendo la contraseña para poder restaurar sesión)
      final socioData = newSocio.toMap();
      socioData['password'] = password; // Agregar contraseña
      await _firestore.collection("usuarios").doc(uid).set(socioData);

      // Cerrar sesión del nuevo usuario creado
      await _auth.signOut();

      // Restaurar la sesión del admin usando su email original
      if (adminEmail != null) {
        // Buscar la contraseña del admin en Firestore
        final adminDoc = await _firestore
            .collection("usuarios")
            .where("email", isEqualTo: adminEmail)
            .where("rol", isEqualTo: "admin")
            .get();
        
        if (adminDoc.docs.isNotEmpty) {
          final adminData = adminDoc.docs.first.data();
          final adminPassword = adminData['password'] ?? '';
          
          if (adminPassword.isNotEmpty) {
            await _auth.signInWithEmailAndPassword(
              email: adminEmail,
              password: adminPassword,
            );
          }
        }
      }

      Get.snackbar("Éxito", "Usuario registrado correctamente");
    } catch (e) {
      Get.snackbar("Error en registro", e.toString());
    }
  }

  /// ====================
  /// Login
  /// ====================
  Future<bool> loginUser({
    required String email,
    required String dni,
    required String password,
  }) async {
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot userDoc =
          await _firestore.collection("usuarios").doc(cred.user!.uid).get();

      if (userDoc.exists && userDoc["dni"] == dni) {
        currentUser.value = SocioModel.fromMap(
          userDoc.data() as Map<String, dynamic>,
          userDoc.id,
        );
        Get.snackbar("Bienvenido", "Ingreso correcto");
        return true; // Login exitoso
      } else {
        await _auth.signOut();
        Get.snackbar("Error", "El DNI no coincide con el usuario");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error en login", e.toString());
      return false;
    }
  }

  /// ====================
  /// Logout
  /// ====================
  Future<void> signOut() async {
    await _auth.signOut();
    currentUser.value = null;
  }
}
