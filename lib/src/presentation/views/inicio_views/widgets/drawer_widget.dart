import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:socio_app/src/presentation/screens/auth_screen/controllers/auth_controller.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.indigoAccent),
            child: const Text(
              'Drawer Header',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            title: const Text('Cerrar sesión'),
            onTap: () async {
              // Confirmación antes de cerrar sesión
              bool? confirm = await showDialog<bool>(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text("Confirmar"),
                      content: const Text("¿Seguro que deseas cerrar sesión?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text("Cancelar"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text("Sí"),
                        ),
                      ],
                    ),
              );

              if (confirm ?? false) {
                await authController.signOut();
                Get.offAllNamed(
                  '/login',
                ); // Redirige al login y elimina historial
              }
            },
          ),
          ListTile(
            title: const Text('Item 2'),
            onTap: () {
              // Handle item tap
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
