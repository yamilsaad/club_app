import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  final emailController = TextEditingController();
  final dniController = TextEditingController();
  final passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: dniController,
              decoration: const InputDecoration(labelText: "DNI"),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                bool success = await authController.loginUser(
                  email: emailController.text.trim(),
                  dni: dniController.text.trim(),
                  password: passwordController.text.trim(),
                );

                if (success) {
                  Get.offNamed('/home'); // Redirige al HomeScreen
                }
              },
              child: const Text("Ingresar"),
            ),
          ],
        ),
      ),
    );
  }
}
