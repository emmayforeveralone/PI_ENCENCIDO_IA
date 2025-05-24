import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // Para manejar fechas

class BloqueadosScreen extends StatefulWidget {
  const BloqueadosScreen({Key? key}) : super(key: key);

  @override
  _BloqueadosScreenState createState() => _BloqueadosScreenState();
}

class _BloqueadosScreenState extends State<BloqueadosScreen> {
  // Lista de usuarios bloqueados (se llenará con datos de Firestore)
  List<Map<String, dynamic>> usuarios = [];

  @override
  void initState() {
    super.initState();
    _cargarUsuariosAdicionales();
  }

  // Cargar usuarios adicionales desde Firestore
  Future<void> _cargarUsuariosAdicionales() async {
    User? usuarioActual = FirebaseAuth.instance.currentUser;

    if (usuarioActual != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(usuarioActual.uid)
          .collection('usuariosAdicionales')
          .get();

      setState(() {
        usuarios = querySnapshot.docs.map((doc) {
          // Calcular si el tiempo de actividad está activo
          bool activo = _esActivo(doc['Tiempo de actividad'], doc['creadoEn']);

          return {
            "nombre": doc['nombre'],
            "apellidos": doc['apellidos'],
            "activo": activo, // Estado inicial de bloqueo
            "tiempoActividad": doc['Tiempo de actividad'], // Tiempo de actividad
            "creadoEn": doc['creadoEn'], // Fecha de creación
          };
        }).toList();
      });
    }
  }

  // Verificar si el tiempo de actividad está activo
  bool _esActivo(String tiempoActividad, Timestamp creadoEn) {
    DateTime ahora = DateTime.now();
    DateTime fechaCreacion = creadoEn.toDate();

    switch (tiempoActividad) {
      case "1 Dia":
        return ahora.isBefore(fechaCreacion.add(const Duration(days: 1)));
      case "1 Semana":
        return ahora.isBefore(fechaCreacion.add(const Duration(days: 7)));
      case "1 Mes":
        return ahora.isBefore(fechaCreacion.add(const Duration(days: 30)));
      case "1 Año":
        return ahora.isBefore(fechaCreacion.add(const Duration(days: 365)));
      default:
        return false; // Si no hay tiempo de actividad, se desactiva
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
            const SizedBox(height: 20),
            Image.asset(
              'assets/images/FondoFace.png',
              width: 800,
              height: 250,
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
              // Mostrar nombre y apellidos del usuario adicional
              Text(
                "${usuarios[index]["nombre"]} ${usuarios[index]["apellidos"]}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
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
              const SizedBox(height: 10),
              Text(
                "Tiempo: ${usuarios[index]["tiempoActividad"]}",
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
              const SizedBox(height: 10),
              Text(
                "Fecha de creación: ${DateFormat('dd/MM/yyyy').format(usuarios[index]["creadoEn"].toDate())}",
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}