import 'package:activity_ally/Api/ActivityCRUD.dart';
import 'package:activity_ally/Views/Actividad/Temporizador.dart';
import 'package:flutter/material.dart';

class InfoActividad extends StatelessWidget {
  final int id;
  final String title;
  final DateTime date;
  final int duration;
  final String? location;
  final String? description;
  final DateTime? finishDate; // Added finishDate attribute

  const InfoActividad({
    required this.id,
    required this.title,
    required this.date,
    required this.duration,
    this.location,
    this.description,
    this.finishDate, // Added finishDate parameter in constructor
  });

  @override
  Widget build(BuildContext context) {
    //int horas = duration/60 ;
    //int minutos = 0 ;
    //int segundos = 0 ;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
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
            Container(
              child: Text(title, style: const TextStyle(fontSize: 20)),
            )
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Flexible(
              child: const Text(
                'Fecha: ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Flexible(
              child:
                  Text(date.toString(), style: const TextStyle(fontSize: 20)),
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
              child: Text(duration.toString() + ' minutos',
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
              child: Text(location!, style: const TextStyle(fontSize: 20)),
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
              child: Text(description!, style: const TextStyle(fontSize: 20)),
            ),
          ]),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final nuevo = await Navigator.of(context).push<int>(
                      MaterialPageRoute(builder: (context) => Temporizador()));
                  if (nuevo == null) {
                    return;
                  }
                },
                style:
                    ElevatedButton.styleFrom(padding: const EdgeInsets.all(15)),
                child: const Text("Comenzar"),
              ),
              ElevatedButton(
                onPressed: () {
                  ActivityCRUD.instance.delete(id);
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
}
