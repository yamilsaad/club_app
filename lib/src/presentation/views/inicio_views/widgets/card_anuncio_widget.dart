import 'package:flutter/material.dart';

class CardAnuncioWidget extends StatelessWidget {
  const CardAnuncioWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Card(
      elevation: 3.0,
      child: Container(
        width: screenWidth * 0.9,
        height: screenHeight * 0.15,
        decoration: BoxDecoration(
          color: Colors.indigo.shade50,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Socio Card'),
              const SizedBox(height: 8.0),
              Text('This is a card widget for displaying socio information.'),
            ],
          ),
        ),
      ),
    );
  }
}
