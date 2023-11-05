import 'package:activity_ally/Api/ChecklistCRUD.dart';
import 'package:activity_ally/Api/PertenenciaCRUD.dart';
import 'package:flutter/material.dart';
import 'package:activity_ally/Models/Pertenencia.dart';
import 'package:activity_ally/Views/Mochila/formu.dart';
import 'package:activity_ally/Views/Mochila/widgets/ficha_check.dart';

class objetos_check extends StatefulWidget {
  final int id;
  const objetos_check({required this.id});

  @override
  State<objetos_check> createState() => _objetos_checkState();
}

class _objetos_checkState extends State<objetos_check> {
  late Future<List<Pertenencia>> objetos;
  late List<Pertenencia> pertenencias;

  void initState() {
    super.initState();
    objetos = PertenenciaCRUD.instance.getAllItems();
  }

  @override
  Widget build(BuildContext context) {
    Widget contenido = const Center(
      child: Text('No has agregado objetos aun'),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Prueba')),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<List<Pertenencia>>(
          future: objetos,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Show loading indicator
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              pertenencias = snapshot.data!;
              return ListView.builder(
                itemCount: pertenencias.length,
                itemBuilder: (context, index) {
                  final item = pertenencias[index];
                  
                  return FichaC(
                      act_id: widget.id,
                      id: item.id,
                      titulo: item.nombre,
                      estado: item.status,
                      descripcion: item.descripcion,
                      foto: item.foto);
                
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final nuevo = null;// await Navigator.of(context).push<Pertenencia>(
             // MaterialPageRoute(builder: (context) => const Formu()));
          if (nuevo == null) {
            return;
          }
          int new_id = await PertenenciaCRUD.instance.insert(nuevo);
          nuevo.id = new_id;
          ChecklistCRUD.instance.insertActivity_Object(widget.id, nuevo.id);
          setState(() => pertenencias.insert(0, nuevo));
        },
        //backgroundColor: Colors.indigo,
        child: const Icon(Icons.add),
      ),
    );
  }
}