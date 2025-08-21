import 'package:flutter/material.dart';
import 'package:socio_app/src/presentation/views/admi_views/widgets/common_widget.dart';

class NuevoSocioSection extends StatelessWidget {
  const NuevoSocioSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 2.5),
      child: ExpansionTile(
        leading: const Icon(Icons.person_add),
        title: const Text("Agregar Nuevo Socio"),
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                buildTextField("Nombre y Apellido"),
                buildTextField("DNI"),
                buildTextField("Domicilio"),
                buildTextField("Oficio o Profesión"),
                buildTextField("Número de Socio"),
                buildTextField("Email"),
                buildTextField("Teléfono"),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: "Rol de Socio",
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: "admin", child: Text("Admin")),
                    DropdownMenuItem(value: "socio", child: Text("Socio")),
                  ],
                  onChanged: (value) {
                    // acá podrías guardar el rol en tu controlador/estado
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // acción para guardar en Firebase más adelante
                  },
                  child: const Text("Guardar Socio"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
