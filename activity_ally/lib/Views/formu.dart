import 'package:flutter/material.dart';
import 'dart:io';
import 'package:activity_ally/Models/Pertenencia.dart';
import 'package:activity_ally/Views/widgets/image_input.dart';

class Formu extends StatefulWidget {
  const Formu({super.key});

  @override
  State<Formu> createState() => _FormuState();
}

class _FormuState extends State<Formu> {
  //Pertenencia Pertenencia = Pertenencia(id: 0, nombre: '', descripcion: '');
  //List<Pertenencia> Pertenencias = [];
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
            const ImageInput(),
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
                  Navigator.of(context).pop(Pertenencia(
                      id: 0,
                      nombre: nombre,
                      status: true,
                      descripcion: descripcion,
                      //foto: File(''),
                      ));
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
