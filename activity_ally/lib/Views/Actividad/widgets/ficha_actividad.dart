import 'package:activity_ally/services/DB/ActivityCRUD.dart';
import 'package:activity_ally/Models/Activity.dart';
import 'package:activity_ally/Presenters/ActivityPresenter.dart';
import 'package:activity_ally/Views/Actividad/widgets/info_actividad.dart';
import 'package:activity_ally/services/Notificacion.dart';
import 'package:flutter/material.dart';

class FichaActividad extends StatefulWidget {
  Activity actividad; // Added finishDate attribute
  ActivityPresenter presenter;

  FichaActividad(
      {required this.actividad,
      required this.presenter});

  @override
  State<FichaActividad> createState() => _FichaActividadState();
}

class _FichaActividadState extends State<FichaActividad> {
   late final Notificacion notificaciones;
  
  void initState() {
    super.initState();
    notificaciones = Notificacion();
    notificaciones.initialize();
  }
    


  @override
  Widget build(BuildContext context) {
    bool isPast = widget.actividad.date.isBefore(DateTime.now());
    bool isFinished = widget.actividad.finishDate != null;

    Color containerColor = Colors.white70;

    if (isPast && !isFinished) {
      containerColor = Colors.red[100] ?? Colors.red; // Use red[100] if available, else use default red
    } else if (isFinished) {
      containerColor = Colors.grey[300] ?? Colors.grey; // Use grey[100] if available, else use default grey
    }
    bool bell = isPast || isFinished || widget.actividad.startDate != null ;
    return Material(
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => InfoActividad(
                        actividad: widget.actividad,
                        presenter: widget.presenter,
                      ))));
        },
        splashColor: Colors.blueGrey,
          child: Container(
            decoration: BoxDecoration(
            color: containerColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey, width: 1),
          ),
          child: Column(
            children: [
              //Card(child: 
              Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      title: Text(widget.actividad.title,
                          style: const TextStyle(fontSize: 20)),
                      subtitle: Text(widget.actividad.date.toString()),
                      trailing: bell ? null : IconButton(
                        icon: widget.actividad.notify ? Icon(Icons.notifications_active) : Icon(Icons.notifications_off),
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
              //),
            ],
          ),
        ),
      ),
    );
  }
}
