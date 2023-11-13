import 'dart:io';

import 'package:activity_ally/services/DB/PertenenciaCRUD.dart';
import 'package:activity_ally/Models/Pertenencia.dart';
import 'package:activity_ally/Presenters/PertenenciaPresenter.dart';
import 'package:flutter/material.dart';

class InfoPertenencia extends StatefulWidget {
  final String titulo;
  final String descripcion;
  final int id;
  bool estado;
  final String? foto;
  final PertenenciaPresenter presenter;
  InfoPertenencia(
      {required this.titulo,
      required this.descripcion,
      required this.id,
      required this.estado,
      required this.foto,
      required this.presenter});

  @override
  State<InfoPertenencia> createState() => _InfoPertenenciaState();
}

class _InfoPertenenciaState extends State<InfoPertenencia> {
  @override
  Widget build(BuildContext context) {
    var image;
    if (widget.foto == null) {
      image = new AssetImage('res/placeholder.jpg');
    } else {
      image = FileImage(File(widget.foto!));
    }
    String estadoActual = "";
    String statusObject() {
      if (widget.estado) {
        estadoActual = "OK";
      } else {
        estadoActual = "Perdido";
      }
      return estadoActual;
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.titulo)),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey, width: 2)),
        child: Column(children: [
          SizedBox(
              child: Image(
            image: image,
            height: 400,
            width: 200,
          )),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(
              child: const Text(
                'Nombre: ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              child: Text(widget.titulo, style: const TextStyle(fontSize: 20)),
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
              child: Text(widget.descripcion, style: const TextStyle(fontSize: 20)),
            ),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(
              child: const Text(
                'Estado: ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              child: Text(statusObject(),
                  style: TextStyle(
                      fontSize: 20,
                      color: widget.estado == false ? Colors.red : Colors.green)),
            )
          ]),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(()  {
                    widget.estado = true;
                  });
                  widget.presenter.onUpdate(Pertenencia(id: widget.id, nombre: widget.titulo, status: widget.estado, foto: widget.foto));
                  /*var form = formkey.currentState;
                    if (form!.validate()) {
                      form.save();
                      Navigator.of(context).pop(Objeto(
                          id: plus(), titulo: titulo, descripcion: descripcion));
                    }*/
                },
                style:
                    ElevatedButton.styleFrom(padding: const EdgeInsets.all(15)),
                child: const Text("Recuperar"),
              ),
              ElevatedButton(
                onPressed: () {
                  widget.presenter.Eliminar(widget.id);
                  Navigator.of(context).pop();
                  /*var form = formkey.currentState;
                    if (form!.validate()) {
                      form.save();
                      Navigator.of(context).pop(Objeto(
                          id: plus(), titulo: titulo, descripcion: descripcion));
                    }*/
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
