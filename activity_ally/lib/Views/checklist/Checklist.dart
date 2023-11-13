import 'package:activity_ally/services/DB/PertenenciaCRUD.dart';
import 'package:activity_ally/Models/Pertenencia.dart';
import 'package:activity_ally/Views/checklist/widgets/check_obj.dart';
import 'package:flutter/material.dart';
import 'package:activity_ally/services/DB/ChecklistCRUD.dart';

class ListadoPage extends StatefulWidget {
  static final nombrePagina = "Checklist";
  final int act_id;


  const ListadoPage({required this.act_id});


  @override
  _ListadoPageState createState() => _ListadoPageState();
}

class _ListadoPageState extends State<ListadoPage> {

  late Future<List<Pertenencia>> objetos;
  late List<Pertenencia>? pertenencias;
  late List<int> checked; 

  void initState() {
    objetos = ChecklistCRUD.instance.getChecklistActivityItems(widget.act_id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            } else if (snapshot.data?.isEmpty ?? true) {
              pertenencias = null;
              return Center(child: Text("No trajiste ningun objeto"));
            } 
            else {
              pertenencias = snapshot.data!;
              //checked = [pertenencias!.length];
              return ListView.builder(
                itemCount: pertenencias!.length,
                itemBuilder: (context, index) {
                  final item = pertenencias![index];
                  return ChecklistItemWidget(
                    item: item,
                    onChanged: (bool newValue) {
                      setState(() {
                        item.status = newValue; // Update the item's status
                      });
                    },
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
          SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'paloma',
            onPressed: () {
              if(pertenencias != null){
                for(Pertenencia p in pertenencias!){
                  if(!p.status){
                    PertenenciaCRUD.instance.update(p);
                  }
                }
              }
              Navigator.of(context).pop(true);
              // Acción a realizar al pulsar el botón "Finalizar"
            },
            child: Icon(Icons.done),
          ),
        ],
      ),
    );
  }
}
