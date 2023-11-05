import 'package:activity_ally/Models/Activity.dart';
import 'package:activity_ally/Presenters/ActivityPresenter.dart';
import 'package:activity_ally/Views/Actividad/widgets/FichaCampana.dart';
import 'package:activity_ally/Views/Mochila/Mochila.dart';
import 'package:flutter/material.dart';

//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
class VistaRecordatorio extends StatefulWidget {
  final ActivityPresenter presenter;
  const VistaRecordatorio({super.key, required this.presenter});

  @override
  State<VistaRecordatorio> createState() => _VistaRecordatorioState();
}

class _VistaRecordatorioState extends State<VistaRecordatorio> implements Mochila {
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
            }else if (snapshot.data?.isEmpty ?? true) {
              return Center(child: Text("No tienes pendientes el dia de hoy"));
            }  
            else {
              List<Activity> _actividades = snapshot.data!;
              return ListView.builder(
                itemCount: _actividades.length,
                itemBuilder: (context, index) {
                  final item = _actividades[index];
                  return FichaCampana(
                    actividad: item,
                    presenter: widget.presenter,
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
