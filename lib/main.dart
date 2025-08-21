import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
//Importación de archivos firebase
import 'package:socio_app/firebase_options.dart';
//Importación de bindings
import 'package:socio_app/src/data/bindings/app_binding.dart';
//Importaciónde de rutas
import 'src/routes/app_route.dart';

void main() async {
  //WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  //FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Inicializar Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Soy Socio',
      initialRoute: '/login',
      getPages: AppRoute.routes,
      initialBinding: AppBinding(),
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),

      // Configuración de localizaciones
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('es', 'ES'), // Español de España
        const Locale('es', 'MX'), // Español de México
        const Locale('es', 'AR'), // Español de Argentina
        const Locale('en', 'US'), // Inglés como respaldo
      ],
      locale: const Locale('es', 'ES'), // Idioma por defecto
    );
  }
}
