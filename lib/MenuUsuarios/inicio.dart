import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart'; // 📌 ML Kit

class InicioScreen extends StatefulWidget {
  const InicioScreen({Key? key}) : super(key: key);

  @override
  _InicioScreenState createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  File? _image;
  String? _imageUrl; // URL de la imagen en Firebase Storage
  String nombre = "Cargando...";
  String correo = "Cargando...";
  int edad = 0;
  final FaceDetector _faceDetector = FaceDetector(options: FaceDetectorOptions(enableContours: true));

  @override
  void initState() {
    super.initState();
    _cargarUsuario();
    _obtenerImagenDeFirebase(); // Obtener la imagen al iniciar la app
  }

  // 🔹 Cargar datos del usuario desde Firestore
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
          correo = usuarioDoc['correo'];

          // Convertir fecha de nacimiento
          String fechaTexto = usuarioDoc['fecha_nacimiento'];
          DateTime fechaNacimiento = DateFormat("dd-MM-yyyy").parse(fechaTexto);
          edad = _calcularEdad(fechaNacimiento);
        });
      }
    }
  }

  // 🔹 Calcular la edad
  int _calcularEdad(DateTime fechaNacimiento) {
    DateTime hoy = DateTime.now();
    int edad = hoy.year - fechaNacimiento.year;
    if (hoy.month < fechaNacimiento.month ||
        (hoy.month == fechaNacimiento.month && hoy.day < fechaNacimiento.day)) {
      edad--;
    }
    return edad;
  }

  // 🔹 Función para tomar foto, analizarla con ML Kit y subirla a Firebase
  Future<void> _takePictureAndUpload() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      setState(() {
        _image = imageFile;
      });

      // 🔍 Analizar imagen con ML Kit
      bool faceDetected = await _analyzeImage(imageFile);

      if (faceDetected) {
        // Subir imagen a Firebase y actualizar Firestore
        String? url = await _uploadImage(imageFile);
        if (url != null) {
          await _updateUserProfile(url); // Guardar en Firestore
          _obtenerImagenDeFirebase(); // Obtener la imagen para actualizar UI
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("No se detectó un rostro en la imagen."))
        );
      }
    }
  }

  // 🔹 Analizar imagen con ML Kit para reconocimiento facial
  Future<bool> _analyzeImage(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final List<Face> faces = await _faceDetector.processImage(inputImage);

    return faces.isNotEmpty; // Retorna true si detecta al menos un rostro
  }

  // 🔹 Subir imagen a Firebase Storage y obtener URL
  Future<String?> _uploadImage(File imageFile) async {
    try {
      User? usuario = FirebaseAuth.instance.currentUser;
      if (usuario == null) return null;

      String filePath = 'usuarios/${usuario.uid}/avatar.jpg';
      Reference ref = FirebaseStorage.instance.ref().child(filePath);
      UploadTask uploadTask = ref.putFile(imageFile);

      await uploadTask.whenComplete(() => null);
      String downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error al subir la imagen: $e");
      return null;
    }
  }

  // 🔹 Guardar la URL de la imagen en Firestore
  Future<void> _updateUserProfile(String url) async {
    User? usuario = FirebaseAuth.instance.currentUser;

    if (usuario != null) {
      await FirebaseFirestore.instance.collection('usuarios').doc(usuario.uid).update({
        'foto': url,
      });
    }
  }

  // 🔹 Obtener la imagen de Firebase Storage para mostrarla en la UI
  Future<void> _obtenerImagenDeFirebase() async {
    User? usuario = FirebaseAuth.instance.currentUser;

    if (usuario != null) {
      DocumentSnapshot usuarioDoc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(usuario.uid)
          .get();

      if (usuarioDoc.exists && usuarioDoc['foto'] != null) {
        setState(() {
          _imageUrl = usuarioDoc['foto']; // Actualizar imagen en la UI
        });
      }
    }
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
              width: 800,
              height: 250,
            ),
            InkWell(
              onTap: _takePictureAndUpload,
              borderRadius: BorderRadius.circular(50),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue,
                backgroundImage: _imageUrl != null
                    ? NetworkImage(_imageUrl!) // Cargar imagen desde Firebase
                    : _image != null
                    ? FileImage(_image!) as ImageProvider
                    : null,
                child: _imageUrl == null && _image == null
                    ? const Icon(Icons.camera_alt, size: 40, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Información del Usuario:',
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

  @override
  void dispose() {
    _faceDetector.close(); // Liberar el detector de rostros
    super.dispose();
  }
}
