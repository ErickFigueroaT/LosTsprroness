import 'package:activity_ally/Models/Pertenencia.dart';
import 'package:activity_ally/Views/checklist/formulario_checklist.dart';
import 'package:activity_ally/Views/checklist/objetos_check.dart';
import 'package:flutter/material.dart';
import 'package:activity_ally/Models/ChecklistModelo.dart';
import 'package:activity_ally/Api/ChecklistCRUD.dart';

class ListadoPage extends StatefulWidget {
  //const ListadoPage({Key key = const Key('my_key')}) : super(key: key);

  static final nombrePagina = "Checklist";
  final int act_id;


  const ListadoPage({required this.act_id});


  @override
  _ListadoPageState createState() => _ListadoPageState();
}

class _ListadoPageState extends State<ListadoPage> {

  late Future<List<Pertenencia>> objetos;
  late List<Pertenencia> pertenencias;

  void initState() {
    objetos = ChecklistCRUD.instance.getChecklistActivityItems(widget.act_id);
    super.initState();
  }




  @override
  Widget build(BuildContext context) {
    bool checkin;
    return Scaffold(
      appBar: AppBar(title: Text("Listado de Objetos")),
      
      body: 
      Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<List<Pertenencia>>(
          future: objetos, //ChecklistCRUD.instance.getAllChecklistItems(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Muestra un indicador de carga mientras se obtienen los datos.
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } //else if (snapshot.data?.isEmpty ?? true) {
              //return Center(child: Text("No hay objetos agregados"));
            //} 
            else {
              pertenencias = snapshot.data!;
              return ListView.builder(
                itemCount: pertenencias.length,
                itemBuilder: (context, index) {
                  //if (checklistItems == null) {
                  // return CircularProgressIndicator(); // Muestra un indicador de carga en caso de que checklistItems sea nulo.
                  //}
                  final item = pertenencias[index];
                  //bool newValue = false;
                  return ListTile(
                    contentPadding: EdgeInsets.all(8.0),
                    title: Text(item.nombre),
                    trailing: Checkbox(
                      value: item.status,//item.completado,
                      onChanged: (bool? newValue) {
                        // Actualiza el estado del elemento en la base de datos
                        //item.completado = newValue!;
                        item.status = newValue!;
                        //ChecklistCRUD.instance.updateChecklistItem(item);
                        setState(() {});
                      },
                    ),
                  );
                },
              );
            }
          },
        )
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          /*
          FloatingActionButton(
            heroTag: 'agregar',
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) =>  objetos_check(id: 1,))),//FormularioPage())),
            child: Icon(Icons.add),
          ),*/
          SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'paloma',
            onPressed: () {
              Navigator.of(context).pop(true);
              // Acción a realizar al pulsar el botón "Finalizar"
            },
            child: Icon(Icons.done),
          ),
        ],
      ),
    );
  }

  /*

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
  }*/
}
