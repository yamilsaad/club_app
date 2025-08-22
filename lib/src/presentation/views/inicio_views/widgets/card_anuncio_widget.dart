import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:socio_app/src/config/themes/app_theme.dart';
import 'package:socio_app/src/data/models/eventos_model.dart';
import 'package:socio_app/src/presentation/views/eventos_views/controllers/eventos_controller.dart';

class CardAnuncioWidget extends StatefulWidget {
  const CardAnuncioWidget({super.key});

  @override
  State<CardAnuncioWidget> createState() => _CardAnuncioWidgetState();
}

class _CardAnuncioWidgetState extends State<CardAnuncioWidget> {
  final EventosController eventosController = Get.find<EventosController>();
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          // Anuncio destacado
          _buildFeaturedAnnouncement(),

          const SizedBox(height: 16),

          // Lista de anuncios recientes
          _buildRecentAnnouncements(),
        ],
      ),
    );
  }

  Widget _buildFeaturedAnnouncement() {
    return Obx(() {
      final eventosDestacados = eventosController.eventosDestacados;
      
      if (eventosDestacados.isEmpty) {
        return _buildEmptyFeaturedAnnouncement();
      }

      return Column(
        children: [
          // Header del anuncio destacado
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppTheme.accentGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.star, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'ANUNCIOS DESTACADOS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // PageView para eventos destacados
                SizedBox(
                  height: 120,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: eventosDestacados.length,
                    itemBuilder: (context, index) {
                      final evento = eventosDestacados[index];
                      return _buildEventoDestacadoCard(evento);
                    },
                  ),
                ),
                
                // Indicadores de página (dots)
                if (eventosDestacados.length > 1) ...[
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      eventosDestacados.length,
                      (index) => _buildPageIndicator(index),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildEventoDestacadoCard(Evento evento) {
    return InkWell(
      onTap: () => _mostrarDetalleEvento(evento),
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              evento.titulo,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              evento.detalle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _formatearFecha(evento.fecha),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyFeaturedAnnouncement() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.accentGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.star, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'ANUNCIO DESTACADO',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            '¡Nueva funcionalidad disponible!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Ahora puedes gestionar tus cuotas y pagos directamente desde la app. Mantente al día con tu membresía.',
            style: TextStyle(color: Colors.white, fontSize: 14, height: 1.4),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'NUEVO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index
            ? Colors.white
            : Colors.white.withOpacity(0.4),
      ),
    );
  }

  String _formatearFecha(DateTime fecha) {
    return '${fecha.day}/${fecha.month}/${fecha.year}';
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

  Widget _buildRecentAnnouncements() {
    return Obx(() {
      final eventosProgramados = eventosController.eventosProgramados;
      
      if (eventosProgramados.isEmpty) {
        return _buildEmptyRecentAnnouncements();
      }

      return Column(
        children: [
          ...eventosProgramados.take(2).map((evento) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () => _mostrarDetalleEvento(evento),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade100, width: 1),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.successColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: FaIcon(
                          FontAwesomeIcons.calendar,
                          color: AppTheme.successColor,
                          size: 18,
                        ),
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              evento.titulo,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.textPrimaryColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              evento.detalle,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.textSecondaryColor,
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _formatearTiempoRelativo(evento.fecha),
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.textSecondaryColor.withOpacity(0.7),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      FaIcon(
                        FontAwesomeIcons.angleRight,
                        color: AppTheme.textSecondaryColor.withOpacity(0.5),
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
          
          // Botón "Ver más" si hay más de 2 eventos
          if (eventosProgramados.length > 2) ...[
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () {
                  Get.toNamed('/eventos-programados');
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Ver ${eventosProgramados.length - 2} eventos más',
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward,
                      color: AppTheme.primaryColor,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      );
    });
  }

  Widget _buildEmptyRecentAnnouncements() {
    final List<Map<String, dynamic>> announcements = [
      {
        'title': 'Mantenimiento programado',
        'description':
            'El sistema estará en mantenimiento el próximo domingo de 2:00 AM a 6:00 AM.',
        'icon': FontAwesomeIcons.wrench,
        'color': AppTheme.warningColor,
        'time': 'Hace 2 horas',
      },
      {
        'title': 'Evento especial este fin de semana',
        'description':
            'No te pierdas nuestro evento especial con descuentos exclusivos para socios.',
        'icon': FontAwesomeIcons.calendar,
        'color': AppTheme.successColor,
        'time': 'Hace 1 día',
      },
    ];

    return Column(
      children: announcements.map((Map<String, dynamic> announcement) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade100, width: 1),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: (announcement['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: FaIcon(
                    announcement['icon'] as IconData,
                    color: announcement['color'] as Color,
                    size: 18,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        announcement['title'] as String,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        announcement['description'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondaryColor,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        announcement['time'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondaryColor.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                FaIcon(
                  FontAwesomeIcons.angleRight,
                  color: AppTheme.textSecondaryColor.withOpacity(0.5),
                  size: 16,
                ),
              ],
            ),
          ),
        );
      }).toList(),
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
                      // Aquí podrías agregar más acciones como compartir, etc.
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

  String _formatearFechaCompleta(DateTime fecha) {
    final meses = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    
    return '${fecha.day} de ${meses[fecha.month - 1]} de ${fecha.year}';
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
