import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socio_app/src/presentation/screens/configuracion_cuota_screen/controllers/configuracion_cuota_controller.dart';
import '../../../data/models/model.dart';

class ConfiguracionCuotaScreen extends StatelessWidget {
  final ConfiguracionCuotaController controller = Get.put(
    ConfiguracionCuotaController(),
  );

  ConfiguracionCuotaScreen({super.key});

  // Controladores para la nueva cuota
  final TextEditingController montoController = TextEditingController();
  final TextEditingController notasController = TextEditingController();
  final TextEditingController recargoController = TextEditingController();
  final TextEditingController mesController = TextEditingController();

  // Controladores para registrar pagos
  final TextEditingController socioIdController = TextEditingController();
  final TextEditingController pagoMontoController = TextEditingController();
  final TextEditingController metodoPagoController = TextEditingController();

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
            // Listado de cuotas existentes
            // ====================
            ...controller.cuotas.map(
              (cuota) => Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  title: Text(
                    "Mes: ${cuota.mes} - Monto: \$${cuota.monto.toStringAsFixed(2)}",
                  ),
                  subtitle: Text(
                    "Vencimiento: ${cuota.fechaVencimiento.toLocal()} - Recargo: ${cuota.recargo ?? 0}",
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // Cargar datos en formulario para edición
                      montoController.text = cuota.monto.toString();
                      notasController.text = cuota.notas ?? "";
                      recargoController.text = (cuota.recargo ?? 0).toString();
                      mesController.text = cuota.mes.toString();

                      Get.defaultDialog(
                        title: "Editar cuota",
                        content: Column(
                          children: [
                            TextField(
                              controller: mesController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: "Mes (1-12)",
                              ),
                            ),
                            TextField(
                              controller: montoController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: "Monto",
                              ),
                            ),
                            TextField(
                              controller: recargoController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: "Recargo",
                              ),
                            ),
                            TextField(
                              controller: notasController,
                              decoration: const InputDecoration(
                                labelText: "Notas",
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                final updatedCuota = CuotaMensual(
                                  id: cuota.id,
                                  mes:
                                      int.tryParse(mesController.text) ??
                                      cuota.mes,
                                  monto:
                                      double.tryParse(montoController.text) ??
                                      cuota.monto,
                                  fechaVencimiento: DateTime.now().add(
                                    const Duration(days: 30),
                                  ),
                                  recargo: double.tryParse(
                                    recargoController.text,
                                  ),
                                  notas: notasController.text,
                                );
                                controller.saveCuota(updatedCuota);
                                Get.back();
                                Get.snackbar("Éxito", "Cuota actualizada");
                              },
                              child: const Text("Guardar cambios"),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ====================
            // Formulario para agregar nueva cuota
            // ====================
            if (controller.cuotas.length < 6)
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
                      TextField(
                        controller: montoController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: "Monto"),
                      ),
                      TextField(
                        controller: recargoController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Recargo (opcional)",
                        ),
                      ),
                      TextField(
                        controller: notasController,
                        decoration: const InputDecoration(labelText: "Notas"),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          final nuevaCuota = CuotaMensual(
                            id:
                                DateTime.now().millisecondsSinceEpoch
                                    .toString(),
                            mes: int.tryParse(mesController.text) ?? 1,
                            monto: double.tryParse(montoController.text) ?? 0,
                            fechaVencimiento: DateTime.now().add(
                              const Duration(days: 30),
                            ),
                            recargo: double.tryParse(recargoController.text),
                            notas: notasController.text,
                          );
                          controller.saveCuota(nuevaCuota);

                          // Limpiar campos
                          mesController.clear();
                          montoController.clear();
                          recargoController.clear();
                          notasController.clear();

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
                  title: const Text("Registrar pago de socio"),
                  children: [
                    TextField(
                      controller: socioIdController,
                      decoration: const InputDecoration(
                        labelText: "ID de socio",
                      ),
                    ),
                    TextField(
                      controller: pagoMontoController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Monto pagado",
                      ),
                    ),
                    TextField(
                      controller: metodoPagoController,
                      decoration: const InputDecoration(
                        labelText: "Método de pago",
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        final pago = PagoSocio(
                          id: '',
                          socioId: socioIdController.text.trim(),
                          monto: double.tryParse(pagoMontoController.text) ?? 0,
                          fechaPago: DateTime.now(),
                          metodo: metodoPagoController.text.trim(),
                        );
                        controller.registrarPago(pago);
                        socioIdController.clear();
                        pagoMontoController.clear();
                        metodoPagoController.clear();
                        Get.snackbar("Éxito", "Pago registrado");
                      },
                      child: const Text("Registrar pago"),
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
                  title: const Text("Historial de pagos"),
                  children: [
                    Obx(() {
                      if (controller.pagos.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text("No hay pagos registrados"),
                        );
                      }
                      return Column(
                        children:
                            controller.pagos.map((pago) {
                              return Card(
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                child: ListTile(
                                  title: Text("Socio: ${pago.socioId}"),
                                  subtitle: Text(
                                    "Monto: \$${pago.monto.toStringAsFixed(2)} - ${pago.fechaPago.toLocal()}",
                                  ),
                                  trailing: Text(
                                    pago.metodo ?? "",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
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
