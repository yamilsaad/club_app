import 'package:shared_preferences/shared_preferences.dart';

// Método para guardar el estado del switch
Future<void> saveTrackingStatus(bool status) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isTracking', status);
}

// Método para cargar el estado del switch
Future<bool> loadTrackingStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isTracking') ??
      false; // Retorna 'false' si no se encuentra
}
