import 'package:flutter/material.dart';
import 'package:pi2025/MenuUsuarios/inicio.dart';
import 'package:pi2025/Registro/formRegistro.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',

      home: HomeScreen()
    );
  }
}
