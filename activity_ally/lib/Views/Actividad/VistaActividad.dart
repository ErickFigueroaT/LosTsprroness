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
                  return FichaActividad(
                    title: item.title,
                    id: item.id,
                    date: item.date,
                    duration: item.duration,
                    location: item.location,
                    description: item.description,
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
          setState(() => _actividades.insert(0, nuevo));
          //pertenencias.add(nuevo);
          ActivityCRUD.instance.insert(nuevo);
          //objetos.add(nuevo);
        },
        //backgroundColor: Colors.indigo,
        child: const Icon(Icons.add),
      ),
    );
  }

  void anadir() async {
    DateTime time = DateTime.now().add(Duration(minutes: 2));
    //ActivityCRUD.instance.insert(Activity(title: 'Actividad', date: time, duration: 10));
    print(time);
    await notificaciones.showNotification(
        id: 1, title: 'Activity ally', body: 'este es un recordatorio');
  }
}
