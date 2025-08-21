// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
//Importacion de archivos necesarios
import '../../screens/configuracion_cuota_screen/controllers/pago_cuota_controller.dart';
import '../../screens/auth_screen/controllers/auth_controller.dart';

class MisPagosScreen extends StatefulWidget {
  const MisPagosScreen({super.key});

  @override
  State<MisPagosScreen> createState() => _MisPagosScreenState();
}

class _MisPagosScreenState extends State<MisPagosScreen> {
  final PagoCuotaController pagoController = Get.put(PagoCuotaController());
  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    // Cargar datos del socio actual
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarDatosSocio();
    });
  }

  void _cargarDatosSocio() {
    if (authController.currentUser.value != null) {
      // Cargar pagos del socio actual
      pagoController.loadPagos();

      // Debug: imprimir información del socio actual
      final socio = authController.currentUser.value;
      print("=== DEBUG MIS PAGOS ===");
      print("Socio ID: ${socio?.idUsuario}");
      print("Socio DNI: ${socio?.dni}");
      print("Socio Nombre: ${socio?.nombre} ${socio?.apellido}");
      print("Total socios cargados: ${pagoController.socios.length}");
      print(
        "Socios disponibles: ${pagoController.socios.map((s) => '${s.idUsuario}:${s.dni}').toList()}",
      );
      print("=======================");
    }
  }

  // Función para formatear la fecha
  String _formatearFecha(DateTime fecha) {
    return '${fecha.day}/${fecha.month}/${fecha.year}';
  }

  // Función para obtener el nombre del mes en español
  String _obtenerNombreMes(int mes) {
    switch (mes) {
      case 1:
        return "Enero";
      case 2:
        return "Febrero";
      case 3:
        return "Marzo";
      case 4:
        return "Abril";
      case 5:
        return "Mayo";
      case 6:
        return "Junio";
      case 7:
        return "Julio";
      case 8:
        return "Agosto";
      case 9:
        return "Septiembre";
      case 10:
        return "Octubre";
      case 11:
        return "Noviembre";
      case 12:
        return "Diciembre";
      default:
        return "Mes desconocido";
    }
  }

  // Función para obtener el color del estado de la cuota
  Color _obtenerColorEstado(DateTime fechaVencimiento) {
    final ahora = DateTime.now();
    if (fechaVencimiento.isBefore(ahora)) {
      return Colors.red; // Vencida
    } else if (fechaVencimiento.isBefore(ahora.add(const Duration(days: 30)))) {
      return Colors.orange; // Por vencer
    } else {
      return Colors.green; // Vigente
    }
  }

  // Función para obtener el icono del estado de la cuota
  IconData _obtenerIconoEstado(DateTime fechaVencimiento) {
    final ahora = DateTime.now();
    if (fechaVencimiento.isBefore(ahora)) {
      return Icons.warning; // Vencida
    } else if (fechaVencimiento.isBefore(ahora.add(const Duration(days: 30)))) {
      return Icons.schedule; // Por vencer
    } else {
      return Icons.check_circle; // Vigente
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Pagos de Cuotas"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        final socio = authController.currentUser.value;

        if (socio == null) {
          return const Center(child: CircularProgressIndicator());
        }

        // Verificar que los datos estén cargados
        if (pagoController.socios.isEmpty || pagoController.cuotas.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text("Cargando datos..."),
              ],
            ),
          );
        }

        // Obtener estado de pagos del socio
        final estadoPagos = pagoController.getEstadoPagosSocio(
          socio.idUsuario!,
        );
        final pagosSocio = pagoController.getPagosPorSocio(socio.idUsuario!);

        // Debug: verificar que los datos se obtuvieron correctamente
        print("Estado pagos obtenido: ${estadoPagos.length} elementos");
        print("Pagos socio obtenidos: ${pagosSocio.length} pagos");

        return RefreshIndicator(
          onRefresh: () async {
            await pagoController.loadPagos();
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ====================
              // Información del socio
              // ====================
              Card(
                elevation: 4,
                color: Colors.indigo.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.indigo.shade100,
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.indigo.shade700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "${socio.nombre} ${socio.apellido}",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Número de Socio: ${socio.numeroSocio}",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.indigo.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "DNI: ${socio.dni}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.indigo.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ====================
              // Resumen del estado de pagos
              // ====================
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Resumen del Año ${DateTime.now().year}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: _buildResumenItem(
                              "Cuotas Pagadas",
                              estadoPagos["cuotasPagadas"].toString(),
                              Colors.green,
                              Icons.check_circle,
                            ),
                          ),
                          Expanded(
                            child: _buildResumenItem(
                              "Cuotas Pendientes",
                              estadoPagos["cuotasPendientes"].toString(),
                              Colors.orange,
                              Icons.pending,
                            ),
                          ),
                          Expanded(
                            child: _buildResumenItem(
                              "Total Cuotas",
                              estadoPagos["totalCuotas"].toString(),
                              Colors.blue,
                              Icons.list_alt,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Total Pagado:",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "\$${estadoPagos["totalPagado"].toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Total Debido:",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "\$${estadoPagos["totalDebido"].toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Monto Pendiente:",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "\$${estadoPagos["montoPendiente"].toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        estadoPagos["montoPendiente"] > 0
                                            ? Colors.orange
                                            : Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            LinearProgressIndicator(
                              value: estadoPagos["porcentajePago"] / 100,
                              backgroundColor: Colors.grey.shade300,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                estadoPagos["porcentajePago"] >= 100
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Progreso: ${estadoPagos["porcentajePago"].toStringAsFixed(1)}%",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ====================
              // Historial de pagos realizados
              // ====================
              Card(
                elevation: 4,
                child: ExpansionTile(
                  initiallyExpanded: true,
                  title: const Text(
                    "Historial de Pagos Realizados",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "${pagosSocio.length} pago${pagosSocio.length == 1 ? '' : 's'} registrado${pagosSocio.length == 1 ? '' : 's'}",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  leading: const Icon(Icons.history),
                  children: [
                    if (pagosSocio.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Icon(Icons.payment, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              "No hay pagos registrados",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              "Los pagos aparecerán aquí una vez que se registren",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    else
                      ...pagosSocio.map((pago) {
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  pago.pagoTardio
                                      ? Colors.red
                                      : pago.fechaPago.isBefore(
                                        pago.fechaVencimiento,
                                      )
                                      ? Colors.green
                                      : Colors.blue,
                              child: Icon(
                                pago.pagoTardio
                                    ? Icons.warning
                                    : pago.fechaPago.isBefore(
                                      pago.fechaVencimiento,
                                    )
                                    ? Icons.check
                                    : Icons.schedule,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            title: Text(
                              "${pago.nombreMes} ${pago.anio}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Monto: \$${pago.montoPagado.toStringAsFixed(2)}",
                                ),
                                Text("Método: ${pago.metodoPago}"),
                                Text(
                                  "Fecha: ${_formatearFecha(pago.fechaPago)}",
                                ),
                                if (pago.notas != null &&
                                    pago.notas!.isNotEmpty)
                                  Text("Notas: ${pago.notas}"),
                                Text(
                                  pago.estadoPago,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color:
                                        pago.pagoTardio
                                            ? Colors.red
                                            : pago.fechaPago.isBefore(
                                              pago.fechaVencimiento,
                                            )
                                            ? Colors.green
                                            : Colors.blue,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            isThreeLine: true,
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (pago.pagoParcial)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      "Parcial",
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.orange.shade800,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                        // ignore: unnecessary_to_list_in_spreads
                      }).toList(),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ====================
              // Estado de cuotas por mes
              // ====================
              Card(
                elevation: 4,
                child: ExpansionTile(
                  initiallyExpanded: false,
                  title: const Text(
                    "Estado de Cuotas por Mes",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text("Ver estado de cada cuota mensual"),
                  leading: const Icon(Icons.calendar_month),
                  children: [
                    ...List.generate(12, (index) {
                      final mes = index + 1;
                      final anio = DateTime.now().year;

                      // Buscar si hay pago para este mes
                      final pagoMes =
                          pagosSocio
                              .where((p) => p.mes == mes && p.anio == anio)
                              .toList();

                      // Buscar la cuota configurada para este mes
                      final cuotaMes =
                          pagoController.cuotas
                              .where((c) => c.mes == mes)
                              .toList();

                      if (cuotaMes.isEmpty) {
                        return const SizedBox.shrink(); // No mostrar si no hay cuota configurada
                      }

                      final cuota = cuotaMes.first;
                      final tienePago = pagoMes.isNotEmpty;
                      final pago = tienePago ? pagoMes.first : null;

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                tienePago
                                    ? Colors.green
                                    : _obtenerColorEstado(
                                      cuota.fechaVencimiento,
                                    ),
                            child: Icon(
                              tienePago
                                  ? Icons.check
                                  : _obtenerIconoEstado(cuota.fechaVencimiento),
                              color: Colors.white,
                            ),
                          ),
                          title: Text(
                            _obtenerNombreMes(mes),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Monto: \$${cuota.monto.toStringAsFixed(2)}",
                              ),
                              Text(
                                "Vencimiento: ${_formatearFecha(cuota.fechaVencimiento)}",
                              ),
                              if (tienePago) ...[
                                Text(
                                  "PAGADO - ${_formatearFecha(pago!.fechaPago)}",
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (pago.pagoParcial)
                                  Text(
                                    "Pago parcial: \$${pago.montoPagado.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      color: Colors.orange,
                                    ),
                                  ),
                              ] else ...[
                                Text(
                                  "PENDIENTE",
                                  style: TextStyle(
                                    color: _obtenerColorEstado(
                                      cuota.fechaVencimiento,
                                    ),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (cuota.fechaVencimiento.isBefore(
                                  DateTime.now(),
                                ))
                                  Text(
                                    "VENCIDA",
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                              ],
                            ],
                          ),
                          isThreeLine: true,
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  tienePago
                                      ? Colors.green.shade100
                                      : _obtenerColorEstado(
                                        cuota.fechaVencimiento,
                                      ).withValues(alpha: 100),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              tienePago ? "PAGADO" : "PENDIENTE",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color:
                                    tienePago
                                        ? Colors.green.shade800
                                        : _obtenerColorEstado(
                                          cuota.fechaVencimiento,
                                        ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildResumenItem(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          title,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
