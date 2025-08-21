import 'package:flutter/material.dart';

class SocioDetalleScreen extends StatelessWidget {
  const SocioDetalleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: const Text("Detalle del Socio")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Información del Socio"),
              SizedBox(height: screenHeight * 0.02),
              Text("Nombre: Juan Pérez"),
              Text("ID de Socio: 123456"),
              Text("Estado: Activo"),
              SizedBox(height: screenHeight * 0.02),
              ElevatedButton(
                onPressed: () {
                  // Acción al presionar el botón
                },
                child: const Text("Editar Información"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
