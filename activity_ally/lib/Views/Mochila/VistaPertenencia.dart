import 'package:activity_ally/Presenters/PertenenciaPresenter.dart';
import 'package:activity_ally/Views/Updatable.dart';
import 'package:flutter/material.dart';
import 'package:activity_ally/Models/Pertenencia.dart';
import 'package:activity_ally/Views/Mochila/widgets/FichaPertenencia.dart';

class VistaPertenencia extends StatefulWidget {
  final PertenenciaPresenter presenter;
  
  const VistaPertenencia(this.presenter);

  @override
  State<VistaPertenencia> createState() => _VistaPertenenciaState();
}

class _VistaPertenenciaState extends State<VistaPertenencia>  implements Updatable{
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
      appBar: AppBar(title: const Text('Pertenencias')),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<List<Pertenencia>>(
          future: objetos,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Show loading indicator
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }else if (snapshot.data?.isEmpty ?? true) {
              return Center(child: Text("Aun no has registrado ningun objeto"));
            }  
            else {
              List<Pertenencia> pertenencias = snapshot.data!;
              return ListView.builder(
                itemCount: pertenencias.length,
                itemBuilder: (context, index) {
                  final item = pertenencias[index];
                  return FichaPertnencia(
                      id: item.id,
                      titulo: item.nombre,
                      estado: item.status,
                      descripcion: item.descripcion,
                      foto: item.foto,
                      presenter: widget.presenter,);
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          widget.presenter.onSubmit(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}