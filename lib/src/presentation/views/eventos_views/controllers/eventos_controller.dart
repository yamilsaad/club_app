import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:socio_app/src/data/models/eventos_model.dart';

class EventosController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _coleccion = 'eventos';

  // Variables reactivas
  final RxList<Evento> eventos = <Evento>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    cargarEventos();
  }

  // Cargar todos los eventos desde Firebase
  Future<void> cargarEventos() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final QuerySnapshot snapshot = await _firestore
          .collection(_coleccion)
          .orderBy('fecha', descending: false)
          .get();

      final List<Evento> eventosList = snapshot.docs.map((doc) {
        return Evento.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      eventos.value = eventosList;
    } catch (e) {
      errorMessage.value = 'Error al cargar eventos: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Crear un nuevo evento
  Future<bool> crearEvento(Evento evento) async {
    try {
      // Validar límites antes de crear
      if (!_puedeCrearEvento(evento.tipoEvento)) {
        errorMessage.value = 'No se puede crear más eventos de tipo "${evento.tipoEvento}". Límite alcanzado.';
        return false;
      }

      // Validar que el evento sea válido
      if (!evento.esValido()) {
        errorMessage.value = 'Los datos del evento no son válidos.';
        return false;
      }

      isLoading.value = true;
      errorMessage.value = '';

      // Crear el documento en Firebase
      final DocumentReference docRef = await _firestore
          .collection(_coleccion)
          .add(evento.toJson());

      // Agregar el evento a la lista local
      final Evento eventoConId = evento.copyWith(id: docRef.id);
      eventos.add(eventoConId);

      // Ordenar por fecha
      eventos.sort((a, b) => a.fecha.compareTo(b.fecha));

      return true;
    } catch (e) {
      errorMessage.value = 'Error al crear evento: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Actualizar un evento existente
  Future<bool> actualizarEvento(Evento evento) async {
    try {
      // Validar límites si cambió el tipo
      final Evento eventoAnterior = eventos.firstWhere((e) => e.id == evento.id);
      if (eventoAnterior.tipoEvento != evento.tipoEvento) {
        if (!_puedeCrearEvento(evento.tipoEvento)) {
          errorMessage.value = 'No se puede cambiar a tipo "${evento.tipoEvento}". Límite alcanzado.';
          return false;
        }
      }

      // Validar que el evento sea válido
      if (!evento.esValido()) {
        errorMessage.value = 'Los datos del evento no son válidos.';
        return false;
      }

      isLoading.value = true;
      errorMessage.value = '';

      // Actualizar en Firebase
      await _firestore
          .collection(_coleccion)
          .doc(evento.id)
          .update(evento.toJson());

      // Actualizar en la lista local
      final int index = eventos.indexWhere((e) => e.id == evento.id);
      if (index != -1) {
        eventos[index] = evento;
        // Ordenar por fecha
        eventos.sort((a, b) => a.fecha.compareTo(b.fecha));
      }

      return true;
    } catch (e) {
      errorMessage.value = 'Error al actualizar evento: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Eliminar un evento
  Future<bool> eliminarEvento(String eventoId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Eliminar de Firebase
      await _firestore
          .collection(_coleccion)
          .doc(eventoId)
          .delete();

      // Eliminar de la lista local
      eventos.removeWhere((e) => e.id == eventoId);

      return true;
    } catch (e) {
      errorMessage.value = 'Error al eliminar evento: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Verificar si se puede crear un evento del tipo especificado
  bool _puedeCrearEvento(String tipoEvento) {
    final int limite = Evento.obtenerLimiteMaximo(tipoEvento);
    final int cantidadActual = eventos.where((e) => e.tipoEvento == tipoEvento).length;
    return cantidadActual < limite;
  }

  // Obtener eventos por tipo
  List<Evento> obtenerEventosPorTipo(String tipoEvento) {
    return eventos.where((e) => e.tipoEvento == tipoEvento).toList();
  }

  // Obtener eventos destacados
  List<Evento> get eventosDestacados => obtenerEventosPorTipo('destacado');

  // Obtener eventos programados
  List<Evento> get eventosProgramados => obtenerEventosPorTipo('programado');

  // Obtener cantidad de eventos por tipo
  int obtenerCantidadPorTipo(String tipoEvento) {
    return eventos.where((e) => e.tipoEvento == tipoEvento).length;
  }

  // Obtener límite disponible por tipo
  int obtenerLimiteDisponible(String tipoEvento) {
    final int limite = Evento.obtenerLimiteMaximo(tipoEvento);
    final int cantidadActual = obtenerCantidadPorTipo(tipoEvento);
    return limite - cantidadActual;
  }

  // Obtener eventos próximos (fecha futura)
  List<Evento> get eventosProximos {
    final ahora = DateTime.now();
    return eventos
        .where((e) => e.fecha.isAfter(ahora))
        .toList()
      ..sort((a, b) => a.fecha.compareTo(b.fecha));
  }

  // Obtener eventos pasados
  List<Evento> get eventosPasados {
    final ahora = DateTime.now();
    return eventos
        .where((e) => e.fecha.isBefore(ahora))
        .toList()
      ..sort((a, b) => b.fecha.compareTo(a.fecha));
  }

  // Limpiar mensaje de error
  void limpiarError() {
    errorMessage.value = '';
  }

  // Verificar si hay errores
  bool get tieneError => errorMessage.value.isNotEmpty;

  // Verificar si está cargando
  bool get estaCargando => isLoading.value;
}
