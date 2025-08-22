// lib/app_binding.dart
import 'package:get/get.dart';
//Importación de controladores
import 'package:socio_app/src/presentation/screens/auth_screen/controllers/auth_controller.dart';
import 'package:socio_app/src/presentation/screens/home_screen/controllers/socio_controller.dart';
import 'package:socio_app/src/presentation/screens/configuracion_cuota_screen/controllers/configuracion_cuota_controller.dart';
import 'package:socio_app/src/presentation/screens/configuracion_cuota_screen/controllers/pago_cuota_controller.dart';
import 'package:socio_app/src/presentation/views/eventos_views/controllers/eventos_controller.dart';
import 'package:socio_app/src/presentation/views/beneficios_views/controllers/beneficios_controller.dart';

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
    Get.put<PagoCuotaController>(PagoCuotaController(), permanent: true);
    Get.put<EventosController>(EventosController(), permanent: true);
    Get.put<BeneficiosController>(BeneficiosController(), permanent: true);
  }
}
