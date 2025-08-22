import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socio_app/src/config/themes/app_theme.dart';
import 'package:socio_app/src/data/models/eventos_model.dart';
import 'package:socio_app/src/presentation/views/eventos_views/controllers/eventos_controller.dart';

class EventosSociosView extends StatefulWidget {
  const EventosSociosView({super.key});

  @override
  State<EventosSociosView> createState() => _EventosSociosViewState();
}

class _EventosSociosViewState extends State<EventosSociosView>
    with TickerProviderStateMixin {
  final EventosController eventosController = Get.find<EventosController>();
  late TabController _tabController;
  DateTime _fechaSeleccionada = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Eventos',
          style: TextStyle(
            color: AppTheme.textPrimaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: AppTheme.textSecondaryColor,
          indicatorColor: AppTheme.primaryColor,
          tabs: const [
            Tab(
              icon: Icon(Icons.calendar_month),
              text: 'Calendario',
            ),
            Tab(
              icon: Icon(Icons.list),
              text: 'Lista',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCalendarioTab(),
          _buildListaTab(),
        ],
      ),
    );
  }

  Widget _buildCalendarioTab() {
    return Obx(() {
      final eventos = eventosController.eventos;
      
      return SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header del calendario
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: AppTheme.elevatedShadow,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.calendar_month,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          'Calendario de Eventos',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Total',
                          '${eventos.length}',
                          Icons.event,
                          Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          'Destacados',
                          '${eventosController.eventosDestacados.length}',
                          Icons.star,
                          Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          'Próximos',
                          '${eventosController.eventosProximos.length}',
                          Icons.upcoming,
                          Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Calendario
            _buildCalendario(eventos),
            
            const SizedBox(height: 24),
            
            // Leyenda del calendario
            _buildLeyendaCalendario(),
          ],
        ),
      );
    });
  }

  Widget _buildCalendario(List<Evento> eventos) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.cardShadow,
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_obtenerNombreMes(_fechaSeleccionada.month)} ${_fechaSeleccionada.year}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 20),
          
          // Navegación del calendario
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _fechaSeleccionada = DateTime(
                      _fechaSeleccionada.year,
                      _fechaSeleccionada.month - 1,
                    );
                  });
                },
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.chevron_left, color: AppTheme.primaryColor),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _fechaSeleccionada = DateTime(
                      _fechaSeleccionada.year,
                      _fechaSeleccionada.month + 1,
                    );
                  });
                },
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.chevron_right, color: AppTheme.primaryColor),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Días de la semana
          Row(
            children: ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom']
                .map((dia) => Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          dia,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          
          // Días del mes
          _buildDiasDelMes(eventos),
        ],
      ),
    );
  }

  Widget _buildDiasDelMes(List<Evento> eventos) {
    final primerDia = DateTime(_fechaSeleccionada.year, _fechaSeleccionada.month, 1);
    final ultimoDia = DateTime(_fechaSeleccionada.year, _fechaSeleccionada.month + 1, 0);
    final diasEnMes = ultimoDia.day;
    
    // Ajustar para que la semana empiece en lunes (1 = lunes, 7 = domingo)
    int primerDiaSemana = primerDia.weekday;
    if (primerDiaSemana == 7) primerDiaSemana = 0; // Domingo = 0
    
    final List<Widget> dias = [];
    
    // Agregar días vacíos al inicio
    for (int i = 0; i < primerDiaSemana; i++) {
      dias.add(const Expanded(child: SizedBox()));
    }
    
    // Agregar días del mes
    for (int dia = 1; dia <= diasEnMes; dia++) {
      final fecha = DateTime(_fechaSeleccionada.year, _fechaSeleccionada.month, dia);
      final eventosDelDia = _obtenerEventosDelDia(eventos, fecha);
      final esHoy = _esHoy(fecha);
      
      dias.add(
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(2),
            child: InkWell(
              onTap: eventosDelDia.isNotEmpty ? () => _mostrarEventosDelDia(eventosDelDia, fecha) : null,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _obtenerColorDia(eventosDelDia, esHoy),
                  borderRadius: BorderRadius.circular(8),
                  border: esHoy ? Border.all(color: AppTheme.primaryColor, width: 2) : null,
                ),
                child: Column(
                  children: [
                    Text(
                      '$dia',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _obtenerColorTextoDia(eventosDelDia, esHoy),
                      ),
                    ),
                    if (eventosDelDia.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: _obtenerColorTextoDia(eventosDelDia, esHoy),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
    
    // Calcular cuántas filas necesitamos
    final filas = ((primerDiaSemana + diasEnMes - 1) / 7).ceil();
    
    return Column(
      children: List.generate(filas, (index) {
        final inicio = index * 7;
        final fin = (inicio + 7).clamp(0, dias.length);
        return Row(
          children: dias.sublist(inicio, fin),
        );
      }),
    );
  }

  Color _obtenerColorDia(List<Evento> eventos, bool esHoy) {
    if (esHoy) {
      return AppTheme.primaryColor.withOpacity(0.1);
    }
    if (eventos.isNotEmpty) {
      final tieneDestacado = eventos.any((e) => e.esDestacado);
      if (tieneDestacado) {
        return AppTheme.accentColor.withOpacity(0.2);
      }
      return AppTheme.successColor.withOpacity(0.2);
    }
    return Colors.transparent;
  }

  Color _obtenerColorTextoDia(List<Evento> eventos, bool esHoy) {
    if (esHoy) {
      return AppTheme.primaryColor;
    }
    if (eventos.isNotEmpty) {
      return AppTheme.textPrimaryColor;
    }
    return AppTheme.textSecondaryColor;
  }

  List<Evento> _obtenerEventosDelDia(List<Evento> eventos, DateTime fecha) {
    return eventos.where((evento) {
      return evento.fecha.year == fecha.year &&
             evento.fecha.month == fecha.month &&
             evento.fecha.day == fecha.day;
    }).toList();
  }

  bool _esHoy(DateTime fecha) {
    final ahora = DateTime.now();
    return fecha.year == ahora.year &&
           fecha.month == ahora.month &&
           fecha.day == ahora.day;
  }

  Widget _buildLeyendaCalendario() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Leyenda del Calendario',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppTheme.primaryColor, width: 2),
                ),
              ),
              const SizedBox(width: 12),
              const Text('Hoy'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Center(
                  child: Icon(Icons.star, size: 12, color: AppTheme.accentColor),
                ),
              ),
              const SizedBox(width: 12),
              const Text('Eventos Destacados'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: AppTheme.successColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 12),
              const Text('Eventos Programados'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildListaTab() {
    return Obx(() {
      final eventos = eventosController.eventos;
      
      if (eventos.isEmpty) {
        return _buildEmptyState();
      }

      return ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Eventos Destacados
          if (eventosController.eventosDestacados.isNotEmpty) ...[
            _buildSeccionTitulo('Eventos Destacados', Icons.star, AppTheme.accentColor),
            const SizedBox(height: 16),
            ...eventosController.eventosDestacados.map((evento) => _buildEventoCard(evento, true)),
            const SizedBox(height: 24),
          ],
          
          // Eventos Programados
          if (eventosController.eventosProgramados.isNotEmpty) ...[
            _buildSeccionTitulo('Eventos Programados', Icons.calendar_today, AppTheme.successColor),
            const SizedBox(height: 16),
            ...eventosController.eventosProgramados.map((evento) => _buildEventoCard(evento, false)),
          ],
        ],
      );
    });
  }

  Widget _buildSeccionTitulo(String titulo, IconData icono, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icono, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          titulo,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildEventoCard(Evento evento, bool esDestacado) {
    final ahora = DateTime.now();
    final diferencia = evento.fecha.difference(ahora);
    final esProximo = diferencia.inDays <= 7 && diferencia.inDays >= 0;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
        border: esDestacado 
            ? Border.all(color: AppTheme.accentColor.withOpacity(0.3), width: 2)
            : esProximo 
                ? Border.all(color: AppTheme.successColor.withOpacity(0.3), width: 2)
                : null,
      ),
      child: InkWell(
        onTap: () => _mostrarDetalleEvento(evento),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con fecha y estado
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: esDestacado 
                          ? AppTheme.accentColor.withOpacity(0.1)
                          : AppTheme.successColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      esDestacado ? Icons.star : Icons.calendar_today,
                      color: esDestacado 
                          ? AppTheme.accentColor
                          : AppTheme.successColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatearFechaCompleta(evento.fecha),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatearTiempoRelativo(evento.fecha),
                          style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (esDestacado)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.accentColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'DESTACADO',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                    )
                  else if (esProximo)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.successColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'PRÓXIMO',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Título del evento
              Text(
                evento.titulo,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Detalle del evento
              Text(
                evento.detalle,
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondaryColor,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 16),
              
              // Footer con acciones
              Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppTheme.textSecondaryColor.withOpacity(0.6),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Toca para ver más detalles',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondaryColor.withOpacity(0.6),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppTheme.primaryColor,
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: color.withOpacity(0.8),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              shape: BoxShape.circle,
              boxShadow: AppTheme.cardShadow,
            ),
            child: Icon(
              Icons.calendar_month_outlined,
              size: 64,
              color: AppTheme.textSecondaryColor.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No hay eventos disponibles',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Los eventos aparecerán aquí cuando sean creados',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _mostrarEventosDelDia(List<Evento> eventos, DateTime fecha) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 500,
              maxHeight: 600,
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.calendar_today,
                        color: AppTheme.primaryColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Eventos del ${_formatearFechaCompleta(fecha)}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textPrimaryColor,
                            ),
                          ),
                          Text(
                            '${eventos.length} evento${eventos.length == 1 ? '' : 's'}',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.textSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey.shade100,
                        shape: const CircleBorder(),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Lista de eventos
                Expanded(
                  child: ListView.builder(
                    itemCount: eventos.length,
                    itemBuilder: (context, index) {
                      final evento = eventos[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: evento.esDestacado 
                              ? AppTheme.accentColor.withOpacity(0.1)
                              : AppTheme.successColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: evento.esDestacado 
                                ? AppTheme.accentColor.withOpacity(0.3)
                                : AppTheme.successColor.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  evento.esDestacado ? Icons.star : Icons.calendar_today,
                                  color: evento.esDestacado 
                                      ? AppTheme.accentColor
                                      : AppTheme.successColor,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    evento.titulo,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.textPrimaryColor,
                                    ),
                                  ),
                                ),
                                if (evento.esDestacado)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppTheme.accentColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      'DESTACADO',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 8,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              evento.detalle,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.textSecondaryColor,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Botón de cerrar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Cerrar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _mostrarDetalleEvento(Evento evento) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 500,
              maxHeight: 600,
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header con icono y tipo de evento
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: evento.esDestacado 
                            ? AppTheme.accentColor.withOpacity(0.1)
                            : AppTheme.successColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        evento.esDestacado ? Icons.star : Icons.calendar_today,
                        color: evento.esDestacado 
                            ? AppTheme.accentColor
                            : AppTheme.successColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            evento.esDestacado ? 'EVENTO DESTACADO' : 'EVENTO PROGRAMADO',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textSecondaryColor,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatearTiempoRelativo(evento.fecha),
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey.shade100,
                        shape: const CircleBorder(),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Título del evento
                Text(
                  evento.titulo,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Fecha del evento
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: AppTheme.primaryColor,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatearFechaCompleta(evento.fecha),
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Detalle del evento
                Text(
                  'Detalles del Evento',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  evento.detalle,
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.textSecondaryColor,
                    height: 1.5,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Botón de acción
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Entendido',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _obtenerNombreMes(int mes) {
    const meses = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return meses[mes - 1];
  }

  String _formatearFechaCompleta(DateTime fecha) {
    final meses = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    
    return '${fecha.day} de ${meses[fecha.month - 1]} de ${fecha.year}';
  }

  String _formatearTiempoRelativo(DateTime fecha) {
    final ahora = DateTime.now();
    final diferencia = fecha.difference(ahora);
    
    if (diferencia.isNegative) {
      // Evento pasado
      final diasPasados = diferencia.inDays.abs();
      if (diasPasados == 0) {
        return 'Hoy';
      } else if (diasPasados == 1) {
        return 'Ayer';
      } else {
        return 'Hace $diasPasados días';
      }
    } else {
      // Evento futuro
      final diasFuturos = diferencia.inDays;
      if (diasFuturos == 0) {
        return 'Hoy';
      } else if (diasFuturos == 1) {
        return 'Mañana';
      } else if (diasFuturos < 7) {
        return 'En $diasFuturos días';
      } else if (diasFuturos < 30) {
        final semanas = (diasFuturos / 7).floor();
        return 'En $semanas semanas';
      } else {
        final meses = (diasFuturos / 30).floor();
        return 'En $meses meses';
      }
    }
  }
}
