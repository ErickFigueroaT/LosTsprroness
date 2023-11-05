import 'package:activity_ally/Models/Activity.dart';
import 'package:activity_ally/Presenters/ActivityPresenter.dart';
import 'package:activity_ally/Views/Actividad/ActivityForm.dart';
import 'package:activity_ally/Views/Actividad/widgets/ficha_actividad.dart';
import 'package:activity_ally/Views/Mochila/Mochila.dart';
import 'package:flutter/material.dart';

//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
class VistaActividad extends StatefulWidget {
  final ActivityPresenter presenter;
  const VistaActividad({super.key, required this.presenter});

  @override
  State<VistaActividad> createState() => _VistaActividadState();
}

class _VistaActividadState extends State<VistaActividad> implements Mochila {
  late Future<List<Activity>> actividades;

  void initState() {
    super.initState();
    this.widget.presenter.view = this;
    actividades = widget.presenter.getActivitys();
  }

   void updateView() async {
    setState(() {
      actividades = widget.presenter.getActivitys();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Actividades"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<List<Activity>>(
          future: actividades,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Show loading indicator
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<Activity> _actividades = snapshot.data!;
              return ListView.builder(
                itemCount: _actividades.length,
                itemBuilder: (context, index) {
                  final item = _actividades[index];
                  return FichaActividad(
                    actividad: item,
                    presenter: widget.presenter,
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ActivityForm(widget.presenter)));
        },
        //backgroundColor: Colors.indigo,
        child: const Icon(Icons.add),
      ),
    );
  }
}
