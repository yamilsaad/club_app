// ignore_for_file: avoid_types_as_parameter_names, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../../../data/models/model.dart';

class PagoCuotaController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Listas reactivas
  var pagos = <PagoCuotaSocio>[].obs;
  var socios = <SocioModel>[].obs;
  var cuotas = <CuotaMensual>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadSocios();
    loadCuotas();
    loadPagos();
  }

  /// ===========================
  /// Cargar socios desde Firestore
  /// ===========================
  Future<void> loadSocios() async {
    try {
      var snapshot = await _db.collection("usuarios").get();
      socios.value =
          snapshot.docs
              .map((doc) => SocioModel.fromMap(doc.data(), doc.id))
              .where(
                (socio) => socio.rol == "socio" || socio.rol == "admin",
              ) // Incluir socios y admins
              .toList();

      print("Usuarios cargados: ${socios.length}");
      print("DNIs disponibles: ${socios.map((s) => s.dni).toList()}");
      print("Roles disponibles: ${socios.map((s) => s.rol).toSet().toList()}");
    } catch (e) {
      Get.snackbar("Error", "No se pudieron cargar los usuarios: $e");
      print("Error cargando usuarios: $e");
    }
  }

  /// ===========================
  /// Cargar cuotas desde Firestore
  /// ===========================
  Future<void> loadCuotas() async {
    try {
      var snapshot = await _db.collection("configuracion_cuota").get();
      cuotas.value =
          snapshot.docs
              .map((doc) => CuotaMensual.fromJson(doc.data(), doc.id))
              .toList();
    } catch (e) {
      Get.snackbar("Error", "No se pudieron cargar las cuotas: $e");
    }
  }

  /// ===========================
  /// Cargar pagos desde Firestore
  /// ===========================
  Future<void> loadPagos() async {
    try {
      var snapshot = await _db.collection("pagos_cuotas").get();
      pagos.value =
          snapshot.docs
              .map((doc) => PagoCuotaSocio.fromJson(doc.data(), doc.id))
              .toList();
    } catch (e) {
      // Si la coleccion no existe, crear una lista vacia
      pagos.value = [];
    }
  }

  /// ===========================
  /// Buscar socio por DNI
  /// ===========================
  SocioModel? buscarSocioPorDNI(String dni) {
    try {
      return socios.firstWhere((socio) => socio.dni == dni);
    } catch (e) {
      return null;
    }
  }

  /// ===========================
  /// Buscar socio por numero de socio
  /// ===========================
  SocioModel? buscarSocioPorNumero(String numeroSocio) {
    try {
      return socios.firstWhere((socio) => socio.numeroSocio == numeroSocio);
    } catch (e) {
      return null;
    }
  }

  /// ===========================
  /// Obtener cuota por mes y anio
  /// ===========================
  CuotaMensual? getCuotaPorMes(int mes, int anio) {
    try {
      return cuotas.firstWhere((cuota) => cuota.mes == mes);
    } catch (e) {
      return null;
    }
  }

  /// ===========================
  /// Registrar nuevo pago de cuota
  /// ===========================
  Future<void> registrarPago({
    required String socioId,
    required int mes,
    required int anio,
    required double montoPagado,
    required String metodoPago,
    String? notas,
  }) async {
    try {
      // Buscar el socio
      final socio = socios.firstWhere((s) => s.idUsuario == socioId);

      // Buscar la cuota correspondiente
      final cuota = getCuotaPorMes(mes, anio);
      if (cuota == null) {
        throw Exception(
          "No existe cuota configurada para el mes $mes del anio $anio",
        );
      }

      // Verificar si ya existe un pago para este socio en este mes/anio
      final pagoExistente =
          pagos
              .where(
                (p) => p.socioId == socioId && p.mes == mes && p.anio == anio,
              )
              .toList();

      if (pagoExistente.isNotEmpty) {
        throw Exception(
          "Ya existe un pago registrado para este socio en el mes $mes del anio $anio",
        );
      }

      // Crear el pago
      final pago = PagoCuotaSocio(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        socioId: socioId,
        cuotaId: cuota.id,
        mes: mes,
        anio: anio,
        montoPagado: montoPagado,
        fechaPago: DateTime.now(),
        metodoPago: metodoPago,
        notas: notas,
        pagoCompleto: montoPagado >= cuota.monto,
        nombreSocio: "${socio.nombre} ${socio.apellido}",
        numeroSocio: socio.numeroSocio,
        montoCuota: cuota.monto,
        fechaVencimiento: cuota.fechaVencimiento,
      );

      // Guardar en Firestore
      await _db.collection("pagos_cuotas").add(pago.toJson());

      // Recargar pagos
      await loadPagos();

      Get.snackbar("Exito", "Pago registrado correctamente");
    } catch (e) {
      Get.snackbar("Error", "No se pudo registrar el pago: $e");
      rethrow;
    }
  }

  /// ===========================
  /// Obtener pagos por socio
  /// ===========================
  List<PagoCuotaSocio> getPagosPorSocio(String socioId) {
    try {
      return pagos.where((pago) => pago.socioId == socioId).toList();
    } catch (e) {
      print("Error en getPagosPorSocio: $e");
      return [];
    }
  }

  /// ===========================
  /// Obtener pagos por mes y anio
  /// ===========================
  List<PagoCuotaSocio> getPagosPorMes(int mes, int anio) {
    return pagos.where((pago) => pago.mes == mes && pago.anio == anio).toList();
  }

  /// ===========================
  /// Obtener estado de pagos de un socio especifico
  /// ===========================
  Map<String, dynamic> getEstadoPagosSocio(String socioId) {
    try {
      // Buscar el socio de forma segura
      final socio = socios.firstWhere((s) => s.idUsuario == socioId);

      // Obtener pagos del socio
      final pagosSocio = pagos.where((p) => p.socioId == socioId).toList();

      final anioActual = DateTime.now().year;
      final cuotasAnio = cuotas.where((c) => c.mes <= 12).toList();

      // Calcular estadisticas
      int totalCuotas = cuotasAnio.length;
      int cuotasPagadas = pagosSocio.where((p) => p.anio == anioActual).length;
      int cuotasPendientes = totalCuotas - cuotasPagadas;

      // Calcular montos
      double totalPagado = pagosSocio
          .where((p) => p.anio == anioActual)
          .fold(0.0, (sum, pago) => sum + pago.montoPagado);

      double totalDebido = cuotasAnio.fold(
        0.0,
        (sum, cuota) => sum + cuota.monto,
      );
      double montoPendiente = totalDebido - totalPagado;

      return {
        "socio": socio,
        "totalCuotas": totalCuotas,
        "cuotasPagadas": cuotasPagadas,
        "cuotasPendientes": cuotasPendientes,
        "totalPagado": totalPagado,
        "totalDebido": totalDebido,
        "montoPendiente": montoPendiente,
        "porcentajePago":
            totalDebido > 0 ? (totalPagado / totalDebido * 100) : 0,
      };
    } catch (e) {
      // Si no se encuentra el socio, retornar valores por defecto
      print("Error en getEstadoPagosSocio: $e");
      return {
        "socio": null,
        "totalCuotas": 0,
        "cuotasPagadas": 0,
        "cuotasPendientes": 0,
        "totalPagado": 0.0,
        "totalDebido": 0.0,
        "montoPendiente": 0.0,
        "porcentajePago": 0.0,
      };
    }
  }

  /// ===========================
  /// Obtener socios morosos (con cuotas vencidas)
  /// ===========================
  List<Map<String, dynamic>> getSociosMorosos() {
    try {
      // Verificar que los datos estén disponibles
      if (socios.isEmpty || cuotas.isEmpty) {
        return [];
      }

      final anioActual = DateTime.now().year;
      final ahora = DateTime.now();

      List<Map<String, dynamic>> sociosMorosos = [];

      for (final socio in socios) {
        try {
          // Verificar que el socio tenga ID válido
          if (socio.idUsuario == null || socio.idUsuario!.isEmpty) {
            continue; // Saltar socios sin ID válido
          }

          final estado = getEstadoPagosSocio(socio.idUsuario!);
          final cuotasPendientes = estado["cuotasPendientes"] as int;

          if (cuotasPendientes > 0) {
            // Verificar si tiene cuotas vencidas
            final cuotasVencidas =
                cuotas.where((c) {
                  final pago =
                      pagos
                          .where(
                            (p) =>
                                p.socioId == socio.idUsuario &&
                                p.mes == c.mes &&
                                p.anio == anioActual,
                          )
                          .toList();

                  return pago.isEmpty && c.fechaVencimiento.isBefore(ahora);
                }).toList();

            if (cuotasVencidas.isNotEmpty) {
              // Calcular días de vencimiento de forma segura
              int diasVencimiento = 0;
              try {
                diasVencimiento = cuotasVencidas
                    .map((c) => ahora.difference(c.fechaVencimiento).inDays)
                    .reduce((a, b) => a > b ? a : b);
              } catch (e) {
                print("Error calculando días de vencimiento: $e");
                diasVencimiento = 0;
              }

              sociosMorosos.add({
                "socio": socio,
                "estado": estado,
                "cuotasVencidas": cuotasVencidas,
                "diasVencimiento": diasVencimiento,
              });
            }
          }
        } catch (e) {
          print("Error procesando socio ${socio.idUsuario}: $e");
          continue; // Continuar con el siguiente socio
        }
      }

      // Ordenar por días de vencimiento (más vencidos primero)
      try {
        sociosMorosos.sort(
          (a, b) => (b["diasVencimiento"] as int).compareTo(
            a["diasVencimiento"] as int,
          ),
        );
      } catch (e) {
        print("Error ordenando socios morosos: $e");
      }

      return sociosMorosos;
    } catch (e) {
      print("Error en getSociosMorosos: $e");
      return [];
    }
  }

  /// ===========================
  /// Generar reporte de pagos del mes
  /// ===========================
  Map<String, dynamic> getReportePagosMes(int mes, int anio) {
    try {
      final pagosMes = getPagosPorMes(mes, anio);
      final cuotaMes = getCuotaPorMes(mes, anio);

      if (cuotaMes == null) {
        return {
          "mes": mes,
          "anio": anio,
          "totalSocios": socios.length,
          "sociosPagaron": pagosMes.length,
          "sociosPendientes": socios.length - pagosMes.length,
          "totalRecaudado": pagosMes.fold(
            0.0,
            (sum, pago) => sum + pago.montoPagado,
          ),
          "totalEsperado": 0.0, // No hay cuota configurada
          "porcentajeRecaudacion": 0.0,
          "cuota": null,
        };
      }

      final totalSocios = socios.length;
      final sociosPagaron = pagosMes.length;
      final sociosPendientes = totalSocios - sociosPagaron;
      final totalRecaudado = pagosMes.fold(
        0.0,
        (sum, pago) => sum + pago.montoPagado,
      );
      final totalEsperado = totalSocios * cuotaMes.monto;
      final porcentajeRecaudacion =
          totalEsperado > 0 ? (totalRecaudado / totalEsperado * 100) : 0;

      return {
        "mes": mes,
        "anio": anio,
        "totalSocios": totalSocios,
        "sociosPagaron": sociosPagaron,
        "sociosPendientes": sociosPendientes,
        "totalRecaudado": totalRecaudado,
        "totalEsperado": totalEsperado,
        "porcentajeRecaudacion": porcentajeRecaudacion,
        "cuota": cuotaMes,
      };
    } catch (e) {
      print("Error en getReportePagosMes: $e");
      // Retornar reporte por defecto en caso de error
      return {
        "mes": mes,
        "anio": anio,
        "totalSocios": 0,
        "sociosPagaron": 0,
        "sociosPendientes": 0,
        "totalRecaudado": 0.0,
        "totalEsperado": 0.0,
        "porcentajeRecaudacion": 0.0,
        "cuota": null,
      };
    }
  }
}
