import 'package:flutter/material.dart';
import 'package:socio_app/src/presentation/views/admi_views/widgets/common_widget.dart';

class NuevoEventoSection extends StatelessWidget {
  const NuevoEventoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 2.5),
      child: ExpansionTile(
        leading: const Icon(Icons.event),
        title: const Text("Crear Evento"),
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                buildTextField("Título del Evento"),
                buildTextField("Detalle del Evento"),
                buildTextField("Fecha del Evento"),
                buildTextField("Imagen del Evento (URL)"),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Guardar Evento"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
