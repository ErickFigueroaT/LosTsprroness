import 'package:activity_ally/services/DB/ChecklistCRUD.dart';
import 'package:activity_ally/services/DB/PertenenciaCRUD.dart';
import 'package:activity_ally/Presenters/PertenenciaPresenter.dart';
import 'package:activity_ally/Views/Updatable.dart';
import 'package:flutter/material.dart';
import 'package:activity_ally/Models/Pertenencia.dart';
import 'package:activity_ally/Views/Mochila/PertenenciaForm.dart';
import 'package:activity_ally/Views/Mochila/widgets/PertenenciaCheckBox.dart';

class ChecklistMaker extends StatefulWidget {
  final int id;
  final PertenenciaPresenter presenter;
  const ChecklistMaker({required this.id, required this.presenter});

  @override
  State<ChecklistMaker> createState() => _ChecklistMakerState();
}

class _ChecklistMakerState extends State<ChecklistMaker> implements Updatable {
  late Future<List<Pertenencia>> objetos;

  void initState() {
    super.initState();
    this.widget.presenter.view = this;
    objetos = widget.presenter.getPertenenciasOk();
  }

  void updateView() async {
    setState(() {
      objetos = widget.presenter.getPertenenciasOk();
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget contenido = const Center(
      child: Text('No has agregado objetos aun'),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Checklist')),
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
            } else {
              List<Pertenencia> pertenencias = snapshot.data!;
              return ListView.builder(
                itemCount: pertenencias.length,
                itemBuilder: (context, index) {
                  final item = pertenencias[index];

                  return PertenenciaCheckBox(
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
              MaterialPageRoute(builder: (context) => PertenenciaForm(widget.presenter)));
        },
        //backgroundColor: Colors.indigo,
        child: const Icon(Icons.add),
      ),
    );
  }
}
