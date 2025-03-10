import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:pi2025/AgregarUsuario/agregarUsuario.dart';

class BloqueadosScreen extends StatefulWidget {
  const BloqueadosScreen({Key? key}) : super(key: key);

  @override
  _BloqueadosScreenState createState() => _BloqueadosScreenState();
}

class _BloqueadosScreenState extends State<BloqueadosScreen> {
  // Lista de usuarios bloqueados sin nombres
  final List<Map<String, dynamic>> usuarios = [
    {"activo": false, "imagen": null},
    {"activo": true, "imagen": null},
    {"activo": false, "imagen": null},
  ];

  // Método para tomar foto y asignarla a un usuario específico
  Future<void> _tomarFoto(int index) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      setState(() {
        usuarios[index]["imagen"] = File(image.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Image.asset(
              'assets/images/FondoFace.png',
              width: 800, // Ancho del logo
              height: 250, // Alto del logo
            ),
            const Text(
              "Usuarios Bloqueados",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: usuarios.length,
                itemBuilder: (context, index) {
                  return usuarioBloqueado(index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget usuarioBloqueado(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => FormUsuarios()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Ver información"),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text(
                    "Estado: ",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Switch(
                    value: usuarios[index]["activo"],
                    onChanged: (value) {
                      setState(() {
                        usuarios[index]["activo"] = value;
                      });
                    },
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                  ),
                  Text(
                    usuarios[index]["activo"] ? "Activo" : "Inactivo",
                    style: TextStyle(
                      color: usuarios[index]["activo"] ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: () => _tomarFoto(index),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[700],
                borderRadius: BorderRadius.circular(15),
              ),
              child: usuarios[index]["imagen"] == null
                  ? const Icon(Icons.camera_alt, color: Colors.white, size: 40)
                  : ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.file(
                  usuarios[index]["imagen"],
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
