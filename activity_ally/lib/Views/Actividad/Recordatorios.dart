import 'package:activity_ally/Api/ActivityCRUD.dart';
import 'package:activity_ally/Models/Activity.dart';
import 'package:activity_ally/Views/Actividad/ActivityForm.dart';
import 'package:activity_ally/Views/Actividad/widgets/ficha_actividad.dart';
import 'package:activity_ally/Views/Actividad/widgets/FichaCampana.dart';
import 'package:activity_ally/services/Notificacion.dart';
import 'package:flutter/material.dart';

//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
class vistaRecordatorio extends StatefulWidget {
  const vistaRecordatorio({super.key});

  @override
  State<vistaRecordatorio> createState() => _vistaRecordatorioState();
}

class _vistaRecordatorioState extends State<vistaRecordatorio> {
  late final Notificacion notificaciones;
  late Future<List<Activity>> actividades;
  late List<Activity> _actividades;

  @override
  void initState() {
    super.initState();
    notificaciones = Notificacion();
    notificaciones.initialize();
    actividades = ActivityCRUD.instance.getAllItems();
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
              _actividades = snapshot.data!;
              return ListView.builder(
                itemCount: _actividades.length,
                itemBuilder: (context, index) {
                  final item = _actividades[index];
                  return FichaCampana(
                    actividad: item,
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
