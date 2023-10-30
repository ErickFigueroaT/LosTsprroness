import 'package:activity_ally/Api/AADB.dart';
import 'package:activity_ally/Api/PertenenciaCRUD.dart';
import 'package:activity_ally/Models/Pertenencia.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'dart:io';

class crud extends StatefulWidget {
  const crud({super.key});

  @override
  State<crud> createState() => _crudState();
}

class _crudState extends State<crud> {
  final String pe = '$Path';
  late Future<List<Pertenencia>> objetos;

  @override
  void initState() {
    super.initState();
    List<Pertenencia> samplePertenencias = [
      Pertenencia(
        nombre: 'Matenme3',
        status: true,
        descripcion: 'Description for matenme',
      ),
    ];
    //PertenenciaCRUD pcrud = PertenenciaCRUD();
    AADB.instance.insert(samplePertenencias[0]);

    objetos = AADB.instance.getAllItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Publicaciones"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<List<Pertenencia>>(
          future: objetos,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Show loading indicator
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<Pertenencia> pertenencias = snapshot.data!;
              return ListView.builder(
                itemCount: pertenencias.length,
                itemBuilder: (context, index) {
                  final item = pertenencias[index];
                  return Pertenencia(
                      id: item.id,
                      nombre: item.nombre,
                      descripcion: item.descripcion,
                      foto: item.foto);
                },
              );
            }
          },
        ),
      ),
    );
  }
}
