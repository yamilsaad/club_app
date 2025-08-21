import 'package:flutter/material.dart';

import 'widgets/widget.dart';

class AdminView extends StatelessWidget {
  const AdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Administración")),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: const [
          SociosSectionWidget(),
          SizedBox(height: 10),
          NuevoSocioSection(),
          SizedBox(height: 10),
          NuevoEventoSection(),
          SizedBox(height: 10),
          NuevoAnuncioSection(),
          SizedBox(height: 10),
          NuevoBeneficioSection(),
        ],
      ),
    );
  }
}
