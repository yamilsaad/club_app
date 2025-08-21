import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/widget.dart';

class AdminView extends StatelessWidget {
  const AdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Administración")),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          const SociosSectionWidget(),
          const SizedBox(height: 10),
          const NuevoSocioSection(),
          const SizedBox(height: 10),
          const NuevoEventoSection(),
          const SizedBox(height: 10),
          const NuevoAnuncioSection(),
          const SizedBox(height: 10),
          const NuevoBeneficioSection(),
          const SizedBox(height: 10),
          const GestionCuotaSection(),
          const SizedBox(height: 10),
          DashboardPagosSection(),
        ],
      ),
    );
  }
}

class DashboardPagosSection extends StatelessWidget {
  const DashboardPagosSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.analytics,
                  color: Colors.deepPurple.shade700,
                  size: 28,
                ),
                const SizedBox(width: 12),
                const Text(
                  "Dashboard de Pagos",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              "Gestiona y monitorea el estado de pagos de todos los socios",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.toNamed('/admin-dashboard');
                },
                icon: const Icon(Icons.dashboard),
                label: const Text("Abrir Dashboard"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
