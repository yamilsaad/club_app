import 'package:flutter/material.dart';
import 'package:socio_app/src/presentation/views/admi_views/widgets/common_widget.dart';

class NuevoBeneficioSection extends StatelessWidget {
  const NuevoBeneficioSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 2.5),
      child: ExpansionTile(
        leading: const Icon(Icons.card_giftcard),
        title: const Text("Crear Beneficio para Socios"),
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                buildTextField("Nombre del Beneficio"),
                buildTextField("Detalle del Beneficio"),
                buildTextField("Imagen del Beneficio (URL)"),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Guardar Beneficio"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
