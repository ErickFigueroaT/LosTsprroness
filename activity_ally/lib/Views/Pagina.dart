import 'package:activity_ally/Api/PertenenciaCRUD.dart';
import 'package:flutter/material.dart';
import 'package:activity_ally/Models/Pertenencia.dart';
import 'package:activity_ally/Views/formu.dart';
import 'package:activity_ally/Views/widgets/ficha.dart';

class Pagina extends StatefulWidget {
  const Pagina({super.key});

  @override
  State<Pagina> createState() => _PaginaState();
}

class _PaginaState extends State<Pagina> {
 
  late Future<List<Pertenencia>> objetos;
  
  void initState() {
    super.initState();
    objetos = PertenenciaCRUD.instance.getAllItems();
  }

  @override
  Widget build(BuildContext context) {
    Widget contenido = const Center(
      child: Text('No has agregado objetos aun'),
    );
    /*

    if (objetos.isNotEmpty) {
      contenido = Padding(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: objetos.length,
          itemBuilder: (context, index) {
            final item = objetos[index];
            return Ficha(
                id: 0,//item.id? => 0,
                titulo: item.nombre,
                descripcion: item.descripcion,
                estado: item.status);
          },
        ),
      );
    }
    */
    

    return Scaffold(
      appBar: AppBar(title: const Text('Prueba')),
      //body: contenido,

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
              List<Pertenencia> pertenencias = snapshot.data!;
              return ListView.builder(
                itemCount: pertenencias.length,
                itemBuilder: (context, index) {
                  final item = pertenencias[index];
                  return Ficha(
                      id: 0 ,
                      titulo: item.nombre,
                      estado: item.status,
                      descripcion: item.descripcion,

                      //foto: item.foto
                      );
                },
              );
            }
          },
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final nuevo = await Navigator.of(context).push<Pertenencia>(
              MaterialPageRoute(builder: (context) => const Formu()));
          if (nuevo == null) {
            return;
          }
          PertenenciaCRUD.instance.insert(nuevo);
          //objetos.add(nuevo);
        },
        //backgroundColor: Colors.indigo,
        child: const Icon(Icons.add),
      ),
    );
  }
}