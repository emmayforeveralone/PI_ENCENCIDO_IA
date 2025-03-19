import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FormUsuarios extends StatefulWidget {
  const FormUsuarios({super.key});

  @override
  State<FormUsuarios> createState() => _FormUsuariosState();
}

class _FormUsuariosState extends State<FormUsuarios> {


  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();

  List listaSeleccion = [
    "1 Dia",
    "1 Semana",
    "1 Mes",
    "1 Año",
  ];
  var selectedTiempo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Agregar Usuario',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 20),
              TextFormField(
                controller: _nombreController,
                style: TextStyle(color: Colors.white),
                autocorrect: true,
                decoration: InputDecoration(
                  focusColor: Colors.white,
                  labelText: 'Nombre',
                  labelStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.black54,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _apellidosController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Apellidos',
                  labelStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.black54,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 19),
              Text(
                'Tiempo de actividad',
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
              SizedBox(height: 5),
              DropdownButtonFormField(
                dropdownColor: Colors.grey[850],
                style: TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null) {
                    return 'Este campo es obligatorio';
                  }
                  return null;
                },
                menuMaxHeight: 250.0,
                // ignore: prefer_const_constructors
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  icon: const Icon(
                    Icons.group,
                    color: Color.fromRGBO(255, 255, 255, 1),
                  ),
                  labelText: "Seleccione una opcion",
                ),
                items: listaSeleccion.map((name) {
                  return DropdownMenuItem(
                    value: name,
                    child: Text(name),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedTiempo = value;
                },
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _guardarUsuario,
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      backgroundColor: Colors.blue.shade900,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))
                  ),
                  child: const Text(
                      'Ingresar', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _guardarUsuario() async {
    User? usuarioActual = FirebaseAuth.instance.currentUser;

    if (usuarioActual == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No hay usuario autenticado')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(usuarioActual.uid)
          .collection('usuariosAdicionales')
          .add({
        'nombre': _nombreController.text,
        'apellidos': _apellidosController.text,
        'Tiempo de actividad': selectedTiempo,
        'creadoEn': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuario agregado con éxito')),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar: $e')),
      );
    }
  }
}
