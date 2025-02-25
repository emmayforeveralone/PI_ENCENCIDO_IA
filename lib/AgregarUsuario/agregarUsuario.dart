import 'package:flutter/material.dart';

class FormUsuarios extends StatefulWidget {
  const FormUsuarios({super.key});

  @override
  State<FormUsuarios> createState() => _FormUsuariosState();
}

class _FormUsuariosState extends State<FormUsuarios> {


  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidosController = TextEditingController();


  final List<String> _dias = List.generate(31, (index) => (index + 1).toString());
  final List<String> _meses = List.generate(12, (index) => (index + 1).toString());
  final List<String> _anios = List.generate(100, (index) => (index + 1920).toString());
  final List<String> _items = ["1 Dia", "1 Semana", "1 Mes", "1 Año"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
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
              SizedBox(height: 20),
              Text(
                'Fecha de nacimiento',
                style: TextStyle(color: Colors.white, fontSize: 17  ),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomDropdown(items: _dias, hint: 'Día', width: 80,),
                  CustomDropdown(items: _meses, hint: 'Mes',width: 80,),
                  CustomDropdown(items: _anios, hint: 'Año', width: 95,),
                ],
              ),
              SizedBox(height: 19),
              Text(
                'Tiempo de actividad',
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
              SizedBox(height: 5),
              CustomDropdown(items: _items, hint: "Tiempo de actividad", width: 200),

              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.blue.shade900,
                  ),
                  child: Text('Enviar', style: TextStyle(fontSize: 16),selectionColor: Colors.white,),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildDropdown(List<String> items) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        value: items.first,
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: TextStyle(color: Colors.white)),
          );
        }).toList(),
        onChanged: (String? newValue) {},
        dropdownColor: Colors.black54,
        underline: SizedBox(),
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
    this.width = 95, // Ancho por defecto
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
