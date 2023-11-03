import 'package:activity_ally/Api/ActivityCRUD.dart';
import 'package:activity_ally/Models/Activity.dart';
import 'package:activity_ally/Views/Actividad/ActivityForm.dart';
import 'package:activity_ally/Views/Actividad/widgets/ficha_actividad.dart';
import 'package:activity_ally/services/Notificacion.dart';
import 'package:flutter/material.dart';

//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
class VistaActividad extends StatefulWidget {
  const VistaActividad({super.key});

  @override
  State<VistaActividad> createState() => _VistaActividadState();
}

class _VistaActividadState extends State<VistaActividad> {
  late Future<List<Activity>> actividades;
  late List<Activity> _actividades;

  @override
  void initState() {
    super.initState();
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
                  return FichaActividad(
                    actividad: item,
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final nuevo = await Navigator.of(context).push<Activity>(
              MaterialPageRoute(builder: (context) => const ActivityForm()));
          if (nuevo == null) {
            return;
          }
          int new_id = await ActivityCRUD.instance.insert(nuevo);
          nuevo.id = new_id;
          setState(() => _actividades.insert(0, nuevo));
        },
        //backgroundColor: Colors.indigo,
        child: const Icon(Icons.add),
      ),
    );
  }
}
