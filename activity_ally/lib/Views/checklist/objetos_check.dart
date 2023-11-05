import 'package:activity_ally/Api/ChecklistCRUD.dart';
import 'package:activity_ally/Api/PertenenciaCRUD.dart';
import 'package:activity_ally/Presenters/PertenenciaPresenter.dart';
import 'package:activity_ally/Views/Updatable.dart';
import 'package:flutter/material.dart';
import 'package:activity_ally/Models/Pertenencia.dart';
import 'package:activity_ally/Views/Mochila/formu.dart';
import 'package:activity_ally/Views/Mochila/widgets/ficha_check.dart';

class objetos_check extends StatefulWidget {
  final int id;
  final PertenenciaPresenter presenter;
  const objetos_check({required this.id, required this.presenter});

  @override
  State<objetos_check> createState() => _objetos_checkState();
}

class _objetos_checkState extends State<objetos_check> implements Updatable{
  late Future<List<Pertenencia>> objetos;

  void initState() {
    super.initState();
    this.widget.presenter.view = this;
    objetos = widget.presenter.getPertenencias();
  }

   void updateView() async {
    setState(() {
      objetos = widget.presenter.getPertenencias();
    });
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
            } else if (snapshot.data?.isEmpty ?? true) {
              return Center(child: Text("Aun no has registrado ningun objeto"));
            }
            else {
              List<Pertenencia> pertenencias = snapshot.data!;
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
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => Formu(widget.presenter)));

              //ChecklistCRUD.instance.insertActivity_Object(widget.id, nuevo.id);
        },
        //backgroundColor: Colors.indigo,
        child: const Icon(Icons.add),
      ),
    );
  }
}