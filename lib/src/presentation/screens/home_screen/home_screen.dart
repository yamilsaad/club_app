import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../views/view.dart';
import '../auth_screen/controllers/auth_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthController authController = Get.find();

  int _selectedIndex = 0;

  late List<Widget> _views;
  late List<BottomNavigationBarItem> _navItems;

  @override
  void initState() {
    super.initState();

    // Construimos las vistas y pestañas según el rol del usuario
    final user = authController.currentUser.value;

    _views = [
      const InicioView(),
      const EventosView(),
      if (user?.rol == "admin") const AdminView(),
      const SettingView(),
    ];

    _navItems = [
      const BottomNavigationBarItem(
        icon: FaIcon(FontAwesomeIcons.houseChimney),
        activeIcon: FaIcon(FontAwesomeIcons.houseChimneyCrack),
        label: 'Inicio',
      ),
      const BottomNavigationBarItem(
        icon: FaIcon(FontAwesomeIcons.calendar),
        activeIcon: FaIcon(FontAwesomeIcons.calendarCheck),
        label: 'Eventos',
      ),
      if (user?.rol == "admin")
        const BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.userShield),
          activeIcon: FaIcon(FontAwesomeIcons.shieldHalved),
          label: 'Admin',
        ),
      const BottomNavigationBarItem(
        icon: FaIcon(FontAwesomeIcons.gear),
        activeIcon: FaIcon(FontAwesomeIcons.gears),
        label: 'Ajustes',
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Si currentUser cambia, actualizamos las vistas y pestañas
      final user = authController.currentUser.value;

      // Si el rol cambió y la cantidad de tabs cambió, reseteamos index
      if (user?.rol != "admin" && _selectedIndex >= 2) {
        _selectedIndex = 1; // Evita que quede en un índice inválido
      }

      return Scaffold(
        body: _views[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.deepPurple,
          unselectedItemColor: Colors.grey.shade600,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          items: _navItems,
        ),
      );
    });
  }
}
