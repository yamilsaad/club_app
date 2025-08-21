// lib/app_binding.dart
import 'package:get/get.dart';
//Importación de controladores
import 'package:socio_app/src/presentation/screens/auth_screen/controllers/auth_controller.dart';
import 'package:socio_app/src/presentation/screens/home_screen/controllers/socio_controller.dart';
import 'package:socio_app/src/presentation/screens/pagos_socios_screen/controllers/pagos_controller.dart';
import 'package:socio_app/src/presentation/views/admi_views/controllers/cuota_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    /// Aquí inicializamos todos los controladores que queremos
    /// disponibles durante toda la app.

    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<SocioController>(SocioController(), permanent: true);
    Get.put<PagosController>(PagosController(), permanent: true);
    Get.put<CuotaController>(CuotaController(), permanent: true);

    /// Cuando tengas más controladores, los agregamos aquí:
    /// Get.put<EventoController>(EventoController(), permanent: true);
    /// Get.put<WeatherController>(WeatherController(), permanent: true);
  }
}
