import 'package:flutter/material.dart';

class BloqueadosScreen extends StatelessWidget {
  const BloqueadosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: const Center(
        child: Text(
          'Usuarios Bloqueados',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}