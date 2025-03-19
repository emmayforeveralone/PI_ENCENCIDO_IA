import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../MenuUsuarios/home_screen.dart';

class Formregistro extends StatefulWidget {
  const Formregistro({super.key});

  @override
  State<Formregistro> createState() => _FormregistroState();
}

class _FormregistroState extends State<Formregistro> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _fechaNacimientoController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> _registrarUsuario() async {
    try {
      // Registrar usuario en Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passController.text.trim(),
      );

      // Guardar datos adicionales en Firestore
      await _firestore.collection('usuarios').doc(userCredential.user!.uid).set({
        'nombre': _nombreController.text,
        'apellidos': _apellidosController.text,
        'email': _emailController.text,
        'fecha_nacimiento': _fechaNacimientoController.text,
        'password': _passController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registro exitoso')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );

      // Redirigir a otra pantalla o limpiar los campos
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Ocurrió un error";

      if (e.code == 'email-already-in-use') {
        errorMessage = 'El correo ya está registrado';
      } else if (e.code == 'weak-password') {
        errorMessage = 'La contraseña es muy débil';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Registro',
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
                validator: (value) => value!.isEmpty ? "Ingrese su nombre" : null,
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
                validator: (value) => value!.isEmpty ? "Ingrese sus apellidos" : null,
              ),
              SizedBox(height: 20),
              Text(
                'Fecha de nacimiento',
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              SizedBox(height: 7),
              TextFormField(
                controller: _fechaNacimientoController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Fecha de Nacimiento (DD-MM-YYYY)",
                  labelStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.black54,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Ingrese su fecha de nacimiento";
                  }
                  final regex = RegExp(r'^\d{2}-\d{2}-\d{4}$');
                  if (!regex.hasMatch(value)) {
                    return "Formato inválido (DD-MM-YYYY)";
                  }
                  return null;
                },
              ),
              SizedBox(height: 19),
              TextFormField(
                controller: _emailController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Correo electrónico',
                  labelStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.black54,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) => value!.isEmpty ? "Ingrese su correo" : null,
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _passController,
                style: TextStyle(color: Colors.white),
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  labelStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.black54,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) => value!.isEmpty ? "Ingrese su contraseña" : null,
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:  () {
                    if (_formKey.currentState!.validate()) {
                      _registrarUsuario();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Por favor, complete todos los campos correctamente')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    backgroundColor: Colors.blue.shade900,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                  ),
                  child: const Text('Ingresar', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}



class CustomDropdown extends StatelessWidget {
  final List<String> items;
  final String hint;
  final double width;

  const CustomDropdown({
    Key? key,
    required this.items,
    required this.hint,
    this.width = 95, required Null Function(dynamic value) onChanged, // Ancho por defecto
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width, // Ancho personalizado
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.black, // Fondo negro
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(border: InputBorder.none),
        dropdownColor: Colors.black, // Color del menú desplegable
        icon: const Icon(Icons.arrow_drop_down, color: Colors.white), // Ícono de desplegable
        style: const TextStyle(color: Colors.white, fontSize: 14), // Texto en blanco
        hint: Text(hint, style: const TextStyle(color: Colors.white70)), // Texto de sugerencia
        items: items
            .map((item) => DropdownMenuItem(
          value: item,
          child: Text(item, style: const TextStyle(color: Colors.white)),
        ))
            .toList(),
        onChanged: (value) {
          print(value);
        },
      ),
    );
  }
}
