import 'package:activity_ally/Views/checklist/formulario_checklist.dart';
import 'package:flutter/material.dart';
import 'package:activity_ally/Models/ChecklistModelo.dart';
import 'package:activity_ally/Api/ChecklistCRUD.dart';

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
      body: FutureBuilder<List<ChecklistItem>>(
        future: ChecklistCRUD.instance.getAllChecklistItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Muestra un indicador de carga mientras se obtienen los datos.
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.data?.isEmpty ?? true) {
            return Center(child: Text("No hay objetos agregados"));
          } else {
            final checklistItems = snapshot.data;
            return ListView.builder(
              itemCount: checklistItems?.length ?? 0,
              itemBuilder: (context, index) {
                if (checklistItems == null) {
                  return CircularProgressIndicator(); // Muestra un indicador de carga en caso de que checklistItems sea nulo.
                }
                final item = checklistItems[index];
                return ListTile(
                  title: Text(item.nombre),
                  trailing: Checkbox(
                    value: item.completado,
                    onChanged: (bool? newValue) {
                      // Actualiza el estado del elemento en la base de datos
                      item.completado = newValue!;
                      ChecklistCRUD.instance.updateChecklistItem(item);
                      setState(() {});
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => FormularioPage())),
            child: Icon(Icons.add),
          ),
          SizedBox(height: 10),
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

  FutureBuilder<List<ChecklistItem>> _crearItem() {
    return FutureBuilder<List<ChecklistItem>>(
      future: ChecklistCRUD.instance.getAllChecklistItems(),
      builder:
          (BuildContext context, AsyncSnapshot<List<ChecklistItem>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Muestra un indicador de carga mientras se obtienen los datos.
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.data?.isEmpty == true) {
          return Center(child: Text("No hay objetos agregados"));
        } else {
          final checklistItems = snapshot.data;
          return ListView.builder(
            itemCount: checklistItems?.length ?? 0,
            itemBuilder: (context, index) {
              if (checklistItems == null) {
                return CircularProgressIndicator(); // Muestra un indicador de carga en caso de que checklistItems sea nulo.
              }
              final item = checklistItems[index];
              return ListTile(
                title: Text(item.nombre),
                trailing: Checkbox(
                  value: item.completado,
                  onChanged: (bool? newValue) {
                    // Actualiza el estado del elemento en la base de datos
                    item.completado = newValue!;
                    ChecklistCRUD.instance.updateChecklistItem(item);
                    setState(() {});
                  },
                ),
              );
            },
          );
        }
      },
    );
  }
}
