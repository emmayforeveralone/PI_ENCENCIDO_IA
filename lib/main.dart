import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pi2025/AgregarUsuario/agregarUsuario.dart';
import 'package:pi2025/MenuUsuarios/home_screen.dart';
import 'package:pi2025/Registro/formRegistro.dart';
import 'package:pi2025/firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FaceLock',
      debugShowCheckedModeBanner: false,

      home: HomeScreen(),
    );
  }
}
