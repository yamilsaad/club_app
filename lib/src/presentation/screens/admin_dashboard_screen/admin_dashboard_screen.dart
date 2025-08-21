// ignore_for_file: unused_element, unnecessary_to_list_in_spreads

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/model.dart';
import '../../screens/configuracion_cuota_screen/controllers/pago_cuota_controller.dart';
import '../../screens/auth_screen/controllers/auth_controller.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  // Usar Get.put con permanent o Get.find si ya está inicializado
  final PagoCuotaController pagoController = Get.put(
    PagoCuotaController(),
    permanent: true,
  );
  final AuthController authController = Get.put(
    AuthController(),
    permanent: true,
  );

  int mesSeleccionado = DateTime.now().month;
  int anioSeleccionado = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    // Cargar datos necesarios
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarDatos();
    });
  }

  void _cargarDatos() {
    pagoController.loadSocios();
    pagoController.loadCuotas();
    pagoController.loadPagos();
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

  // Función para formatear la fecha
  String _formatearFecha(DateTime fecha) {
    return '${fecha.day}/${fecha.month}/${fecha.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Administrativo"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _cargarDatos),
        ],
      ),
      body: Obx(() {
        // Verificar que los datos estén cargados
        if (pagoController.socios.isEmpty || pagoController.cuotas.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text("Cargando datos del dashboard..."),
              ],
            ),
          );
        }

        // Obtener reportes
        final reporteMes =
            pagoController.getReportePagosMes(
              mesSeleccionado,
              anioSeleccionado,
            ) ??
            {};

        final sociosMorosos = pagoController.getSociosMorosos() ?? [];

        // Validar que los reportes no sean null
        if (reporteMes.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, size: 64, color: Colors.red),
                SizedBox(height: 16),
                Text(
                  "Error al cargar reportes",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text("Intenta refrescar la página"),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await pagoController.loadPagos();
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ====================
              // Selector de mes y año
              // ====================
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Seleccionar Período",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              decoration: const InputDecoration(
                                labelText: "Mes",
                                prefixIcon: Icon(Icons.calendar_month),
                              ),
                              value: mesSeleccionado,
                              items: List.generate(12, (index) {
                                final mes = index + 1;
                                return DropdownMenuItem(
                                  value: mes,
                                  child: Text(_obtenerNombreMes(mes)),
                                );
                              }),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    mesSeleccionado = value;
                                  });
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<int>(
                              decoration: const InputDecoration(
                                labelText: "Año",
                                prefixIcon: Icon(Icons.calendar_today),
                              ),
                              value: anioSeleccionado,
                              items:
                                  [
                                    DateTime.now().year - 1,
                                    DateTime.now().year,
                                    DateTime.now().year + 1,
                                  ].map((anio) {
                                    return DropdownMenuItem(
                                      value: anio,
                                      child: Text(anio.toString()),
                                    );
                                  }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    anioSeleccionado = value;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ====================
              // Resumen general del mes
              // ====================
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Resumen de ${_obtenerNombreMes(mesSeleccionado)} $anioSeleccionado",
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
                              "Total Socios",
                              (reporteMes["totalSocios"] ?? 0).toString(),
                              Colors.blue,
                              Icons.people,
                            ),
                          ),
                          Expanded(
                            child: _buildResumenItem(
                              "Socios Pagaron",
                              (reporteMes["sociosPagaron"] ?? 0).toString(),
                              Colors.green,
                              Icons.check_circle,
                            ),
                          ),
                          Expanded(
                            child: _buildResumenItem(
                              "Socios Pendientes",
                              (reporteMes["sociosPendientes"] ?? 0).toString(),
                              Colors.orange,
                              Icons.pending,
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
                                  "Total Recaudado:",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "\$${(reporteMes["totalRecaudado"] ?? 0.0).toStringAsFixed(2)}",
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
                                  "Total Esperado:",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "\$${(reporteMes["totalEsperado"] ?? 0.0).toStringAsFixed(2)}",
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
                                  "Porcentaje Recaudación:",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  "${(reporteMes["porcentajeRecaudacion"] ?? 0.0).toStringAsFixed(1)}%",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        (reporteMes["porcentajeRecaudacion"] ??
                                                    0.0) >=
                                                80
                                            ? Colors.green
                                            : (reporteMes["porcentajeRecaudacion"] ??
                                                    0.0) >=
                                                60
                                            ? Colors.orange
                                            : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            LinearProgressIndicator(
                              value:
                                  (reporteMes["porcentajeRecaudacion"] ?? 0.0) /
                                  100,
                              backgroundColor: Colors.grey.shade300,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                (reporteMes["porcentajeRecaudacion"] ?? 0.0) >=
                                        80
                                    ? Colors.green
                                    : (reporteMes["porcentajeRecaudacion"] ??
                                            0.0) >=
                                        60
                                    ? Colors.orange
                                    : Colors.red,
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
              // Lista de socios morosos
              // ====================
              Card(
                elevation: 4,
                child: ExpansionTile(
                  initiallyExpanded: true,
                  title: const Text(
                    "Socios con Cuotas Vencidas",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "${sociosMorosos.length} socio${sociosMorosos.length == 1 ? '' : 's'} moroso${sociosMorosos.length == 1 ? '' : 's'}",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  leading: const Icon(Icons.warning, color: Colors.red),
                  children: [
                    if (sociosMorosos.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 64,
                              color: Colors.green,
                            ),
                            SizedBox(height: 16),
                            Text(
                              "¡Excelente! No hay socios morosos",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Todos los socios están al día con sus cuotas",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    else
                      ...sociosMorosos.map((socioMoroso) {
                        try {
                          final socio = socioMoroso["socio"] as SocioModel?;
                          final estado =
                              socioMoroso["estado"] as Map<String, dynamic>?;
                          final cuotasVencidas =
                              socioMoroso["cuotasVencidas"]
                                  as List<CuotaMensual>?;
                          final diasVencimiento =
                              socioMoroso["diasVencimiento"] as int?;

                          // Verificar que todos los datos sean válidos
                          if (socio == null ||
                              estado == null ||
                              cuotasVencidas == null ||
                              diasVencimiento == null) {
                            return const SizedBox.shrink(); // No mostrar si faltan datos
                          }

                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            color: Colors.red.shade50,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.red,
                                child: Icon(
                                  Icons.warning,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              title: Text(
                                "${socio.nombre} ${socio.apellido}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "N° Socio: ${socio.numeroSocio ?? 'N/A'}",
                                  ),
                                  Text("DNI: ${socio.dni ?? 'N/A'}"),
                                  Text("Teléfono: ${socio.telefono ?? 'N/A'}"),
                                  Text(
                                    "Cuotas vencidas: ${cuotasVencidas.length}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Días de vencimiento: $diasVencimiento días",
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                  Text(
                                    "Monto pendiente: \$${(estado["montoPendiente"] ?? 0.0).toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              isThreeLine: true,
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.phone,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  // Aquí se podría implementar llamada telefónica
                                  Get.snackbar(
                                    "Contactar",
                                    "Contactando a ${socio.nombre} ${socio.apellido}",
                                    backgroundColor: Colors.blue,
                                    colorText: Colors.white,
                                  );
                                },
                              ),
                            ),
                          );
                        } catch (e) {
                          print("Error procesando socio moroso: $e");
                          return const SizedBox.shrink(); // No mostrar si hay error
                        }
                      }).toList(),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ====================
              // Resumen anual
              // ====================
              Card(
                elevation: 4,
                child: ExpansionTile(
                  initiallyExpanded: false,
                  title: Text(
                    "Resumen Anual $anioSeleccionado",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text("Ver estadísticas del año completo"),
                  leading: const Icon(Icons.analytics),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Generar resumen para cada mes
                          ...List.generate(12, (index) {
                            try {
                              final mes = index + 1;
                              final reporteMesAnio = pagoController
                                  .getReportePagosMes(mes, anioSeleccionado);

                              // Verificar que el reporte sea válido
                              if (reporteMesAnio.isEmpty) {
                                return const SizedBox.shrink();
                              }

                              final porcentajeRecaudacion =
                                  reporteMesAnio["porcentajeRecaudacion"] ??
                                  0.0;
                              final totalRecaudado =
                                  reporteMesAnio["totalRecaudado"] ?? 0.0;
                              final totalEsperado =
                                  reporteMesAnio["totalEsperado"] ?? 0.0;

                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor:
                                        porcentajeRecaudacion >= 80
                                            ? Colors.green
                                            : porcentajeRecaudacion >= 60
                                            ? Colors.orange
                                            : Colors.red,
                                    child: Text(
                                      mes.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  title: Text(_obtenerNombreMes(mes)),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Recaudado: \$${totalRecaudado.toStringAsFixed(2)}",
                                      ),
                                      Text(
                                        "Esperado: \$${totalEsperado.toStringAsFixed(2)}",
                                      ),
                                    ],
                                  ),
                                  trailing: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          porcentajeRecaudacion >= 80
                                              ? Colors.green.shade100
                                              : porcentajeRecaudacion >= 60
                                              ? Colors.orange.shade100
                                              : Colors.red.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      "${porcentajeRecaudacion.toStringAsFixed(1)}%",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            porcentajeRecaudacion >= 80
                                                ? Colors.green.shade800
                                                : porcentajeRecaudacion >= 60
                                                ? Colors.orange.shade800
                                                : Colors.red.shade800,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            } catch (e) {
                              print("Error procesando mes $index: $e");
                              return const SizedBox.shrink();
                            }
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ====================
              // Acciones rápidas
              // ====================
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Acciones Rápidas",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Get.toNamed('/configuracion-cuenta');
                              },
                              icon: const Icon(Icons.payment),
                              label: const Text("Registrar Pago"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // Aquí se podría implementar exportar reporte
                                Get.snackbar(
                                  "Exportar",
                                  "Exportando reporte de pagos...",
                                  backgroundColor: Colors.blue,
                                  colorText: Colors.white,
                                );
                              },
                              icon: const Icon(Icons.download),
                              label: const Text("Exportar"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
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
