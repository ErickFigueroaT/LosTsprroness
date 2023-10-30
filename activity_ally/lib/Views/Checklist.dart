import 'package:activity_ally/Views/formulario_checklist.dart';
import 'package:flutter/material.dart';
import 'package:activity_ally/Models/Checklist_modelo.dart';

class ListadoPage extends StatefulWidget {
  const ListadoPage({Key key = const Key('my_key')}) : super(key: key);

  static final nombrePagina = "Checklist";

  @override
  _ListadoPageState createState() => _ListadoPageState();
}

class _ListadoPageState extends State<ListadoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Listado de Objetos")),
      //...
      body: (Tareas().tareas.isNotEmpty)
          ? ListView(children: _crearItem())
          : Center(
              child: Text("No hay objetos agregados"),
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => FormularioPage())),
            child: Icon(Icons.add),
          ),
          SizedBox(height: 10), // Añade un espacio entre los botones
          FloatingActionButton(
            onPressed: () {
              // Acción a realizar al pulsar el botón "Finalizar"
            },
            child: Icon(Icons.done),
          ),
        ],
      ),
    );
  }

  List<Widget> _crearItem() {
    List<Widget> items = [];
    for (Map<String, dynamic> tarea in Tareas().tareas) {
      final String nombre = tarea['nombre'];
      final bool completado = tarea['estado'];

      items.add(
        ListTile(
          title: Text(nombre),
          trailing: Checkbox(
            value: completado == null ? false : completado,
            onChanged: (bool? newValue) {
              setState(() {
                tarea['estado'] = newValue;
              });
            },
          ),
        ),
      );
    }
    return items;
  }
}
