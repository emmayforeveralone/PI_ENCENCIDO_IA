import 'package:flutter/material.dart';


class Formregistro extends StatefulWidget {
  const Formregistro({super.key});

  @override
  State<Formregistro> createState() => _FormregistroState();
}

class _FormregistroState extends State<Formregistro> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
      ),
      body: Padding(padding: EdgeInsets.all(10),
        child: Form(
            child: Column(children: [
              TextFormField(
                controller: null,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  hintText: 'Escribe tu nombre',
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Apellidos',
                  hintText: 'Escribe tus apellidos',
                ),
              ),

              SizedBox(height: 5),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Correo Electrónico',
                  hintText: 'Escribe tu correo',
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  hintText: 'Escribe tu contraseña',
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  // Validate will return true if the form is valid, or false if
                  // the form is invalid.
                },
                child: const Text('Registrar'),
              ),
            ],)),
      ),
    );
  }
}
