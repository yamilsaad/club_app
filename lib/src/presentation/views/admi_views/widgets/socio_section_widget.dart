import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class SociosSectionWidget extends StatelessWidget {
  const SociosSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 2.5),
      child: ExpansionTile(
        leading: const Icon(Icons.group),
        title: const Text("Lista de Socios"),
        children: [
          ListTile(
            title: const Text("Juan Pérez"),
            subtitle: const Text("Activo - Cuota al día"),
            trailing: ElevatedButton(
              onPressed: () {
                Get.toNamed(
                  '/socio-detalle',
                  arguments: {'id': '1', 'name': 'Juan Pérez'},
                );
              },
              child: const Text("Ver Detalle"),
            ),
          ),
        ],
      ),
    );
  }
}
