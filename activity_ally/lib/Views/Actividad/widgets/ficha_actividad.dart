import 'package:activity_ally/Models/Activity.dart';
import 'package:activity_ally/Presenters/ActivityPresenter.dart';
import 'package:activity_ally/Views/Actividad/widgets/info_actividad.dart';
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
  //int duracionReal = 0;
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

    return Material(
      child: InkWell(
        onTap: () async {
          final nuevo = await Navigator.push(
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
               Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      title: Text(widget.actividad.title,
                          style: const TextStyle(fontSize: 20)),
                      subtitle: Text(widget.actividad.date.toString()),
                    ),
                  ],
               )  
            ],
          ),
        ),
      ),
    );
  }
}
