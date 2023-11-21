import 'dart:io';
import 'package:activity_ally/ImageLoader.dart';
import 'package:activity_ally/Presenters/PertenenciaPresenter.dart';
import 'package:flutter/material.dart';
import 'package:activity_ally/Views/Mochila/widgets/InfoPertenencia.dart';

class FichaPertnencia extends StatefulWidget {
  final int id;
  final String descripcion;
  final String titulo;
  final bool estado;
  final String? foto;
  final PertenenciaPresenter presenter;
  const FichaPertnencia(
      {required this.id,
      required this.titulo,
      required this.descripcion,
      required this.estado,
      required this.foto,
      required this.presenter});

  @override
  State<FichaPertnencia> createState() => _FichaPertnenciaState();
}

class _FichaPertnenciaState extends State<FichaPertnencia> {
  @override
  Widget build(BuildContext context) {
    var image = ImageLoader.loadImage(widget.foto);
    return Material(
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => InfoPertenencia(
                        titulo: widget.titulo,
                        descripcion: widget.descripcion,
                        id: widget.id,
                        estado: widget.estado,
                        foto: widget.foto,
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
