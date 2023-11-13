import 'package:activity_ally/Models/Activity.dart';
import 'package:activity_ally/Presenters/PertenenciaPresenter.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:activity_ally/Models/Pertenencia.dart';
import 'package:activity_ally/Views/Mochila/widgets/image_input.dart';

class PertenenciaForm extends StatefulWidget {
  final PertenenciaPresenter presenter;
  const PertenenciaForm(this.presenter,);

  @override
  State<PertenenciaForm> createState() => _PertenenciaFormState();
}

class _PertenenciaFormState extends State<PertenenciaForm> {
  //Pertenencia Pertenencia = Pertenencia(id: 0, nombre: '', descripcion: '');
  //List<Pertenencia> Pertenencias = [];
  String? seleccion;

  final formkey = GlobalKey<FormState>();
  int id = 0;
  var nombre = '';
  var descripcion = '';

  int plus() {
    id++;
    return id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add')),
      body: Center(
          child: Form(
        key: formkey,
        child: ListView(
          //mainAxisSize: MainAxisSize.min,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ImageInput(
              onPickImage: (image) {
                seleccion = image.path;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
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
              maxLines: 3,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: "Descripcion"),
              onSaved: (value) {
                descripcion = value!;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Introduce descripcion';
                }
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                var form = formkey.currentState;
                if (form!.validate()) {
                  form.save();
                  widget.presenter.onSubmit(nombre, descripcion, seleccion);
                  Navigator.of(context).pop();

                }
              },
              style:
                  ElevatedButton.styleFrom(padding: const EdgeInsets.all(15)),
              child: const Text("Agregar"),
            )
          ],
        ),
      )),
    );
  }
}