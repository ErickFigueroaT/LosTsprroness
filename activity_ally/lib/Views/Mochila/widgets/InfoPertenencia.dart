import 'package:activity_ally/ImageLoader.dart';
import 'package:activity_ally/Models/Pertenencia.dart';
import 'package:activity_ally/Presenters/PertenenciaPresenter.dart';
import 'package:flutter/material.dart';

class InfoPertenencia extends StatefulWidget {
  String titulo;
  String descripcion;
  final int id;
  bool estado;
  String? foto;
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
    var image = ImageLoader.loadImage(widget.foto);
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
        child: Column(
          children: [
          SizedBox(
            height:  500, // Adjust the height as needed
            child: ListView(
              children: [
                SizedBox(
                  child: Image(
                  image: image,
                  height: 300,
                  fit: BoxFit.cover,
                  //width: 200,
                )),
                Container(
                  child: const Text(
                    'Nombre: ',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  child: Text(widget.titulo, style: const TextStyle(fontSize: 20)),
                ),
                Container(
                  child: Text(
                    'Descripcion: ',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  child: Text(widget.descripcion, style: const TextStyle(fontSize: 20)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: const Text(
                        'Estado: ',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      child: Text(
                        statusObject(),
                        style: TextStyle(
                          fontSize: 20,
                          color: widget.estado == false ? Colors.red : Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
                // Add more widgets to the ListView if needed
              ],
            ),
          ),

          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue, // Set your desired background color here
                ),
                child: IconButton(
                  onPressed: () async {
                    Pertenencia pertenencia = Pertenencia(id: widget.id, nombre: widget.titulo, descripcion: widget.descripcion, status: widget.estado, foto: widget.foto);
                    pertenencia = await widget.presenter.onChange(context,pertenencia);
                    setState(() {
                      widget.titulo = pertenencia.nombre;
                      widget.descripcion = pertenencia.descripcion;
                      widget.foto = pertenencia.foto;
                      image = ImageLoader.loadImage(widget.foto);
                    });
                  },
                  icon: Icon(Icons.edit, color: Colors.white), // Set the icon color
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red, // Set your desired background color here
                ),
                child: IconButton(
                  onPressed: () {
                    widget.presenter.Eliminar(widget.id);
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.delete, color: Colors.white), // Set the icon color
                ),
              ),
            ],
          )
        ]),
      ),
    );
  }
}
/**
 * ElevatedButton(
                onPressed: () {
                  setState(()  {
                    widget.estado = true;
                  });
                  widget.presenter.onUpdate(Pertenencia(id: widget.id, nombre: widget.titulo, status: widget.estado, foto: widget.foto));
                },
                style:
                    ElevatedButton.styleFrom(padding: const EdgeInsets.all(15)),
                child: const Text("Recuperar"),
              ),
 */
