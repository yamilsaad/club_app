// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../views/view.dart';
import '../../views/eventos_views/eventos_socios_view.dart';
import '../auth_screen/controllers/auth_controller.dart';
import '../../../config/themes/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final AuthController authController = Get.find();
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  late List<Widget> _views;
  late List<Map<String, dynamic>> _navItems;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Construimos las vistas y pestañas según el rol del usuario
    final user = authController.currentUser.value;
    _buildViewsAndNavItems(user);

    _animationController.forward();
  }

  void _buildViewsAndNavItems(dynamic user) {
    _views = [
      const InicioView(),
      const EventosSociosView(),
      if (user?.rol == "admin") const AdminView(),
      // Aquí agregamos la pantalla de beneficios
      Container(), // Placeholder para beneficios (se navega con Get.toNamed)
      // const SettingView(), // Comentado temporalmente
    ];

    _navItems = [
      {
        'icon': FontAwesomeIcons.houseChimney,
        'activeIcon': FontAwesomeIcons.houseChimneyCrack,
        'label': 'Inicio',
      },
      {
        'icon': FontAwesomeIcons.calendar,
        'activeIcon': FontAwesomeIcons.calendarCheck,
        'label': 'Eventos',
      },
      if (user?.rol == "admin")
        {
          'icon': FontAwesomeIcons.userShield,
          'activeIcon': FontAwesomeIcons.shieldHalved,
          'label': 'Admin',
        },
      {
        'icon': FontAwesomeIcons.gift,
        'activeIcon': FontAwesomeIcons.gifts,
        'label': 'Beneficios',
      },
      // {
      //   'icon': FontAwesomeIcons.gear,
      //   'activeIcon': FontAwesomeIcons.gears,
      //   'label': 'Ajustes',
      // }, // Comentado temporalmente
    ];
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      // Si es el tab de Beneficios, navegar en lugar de cambiar de tab
      final user = authController.currentUser.value;
      final beneficiosIndex = user?.rol == "admin" ? 3 : 2; // Índice de beneficios dependiendo del rol
      
      if (index == beneficiosIndex) {
        Get.toNamed('/beneficios');
        return;
      }
      
      setState(() {
        _selectedIndex = index;
      });
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Si currentUser cambia, actualizamos las vistas y pestañas
      final user = authController.currentUser.value;

      // Si el rol cambió y la cantidad de tabs cambió, reseteamos index
      if (user?.rol != "admin" && _selectedIndex >= _navItems.length) {
        _selectedIndex = 0; // Evita que quede en un índice inválido
      }

      // Reconstruir vistas si es necesario
      _buildViewsAndNavItems(user);

      return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: _views[_selectedIndex],
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      );
    });
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              // Todos los tabs en una sola fila
              ..._navItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value as Map<String, dynamic>;
                final isSelected = index == _selectedIndex;
                final isBeneficios = item['label'] == 'Beneficios';

                return Expanded(
                  child: GestureDetector(
                    onTap: () => _onItemTapped(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        // Si es beneficios, usar el estilo especial
                        color: isBeneficios 
                            ? Colors.transparent
                            : (isSelected
                                ? AppTheme.primaryColor.withOpacity(0.1)
                                : Colors.transparent),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Si es beneficios, usar el estilo especial del botón
                          if (isBeneficios)
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                gradient: AppTheme.accentGradient,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.accentColor.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.card_giftcard,
                                color: Colors.white,
                                size: 16,
                              ),
                            )
                          else
                            FaIcon(
                              isSelected
                                  ? item['activeIcon'] as IconData
                                  : item['icon'] as IconData,
                              color: isSelected
                                  ? AppTheme.primaryColor
                                  : AppTheme.textSecondaryColor,
                              size: 20,
                            ),
                          const SizedBox(height: 4),
                          Flexible(
                            child: Text(
                              item['label'] as String,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: isSelected
                                    ? AppTheme.primaryColor
                                    : AppTheme.textSecondaryColor,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
