import 'package:activity_ally/Presenters/ActivityPresenter.dart';
import 'package:activity_ally/services/Notificacion.dart';
import 'package:flutter/material.dart';

class FichaActividad extends StatefulWidget {
  //Activity actividad; // Added finishDate attribute
  ActivityPresenter presenter;
  int id;
  String title;
  DateTime  date;
  bool notify;
  DateTime? startDate, finishDate;

  FichaActividad(
      {required this.id, 
      required this.title,
      required this.date,
      required this.notify,
      required this.presenter,
      this.finishDate, this.startDate});

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
    bool isPast = widget.date.isBefore(DateTime.now());
    bool isFinished = widget.finishDate != null;

    Color containerColor = Colors.white70;

    if (isPast && !isFinished) {
      containerColor = Colors.red[100] ?? Colors.red; // Use red[100] if available, else use default red
    } else if (isFinished) {
      containerColor = Colors.grey[300] ?? Colors.grey; // Use grey[100] if available, else use default grey
    }
    bool bell = isPast || isFinished || widget.startDate != null ;
    return Material(
      child: InkWell(
        onTap:showDetails,
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
                      title: Text(widget.title,
                          style: const TextStyle(fontSize: 20)),
                      subtitle: Text(widget.date.toString()),
                      trailing: bell ? null : IconButton(
                        icon: widget.notify ? Icon(Icons.notifications_active) : Icon(Icons.notifications_off),
                        onPressed: () async {
                          int id = await widget.presenter.changeSub(context, widget.id);
                          if(id>0){
                            setState(() {
                              widget.notify = !widget.notify;
                            });
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
  showDetails(){
    widget.presenter.showDetails(context, widget.id);
  }

  
}
