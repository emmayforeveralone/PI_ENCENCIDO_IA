import 'package:flutter/material.dart';
import 'package:pi2025/MenuUsuarios/usuarios.dart';
import 'bloqueados.dart';
import 'inicio.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Índice de la pantalla actual

  // Lista de pantallas
  final List<Widget> _screens = [
     InicioScreen(),
     UsuariosScreen(),
     BloqueadosScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex, // Mantiene el estado de cada pantalla
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black, // Fondo negro
        selectedItemColor: Colors.blue, // Color al seleccionar
        unselectedItemColor: Colors.white, // Color cuando no está seleccionado
        currentIndex: _selectedIndex, // Índice de la pantalla actual
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Usuarios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.block),
            label: 'Bloqueados',
          ),
        ],
      ),
    );
  }
}
