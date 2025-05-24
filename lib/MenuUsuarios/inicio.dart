import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:path_provider/path_provider.dart'; // Para guardar imágenes localmente
import 'package:pi2025/Login/login.dart'; // Importa la pantalla de inicio de sesión

class InicioScreen extends StatefulWidget {
  const InicioScreen({Key? key}) : super(key: key);

  @override
  _InicioScreenState createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  File? _image;
  String nombre = "Cargando...";
  String correo = "No disponible";
  int edad = 0;
  final FaceDetector _faceDetector = FaceDetector(options: FaceDetectorOptions(enableContours: true));

  @override
  void initState() {
    super.initState();
    _cargarUsuario();
  }

  // Cargar datos del usuario desde Firestore y la imagen guardada localmente
  Future<void> _cargarUsuario() async {
    User? usuario = FirebaseAuth.instance.currentUser;

    if (usuario != null) {
      DocumentSnapshot usuarioDoc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(usuario.uid)
          .get();

      if (usuarioDoc.exists) {
        setState(() {
          nombre = usuarioDoc.get('nombre') ?? "Desconocido";
          correo = usuarioDoc.data().toString().contains('email') ? usuarioDoc.get('email') : "No disponible";

          if (usuarioDoc.data().toString().contains('fecha_nacimiento')) {
            String fechaTexto = usuarioDoc.get('fecha_nacimiento');
            DateTime fechaNacimiento = DateFormat("dd-MM-yyyy").parse(fechaTexto);
            edad = _calcularEdad(fechaNacimiento);
          }
        });

        // Cargar imagen guardada localmente
        await _cargarImagenLocal(usuario.uid);
      }
    }
  }

  // Cargar la imagen desde almacenamiento local
  Future<void> _cargarImagenLocal(String uid) async {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = '${directory.path}/$uid.jpg';
    final imageFile = File(imagePath);

    if (imageFile.existsSync()) {
      setState(() {
        _image = imageFile;
      });
    }
  }

  // Calcular la edad
  int _calcularEdad(DateTime fechaNacimiento) {
    DateTime hoy = DateTime.now();
    int edad = hoy.year - fechaNacimiento.year;
    if (hoy.month < fechaNacimiento.month ||
        (hoy.month == fechaNacimiento.month && hoy.day < fechaNacimiento.day)) {
      edad--;
    }
    return edad;
  }

  // Tomar foto, analizar rostro con ML Kit y guardarla
  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      bool faceDetected = await _analyzeImage(imageFile);

      if (!faceDetected) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No se detectó un rostro en la imagen.")),
        );
        return;
      }

      // Guardar imagen localmente
      await _guardarImagenLocal(imageFile);

      setState(() {
        _image = imageFile;
      });
    }
  }

  // Analizar imagen con ML Kit
  Future<bool> _analyzeImage(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final List<Face> faces = await _faceDetector.processImage(inputImage);
    return faces.isNotEmpty; // Retorna true si detecta al menos un rostro
  }

  // Guardar imagen localmente asociada al usuario actual
  Future<void> _guardarImagenLocal(File imageFile) async {
    User? usuario = FirebaseAuth.instance.currentUser;
    if (usuario == null) return;

    final directory = await getApplicationDocumentsDirectory();
    final imagePath = '${directory.path}/${usuario.uid}.jpg';
    final savedImage = await imageFile.copy(imagePath);

    setState(() {
      _image = savedImage;
    });
  }

  // Método para cerrar sesión
  Future<void> _cerrarSesion() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => hi()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: Stack(
        children: [
          Center(
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
                  onTap: _takePicture,
                  borderRadius: BorderRadius.circular(50),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.blue,
                    backgroundImage: _image != null
                        ? FileImage(_image!) as ImageProvider
                        : null,
                    child: _image == null
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
          Positioned(
            left: 20,
            bottom: 20,
            child: ElevatedButton(
              onPressed: _cerrarSesion,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black12,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              ),
              child: const Text(
                'Cerrar Sesión',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _faceDetector.close();
    super.dispose();
  }
}
