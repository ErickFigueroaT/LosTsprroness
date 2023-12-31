import 'package:activity_ally/Models/Activity.dart';
import 'package:activity_ally/Presenters/ActivityPresenter.dart';
import 'package:activity_ally/Presenters/ChecklistPresenter.dart';
//import 'package:activity_ally/Presenters/PertenenciaPresenter.dart';
//import 'package:activity_ally/Views/Actividad/Temporizador.dart';
import 'package:activity_ally/Views/Updatable.dart';
//import 'package:activity_ally/Views/checklist/ChecklistMaker.dart';
import 'package:flutter/material.dart';

class InfoActividad extends StatefulWidget {
  final Activity actividad; // Added finishDate attribute
  final ActivityPresenter presenter;

  const InfoActividad({
    required this.actividad,
    required this.presenter,
  });

  @override
  State<InfoActividad> createState() => _InfoActividadState();
}

class _InfoActividadState extends State<InfoActividad> implements Updatable {
  int duracionReal = 0;
  int secs = 0;
  int mins = 0;
  int hors = 0;
  @override
  Widget build(BuildContext context) {
    if (widget.actividad.duration_r != null) {
      duracionReal = widget.actividad.duration_r!;
    }
    int horas = (widget.actividad.duration / 60).floor();
    int minutos = widget.actividad.duration % 60;
    secs = duracionReal % 60;
    mins = ((duracionReal / 60) % 60).floor();
    hors = (duracionReal / 3600).floor();

    return Scaffold(
      appBar: AppBar(title: Text(widget.actividad.title)),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 40),
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey, width: 2)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          //Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            child: const Text(
              'Nombre: ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Flexible(
            child: Text(widget.actividad.title,
                style: const TextStyle(fontSize: 20)),
          ),
          //]),
          //Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            child: Text(
              'Fecha: ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Flexible(
            child: Text(widget.actividad.date.toString(),
                style: const TextStyle(fontSize: 20)),
          ),
          //]),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(
              child: const Text(
                'Estimacion: ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              child: Text('$horas:${minutos.toString().padLeft(2, '0')}:00',
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
              child: Text(widget.actividad.location!,
                  style: const TextStyle(fontSize: 20)),
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
                '${hors.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 20),
              ),
            )
          ]),
          //Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            child: Text(
              'Descripcion: ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Flexible(
            child: Text(widget.actividad.description ?? '',
                style: const TextStyle(fontSize: 20)),
          ),
          //]),
          const SizedBox(height: 50),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              botonObjetos(),
              botonEditar(),
              botonIniciar(),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [botonEliminar()],
          )
        ]),
      ),
    );
  }

  botonIniciar() {
    if (widget.actividad.finishDate == null) {
      return customIconButton(
          duracionReal == 0 ? Icons.play_arrow : Icons.play_arrow,
          comenzar,
          Colors.blue);
    } else {
      return const Text('');
    }
  }

  botonObjetos() {
    if (widget.actividad.finishDate == null) {
      return customIconButton(Icons.backpack, agregar, Colors.blue);
    } else {
      return const Text('');
    }
  }

  void agregar() async {
    //Navigator.push(context, MaterialPageRoute(builder: (context) => ChecklistMaker(id: widget.actividad.id, presenter: PertenenciaPresenter(),)));
    ChecklistPresenter presenter = ChecklistPresenter();
    presenter.makeChecklist(context, widget.actividad.id);
  }

  botonEliminar() {
    return customIconButton(Icons.delete, eliminar, Colors.red);
  }

  eliminar() {
    widget.presenter.cancelar(widget.actividad);
    Navigator.of(context).pop();
  }

  botonEditar() {
    if (widget.actividad.startDate == null) {
      return customIconButton(Icons.edit, editar, Colors.blue);
    } else {
      return const Text('');
    }
  }

  void editar() async {
    int id = await widget.presenter.onChange(context, widget.actividad);
    if (id >0 ) {
      updateView();
    }
  }

  void comenzar() async {
    bool complete = await widget.presenter.start(widget.actividad, context);
    if (complete) {
      duracionReal = widget.actividad.duration_r ?? 0;
      updateView();
    }
    //Navigator.push(context, MaterialPageRoute(builder: (context) => Temporizador(actividad: widget.actividad, presenter: widget.presenter, parent: this,)));
  }

  Container customIconButton(
      IconData icon, Function onPressed, Color backgroundColor) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
      ),
      child: IconButton(
        onPressed: () => onPressed(),
        style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(15)),
        icon: Icon(icon, color: Colors.white),
      ),
    );
  }

  @override
  updateView() {
    setState(() {});
  }
}
