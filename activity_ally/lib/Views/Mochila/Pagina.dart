import 'package:activity_ally/Api/PertenenciaCRUD.dart';
import 'package:flutter/material.dart';
import 'package:activity_ally/Models/Pertenencia.dart';
import 'package:activity_ally/Views/Mochila/formu.dart';
import 'package:activity_ally/Views/Mochila/widgets/ficha.dart';

class Pagina extends StatefulWidget {
  const Pagina({super.key});

  @override
  State<Pagina> createState() => _PaginaState();
}

class _PaginaState extends State<Pagina> {
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
                  return Ficha(
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
          final nuevo = await Navigator.of(context).push<Pertenencia>(
              MaterialPageRoute(builder: (context) => const Formu()));
          if (nuevo == null) {
            return;
          }
          //PertenenciaCRUD.instance.insert(nuevo);
          int new_id = await PertenenciaCRUD.instance.insert(nuevo);
          nuevo.id = new_id;
          setState(() => pertenencias.insert(0, nuevo));
          //pertenencias.add(nuevo);

          //objetos.add(nuevo);
        },
        //backgroundColor: Colors.indigo,
        child: const Icon(Icons.add),
      ),
    );
  }
}
