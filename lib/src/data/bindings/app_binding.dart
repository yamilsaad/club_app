// lib/app_binding.dart
import 'package:get/get.dart';
//Importación de controladores
import 'package:socio_app/src/presentation/controllers/presentation_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    /// Aquí inicializamos todos los controladores que queremos
    /// disponibles durante toda la app.

    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<SocioController>(SocioController(), permanent: true);
    Get.put<ConfiguracionCuotaController>(
      ConfiguracionCuotaController(),
      permanent: true,
    );
  }
}
