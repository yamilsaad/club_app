import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socio_app/src/presentation/views/admi_views/controllers/cuota_controller.dart';

class GestionCuotaSection extends StatelessWidget {
  const GestionCuotaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 2.5),
      child: ExpansionTile(
        title: Text("Configuración de cuota mensual"),
        children: [
          Obx(() {
            final controller = Get.find<CuotaController>();
            return Column(
              children: [
                Text(
                  "Monto actual: ${controller.cuotaActual.value} ${controller.moneda.value}",
                ),
                Text("Notas: ${controller.observaciones.value}"),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // Aquí abrimos un diálogo para registrar nueva cuota
                    showDialog(
                      context: context,
                      builder: (_) {
                        final montoController = TextEditingController();
                        final observacionController = TextEditingController();
                        return AlertDialog(
                          title: Text("Registrar nueva cuota"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: montoController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(labelText: "Monto"),
                              ),
                              TextField(
                                controller: observacionController,
                                decoration: InputDecoration(
                                  labelText: "Observaciones",
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("Cancelar"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                final monto =
                                    double.tryParse(montoController.text) ??
                                    0.0;
                                final observaciones =
                                    observacionController.text;
                                final cuotaCtrl = Get.find<CuotaController>();
                                cuotaCtrl.registrarNuevaCuota(
                                  monto: monto,
                                  observaciones: observaciones,
                                  adminUid:
                                      "admin_demo_uid", // luego usamos el real
                                );
                                Navigator.pop(context);
                              },
                              child: Text("Guardar"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text("Actualizar cuota"),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
