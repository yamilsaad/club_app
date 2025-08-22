import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/themes/app_theme.dart';
import '../../../data/models/socio_model.dart';
import '../../screens/auth_screen/controllers/auth_controller.dart';
import '../../screens/home_screen/controllers/socio_controller.dart';

class GestionSociosView extends StatefulWidget {
  const GestionSociosView({super.key});

  @override
  State<GestionSociosView> createState() => _GestionSociosViewState();
}

class _GestionSociosViewState extends State<GestionSociosView>
    with TickerProviderStateMixin {
  final SocioController _socioController = Get.find();
  final AuthController _authController = Get.find();
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Gestión de Socios',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderCard(),
                  const SizedBox(height: 24),
                  Expanded(
                    child: _buildListaSocios(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor.withOpacity(0.1),
            AppTheme.accentColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.group,
              color: AppTheme.primaryColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Gestión de Socios',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Obx(() {
                  final totalSocios = _socioController.sociosList.length;
                  final sociosActivos = _socioController.sociosList
                      .where((socio) => socio.estadoSocio)
                      .length;
                  
                  return Text(
                    '$totalSocios socio${totalSocios == 1 ? '' : 's'} total, $sociosActivos activo${sociosActivos == 1 ? '' : 's'}',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondaryColor,
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListaSocios() {
    return Obx(() {
      final socios = _socioController.sociosList;
      
      if (socios.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.group_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              const Text(
                'No hay socios registrados',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Los nuevos socios se registran desde la pantalla de registro',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        itemCount: socios.length,
        itemBuilder: (context, index) {
          final socio = socios[index];
          return _buildSocioCard(socio);
        },
      );
    });
  }

  Widget _buildSocioCard(SocioModel socio) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: socio.estadoSocio 
              ? AppTheme.successColor.withOpacity(0.3)
              : Colors.orange.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                  child: Text(
                    '${socio.nombre[0]}${socio.apellido[0]}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${socio.nombre} ${socio.apellido}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Socio #${socio.numeroSocio}',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: socio.estadoSocio 
                        ? AppTheme.successColor.withOpacity(0.2)
                        : Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    socio.estadoSocio ? 'Activo' : 'Inactivo',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: socio.estadoSocio 
                          ? AppTheme.successColor
                          : Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildInfoItem(Icons.email, socio.email),
                const SizedBox(width: 24),
                _buildInfoItem(Icons.phone, socio.telefono),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildInfoItem(Icons.badge, socio.dni),
                const SizedBox(width: 24),
                _buildInfoItem(Icons.work, socio.oficio),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: socio.rol == 'admin' 
                        ? AppTheme.primaryColor.withOpacity(0.2)
                        : AppTheme.accentColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    socio.rol.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: socio.rol == 'admin' 
                          ? AppTheme.primaryColor
                          : AppTheme.accentColor,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  'Creado: ${socio.fechaCreacion.day}/${socio.fechaCreacion.month}/${socio.fechaCreacion.year}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: OutlinedButton.icon(
                      onPressed: () => _editarSocio(socio),
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text('Editar', style: TextStyle(fontSize: 12)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primaryColor,
                        side: BorderSide(color: AppTheme.primaryColor),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: ElevatedButton.icon(
                      onPressed: () => _cambiarEstadoSocio(socio),
                      icon: Icon(
                        socio.estadoSocio ? Icons.block : Icons.check_circle,
                        size: 18,
                      ),
                      label: Text(
                        socio.estadoSocio ? 'Desactivar' : 'Activar',
                        style: const TextStyle(fontSize: 12),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: socio.estadoSocio 
                            ? Colors.orange
                            : AppTheme.successColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: ElevatedButton.icon(
                      onPressed: () => _mostrarDialogoEliminar(socio),
                      icon: const Icon(Icons.delete, size: 18),
                      label: const Text('Eliminar', style: TextStyle(fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.errorColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
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

  Widget _buildInfoItem(IconData icon, String text) {
    return Expanded(
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: AppTheme.textSecondaryColor,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondaryColor,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _editarSocio(SocioModel socio) {
    // Para futuras implementaciones: formulario de edición
    Get.snackbar(
      'Función en desarrollo',
      'La edición de socios estará disponible próximamente',
      backgroundColor: AppTheme.accentColor,
      colorText: Colors.white,
    );
  }

  void _cambiarEstadoSocio(SocioModel socio) {
    final nuevoEstado = !socio.estadoSocio;
    final accion = nuevoEstado ? 'activar' : 'desactivar';
    
    Get.dialog(
      AlertDialog(
        title: Text('$accion Socio'),
        content: Text(
          '¿Estás seguro de que quieres $accion a ${socio.nombre} ${socio.apellido}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              await _socioController.actualizarEstadoSocio(socio.idUsuario!, nuevoEstado);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: nuevoEstado ? AppTheme.successColor : Colors.orange,
            ),
            child: Text(accion),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoEliminar(SocioModel socio) {
    Get.dialog(
      AlertDialog(
        title: const Text('Eliminar Socio'),
        content: Text(
          '¿Estás seguro de que quieres eliminar a ${socio.nombre} ${socio.apellido}? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              await _socioController.eliminarSocio(socio.idUsuario!);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
