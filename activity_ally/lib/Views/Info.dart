import 'package:activity_ally/Api/PertenenciaCRUD.dart';
import 'package:flutter/material.dart';
class Info extends StatelessWidget {
  final String titulo;
  final String descripcion;
  final int id;
  final bool estado;
  const Info(
      {required this.titulo,
      required this.descripcion,
      required this.id,
      required this.estado,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String estadoActual = "";
    String statusObject() {
      if (estado) {
        estadoActual = "OK";
      } else {
        estadoActual = "Perdido";
      }
      return estadoActual;
    }

    return Scaffold(
      appBar: AppBar(title: Text(titulo)),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey, width: 2)),
        child: Column(children: [
          /*SizedBox(
              child: Image(
            image: NetworkImage(pictureUrl),
            height: 400,
            width: 200,
          )),*/
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(
              child: const Text(
                'Nombre: ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              child: Text(titulo, style: const TextStyle(fontSize: 20)),
            )
          ]),
          Wrap(
            children: [
            
            Flexible(
              child: const Text(
                'Descripcion: ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Flexible(
              child: Text(descripcion, style: const TextStyle(fontSize: 20)),
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
                      color: estado == false ? Colors.red : Colors.green)),
            )
          ]),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  /*var form = formkey.currentState;
                    if (form!.validate()) {
                      form.save();
                      Navigator.of(context).pop(Objeto(
                          id: plus(), titulo: titulo, descripcion: descripcion));
                    }*/
                },
                style:
                    ElevatedButton.styleFrom(padding: const EdgeInsets.all(15)),
                child: const Text("Editar"),
              ),
              ElevatedButton(
                onPressed: () {
                  PertenenciaCRUD.instance.delete(id);
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