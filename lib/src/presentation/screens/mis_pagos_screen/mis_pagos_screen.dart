// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
//Importacion de archivos necesarios
import '../../screens/configuracion_cuota_screen/controllers/pago_cuota_controller.dart';
import '../../screens/auth_screen/controllers/auth_controller.dart';
import '../../../config/themes/app_theme.dart';

class MisPagosScreen extends StatefulWidget {
  const MisPagosScreen({super.key});

  @override
  State<MisPagosScreen> createState() => _MisPagosScreenState();
}

class _MisPagosScreenState extends State<MisPagosScreen>
    with TickerProviderStateMixin {
  final PagoCuotaController pagoController = Get.put(PagoCuotaController());
  final AuthController authController = Get.find<AuthController>();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();

    // Cargar datos del socio actual
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarDatosSocio();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
      return AppTheme.errorColor; // Vencida
    } else if (fechaVencimiento.isBefore(ahora.add(const Duration(days: 30)))) {
      return AppTheme.warningColor; // Por vencer
    } else {
      return AppTheme.successColor; // Vigente
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
      backgroundColor: AppTheme.backgroundColor,
      appBar: _buildAppBar(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Obx(() {
            final socio = authController.currentUser.value;

            if (socio == null) {
              return _buildLoadingState();
            }

            // Verificar que los datos estén cargados
            if (pagoController.socios.isEmpty ||
                pagoController.cuotas.isEmpty) {
              return _buildLoadingState();
            }

            // Obtener estado de pagos del socio
            final estadoPagos = pagoController.getEstadoPagosSocio(
              socio.idUsuario!,
            );
            final pagosSocio = pagoController.getPagosPorSocio(
              socio.idUsuario!,
            );

            // Debug: verificar que los datos se obtuvieron correctamente
            print("Estado pagos obtenido: ${estadoPagos.length} elementos");
            print("Pagos socio obtenidos: ${pagosSocio.length} pagos");

            return RefreshIndicator(
              onRefresh: () async {
                await pagoController.loadPagos();
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Información del socio
                    _buildSocioCard(socio),

                    const SizedBox(height: 24),

                    // Resumen del estado de pagos
                    _buildResumenCard(estadoPagos),

                    const SizedBox(height: 24),

                    // Historial de pagos realizados
                    _buildHistorialCard(pagosSocio),

                    const SizedBox(height: 24),

                    // Estado de cuotas por mes
                    _buildEstadoCuotasCard(pagosSocio),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: const Text(
        "Mis Pagos de Cuotas",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppTheme.textPrimaryColor,
        ),
      ),
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: AppTheme.textPrimaryColor,
        ),
        onPressed: () => Get.back(),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          child: IconButton(
            icon: const Icon(Icons.refresh, color: AppTheme.primaryColor),
            onPressed: () => pagoController.loadPagos(),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppTheme.primaryColor),
          SizedBox(height: 16),
          Text(
            "Cargando datos...",
            style: TextStyle(fontSize: 16, color: AppTheme.textSecondaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildSocioCard(dynamic socio) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.elevatedShadow,
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, size: 40, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            "${socio.nombre} ${socio.apellido}",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "Número de Socio: ${socio.numeroSocio}",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "DNI: ${socio.dni}",
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResumenCard(Map<String, dynamic> estadoPagos) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.analytics,
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "Resumen del Año ${DateTime.now().year}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Métricas principales
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    "Cuotas Pagadas",
                    estadoPagos["cuotasPagadas"].toString(),
                    AppTheme.successColor,
                    Icons.check_circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    "Cuotas Pendientes",
                    estadoPagos["cuotasPendientes"].toString(),
                    AppTheme.warningColor,
                    Icons.pending,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    "Total Cuotas",
                    estadoPagos["totalCuotas"].toString(),
                    AppTheme.primaryColor,
                    Icons.list_alt,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Resumen financiero
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200, width: 1),
              ),
              child: Column(
                children: [
                  _buildFinancialRow(
                    "Total Pagado:",
                    "\$${estadoPagos["totalPagado"].toStringAsFixed(2)}",
                    AppTheme.successColor,
                  ),
                  const SizedBox(height: 12),
                  _buildFinancialRow(
                    "Total Debido:",
                    "\$${estadoPagos["totalDebido"].toStringAsFixed(2)}",
                    AppTheme.primaryColor,
                  ),
                  const SizedBox(height: 12),
                  _buildFinancialRow(
                    "Monto Pendiente:",
                    "\$${estadoPagos["montoPendiente"].toStringAsFixed(2)}",
                    estadoPagos["montoPendiente"] > 0
                        ? AppTheme.warningColor
                        : AppTheme.successColor,
                  ),
                  const SizedBox(height: 20),

                  // Barra de progreso
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Progreso de Pago",
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.textSecondaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "${estadoPagos["porcentajePago"].toStringAsFixed(1)}%",
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: estadoPagos["porcentajePago"] / 100,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          estadoPagos["porcentajePago"] >= 100
                              ? AppTheme.successColor
                              : AppTheme.primaryColor,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        minHeight: 8,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
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
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
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
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _buildHistorialCard(List pagosSocio) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: ExpansionTile(
        initiallyExpanded: false,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.history,
                color: AppTheme.accentColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              "Historial de Pagos",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
            ),
          ],
        ),
        subtitle: Text(
          "${pagosSocio.length} pago${pagosSocio.length == 1 ? '' : 's'} registrado${pagosSocio.length == 1 ? '' : 's'}",
          style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 14),
        ),
        children: [
          if (pagosSocio.isEmpty)
            _buildEmptyState(
              Icons.payment,
              "No hay pagos registrados",
              "Los pagos aparecerán aquí una vez que se registren",
            )
          else
            ...pagosSocio.map((pago) => _buildPagoItem(pago)).toList(),
        ],
      ),
    );
  }

  Widget _buildPagoItem(dynamic pago) {
    final isPagoTardio = pago.pagoTardio;
    final isPagoAnticipado = pago.fechaPago.isBefore(pago.fechaVencimiento);

    Color statusColor;
    IconData statusIcon;

    if (isPagoTardio) {
      statusColor = AppTheme.warningColor;
      statusIcon = Icons.warning;
    } else if (isPagoAnticipado) {
      statusColor = AppTheme.successColor;
      statusIcon = Icons.check;
    } else {
      statusColor = AppTheme.primaryColor;
      statusIcon = Icons.schedule;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(statusIcon, color: statusColor, size: 20),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${pago.nombreMes} ${pago.anio}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Monto: \$${pago.montoPagado.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  Text(
                    "Método: ${pago.metodoPago}",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  Text(
                    "Fecha: ${_formatearFecha(pago.fechaPago)}",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  if (pago.notas != null && pago.notas!.isNotEmpty)
                    Text(
                      "Notas: ${pago.notas}",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondaryColor.withOpacity(0.7),
                      ),
                    ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (pago.pagoParcial)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.warningColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Parcial",
                      style: TextStyle(
                        fontSize: 10,
                        color: AppTheme.warningColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    pago.estadoPago,
                    style: TextStyle(
                      fontSize: 10,
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEstadoCuotasCard(List pagosSocio) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: ExpansionTile(
        initiallyExpanded: false,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.secondaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.calendar_month,
                color: AppTheme.secondaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              "Estado de Cuotas por Mes",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimaryColor,
              ),
            ),
          ],
        ),
        subtitle: const Text(
          "Ver estado de cada cuota mensual",
          style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 14),
        ),
        children: [
          ...List.generate(12, (index) {
            final mes =
                12 - index; // Cambiamos el orden: empezamos desde diciembre
            final anio = DateTime.now().year;

            // Buscar si hay pago para este mes
            final pagoMes =
                pagosSocio
                    .where((p) => p.mes == mes && p.anio == anio)
                    .toList();

            // Buscar la cuota configurada para este mes
            final cuotaMes =
                pagoController.cuotas.where((c) => c.mes == mes).toList();

            if (cuotaMes.isEmpty) {
              return const SizedBox.shrink(); // No mostrar si no hay cuota configurada
            }

            final cuota = cuotaMes.first;
            final tienePago = pagoMes.isNotEmpty;
            final pago = tienePago ? pagoMes.first : null;

            return _buildCuotaItem(mes, cuota, tienePago, pago);
          }),
        ],
      ),
    );
  }

  Widget _buildCuotaItem(int mes, dynamic cuota, bool tienePago, dynamic pago) {
    final colorEstado =
        tienePago
            ? AppTheme.successColor
            : _obtenerColorEstado(cuota.fechaVencimiento);

    final iconoEstado =
        tienePago ? Icons.check : _obtenerIconoEstado(cuota.fechaVencimiento);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colorEstado.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(iconoEstado, color: colorEstado, size: 20),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _obtenerNombreMes(mes),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Monto: \$${cuota.monto.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  Text(
                    "Vencimiento: ${_formatearFecha(cuota.fechaVencimiento)}",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  if (tienePago) ...[
                    Text(
                      "PAGADO - ${_formatearFecha(pago!.fechaPago)}",
                      style: const TextStyle(
                        color: AppTheme.successColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    if (pago.pagoParcial)
                      Text(
                        "Pago parcial: \$${pago.montoPagado.toStringAsFixed(2)}",
                        style: TextStyle(
                          color: AppTheme.warningColor,
                          fontSize: 12,
                        ),
                      ),
                  ] else ...[
                    Text(
                      "PENDIENTE",
                      style: TextStyle(
                        color: colorEstado,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    if (cuota.fechaVencimiento.isBefore(DateTime.now()))
                      Text(
                        "VENCIDA",
                        style: const TextStyle(
                          color: AppTheme.errorColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: colorEstado.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                tienePago ? "PAGADO" : "PENDIENTE",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: colorEstado,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(
            icon,
            size: 64,
            color: AppTheme.textSecondaryColor.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: AppTheme.textSecondaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.textSecondaryColor.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
