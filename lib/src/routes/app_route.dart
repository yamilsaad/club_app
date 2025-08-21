import 'package:get/get.dart';
//Importación de archivos necesarios
import '../presentation/screens/screen.dart';

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
  ];
}
