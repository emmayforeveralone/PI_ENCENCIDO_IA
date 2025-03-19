import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Importamos intl para manejar fechas
import 'package:pi2025/FaceLogica/face_recognition.dart'; // Servicio de reconocimiento facial

class InicioScreen extends StatefulWidget {
  const InicioScreen({Key? key}) : super(key: key);

  @override
  _InicioScreenState createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  File? _image;
  final FaceRecognitionService _faceRecognitionService = FaceRecognitionService();

  String nombre = "Cargando...";
  String correo = "Cargando...";
  int edad = 0;

  @override
  void initState() {
    super.initState();
    _cargarUsuario(); // Llamamos a la función al iniciar la pantalla
  }

  // Función para obtener los datos del usuario desde Firestore
  Future<void> _cargarUsuario() async {
    User? usuario = FirebaseAuth.instance.currentUser;

    if (usuario != null) {
      DocumentSnapshot usuarioDoc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(usuario.uid)
          .get();

      if (usuarioDoc.exists) {
        setState(() {
          nombre = "${usuarioDoc['nombre']} ${usuarioDoc['apellidos']}";
          correo = usuarioDoc['email'];

          // Convertir la fecha de nacimiento de "DD-MM-YYYY" a DateTime
          String fechaTexto = usuarioDoc['fecha_nacimiento'];
          DateTime fechaNacimiento = DateFormat("dd-MM-yyyy").parse(fechaTexto);

          edad = _calcularEdad(fechaNacimiento);
        });
      }
    }
  }

  // Función para calcular la edad a partir de la fecha de nacimiento
  int _calcularEdad(DateTime fechaNacimiento) {
    DateTime hoy = DateTime.now();
    int edad = hoy.year - fechaNacimiento.year;
    if (hoy.month < fechaNacimiento.month ||
        (hoy.month == fechaNacimiento.month && hoy.day < fechaNacimiento.day)) {
      edad--;
    }
    return edad;
  }

  // Función para tomar una foto
  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      // Detectar rostro en la imagen
      bool hasFace = await _faceRecognitionService.detectFace(_image!);

      if (hasFace) {
        _showMessage("Rostro detectado correctamente.");
      } else {
        _showMessage("No se detectó un rostro. Inténtalo de nuevo.");
      }
    }
  }

  // Función para mostrar mensajes en pantalla
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _faceRecognitionService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850], // Fondo oscuro
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            Image.asset(
              'assets/images/FondoFace.png',
              width: 800, // Ancho del logo
              height: 250, // Alto del logo
            ),
            InkWell(
              onTap: _takePicture,
              borderRadius: BorderRadius.circular(50), // Hacemos el botón circular
              child: CircleAvatar(
                radius: 50, // Tamaño de la imagen circular
                backgroundColor: Colors.blue,
                backgroundImage: _image != null ? FileImage(_image!) : null, // Mostramos la imagen si hay una
                child: _image == null
                    ? const Icon(Icons.camera_alt, size: 40, color: Colors.white) // Icono si no hay imagen
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Información del Usuario: ',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Nombre: $nombre',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              'Edad: $edad',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              'Correo electrónico: $correo',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
