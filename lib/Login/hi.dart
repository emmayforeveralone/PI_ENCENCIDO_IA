import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pi2025/MenuUsuarios/home_screen.dart';

import '../Registro/formRegistro.dart';

class hi extends StatefulWidget {
  const hi({super.key});

  @override
  State<hi> createState() => _hiState();
}

class _hiState extends State<hi> {

  final TextEditingController _correo = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance; // Instancia de Firebase Auth

  Future<void> _login() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _correo.text.trim(),
        password: _pass.text.trim(),
      );
      // Si el login es exitoso, navegar a la pantalla principal
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      // Mostrar mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al ingresar")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            const SizedBox(height: 100),
            Image.asset('assets/images/FondoFace.png', height: 200),
            const SizedBox(height: 20),
            const Text('Bienvenidos',
                style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextFormField(
              controller: _correo,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email, color: Colors.white),
                hintText: 'Ingresa el correo electronico',
                hintStyle: TextStyle(color: Colors.white70),
                fillColor: Colors.black54,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _pass,
              obscureText: true,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock, color: Colors.white),
                hintText: 'Contraseña',
                hintStyle: TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.black54,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                backgroundColor: Colors.blue.shade900,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Ingresar', style: TextStyle(color: Colors.white)),
            ),

            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Formregistro(),)

                );
              },
              child: const Text('Crear Cuenta', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('¿Olvidaste tu contraseña?', style: TextStyle(color: Colors.white70)),
            ),
          ],
        ),
      ),
    );
  }
}
