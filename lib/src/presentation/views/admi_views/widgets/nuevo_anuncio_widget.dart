import 'package:flutter/material.dart';
import 'package:socio_app/src/presentation/views/admi_views/widgets/common_widget.dart';

class NuevoAnuncioSection extends StatelessWidget {
  const NuevoAnuncioSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 2.5),
      child: ExpansionTile(
        leading: const Icon(Icons.campaign),
        title: const Text("Crear Anuncio Importante"),
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                buildTextField("Título"),
                buildTextField("Detalle"),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: "Nivel de Importancia",
                  ),
                  items: const [
                    DropdownMenuItem(value: "Alta", child: Text("Alta")),
                    DropdownMenuItem(value: "Media", child: Text("Media")),
                    DropdownMenuItem(value: "Baja", child: Text("Baja")),
                  ],
                  onChanged: (value) {},
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Guardar Anuncio"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
