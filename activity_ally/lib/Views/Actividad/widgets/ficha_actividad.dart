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
  int duracionReal = 0;
  @override
  Widget build(BuildContext context) {
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
