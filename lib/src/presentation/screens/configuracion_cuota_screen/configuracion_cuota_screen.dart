// ignore_for_file: unnecessary_string_interpolations, unnecessary_to_list_in_spreads

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socio_app/src/presentation/screens/configuracion_cuota_screen/controllers/configuracion_cuota_controller.dart';
import 'package:socio_app/src/presentation/screens/configuracion_cuota_screen/controllers/pago_cuota_controller.dart';
import '../../../data/models/model.dart';

class ConfiguracionCuotaScreen extends StatefulWidget {
  const ConfiguracionCuotaScreen({super.key});

  @override
  State<ConfiguracionCuotaScreen> createState() =>
      _ConfiguracionCuotaScreenState();
}

class _ConfiguracionCuotaScreenState extends State<ConfiguracionCuotaScreen> {
  final ConfiguracionCuotaController controller = Get.put(
    ConfiguracionCuotaController(),
  );

  // Nuevo controlador para pagos de cuotas
  final PagoCuotaController pagoController = Get.put(PagoCuotaController());

  // Controladores para la nueva cuota
  final TextEditingController montoController = TextEditingController();
  final TextEditingController notasController = TextEditingController();
  final TextEditingController recargoController = TextEditingController();
  final TextEditingController mesController = TextEditingController();

  // Controladores para registrar pagos
  final TextEditingController socioIdController = TextEditingController();
  final TextEditingController pagoMontoController = TextEditingController();
  final TextEditingController metodoPagoController = TextEditingController();

  // Variable para la fecha de vencimiento seleccionada
  DateTime? fechaVencimientoSeleccionada;

  // Variable para rastrear el día del mes seleccionado
  int? diaSeleccionado;

  // Variables para el registro de pagos
  int mesSeleccionado = DateTime.now().month;
  int anioSeleccionado = DateTime.now().year;
  String metodoPagoSeleccionado = "Efectivo";

  @override
  void initState() {
    super.initState();
    // Inicializar con la fecha actual
    fechaVencimientoSeleccionada = DateTime.now();
    // Cargar las cuotas existentes
    controller.loadCuotas();
  }

  // Función para seleccionar fecha de vencimiento
  Future<void> _seleccionarFechaVencimiento() async {
    final DateTime? fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: fechaVencimientoSeleccionada ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 365 * 2),
      ), // 2 años máximo
      locale: const Locale('es', 'ES'),
    );

    if (fechaSeleccionada != null) {
      setState(() {
        fechaVencimientoSeleccionada = fechaSeleccionada;
      });
    }
  }

  // Función para formatear la fecha
  String _formatearFecha(DateTime fecha) {
    return '${fecha.day}/${fecha.month}/${fecha.year}';
  }

  // Función para configurar fecha de vencimiento por día del mes
  void _configurarVencimientoPorDia(int diaDelMes) {
    final ahora = DateTime.now();
    final fechaVencimiento = DateTime(ahora.year, ahora.month, diaDelMes);

    // Si la fecha ya pasó este mes, ir al próximo mes
    if (fechaVencimiento.isBefore(ahora)) {
      setState(() {
        fechaVencimientoSeleccionada = DateTime(
          ahora.year,
          ahora.month + 1,
          diaDelMes,
        );
        diaSeleccionado = diaDelMes;
      });
    } else {
      setState(() {
        fechaVencimientoSeleccionada = fechaVencimiento;
        diaSeleccionado = diaDelMes;
      });
    }
  }

  // Función para verificar si la cuota está vencida
  bool _esCuotaVencida(DateTime fechaVencimiento) {
    final ahora = DateTime.now();
    return fechaVencimiento.isBefore(ahora);
  }

  // Función para verificar si la cuota está por vencer
  bool _esCuotaPorVencer(DateTime fechaVencimiento) {
    final ahora = DateTime.now();
    final fechaLimite = ahora.add(
      const Duration(days: 30),
    ); // 30 días antes de vencer
    return fechaVencimiento.isAfter(ahora) &&
        fechaVencimiento.isBefore(fechaLimite);
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

  // Función para obtener el estado de vencimiento
  String _obtenerEstadoVencimiento(DateTime fechaVencimiento) {
    if (_esCuotaVencida(fechaVencimiento)) {
      return "Vencida";
    } else if (_esCuotaPorVencer(fechaVencimiento)) {
      return "Por vencer";
    } else {
      return "Vigente";
    }
  }

  Widget _buildResumenItem(
    String title,
    int count,
    Color color,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 40),
        const SizedBox(height: 8),
        Text(
          "$title: $count",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              "$label ",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.grey.shade900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Configuración de cuotas")),
      body: Obx(() {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ====================
            // Mensaje si no hay cuotas creadas
            // ====================
            if (controller.cuotas.isEmpty)
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                color: Colors.yellow.shade100,
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Aún no se ha creado ninguna cuota. Por favor, registre una nueva cuota mensual.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

            // ====================
            // Resumen de cuotas por estado
            // ====================
            if (controller.cuotas.isNotEmpty)
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Resumen de cuotas:",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildResumenItem(
                              "Vigentes",
                              controller.cuotas
                                  .where(
                                    (c) =>
                                        !_esCuotaVencida(c.fechaVencimiento) &&
                                        !_esCuotaPorVencer(c.fechaVencimiento),
                                  )
                                  .length,
                              Colors.green,
                              Icons.check_circle,
                            ),
                          ),
                          Expanded(
                            child: _buildResumenItem(
                              "Por vencer",
                              controller.cuotas
                                  .where(
                                    (c) =>
                                        _esCuotaPorVencer(c.fechaVencimiento),
                                  )
                                  .length,
                              Colors.orange,
                              Icons.schedule,
                            ),
                          ),
                          Expanded(
                            child: _buildResumenItem(
                              "Vencidas",
                              controller.cuotas
                                  .where(
                                    (c) => _esCuotaVencida(c.fechaVencimiento),
                                  )
                                  .length,
                              Colors.red,
                              Icons.warning,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

            // ====================
            // Listado de cuotas existentes
            // ====================
            if (controller.cuotas.isNotEmpty)
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ExpansionTile(
                  initiallyExpanded: false,
                  title: const Text(
                    "Cuotas existentes",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "${controller.cuotas.length} cuota${controller.cuotas.length == 1 ? '' : 's'} configurada${controller.cuotas.length == 1 ? '' : 's'}",
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  leading: const Icon(Icons.list_alt),
                  children: [
                    ...controller.cuotas.map(
                      (cuota) => ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              _esCuotaVencida(cuota.fechaVencimiento)
                                  ? Colors.red
                                  : _esCuotaPorVencer(cuota.fechaVencimiento)
                                  ? Colors.orange
                                  : Colors.green,
                          child: Icon(
                            _esCuotaVencida(cuota.fechaVencimiento)
                                ? Icons.warning
                                : _esCuotaPorVencer(cuota.fechaVencimiento)
                                ? Icons.schedule
                                : Icons.check,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          "Mes: ${_obtenerNombreMes(cuota.mes)} - Monto: \$${cuota.monto.toStringAsFixed(2)}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Vencimiento: ${_formatearFecha(cuota.fechaVencimiento)}",
                              style: TextStyle(
                                color:
                                    _esCuotaVencida(cuota.fechaVencimiento)
                                        ? Colors.red
                                        : _esCuotaPorVencer(
                                          cuota.fechaVencimiento,
                                        )
                                        ? Colors.orange
                                        : Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (cuota.recargo != null && cuota.recargo! > 0)
                              Text(
                                "Recargo: \$${cuota.recargo!.toStringAsFixed(2)}",
                              ),
                            if (cuota.notas != null && cuota.notas!.isNotEmpty)
                              Text("Notas: ${cuota.notas}"),
                            Text(
                              _obtenerEstadoVencimiento(cuota.fechaVencimiento),
                              style: TextStyle(
                                fontSize: 12,
                                color:
                                    _esCuotaVencida(cuota.fechaVencimiento)
                                        ? Colors.red
                                        : _esCuotaPorVencer(
                                          cuota.fechaVencimiento,
                                        )
                                        ? Colors.orange
                                        : Colors.green,
                              ),
                            ),
                          ],
                        ),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // Cargar datos en formulario para edición
                            montoController.text = cuota.monto.toString();
                            notasController.text = cuota.notas ?? "";
                            recargoController.text =
                                (cuota.recargo ?? 0).toString();
                            mesController.text = cuota.mes.toString();
                            fechaVencimientoSeleccionada =
                                cuota.fechaVencimiento;

                            // Configurar el día seleccionado basado en la fecha de vencimiento
                            setState(() {
                              diaSeleccionado = cuota.fechaVencimiento.day;
                            });

                            Get.defaultDialog(
                              title: "Editar cuota",
                              content: StatefulBuilder(
                                builder: (context, setStateDialog) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: mesController,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          labelText: "Mes (1-12)",
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      TextField(
                                        controller: montoController,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          labelText: "Monto",
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      TextField(
                                        controller: recargoController,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          labelText: "Recargo",
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      TextField(
                                        controller: notasController,
                                        decoration: const InputDecoration(
                                          labelText: "Notas",
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      // Selector de fecha de vencimiento
                                      ListTile(
                                        title: const Text(
                                          "Fecha de vencimiento:",
                                        ),
                                        subtitle: Text(
                                          fechaVencimientoSeleccionada != null
                                              ? _formatearFecha(
                                                fechaVencimientoSeleccionada!,
                                              )
                                              : "Seleccionar fecha",
                                        ),
                                        trailing: const Icon(
                                          Icons.calendar_today,
                                        ),
                                        onTap: () async {
                                          final DateTime? fechaSeleccionada =
                                              await showDatePicker(
                                                context: context,
                                                initialDate:
                                                    fechaVencimientoSeleccionada ??
                                                    DateTime.now(),
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime.now().add(
                                                  const Duration(days: 365 * 2),
                                                ),
                                                locale: const Locale(
                                                  'es',
                                                  'ES',
                                                ),
                                              );
                                          if (fechaSeleccionada != null) {
                                            setStateDialog(() {
                                              fechaVencimientoSeleccionada =
                                                  fechaSeleccionada;
                                            });
                                          }
                                        },
                                      ),
                                      const SizedBox(height: 10),
                                      // Selector rápido de días del mes para edición
                                      Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "Configurar vencimiento por día del mes:",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Wrap(
                                                spacing: 8,
                                                children:
                                                    [
                                                      5,
                                                      10,
                                                      15,
                                                      20,
                                                      25,
                                                      30,
                                                    ].map((dia) {
                                                      final isSelected =
                                                          fechaVencimientoSeleccionada
                                                              ?.day ==
                                                          dia;
                                                      return ElevatedButton(
                                                        onPressed: () {
                                                          final ahora =
                                                              DateTime.now();
                                                          final fechaVencimiento =
                                                              DateTime(
                                                                ahora.year,
                                                                ahora.month,
                                                                dia,
                                                              );

                                                          if (fechaVencimiento
                                                              .isBefore(
                                                                ahora,
                                                              )) {
                                                            setStateDialog(() {
                                                              fechaVencimientoSeleccionada =
                                                                  DateTime(
                                                                    ahora.year,
                                                                    ahora.month +
                                                                        1,
                                                                    dia,
                                                                  );
                                                            });
                                                          } else {
                                                            setStateDialog(() {
                                                              fechaVencimientoSeleccionada =
                                                                  fechaVencimiento;
                                                            });
                                                          }
                                                        },
                                                        style: ElevatedButton.styleFrom(
                                                          minimumSize:
                                                              const Size(
                                                                50,
                                                                40,
                                                              ),
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 8,
                                                              ),
                                                          backgroundColor:
                                                              isSelected
                                                                  ? Colors.green
                                                                  : null,
                                                          foregroundColor:
                                                              isSelected
                                                                  ? Colors.white
                                                                  : null,
                                                        ),
                                                        child: Text("Día $dia"),
                                                      );
                                                    }).toList(),
                                              ),
                                              const SizedBox(height: 8),
                                              // Eliminamos el campo de texto personalizado para mantener consistencia
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      ElevatedButton(
                                        onPressed: () {
                                          if (fechaVencimientoSeleccionada ==
                                              null) {
                                            Get.snackbar(
                                              "Error",
                                              "Debe seleccionar una fecha de vencimiento",
                                            );
                                            return;
                                          }

                                          final updatedCuota = CuotaMensual(
                                            id: cuota.id,
                                            mes:
                                                int.tryParse(
                                                  mesController.text,
                                                ) ??
                                                cuota.mes,
                                            monto:
                                                double.tryParse(
                                                  montoController.text,
                                                ) ??
                                                cuota.monto,
                                            fechaVencimiento:
                                                fechaVencimientoSeleccionada!,
                                            recargo: double.tryParse(
                                              recargoController.text,
                                            ),
                                            notas: notasController.text,
                                          );
                                          controller.saveCuota(updatedCuota);
                                          Get.back();
                                          Get.snackbar(
                                            "Éxito",
                                            "Cuota actualizada",
                                          );

                                          // Limpiar el día seleccionado
                                          setState(() {
                                            diaSeleccionado = null;
                                          });
                                        },
                                        child: const Text("Guardar cambios"),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 10),

            // ====================
            // Formulario para agregar nueva cuota
            // ====================
            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ExpansionTile(
                  initiallyExpanded: true,
                  title: const Text("Agregar nueva cuota"),
                  children: [
                    TextField(
                      controller: mesController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Mes (1-12)",
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: montoController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Monto"),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: recargoController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Recargo (opcional)",
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: notasController,
                      decoration: const InputDecoration(labelText: "Notas"),
                    ),
                    const SizedBox(height: 10),
                    // Selector de fecha de vencimiento
                    ListTile(
                      title: const Text("Fecha de vencimiento:"),
                      subtitle: Text(
                        fechaVencimientoSeleccionada != null
                            ? _formatearFecha(fechaVencimientoSeleccionada!)
                            : "Seleccionar fecha",
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: _seleccionarFechaVencimiento,
                    ),
                    const SizedBox(height: 10),
                    // Selector rápido de días del mes
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Configurar vencimiento por día del mes:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children:
                                  [5, 10, 15, 20, 25, 30].map((dia) {
                                    final isSelected = diaSeleccionado == dia;
                                    return ElevatedButton(
                                      onPressed:
                                          () =>
                                              _configurarVencimientoPorDia(dia),
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(50, 40),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        backgroundColor:
                                            isSelected ? Colors.green : null,
                                        foregroundColor:
                                            isSelected ? Colors.white : null,
                                      ),
                                      child: Text("Día $dia"),
                                    );
                                  }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        if (fechaVencimientoSeleccionada == null) {
                          Get.snackbar(
                            "Error",
                            "Debe seleccionar una fecha de vencimiento",
                          );
                          return;
                        }

                        final nuevaCuota = CuotaMensual(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          mes: int.tryParse(mesController.text) ?? 1,
                          monto: double.tryParse(montoController.text) ?? 0,
                          fechaVencimiento: fechaVencimientoSeleccionada!,
                          recargo: double.tryParse(recargoController.text),
                          notas: notasController.text,
                        );
                        controller.saveCuota(nuevaCuota);

                        // Limpiar campos
                        mesController.clear();
                        montoController.clear();
                        recargoController.clear();
                        notasController.clear();
                        setState(() {
                          fechaVencimientoSeleccionada = DateTime.now();
                          diaSeleccionado = null;
                        });

                        Get.snackbar("Éxito", "Nueva cuota creada");
                      },
                      child: const Text("Crear cuota"),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ====================
            // Registrar nuevo pago de socio
            // ====================
            Card(
              elevation: 4.0,
              margin: const EdgeInsets.symmetric(vertical: 1.0),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: ExpansionTile(
                  title: const Text("Registrar pago de cuota"),
                  subtitle: const Text(
                    "Registrar pago de socio o administrador",
                  ),
                  children: [
                    // Buscador de socio por DNI
                    TextField(
                      controller: socioIdController,
                      decoration: const InputDecoration(
                        labelText: "DNI del usuario",
                        hintText: "Ingrese el DNI del socio o administrador",
                        prefixIcon: Icon(Icons.person_search),
                        suffixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        // Buscar socio mientras se escribe
                        if (value.length >= 7) {
                          setState(() {
                            // Forzar rebuild para mostrar/ocultar información del socio
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 10),

                    // Información del socio encontrado
                    Obx(() {
                      final socioEncontrado =
                          pagoController.socios
                              .where(
                                (s) => s.dni == socioIdController.text.trim(),
                              )
                              .toList();

                      if (socioEncontrado.isNotEmpty) {
                        final socio = socioEncontrado.first;
                        final esAdmin = socio.rol == "admin";

                        return Card(
                          color:
                              esAdmin
                                  ? Colors.purple.shade50
                                  : Colors.green.shade50,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      esAdmin
                                          ? Icons.admin_panel_settings
                                          : Icons.person,
                                      color:
                                          esAdmin
                                              ? Colors.purple.shade700
                                              : Colors.green.shade700,
                                      size: 24,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      esAdmin
                                          ? "Administrador encontrado:"
                                          : "Socio encontrado:",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color:
                                            esAdmin
                                                ? Colors.purple.shade800
                                                : Colors.green.shade800,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            esAdmin
                                                ? Colors.purple.shade200
                                                : Colors.green.shade200,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        socio.rol.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              esAdmin
                                                  ? Colors.purple.shade800
                                                  : Colors.green.shade800,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                _buildInfoRow(
                                  "Nombre completo:",
                                  "${socio.nombre} ${socio.apellido}",
                                ),
                                _buildInfoRow(
                                  "Número de socio:",
                                  socio.numeroSocio,
                                ),
                                _buildInfoRow("DNI:", socio.dni),
                                _buildInfoRow("Teléfono:", socio.telefono),
                                _buildInfoRow("Dirección:", socio.direccion),
                                _buildInfoRow("Oficio:", socio.oficio),
                                _buildInfoRow(
                                  "Estado:",
                                  socio.estadoSocio ? "Activo" : "Inactivo",
                                ),
                                _buildInfoRow(
                                  "Rol:",
                                  socio.rol == "admin"
                                      ? "Administrador"
                                      : "Socio",
                                ),
                              ],
                            ),
                          ),
                        );
                      } else if (socioIdController.text.trim().isNotEmpty &&
                          socioIdController.text.trim().length >= 7) {
                        return Card(
                          color: Colors.red.shade50,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.person_off,
                                  color: Colors.red.shade700,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "No se encontró ningún usuario con ese DNI",
                                  style: TextStyle(
                                    color: Colors.red.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }),

                    const SizedBox(height: 10),

                    // Selección de mes y año
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
                        const SizedBox(width: 10),
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

                    const SizedBox(height: 10),

                    // Monto a pagar
                    TextField(
                      controller: pagoMontoController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Monto pagado",
                        hintText: "Ingrese el monto que pagó el socio",
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Método de pago
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Método de pago",
                        prefixIcon: Icon(Icons.payment),
                      ),
                      value: metodoPagoSeleccionado,
                      items:
                          [
                            "Efectivo",
                            "Transferencia",
                            "Débito",
                            "Crédito",
                            "Cheque",
                            "Otro",
                          ].map((metodo) {
                            return DropdownMenuItem(
                              value: metodo,
                              child: Text(metodo),
                            );
                          }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            metodoPagoSeleccionado = value;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 10),

                    // Notas adicionales
                    TextField(
                      controller:
                          metodoPagoController, // Reutilizamos este controller para notas
                      decoration: const InputDecoration(
                        labelText: "Notas adicionales (opcional)",
                        hintText: "Información adicional sobre el pago",
                        prefixIcon: Icon(Icons.note),
                      ),
                      maxLines: 2,
                    ),

                    const SizedBox(height: 15),

                    // Botón para registrar pago
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          // Validar que se haya encontrado un socio
                          final socioEncontrado =
                              pagoController.socios
                                  .where((s) => s.dni == socioIdController.text)
                                  .toList();

                          if (socioEncontrado.isEmpty) {
                            Get.snackbar(
                              "Error",
                              "Debe buscar y encontrar un socio válido",
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                            return;
                          }

                          // Validar monto
                          final monto = double.tryParse(
                            pagoMontoController.text,
                          );
                          if (monto == null || monto <= 0) {
                            Get.snackbar(
                              "Error",
                              "Debe ingresar un monto válido",
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                            return;
                          }

                          try {
                            // Registrar el pago usando el nuevo controlador
                            await pagoController.registrarPago(
                              socioId: socioEncontrado.first.idUsuario!,
                              mes: mesSeleccionado, // Usar mes seleccionado
                              anio: anioSeleccionado, // Usar año seleccionado
                              montoPagado: monto,
                              metodoPago: metodoPagoSeleccionado,
                              notas:
                                  metodoPagoController.text.isNotEmpty
                                      ? metodoPagoController.text
                                      : null,
                            );

                            // Limpiar campos
                            socioIdController.clear();
                            pagoMontoController.clear();
                            metodoPagoController.clear();

                            Get.snackbar(
                              "Éxito",
                              "Pago de cuota registrado correctamente",
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                            );
                          } catch (e) {
                            Get.snackbar(
                              "Error",
                              "No se pudo registrar el pago: $e",
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          }
                        },
                        icon: const Icon(Icons.save),
                        label: const Text("Registrar Pago de Cuota"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ====================
            // Historial de pagos
            // ====================
            Card(
              elevation: 4.0,
              margin: const EdgeInsets.symmetric(vertical: 1.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ExpansionTile(
                  title: const Text("Historial de pagos de cuotas"),
                  subtitle: const Text("Ver todos los pagos registrados"),
                  children: [
                    Obx(() {
                      if (pagoController.pagos.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
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
                        );
                      }

                      return Column(
                        children: [
                          // Resumen de pagos
                          Card(
                            color: Colors.blue.shade50,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          "Total Pagos",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.blue.shade700,
                                          ),
                                        ),
                                        Text(
                                          "${pagoController.pagos.length}",
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue.shade800,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          "Total Recaudado",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.blue.shade700,
                                          ),
                                        ),
                                        Text(
                                          "\$${pagoController.pagos.fold(0.0, (sum, pago) => sum + pago.montoPagado).toStringAsFixed(2)}",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue.shade800,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Lista de pagos
                          ...pagoController.pagos.map((pago) {
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 4),
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
                                  ),
                                ),
                                title: Text(
                                  "${pago.nombreSocio}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${pago.nombreMes} ${pago.anio} - \$${pago.montoPagado.toStringAsFixed(2)}",
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
                                    Text(
                                      "N° ${pago.numeroSocio}",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    if (pago.pagoParcial)
                                      Text(
                                        "Parcial",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.orange,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
