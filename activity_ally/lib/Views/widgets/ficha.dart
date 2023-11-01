import 'dart:io';
import 'package:flutter/material.dart';
import 'package:activity_ally/Views/Info.dart';

class Ficha extends StatefulWidget {
  final int id;
  final String descripcion;
  final String titulo;
  final bool estado;
  final String? foto;
  const Ficha(
      {required this.id,
      required this.titulo,
      required this.descripcion,
      required this.estado,
      required this.foto});

  @override
  State<Ficha> createState() => _FichaState();
}

class _FichaState extends State<Ficha> {
  @override
  Widget build(BuildContext context) {
    var image;
      if (widget.foto == null){
        image = new AssetImage('res/placeholder.jpg');
      }
      else{
        image = FileImage(File(widget.foto!));
      }
    return Material(
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => Info(
                        titulo: widget.titulo,
                        descripcion: widget.descripcion,
                        id: widget.id,
                        estado: widget.estado,
                        foto: widget.foto,
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
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16)),
                        image: DecorationImage(image: image)),//FileImage(widget.foto))),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(color: Colors.white54),
                    child: Text(widget.titulo,
                        style: const TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
