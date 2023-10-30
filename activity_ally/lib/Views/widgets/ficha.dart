import 'package:flutter/material.dart';
import 'package:activity_ally/Models/Pertenencia.dart';
import 'package:activity_ally/Views/Info.dart';

class Ficha extends StatefulWidget {
  final int id;
  final String descripcion;
  final String titulo;
  final bool estado;
  const Ficha(
      {required this.id,
      required this.titulo,
      required this.descripcion,
      required this.estado,
      Key? key})
      : super(key: key);

  @override
  State<Ficha> createState() => _FichaState();
}

class _FichaState extends State<Ficha> {
  @override
  Widget build(BuildContext context) {
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
                      estado: widget.estado))));
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
                    decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                    ),
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
