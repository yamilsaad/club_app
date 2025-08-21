import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socio_app/src/presentation/screens/auth_screen/controllers/auth_controller.dart';

class CardSocioWidget extends StatelessWidget {
  const CardSocioWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final AuthController authController = Get.find();

    return Obx(() {
      final socio = authController.currentUser.value;

      if (socio == null) {
        // Si no hay usuario logueado
        return Card(
          elevation: 3.0,
          child: Container(
            width: screenWidth * 0.9,
            height: screenHeight * 0.25,
            decoration: BoxDecoration(
              color: Colors.indigo.shade50,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: const Center(child: Text("Cargando datos del socio...")),
          ),
        );
      }

      // Mostrar datos del socio logueado
      return Card(
        elevation: 3.0,
        child: Container(
          width: screenWidth * 0.9,
          height: screenHeight * 0.25,
          decoration: BoxDecoration(
            color: Colors.indigo.shade50,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${socio.nombre} ${socio.apellido}',
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text('Número de Socio: ${socio.numeroSocio}'),
                Text('DNI: ${socio.dni}'),
                Text('Email: ${socio.email}'),
                Text('Teléfono: ${socio.telefono}'),
                Text('Rol: ${socio.rol}'),
              ],
            ),
          ),
        ),
      );
    });
  }
}
