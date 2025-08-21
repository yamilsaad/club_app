import 'package:flutter/material.dart';
import 'package:get/get.dart';
//Importaciones de controladores y pantallas

class GestionCuotaSection extends StatelessWidget {
  const GestionCuotaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 2.5),
      child: ExpansionTile(
        title: const Text("Configuración de cuota mensual"),
        leading: const Icon(Icons.monetization_on),

        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Navegamos a la pantalla de configurar cuota
                    Get.toNamed('/configuracion-cuenta');
                  },
                  child: const Text("Configurar cuota mensual"),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ],
      ),
    );
  }
}
