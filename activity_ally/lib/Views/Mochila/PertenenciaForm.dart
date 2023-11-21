import 'package:flutter/material.dart';
import 'dart:io';
import 'package:activity_ally/Views/Mochila/widgets/image_input.dart';

class PertenenciaForm extends StatefulWidget {
  final String nombre;
  final String descripcion;
  final String? foto;

  const PertenenciaForm({ 
    this.nombre ='',
    this.descripcion ='',
    this.foto,
  });

  @override
  State<PertenenciaForm> createState() => _PertenenciaFormState();
}

class _PertenenciaFormState extends State<PertenenciaForm> {

  final formkey = GlobalKey<FormState>();
  
  int id = 0;
  var nombre = '';
  var descripcion = '';
  String? seleccion;
  
  late TextEditingController nombreController ;
  late TextEditingController descripcionController;
  
  void initState() {
    super.initState();
    nombreController = TextEditingController(text: widget.nombre);
    descripcionController= TextEditingController(text: widget.descripcion);
  }


  setNombre(String nombre){
    nombreController.text = nombre;
  }

  void setDescripcion(String descripcion) {
    descripcionController.text = descripcion;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.nombre != '' ? 'Editar Actividad' : 'Nueva Actividad')),
      body: Center(
          child: Form(
        key: formkey,
        child: ListView(
          //mainAxisSize: MainAxisSize.min,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ImageInput(
              initialImagePath: widget.foto,
              onPickImage: (image) {
                seleccion = image.path;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: nombreController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: "nombre"),
              onSaved: (value) {
                nombre = value!;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Introduce nombre';
                }
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: descripcionController,
              maxLines: 3,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: "Descripcion"),
              onSaved: (value) {
                descripcion = value!;
              },
              /*
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Introduce descripcion';
                }
              },
              */
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                var form = formkey.currentState;
                if (form!.validate()) {
                  form.save();
                  //widget.presenter.onSubmit(nombre, descripcion, seleccion);
                  Map<String, dynamic> res = {
                    'nombre':nombre,
                    'descripcion': descripcion,
                    'foto': seleccion
                    ,};
                  Navigator.of(context).pop(res);

                }
              },
              style:
                  ElevatedButton.styleFrom(padding: const EdgeInsets.all(15)),
              child: const Text("Guardar"),
            )
          ],
        ),
      )),
    );
  }
}
