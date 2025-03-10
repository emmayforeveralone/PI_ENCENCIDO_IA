import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../AgregarUsuario/agregarUsuario.dart';
import 'package:pi2025/FaceLogica/face_recognition.dart'; // Importamos el servicio de reconocimiento facial

class UsuariosScreen extends StatefulWidget {
  const UsuariosScreen({Key? key}) : super(key: key);

  @override
  _UsuariosScreenState createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {

  final FaceRecognitionService _faceRecognitionService = FaceRecognitionService();
  Map<String, File?> userImages = {}; // Mapa para almacenar imágenes de cada usuario

  // Función para tomar la foto y analizar el rostro
  Future<void> _takePicture(String userKey) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        userImages[userKey] = File(pickedFile.path);
      });

      // Detectar rostro en la imagen
      bool hasFace = await _faceRecognitionService.detectFace(userImages[userKey]!);

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
      backgroundColor: Colors.grey[850],
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 35),
            Image.asset(
              'assets/images/FondoFace.png',
              width: 800, // Ancho del logo
              height: 250, // Alto del logo
            ),
            const Text(
              "Agregar usuarios",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 20),
            // Lista de botones individuales
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildUserButton(
                    context,
                    "Agregar Información",
                    "user1",
                    Icons.person_add,
                        () {
                      // Acción para agregar información del usuario
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FormUsuarios()),
                      );
                    },
                  ),
                  _buildUserButton(
                    context,
                    "Agregar Información",
                    "user2",
                    Icons.person_add,
                        () {
                        // Acción para agregar información del usuario 2
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FormUsuarios()),
                          );
                    },
                  ),
                  _buildUserButton(
                    context,
                    "Agregar Información",
                    "user3",
                    Icons.person_add,
                        () {
                      // Acción para agregar información del usuario 3
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FormUsuarios()),
                          );
                        },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserButton(BuildContext context, String text, String userKey,
      IconData icon, VoidCallback onInfoPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            onPressed: onInfoPressed,
            child: Text(
              text,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Column(
            children: [
              InkWell(
                onTap: () => _takePicture(userKey),
                borderRadius: BorderRadius.circular(50),
                child: CircleAvatar(
                  radius: 40, // Tamaño del botón
                  backgroundColor: Colors.white,
                  backgroundImage: userImages[userKey] != null
                      ? FileImage(userImages[userKey]!)
                      : null, // Mostrar imagen si ya se tomó
                  child: userImages[userKey] == null
                      ? Icon(icon, size: 40, color: Colors.blue) // Icono si no hay imagen
                      : null,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "Agregar imagen",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
