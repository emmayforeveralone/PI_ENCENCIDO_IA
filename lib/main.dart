import 'package:flutter/material.dart';
import 'package:pi2025/AgregarUsuario/agregarUsuario.dart';
import 'package:pi2025/MenuUsuarios/home_screen.dart';
import 'package:pi2025/Registro/formRegistro.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FaceLock',
      debugShowCheckedModeBanner: false,

      home: Formregistro(),
    );
  }
}
