import 'package:activity_ally/Api/ActivityCRUD.dart';
import 'package:activity_ally/Models/Activity.dart';
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
  @override
  void initState() {
    super.initState();
    notificaciones = Notificacion();
    notificaciones.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: const Text("Actividades"),
      ),
      body: Container(
        child: ListView(
          children: [

            ElevatedButton(
              onPressed: () {
                
                anadir();
              },
              child: Text('New'),
            ),
          ],
        ) 
      ),
    );
  }
  void anadir() async {
    DateTime time = DateTime.now().add(Duration(minutes: 2));
    //ActivityCRUD.instance.insert(Activity(title: 'Actividad', date: time, duration: 10));
    print(time);
    await notificaciones.showNotification(id: 1, title: 'Activity ally', body: 'este es un recordatorio');

  }
}
