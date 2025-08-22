import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socio_app/src/config/themes/app_theme.dart';
import '../../../screens/configuracion_cuota_screen/controllers/pago_cuota_controller.dart';
import '../../../screens/auth_screen/controllers/auth_controller.dart';

class CuotasSocioWidget extends StatefulWidget {
  const CuotasSocioWidget({super.key});

  @override
  State<CuotasSocioWidget> createState() => _CuotasSocioWidgetState();
}

class _CuotasSocioWidgetState extends State<CuotasSocioWidget> {
  final PagoCuotaController pagoController = Get.find<PagoCuotaController>();
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Obx(() {
          final socio = authController.currentUser.value;
          if (socio == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppTheme.primaryColor),
            );
          }

          // Obtener estado de pagos del socio
          final estadoPagos = pagoController.getEstadoPagosSocio(
            socio.idUsuario!,
          );
          final pagosSocio = pagoController.getPagosPorSocio(socio.idUsuario!);

          // Filtrar solo cuotas pendientes y vencidas
          final cuotasPendientes = _obtenerCuotasPendientes(pagosSocio);

          return Column(
            children: [
              // Resumen de cuotas
              _buildSummary(estadoPagos),

              const SizedBox(height: 20),

              // Lista de cuotas pendientes o mensaje
              _buildCuotasList(cuotasPendientes),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildSummary(Map<String, dynamic> estadoPagos) {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            'Pendientes',
            estadoPagos["cuotasPendientes"].toString(),
            AppTheme.warningColor,
            Icons.schedule,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            'Vencidas',
            _contarCuotasVencidas().toString(),
            AppTheme.errorColor,
            Icons.warning,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            'Total a Pagar',
            '\$${estadoPagos["montoPendiente"].toStringAsFixed(2)}',
            AppTheme.primaryColor,
            Icons.account_balance_wallet,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String title,
    String count,
    Color color,
    IconData icon,
  ) {
    // Determinar si es la tarjeta "Total a Pagar" para ajustar el tamaño
    final isTotalAPagar = title == 'Total a Pagar';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            count,
            style: TextStyle(
              fontSize:
                  isTotalAPagar ? 18 : 24, // Más pequeño para "Total a Pagar"
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildCuotasList(List<dynamic> cuotasPendientes) {
    // Si no hay cuotas pendientes, mostrar mensaje de "al día"
    if (cuotasPendientes.isEmpty) {
      return _buildAlDiaMessage();
    }

    return Column(
      children: [
        // Título de la lista
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Text(
                'Cuotas que requieren atención:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
        ),
        // Lista de cuotas pendientes
        ...cuotasPendientes.map((cuota) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade100, width: 1),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _obtenerColorEstado(
                        cuota.fechaVencimiento,
                      ).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _obtenerIconoEstado(cuota.fechaVencimiento),
                      color: _obtenerColorEstado(cuota.fechaVencimiento),
                      size: 20,
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _obtenerNombreMes(cuota.mes),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Vence: ${_formatearFecha(cuota.fechaVencimiento)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${cuota.monto.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _obtenerColorEstado(
                            cuota.fechaVencimiento,
                          ).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _obtenerEstadoTexto(cuota.fechaVencimiento),
                          style: TextStyle(
                            fontSize: 12,
                            color: _obtenerColorEstado(cuota.fechaVencimiento),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildAlDiaMessage() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppTheme.successGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.celebration, color: Colors.white, size: 32),
          ),
          const SizedBox(height: 16),
          const Text(
            '¡Estás al día!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Todas tus cuotas están pagadas al corriente',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Métodos auxiliares para procesar datos reales
  List<dynamic> _obtenerCuotasPendientes(List pagosSocio) {
    final List<dynamic> cuotasPendientes = [];

    // Generar cuotas para los 12 meses del año actual
    for (int mes = 1; mes <= 12; mes++) {
      final anio = DateTime.now().year;

      // Buscar si hay pago para este mes
      final pagoMes =
          pagosSocio.where((p) => p.mes == mes && p.anio == anio).toList();

      // Buscar la cuota configurada para este mes
      final cuotaMes =
          pagoController.cuotas.where((c) => c.mes == mes).toList();

      if (cuotaMes.isNotEmpty) {
        final cuota = cuotaMes.first;
        final tienePago = pagoMes.isNotEmpty;

        // Solo agregar si no tiene pago (está pendiente o vencida)
        if (!tienePago) {
          cuotasPendientes.add(cuota);
        }
      }
    }

    return cuotasPendientes;
  }

  int _contarCuotasVencidas() {
    final socio = authController.currentUser.value;
    if (socio == null) return 0;

    final pagosSocio = pagoController.getPagosPorSocio(socio.idUsuario!);
    int contador = 0;

    for (int mes = 1; mes <= 12; mes++) {
      final anio = DateTime.now().year;
      final pagoMes =
          pagosSocio.where((p) => p.mes == mes && p.anio == anio).toList();
      final cuotaMes =
          pagoController.cuotas.where((c) => c.mes == mes).toList();

      if (cuotaMes.isNotEmpty && pagoMes.isEmpty) {
        final cuota = cuotaMes.first;
        if (cuota.fechaVencimiento.isBefore(DateTime.now())) {
          contador++;
        }
      }
    }

    return contador;
  }

  String _formatearFecha(DateTime fecha) {
    return '${fecha.day}/${fecha.month}/${fecha.year}';
  }

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

  Color _obtenerColorEstado(DateTime fechaVencimiento) {
    final ahora = DateTime.now();
    if (fechaVencimiento.isBefore(ahora)) {
      return AppTheme.errorColor; // Vencida
    } else if (fechaVencimiento.isBefore(ahora.add(const Duration(days: 30)))) {
      return AppTheme.warningColor; // Por vencer
    } else {
      return AppTheme.successColor; // Vigente
    }
  }

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

  String _obtenerEstadoTexto(DateTime fechaVencimiento) {
    final ahora = DateTime.now();
    if (fechaVencimiento.isBefore(ahora)) {
      return "VENCIDA";
    } else if (fechaVencimiento.isBefore(ahora.add(const Duration(days: 30)))) {
      return "PENDIENTE";
    } else {
      return "VIGENTE";
    }
  }
}
