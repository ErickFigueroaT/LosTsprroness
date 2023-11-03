import 'package:activity_ally/Api/ActivityCRUD.dart';
import 'package:activity_ally/Models/Activity.dart';
import 'package:activity_ally/Views/Actividad/widgets/info_actividad.dart';
import 'package:activity_ally/services/Notificacion.dart';
import 'package:flutter/material.dart';

class FichaCampana extends StatefulWidget {
  Activity actividad; // Added finishDate attribute

  FichaCampana({
    required this.actividad,
  });

  @override
  State<FichaCampana> createState() => _FichaCampanaState();
}

class _FichaCampanaState extends State<FichaCampana> {
  late final Notificacion notificaciones;
  
  void initState() {
    super.initState();
    notificaciones = Notificacion();
    notificaciones.initialize();
  }
    


  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => InfoActividad(
                        title: widget.actividad.title,
                        id: widget.actividad.id,
                        description: widget.actividad.description,
                        location: widget.actividad.location,
                        date: widget.actividad.date,
                        duration: widget.actividad.duration,
                      ))));
        },
        splashColor: Colors.blueGrey,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey, width: 1)),
          child: Column(
            children: [
              Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      title: Text(widget.actividad.title,
                          style: const TextStyle(fontSize: 20)),
                      subtitle: Text(widget.actividad.date.toString()),
                      trailing: widget.actividad.date.isBefore(DateTime.now()) ? null : IconButton(
                        icon: widget.actividad.notify ? Icon(Icons.notifications_active) : Icon(Icons.notifications),
                        onPressed: () {
                          if(widget.actividad.date.isAfter(DateTime.now())){
                            if(widget.actividad.notify == false){
                              notificaciones.NotificacionProgramada(
                              Activity(id: widget.actividad.id, title: widget.actividad.title, date: widget.actividad.date, duration: widget.actividad.duration));
                            }
                            else{
                              notificaciones.cancela(widget.actividad.id);
                            }
                            setState(() {
                              widget.actividad.notify = !widget.actividad.notify;
                              ActivityCRUD.instance.update(widget.actividad);
                            });
                          }
                          else{
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Recordatorio fallido: actividad en una fecha pasada'),
                                backgroundColor:
                                    Colors.red, // Set snackbar color to red
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  
}
