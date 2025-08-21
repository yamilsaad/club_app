import 'package:flutter/material.dart';

class CuotasSocioWidget extends StatelessWidget {
  const CuotasSocioWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      width: screenWidth * 0.98,
      height: screenHeight * 0.25,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            child: ListTile(
              title: Text('Cuota 1'),
              subtitle: Text('Fecha de pago: 01/01/2023'),
              trailing: Icon(Icons.check_circle, color: Colors.green),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Cuota 2'),
              subtitle: Text('Fecha de pago: 15/02/2023'),
              trailing: Icon(Icons.check_circle, color: Colors.green),
            ),
          ),
          // Agregar más cuotas según sea necesario
        ],
      ),
    );
  }
}
