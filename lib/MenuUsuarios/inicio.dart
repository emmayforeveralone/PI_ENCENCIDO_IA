import 'package:flutter/material.dart';
import 'package:pi2025/MenuUsuarios/usuarios.dart';
import 'bloqueados.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Índice de la pantalla actual

  // Lista de pantallas
  final List<Widget> _screens = [
    const InicioScreen(),
    const UsuariosScreen(),
    const BloqueadosScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Muestra la pantalla seleccionada
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

class InicioScreen extends StatelessWidget {
  const InicioScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900], // Fondo oscuro
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50, // Tamaño de la imagen circular
              backgroundImage: NetworkImage(
                'https://www.w3schools.com/howto/img_avatar.png', // Imagen de prueba
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Información del Usuario:',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Nombre: Jose Miguel Galvez Lopez',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 5),
            const Text(
              'Edad: 30',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 5),
            const Text(
              'Correo electrónico: LaRanaRene@gmail.com',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}


