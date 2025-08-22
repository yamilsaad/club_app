import 'package:get/get.dart';
//Importación de archivos necesarios
import '../presentation/screens/screen.dart';
import '../presentation/screens/mis_pagos_screen/mis_pagos_screen.dart';
import '../presentation/screens/admin_dashboard_screen/admin_dashboard_screen.dart';
import '../presentation/views/eventos_views/eventos_view.dart';
import '../presentation/views/eventos_views/eventos_programados_view.dart';

class AppRoute {
  /* static Future<bool> _seenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('seenOnboarding') ?? false;
  }*/
  static List<GetPage> get routes => [
    /*GetPage(
          name: '/',
          page: () => FutureBuilder<bool>(
            future: _seenOnboarding(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (snapshot.data ?? false) {
                  return const LoginScreen();
                } else {
                  return const OnBoardingScreen();
                }
              }
            },
          ),
        ),*/
    GetPage(name: '/login', page: () => LoginScreen()),
    GetPage(name: '/register', page: () => RegisterScreen()),
    GetPage(name: '/home', page: () => const HomeScreen()),
    GetPage(name: '/socio-detalle', page: () => SocioDetalleScreen()),
    GetPage(
      name: '/configuracion-cuenta',
      page: () => ConfiguracionCuotaScreen(),
    ),
    GetPage(name: '/mis-pagos', page: () => const MisPagosScreen()),
    GetPage(name: '/admin-dashboard', page: () => const AdminDashboardScreen()),
    GetPage(name: '/eventos', page: () => const EventosView()),
    GetPage(name: '/eventos-programados', page: () => const EventosProgramadosView()),
  ];
}
