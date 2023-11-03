import 'package:activity_ally/Api/ActivityCRUD.dart';
import 'package:activity_ally/Models/Activity.dart';
import 'package:activity_ally/Views/Actividad/Temporizador.dart';
import 'package:flutter/material.dart';

class InfoActividad extends StatefulWidget {
  final int id;
  final String title;
  final DateTime date;
  final int duration;
  final String? location;
  final String? description;
  final DateTime? finishDate;
  final int? duration_r; // Added finishDate attribute

  const InfoActividad(
      {required this.id,
      required this.title,
      required this.date,
      required this.duration,
      this.location,
      this.description,
      this.finishDate,
      // ignore: non_constant_identifier_names
      this.duration_r // Added finishDate parameter in constructor
      });

  @override
  State<InfoActividad> createState() => _InfoActividadState();
}

class _InfoActividadState extends State<InfoActividad> {
  int duracionReal = 0;
  int secs = 0;
  int mins = 0;
  int hors = 0;
  String s = '';
  String m = '';
  String h = '';
  @override
  Widget build(BuildContext context) {
    print('---------------');
    print(widget.duration_r);
    print(widget.duration);
    if (widget.duration_r != null) {
      duracionReal = widget.duration_r!;
    }
    double horas = widget.duration / 60;
    double minutos = widget.duration % 60;
    int hrs = horas.round();
    int min = minutos.round();
    String hours = hrs.toString();
    String minutes = min.toString();
    secs = duracionReal % 60;
    mins = (duracionReal / 60).floor();
    hors = (duracionReal / 3600).floor();

    s = secs.toString();
    m = mins.toString();
    h = hors.toString();
    if (hrs < 10) {
      hours = '0' + hrs.toString();
    }
    if (min < 10) {
      minutes = '0' + min.toString();
    }
    if (secs < 10) {
      s = '0' + secs.toString();
    }
    if (mins < 10) {
      m = '0' + mins.toString();
    }
    if (hors < 10) {
      h = '0' + hors.toString();
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 40),
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey, width: 2)),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(
              child: const Text(
                'Nombre: ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Flexible(
              child: Text(widget.title, style: const TextStyle(fontSize: 20)),
            )
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            const Flexible(
              child: Text(
                'Fecha: ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Flexible(
              child: Text(widget.date.toString(),
                  style: const TextStyle(fontSize: 20)),
            )
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(
              child: const Text(
                'Estimacion: ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              child: Text('$hours:$minutes:00',
                  style: const TextStyle(fontSize: 20)),
            )
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(
              child: const Text(
                'Lugar: ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              child:
                  Text(widget.location!, style: const TextStyle(fontSize: 20)),
            )
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(
              child: const Text(
                'Duracion: ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              child: Text(
                '$h:$m:$s',
                style: const TextStyle(fontSize: 20),
              ),
            )
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            const Flexible(
              child: Text(
                'Descripcion: ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Flexible(
              child: Text(widget.description!,
                  style: const TextStyle(fontSize: 20)),
            ),
          ]),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              boton(),
              ElevatedButton(
                onPressed: () {
                  ActivityCRUD.instance.delete(widget.id);
                  Navigator.of(context).pop();
                },
                style:
                    ElevatedButton.styleFrom(padding: const EdgeInsets.all(15)),
                child: const Text("Eliminar"),
              ),
            ],
          )
        ]),
      ),
    );
  }

  boton() {
    if (duracionReal == 0) {
      return ElevatedButton(
        onPressed: actualizar,
        style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(15)),
        child: const Text("Comenzar"),
      );
    } else {
      return const Text('');
    }
  }

  void actualizar() async {
    final nuevo = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => Temporizador()));
    setState(() => duracionReal = nuevo!);
    ActivityCRUD.instance.update(Activity(
        id: widget.id,
        title: widget.title,
        date: widget.date,
        duration: widget.duration,
        location: widget.location,
        description: widget.description,
        duration_r: nuevo));
    print(' a ' + widget.duration_r.toString());
  }
}
