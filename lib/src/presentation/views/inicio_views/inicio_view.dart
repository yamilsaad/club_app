import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
//Importación de archivos necesarios
import 'widgets/widget.dart';
import 'package:socio_app/src/presentation/screens/auth_screen/controllers/auth_controller.dart';

class InicioView extends StatelessWidget {
  const InicioView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    // Obtener el controlador de autenticación
    final AuthController authController = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          final user = authController.currentUser.value;
          return Text("Hola, ${user?.nombre ?? 'Socio'}");
        }),
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.bell),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.02),
              TitleCard(screenWidth: screenWidth),
              SizedBox(height: screenHeight * 0.02),
              CardSocioWidget(),
              SizedBox(height: screenHeight * 0.02),
              TitleCard2(screenWidth: screenWidth),
              CardAnuncioWidget(),
              SizedBox(height: screenHeight * 0.02),
              TitleCard3(screenWidth: screenWidth),
              CuotasSocioWidget(),
              SizedBox(height: screenHeight * 0.02),
              TitleCard4(screenWidth: screenWidth),
              MisPagosCard(),
              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        ),
      ),
      drawer: DrawerWidget(),
    );
  }
}

class TitleCard extends StatelessWidget {
  const TitleCard({super.key, required this.screenWidth});

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: Text(
            "Mi Tarjeta de Socio",
            style: TextStyle(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class TitleCard2 extends StatelessWidget {
  const TitleCard2({super.key, required this.screenWidth});

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: Text(
            "Anuncio Importantes",
            style: TextStyle(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class TitleCard3 extends StatelessWidget {
  const TitleCard3({super.key, required this.screenWidth});

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: Text(
            "Mis Cuotas",
            style: TextStyle(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class TitleCard4 extends StatelessWidget {
  const TitleCard4({super.key, required this.screenWidth});

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 25.0),
          child: Text(
            "Mis Pagos de Cuotas",
            style: TextStyle(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class MisPagosCard extends StatelessWidget {
  const MisPagosCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: InkWell(
        onTap: () {
          Get.toNamed('/mis-pagos');
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.indigo.shade100, Colors.indigo.shade50],
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.payment,
                  size: 32,
                  color: Colors.indigo.shade700,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Ver Estado de Mis Pagos",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Consulta tu historial de pagos, cuotas pendientes y estado de cuenta",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.indigo.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.indigo.shade400),
            ],
          ),
        ),
      ),
    );
  }
}
