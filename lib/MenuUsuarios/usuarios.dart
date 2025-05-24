import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../AgregarUsuario/agregarUsuario.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pi2025/FaceLogica/face_recognition.dart'; // Servicio de reconocimiento facial

class UsuariosScreen extends StatefulWidget {
  const UsuariosScreen({Key? key}) : super(key: key);

  @override
  _UsuariosScreenState createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  final FaceRecognitionService _faceRecognitionService = FaceRecognitionService();
  Map<String, List<File>> userImages = {}; // Mapa para almacenar imágenes de cada usuario

  @override
  void initState() {
    super.initState();
    _loadUserImages();
  }

  // Cargar imágenes desde el almacenamiento local
  Future<void> _loadUserImages() async {
    User? usuarioActual = FirebaseAuth.instance.currentUser;
    if (usuarioActual == null) return;

    String userDirPath = (await getApplicationDocumentsDirectory()).path;

    FirebaseFirestore.instance
        .collection('usuarios')
        .doc(usuarioActual.uid)
        .collection('usuariosAdicionales')
        .get()
        .then((snapshot) {
      for (var doc in snapshot.docs) {
        String userId = doc.id;
        List<File> images = [];

        for (int i = 0; i < 3; i++) {
          File imageFile = File('$userDirPath/$userId-$i.jpg');
          if (imageFile.existsSync()) {
            images.add(imageFile);
          }
        }

        setState(() {
          userImages[userId] = images;
        });
      }
    });
  }

  // Función para tomar una foto y analizar el rostro
  Future<void> _takePicture(String userId) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile == null) return;

    File imageFile = File(pickedFile.path);
    bool hasFace = await _faceRecognitionService.detectFace(imageFile);

    if (!hasFace) {
      _showMessage("No se detectó un rostro. Inténtalo de nuevo.");
      return;
    }

    // Obtener la lista de imágenes del usuario
    List<File> images = userImages[userId] ?? [];

    if (images.length >= 3) {
      _showMessage("Solo puedes agregar 3 fotos por usuario.");
      return;
    }

    // Guardar la imagen en almacenamiento local
    String userDirPath = (await getApplicationDocumentsDirectory()).path;
    String newImagePath = '$userDirPath/$userId-${images.length}.jpg';
    File newImageFile = await imageFile.copy(newImagePath);

    setState(() {
      images.add(newImageFile);
      userImages[userId] = images;
    });

    _showMessage("Rostro detectado y guardado correctamente.");
  }

  // Mostrar mensaje en pantalla
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
    User? usuarioActual = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 35),
            Image.asset(
              'assets/images/FondoFace.png',
              width: 800,
              height: 250,
            ),
            const Text(
              "Agregar usuarios",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('usuarios')
                    .doc(usuarioActual?.uid)
                    .collection('usuariosAdicionales')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  List<QueryDocumentSnapshot> usuarios = snapshot.hasData ? snapshot.data!.docs : [];

                  return ListView.builder(
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      if (index < usuarios.length) {
                        var usuario = usuarios[index];
                        return _buildUserInfo(
                          usuario.id,
                          usuario['nombre'],
                          usuario['apellidos'],
                          usuario['Tiempo de actividad'],
                        );
                      } else {
                        return _buildUserButton(context, "Agregar Información", Icons.person_add, () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => FormUsuarios()));
                        });
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserButton(BuildContext context, String text, IconData icon, VoidCallback onInfoPressed) {
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
            child: Text(text, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo(String userId, String nombre, String apellidos, String tiempo) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nombre: $nombre $apellidos', style: const TextStyle(color: Colors.white, fontSize: 16)),
              Text('Tiempo: $tiempo', style: const TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
          Column(
            children: [
              InkWell(
                onTap: () => _takePicture(userId),
                borderRadius: BorderRadius.circular(50),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  backgroundImage: userImages[userId]?.isNotEmpty == true
                      ? FileImage(userImages[userId]!.first)
                      : null,
                  child: userImages[userId]?.isEmpty == true
                      ? const Icon(Icons.person, size: 40, color: Colors.blue)
                      : null,
                ),
              ),
              const SizedBox(height: 5),
              const Text("Imagen", style: TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
