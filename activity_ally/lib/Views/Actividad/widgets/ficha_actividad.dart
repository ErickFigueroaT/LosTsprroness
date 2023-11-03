import 'package:activity_ally/Views/Actividad/widgets/info_actividad.dart';
import 'package:flutter/material.dart';

class FichaActividad extends StatefulWidget {
  int id;
  String title;
  DateTime date;
  int duration;
  String? location;
  String? description;
  DateTime? finishDate;
  int? duration_r; // Added finishDate attribute

  FichaActividad(
      {required this.id,
      required this.title,
      required this.date,
      required this.duration,
      this.location,
      this.description,
      this.finishDate, // Added finishDate parameter in constructor
      this.duration_r});

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
                        title: widget.title,
                        id: widget.id,
                        description: widget.description,
                        location: widget.location,
                        date: widget.date,
                        duration: widget.duration,
                        duration_r: widget.duration_r,
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
                      title: Text(widget.title,
                          style: const TextStyle(fontSize: 20)),
                      subtitle: Text(widget.date.toString()),
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
