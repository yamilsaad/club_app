import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socio_app/src/config/themes/app_theme.dart';
import 'package:socio_app/src/data/models/eventos_model.dart';
import 'package:socio_app/src/presentation/views/eventos_views/controllers/eventos_controller.dart';

class EventosView extends StatelessWidget {
  const EventosView({super.key});

  @override
  Widget build(BuildContext context) {
    final EventosController controller = Get.find<EventosController>();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Gestión de Eventos',
          style: TextStyle(
            color: AppTheme.textPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppTheme.surfaceColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.primaryColor),
      ),
      body: Obx(() {
        if (controller.estaCargando) {
          return const Center(
            child: CircularProgressIndicator(color: AppTheme.primaryColor),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Resumen de eventos
              _buildEventosSummary(controller),

              const SizedBox(height: 24),

              // Formulario de creación
              _buildCrearEventoForm(controller),

              const SizedBox(height: 32),

              // Lista de eventos
              _buildEventosList(controller),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCrearEventoDialog(context, controller),
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEventosSummary(EventosController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resumen de Eventos',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Destacados',
                  '${controller.eventosDestacados.length}/3',
                  AppTheme.warningColor,
                  Icons.star,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  'Programados',
                  '${controller.eventosProgramados.length}/24',
                  AppTheme.successColor,
                  Icons.event,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String count,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 8),
          Text(
            count,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCrearEventoForm(EventosController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.add_circle, color: AppTheme.primaryColor, size: 24),
              const SizedBox(width: 12),
              const Text(
                'Crear Nuevo Evento',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _showCrearEventoDialog(Get.context!, controller),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Crear Evento',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventosList(EventosController controller) {
    if (controller.eventos.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppTheme.cardShadow,
        ),
        child: const Center(
          child: Column(
            children: [
              Icon(
                Icons.event_busy,
                size: 64,
                color: AppTheme.textSecondaryColor,
              ),
              SizedBox(height: 16),
              Text(
                'No hay eventos creados',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Crea tu primer evento usando el botón +',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Eventos Creados',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: 16),
        ...controller.eventos.map(
          (evento) => _buildEventoCard(evento, controller),
        ),
      ],
    );
  }

  Widget _buildEventoCard(Evento evento, EventosController controller) {
    final bool esDestacado = evento.esDestacado;
    final Color tipoColor =
        esDestacado ? AppTheme.warningColor : AppTheme.successColor;
    final IconData tipoIcon = esDestacado ? Icons.star : Icons.event;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppTheme.cardShadow,
        border: Border.all(color: tipoColor.withOpacity(0.3), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: tipoColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(tipoIcon, color: tipoColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      evento.titulo,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                    Text(
                      evento.tipoEvento.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: tipoColor,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected:
                    (value) => _handleEventoAction(value, evento, controller),
                itemBuilder:
                    (context) => [
                      const PopupMenuItem(
                        value: 'editar',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 18),
                            SizedBox(width: 8),
                            Text('Editar'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'eliminar',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 18, color: Colors.red),
                            SizedBox(width: 8),
                            Text(
                              'Eliminar',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ],
                child: const Icon(
                  Icons.more_vert,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            evento.detalle,
            style: const TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 16,
                color: AppTheme.textSecondaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                _formatearFecha(evento.fecha),
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showCrearEventoDialog(
    BuildContext context,
    EventosController controller,
  ) {
    Get.dialog(
      CrearEventoDialog(controller: controller),
      barrierDismissible: false,
    );
  }

  void _handleEventoAction(
    String action,
    Evento evento,
    EventosController controller,
  ) {
    switch (action) {
      case 'editar':
        _showEditarEventoDialog(Get.context!, controller, evento);
        break;
      case 'eliminar':
        _confirmarEliminacion(evento, controller);
        break;
    }
  }

  void _showEditarEventoDialog(
    BuildContext context,
    EventosController controller,
    Evento evento,
  ) {
    Get.dialog(
      CrearEventoDialog(controller: controller, eventoAEditar: evento),
      barrierDismissible: false,
    );
  }

  void _confirmarEliminacion(Evento evento, EventosController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirmar Eliminación'),
        content: Text(
          '¿Estás seguro de que quieres eliminar el evento "${evento.titulo}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.eliminarEvento(evento.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  String _formatearFecha(DateTime fecha) {
    return '${fecha.day}/${fecha.month}/${fecha.year}';
  }
}

// Dialog para crear/editar eventos
class CrearEventoDialog extends StatefulWidget {
  final EventosController controller;
  final Evento? eventoAEditar;

  const CrearEventoDialog({
    super.key,
    required this.controller,
    this.eventoAEditar,
  });

  @override
  State<CrearEventoDialog> createState() => _CrearEventoDialogState();
}

class _CrearEventoDialogState extends State<CrearEventoDialog> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _detalleController = TextEditingController();
  final _urlImagenController = TextEditingController();

  String _tipoEventoSeleccionado = 'programado';
  DateTime _fechaSeleccionada = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.eventoAEditar != null) {
      _cargarDatosEvento();
    }
  }

  void _cargarDatosEvento() {
    final evento = widget.eventoAEditar!;
    _tituloController.text = evento.titulo;
    _detalleController.text = evento.detalle;
    _urlImagenController.text = evento.urlImagen;
    _tipoEventoSeleccionado = evento.tipoEvento;
    _fechaSeleccionada = evento.fecha;
  }

  @override
  Widget build(BuildContext context) {
    final bool esEdicion = widget.eventoAEditar != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 500,
          minWidth: 400,
          maxHeight: 700,
        ),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      esEdicion ? Icons.edit : Icons.add_circle,
                      color: AppTheme.primaryColor,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      esEdicion ? 'Editar Evento' : 'Crear Nuevo Evento',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Campo Título
                TextFormField(
                  controller: _tituloController,
                  decoration: InputDecoration(
                    labelText: 'Título del Evento',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.title),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa un título';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Campo Detalle
                TextFormField(
                  controller: _detalleController,
                  decoration: InputDecoration(
                    labelText: 'Detalle del Evento',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.description),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa un detalle';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Campo Tipo de Evento
                DropdownButtonFormField<String>(
                  value: _tipoEventoSeleccionado,
                  decoration: InputDecoration(
                    labelText: 'Tipo de Evento',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.category),
                  ),
                  items: [
                    DropdownMenuItem(
                      value: 'programado',
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.event,
                            color: AppTheme.successColor,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Text('Programado'),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.successColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${widget.controller.obtenerLimiteDisponible('programado')} disponibles',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppTheme.successColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'destacado',
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star,
                            color: AppTheme.warningColor,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          const Text('Destacado'),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.warningColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${widget.controller.obtenerLimiteDisponible('destacado')} disponibles',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppTheme.warningColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _tipoEventoSeleccionado = value;
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor selecciona un tipo';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Campo Fecha
                InkWell(
                  onTap: () => _seleccionarFecha(context),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Fecha del Evento',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      _formatearFecha(_fechaSeleccionada),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Campo URL de Imagen
                TextFormField(
                  controller: _urlImagenController,
                  decoration: InputDecoration(
                    labelText: 'URL de la Imagen',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.image),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa una URL de imagen';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Botones de acción
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Cancelar'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _guardarEvento,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: const Size(120, 48),
                      ),
                      child:
                          _isLoading
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                              : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    esEdicion ? Icons.save : Icons.add,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    esEdicion ? 'Actualizar' : 'Crear',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? fechaSeleccionada = await showDatePicker(
      context: context,
      initialDate: _fechaSeleccionada,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (fechaSeleccionada != null) {
      setState(() {
        _fechaSeleccionada = fechaSeleccionada;
      });
    }
  }

  Future<void> _guardarEvento() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final Evento evento = Evento(
        id: widget.eventoAEditar?.id ?? '',
        titulo: _tituloController.text.trim(),
        detalle: _detalleController.text.trim(),
        fecha: _fechaSeleccionada,
        urlImagen: _urlImagenController.text.trim(),
        tipoEvento: _tipoEventoSeleccionado,
        fechaCreacion: widget.eventoAEditar?.fechaCreacion ?? DateTime.now(),
        creadoPor:
            widget.eventoAEditar?.creadoPor ??
            'admin', // TODO: Obtener del usuario actual
      );

      bool exito;
      if (widget.eventoAEditar != null) {
        exito = await widget.controller.actualizarEvento(evento);
      } else {
        exito = await widget.controller.crearEvento(evento);
      }

      if (exito) {
        Get.back();
        Get.snackbar(
          'Éxito',
          widget.eventoAEditar != null
              ? 'Evento actualizado correctamente'
              : 'Evento creado correctamente',
          backgroundColor: AppTheme.successColor,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          widget.controller.errorMessage.value,
          backgroundColor: AppTheme.errorColor,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatearFecha(DateTime fecha) {
    return '${fecha.day}/${fecha.month}/${fecha.year}';
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _detalleController.dispose();
    _urlImagenController.dispose();
    super.dispose();
  }
}
