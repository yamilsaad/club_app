import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/themes/app_theme.dart';
import '../../../data/models/socio_model.dart';
import '../../screens/auth_screen/controllers/auth_controller.dart';
import '../../screens/home_screen/controllers/socio_controller.dart';

class CrearSocioView extends StatefulWidget {
  final SocioModel? socioParaEditar;
  
  const CrearSocioView({super.key, this.socioParaEditar});

  @override
  State<CrearSocioView> createState() => _CrearSocioViewState();
}

class _CrearSocioViewState extends State<CrearSocioView>
    with TickerProviderStateMixin {
  final AuthController _authController = Get.find();
  final SocioController _socioController = Get.find();
  
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _emailController = TextEditingController();
  final _dniController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _direccionController = TextEditingController();
  final _oficioController = TextEditingController();
  final _numeroSocioController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  String _rolSeleccionado = 'socio';
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _esEdicion = false;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _esEdicion = widget.socioParaEditar != null;
    
    if (_esEdicion) {
      _cargarDatosSocio();
    }
    
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
    _nombreController.dispose();
    _apellidoController.dispose();
    _emailController.dispose();
    _dniController.dispose();
    _telefonoController.dispose();
    _direccionController.dispose();
    _oficioController.dispose();
    _numeroSocioController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _cargarDatosSocio() {
    final socio = widget.socioParaEditar!;
    _nombreController.text = socio.nombre;
    _apellidoController.text = socio.apellido;
    _emailController.text = socio.email;
    _dniController.text = socio.dni;
    _telefonoController.text = socio.telefono;
    _direccionController.text = socio.direccion;
    _oficioController.text = socio.oficio;
    _numeroSocioController.text = socio.numeroSocio;
    _rolSeleccionado = socio.rol;
  }

  Future<void> _guardarSocio() async {
    if (!_formKey.currentState!.validate()) return;

    // Verificar límite de socios solo si es creación nueva
    if (!_esEdicion) {
      final totalSocios = _socioController.sociosList.length;
      if (totalSocios >= 100) {
        Get.snackbar(
          'Límite alcanzado',
          'No se pueden crear más de 100 socios. Elimina uno antes de crear uno nuevo.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (_esEdicion) {
        // Actualizar socio existente
        final socioActualizado = SocioModel(
          idUsuario: widget.socioParaEditar!.idUsuario,
          nombre: _nombreController.text.trim(),
          apellido: _apellidoController.text.trim(),
          email: _emailController.text.trim(),
          dni: _dniController.text.trim(),
          telefono: _telefonoController.text.trim(),
          direccion: _direccionController.text.trim(),
          rol: _rolSeleccionado,
          numeroSocio: _numeroSocioController.text.trim(),
          estadoSocio: widget.socioParaEditar!.estadoSocio,
          oficio: _oficioController.text.trim(),
          fechaCreacion: widget.socioParaEditar!.fechaCreacion,
        );

        await _socioController.actualizarSocio(socioActualizado);
        Get.snackbar(
          'Éxito',
          'Socio actualizado correctamente',
          backgroundColor: AppTheme.successColor,
          colorText: Colors.white,
        );
      } else {
        // Crear nuevo socio
        if (_passwordController.text != _confirmPasswordController.text) {
          Get.snackbar(
            'Error',
            'Las contraseñas no coinciden',
            backgroundColor: AppTheme.errorColor,
            colorText: Colors.white,
          );
          return;
        }

        await _authController.registerUser(
          nombre: _nombreController.text.trim(),
          apellido: _apellidoController.text.trim(),
          dni: _dniController.text.trim(),
          domicilio: _direccionController.text.trim(),
          oficio: _oficioController.text.trim(),
          numeroSocio: _numeroSocioController.text.trim(),
          email: _emailController.text.trim(),
          telefono: _telefonoController.text.trim(),
          rol: _rolSeleccionado,
          password: _passwordController.text,
        );

        Get.snackbar(
          'Éxito',
          'Socio creado correctamente',
          backgroundColor: AppTheme.successColor,
          colorText: Colors.white,
        );
      }

      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Ocurrió un error: $e',
        backgroundColor: AppTheme.errorColor,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          _esEdicion ? 'Editar Socio' : 'Crear Nuevo Socio',
          style: const TextStyle(
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderCard(),
                    const SizedBox(height: 24),
                    _buildFormFields(),
                    const SizedBox(height: 32),
                    _buildActionButtons(),
                  ],
                ),
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
              _esEdicion ? Icons.edit : Icons.person_add,
              color: AppTheme.primaryColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _esEdicion ? 'Editar Socio' : 'Crear Nuevo Socio',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                                 Text(
                   _esEdicion 
                       ? 'Modifica la información del socio seleccionado'
                       : 'Completa el formulario para registrar un nuevo socio',
                   style: TextStyle(
                     fontSize: 14,
                     color: AppTheme.textSecondaryColor,
                   ),
                 ),
                 if (!_esEdicion) ...[
                   const SizedBox(height: 8),
                   Obx(() {
                     final totalSocios = _socioController.sociosList.length;
                     return Text(
                       'Socios registrados: $totalSocios/100',
                       style: TextStyle(
                         fontSize: 12,
                         color: totalSocios >= 100 
                             ? Colors.orange 
                             : AppTheme.textSecondaryColor,
                         fontWeight: FontWeight.w500,
                       ),
                     );
                   }),
                 ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      children: [
        // Nombre y Apellido
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _nombreController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El nombre es requerido';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  prefixIcon: Icon(Icons.person_outline),
                  hintText: 'Juan',
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _apellidoController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El apellido es requerido';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Apellido',
                  prefixIcon: Icon(Icons.person_outline),
                  hintText: 'Pérez',
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 20),
        
        // Email
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'El email es requerido';
            }
            if (!GetUtils.isEmail(value.trim())) {
              return 'Ingresa un email válido';
            }
            return null;
          },
          decoration: const InputDecoration(
            labelText: 'Correo electrónico',
            prefixIcon: Icon(Icons.email_outlined),
            hintText: 'ejemplo@correo.com',
          ),
        ),
        
        const SizedBox(height: 20),
        
        // DNI y Teléfono
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _dniController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El DNI es requerido';
                  }
                  if (value.trim().length < 7) {
                    return 'El DNI debe tener al menos 7 dígitos';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'DNI',
                  prefixIcon: Icon(Icons.badge_outlined),
                  hintText: '12345678',
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _telefonoController,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El teléfono es requerido';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                  prefixIcon: Icon(Icons.phone_outlined),
                  hintText: '+54 9 11 1234-5678',
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 20),
        
        // Dirección
        TextFormField(
          controller: _direccionController,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'La dirección es requerida';
            }
            return null;
          },
          decoration: const InputDecoration(
            labelText: 'Dirección',
            prefixIcon: Icon(Icons.location_on_outlined),
            hintText: 'Av. Corrientes 1234, CABA',
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Oficio y Número de Socio
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _oficioController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El oficio es requerido';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Oficio o Profesión',
                  prefixIcon: Icon(Icons.work_outline),
                  hintText: 'Ingeniero',
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _numeroSocioController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El número de socio es requerido';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Número de Socio',
                  prefixIcon: Icon(Icons.confirmation_number_outlined),
                  hintText: '001',
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 20),
        
        // Rol
        DropdownButtonFormField<String>(
          value: _rolSeleccionado,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'El rol es requerido';
            }
            return null;
          },
          decoration: const InputDecoration(
            labelText: 'Rol',
            prefixIcon: Icon(Icons.admin_panel_settings_outlined),
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'socio', child: Text('Socio')),
            DropdownMenuItem(value: 'admin', child: Text('Administrador')),
          ],
          onChanged: (value) {
            setState(() {
              _rolSeleccionado = value!;
            });
          },
        ),
        
        // Solo mostrar campos de contraseña si es creación nueva
        if (!_esEdicion) ...[
          const SizedBox(height: 20),
          
          // Contraseña
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'La contraseña es requerida';
              }
              if (value.length < 6) {
                return 'La contraseña debe tener al menos 6 caracteres';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: 'Contraseña',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Confirmar Contraseña
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Confirma la contraseña';
              }
              if (value != _passwordController.text) {
                return 'Las contraseñas no coinciden';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: 'Confirmar Contraseña',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _isLoading ? null : () => Get.back(),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.primaryColor,
              side: BorderSide(color: AppTheme.primaryColor),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Cancelar',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _isLoading ? null : _guardarSocio,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    _esEdicion ? 'Actualizar' : 'Crear Socio',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
          ),
        ),
      ],
    );
  }
}
