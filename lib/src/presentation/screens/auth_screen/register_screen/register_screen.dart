import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../../../../config/themes/app_theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with TickerProviderStateMixin {
  final AuthController authController = Get.put(AuthController());
  final formKey = GlobalKey<FormState>();
  
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final emailController = TextEditingController();
  final dniController = TextEditingController();
  final telefonoController = TextEditingController();
  final direccionController = TextEditingController();
  final oficioController = TextEditingController();
  final numeroSocioController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!formKey.currentState!.validate()) return;
    if (!_acceptTerms) {
      Get.snackbar(
        'Error',
        'Debes aceptar los términos y condiciones',
        backgroundColor: AppTheme.errorColor,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      await authController.registerUser(
        nombre: nombreController.text.trim(),
        apellido: apellidoController.text.trim(),
        dni: dniController.text.trim(),
        domicilio: direccionController.text.trim(),
        oficio: oficioController.text.trim(),
        numeroSocio: numeroSocioController.text.trim(),
        email: emailController.text.trim(),
        telefono: telefonoController.text.trim(),
        rol: 'socio', // Por defecto todos los registros son socios
        password: passwordController.text,
      );
      
      Get.snackbar(
        'Éxito',
        'Cuenta creada exitosamente',
        backgroundColor: AppTheme.successColor,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      
      // Navegar al login
      Get.offNamed('/login');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Ocurrió un error durante el registro',
        backgroundColor: AppTheme.errorColor,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.backgroundColor,
              AppTheme.surfaceColor,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        
                        // Header
                        _buildHeader(),
                        
                        const SizedBox(height: 40),
                        
                        // Formulario de registro
                        _buildRegisterForm(),
                        
                        const SizedBox(height: 24),
                        
                        // Términos y condiciones
                        _buildTermsCheckbox(),
                        
                        const SizedBox(height: 32),
                        
                        // Botón de registro
                        _buildRegisterButton(),
                        
                        const SizedBox(height: 24),
                        
                        // Enlace al login
                        _buildLoginLink(),
                        
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Logo circular con gradiente
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            shape: BoxShape.circle,
            boxShadow: AppTheme.elevatedShadow,
          ),
          child: const Icon(
            Icons.person_add,
            size: 40,
            color: Colors.white,
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Título principal
        const Text(
          'Crear Cuenta',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimaryColor,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 8),
        
        // Subtítulo
        Text(
          'Únete a nuestra comunidad de socios',
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.textSecondaryColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      children: [
        // Nombre y Apellido en la misma fila
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: nombreController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El nombre es requerido';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: apellidoController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El apellido es requerido';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Apellido',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 20),
        
        // Email
        TextFormField(
          controller: emailController,
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
        
        // DNI
        TextFormField(
          controller: dniController,
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
        
        const SizedBox(height: 20),
        
        // Teléfono
        TextFormField(
          controller: telefonoController,
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
        
        const SizedBox(height: 20),
        
        // Dirección
        TextFormField(
          controller: direccionController,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'La dirección es requerida';
            }
            return null;
          },
          decoration: const InputDecoration(
            labelText: 'Dirección',
            prefixIcon: Icon(Icons.location_on_outlined),
            hintText: 'Calle, número, ciudad',
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Oficio
        TextFormField(
          controller: oficioController,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'El oficio es requerido';
            }
            return null;
          },
          decoration: const InputDecoration(
            labelText: 'Oficio/Profesión',
            prefixIcon: Icon(Icons.work_outlined),
            hintText: 'Ej: Empleado, Comerciante, Estudiante',
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Número de Socio
        TextFormField(
          controller: numeroSocioController,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'El número de socio es requerido';
            }
            return null;
          },
          decoration: const InputDecoration(
            labelText: 'Número de Socio',
            prefixIcon: Icon(Icons.confirmation_number_outlined),
            hintText: 'Ej: 001, 002, 003',
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Contraseña
        TextFormField(
          controller: passwordController,
          obscureText: _obscurePassword,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'La contraseña es requerida';
            }
            if (value.trim().length < 6) {
              return 'La contraseña debe tener al menos 6 caracteres';
            }
            return null;
          },
          decoration: InputDecoration(
            labelText: 'Contraseña',
            prefixIcon: const Icon(Icons.lock_outlined),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                color: AppTheme.textSecondaryColor,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            hintText: '••••••••',
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Confirmar contraseña
        TextFormField(
          controller: confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Confirma tu contraseña';
            }
            if (value != passwordController.text) {
              return 'Las contraseñas no coinciden';
            }
            return null;
          },
          decoration: InputDecoration(
            labelText: 'Confirmar contraseña',
            prefixIcon: const Icon(Icons.lock_outlined),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                color: AppTheme.textSecondaryColor,
              ),
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
            hintText: '••••••••',
          ),
        ),
      ],
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _acceptTerms,
          onChanged: (value) {
            setState(() {
              _acceptTerms = value ?? false;
            });
          },
          activeColor: AppTheme.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _acceptTerms = !_acceptTerms;
              });
            },
            child: RichText(
              text: TextSpan(
                text: 'Acepto los ',
                style: TextStyle(
                  color: AppTheme.textSecondaryColor,
                  fontSize: 14,
                ),
                children: [
                  TextSpan(
                    text: 'términos y condiciones',
                    style: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const TextSpan(text: ' y la '),
                  TextSpan(
                    text: 'política de privacidad',
                    style: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleRegister,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Crear Cuenta',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '¿Ya tienes una cuenta? ',
          style: TextStyle(
            color: AppTheme.textSecondaryColor,
            fontSize: 16,
          ),
        ),
        GestureDetector(
          onTap: () => Get.back(),
          child: const Text(
            'Inicia sesión',
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
