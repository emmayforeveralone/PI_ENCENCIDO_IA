import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:pi2025/FaceLogica/face_recognition.dart'; // Importamos el servicio de reconocimiento facial

class InicioScreen extends StatefulWidget {
  const InicioScreen({Key? key}) : super(key: key);

  @override
  _InicioScreenState createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  File? _image;
  final FaceRecognitionService _faceRecognitionService = FaceRecognitionService();

  // Función para tomar la foto y analizar el rostro
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
        print("Rostro detectado.");
        _showMessage("Rostro detectado correctamente.");
      } else {
        print("No se detectó ningún rostro.");
        _showMessage("No se detectó un rostro. Inténtalo de nuevo.");
      }
    }
  }

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
      backgroundColor: Colors.grey[900], // Fondo oscuro
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: _takePicture,
              borderRadius: BorderRadius.circular(50), // Hacemos el botón circular
              child: CircleAvatar(
                radius: 50, // Tamaño de la imagen circular
                backgroundColor: Colors.blue,
                backgroundImage: _image != null ? FileImage(_image!) : null, // Mostramos la imagen si hay una
                child: _image == null
                    ? Icon(Icons.camera_alt, size: 40, color: Colors.white) // Icono si no hay imagen
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Información del Usuario: ',
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
