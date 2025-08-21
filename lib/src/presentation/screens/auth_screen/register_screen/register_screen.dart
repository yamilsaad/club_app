import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final AuthController authController = Get.put(AuthController());

  // Controladores de campos
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final dniController = TextEditingController();
  final domicilioController = TextEditingController();
  final oficioController = TextEditingController();
  final numeroSocioController = TextEditingController();
  final emailController = TextEditingController();
  final telefonoController = TextEditingController();
  final passwordController = TextEditingController();

  final RxString rolSeleccionado = "socio".obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrar Usuario")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTextField("Nombre", nombreController),
            _buildTextField("Apellido", apellidoController),
            _buildTextField("DNI", dniController),
            _buildTextField("Domicilio", domicilioController),
            _buildTextField("Oficio o Profesión", oficioController),
            _buildTextField("Número de Socio", numeroSocioController),
            _buildTextField("Email", emailController),
            _buildTextField("Teléfono", telefonoController),
            _buildPasswordField("Password", passwordController),

            const SizedBox(height: 10),

            // Dropdown rol
            Obx(
              () => DropdownButtonFormField<String>(
                value: rolSeleccionado.value,
                decoration: const InputDecoration(
                  labelText: "Rol de Socio",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: "admin", child: Text("Admin")),
                  DropdownMenuItem(value: "socio", child: Text("Socio")),
                ],
                onChanged: (value) {
                  if (value != null) {
                    rolSeleccionado.value = value;
                  }
                },
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                authController.registerUser(
                  nombre: nombreController.text.trim(),
                  apellido: apellidoController.text.trim(),
                  dni: dniController.text.trim(),
                  domicilio: domicilioController.text.trim(),
                  oficio: oficioController.text.trim(),
                  numeroSocio: numeroSocioController.text.trim(),
                  email: emailController.text.trim(),
                  telefono: telefonoController.text.trim(),
                  rol: rolSeleccionado.value,
                  password: passwordController.text.trim(),
                );
              },
              child: const Text("Registrar Usuario"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        obscureText: true,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
