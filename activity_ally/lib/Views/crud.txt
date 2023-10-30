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
        nombre: 'Backpack',
        descripcion: 'A sturdy backpack for carrying essentials.',
        foto:
            'https://www.google.com/url?sa=i&url=https%3A%2F%2Fpixabay.com%2Fes%2Fvectors%2Fimagen-icono-sitio-web-dibujo-2008484%2F&psig=AOvVaw2NOoiSnpHL3Jkj-qZWX3WE&ust=1698724452893000&source=images&cd=vfe&opi=89978449&ved=0CBMQjhxqFwoTCNDBse7vnIIDFQAAAAAdAAAAABAE',
        status: true,
      ),
      Pertenencia(
        nombre: 'Wallet',
        descripcion: 'A leather wallet with multiple card slots.',
        foto:
            'https://www.google.com/url?sa=i&url=https%3A%2F%2Fpixabay.com%2Fes%2Fvectors%2Fimagen-icono-sitio-web-dibujo-2008484%2F&psig=AOvVaw2NOoiSnpHL3Jkj-qZWX3WE&ust=1698724452893000&source=images&cd=vfe&opi=89978449&ved=0CBMQjhxqFwoTCNDBse7vnIIDFQAAAAAdAAAAABAE',
        status: true,
      ),
      Pertenencia(
        nombre: 'Laptop',
        descripcion: 'A powerful laptop for work and entertainment.',
        foto:
            'https://www.google.com/url?sa=i&url=https%3A%2F%2Fpixabay.com%2Fes%2Fvectors%2Fimagen-icono-sitio-web-dibujo-2008484%2F&psig=AOvVaw2NOoiSnpHL3Jkj-qZWX3WE&ust=1698724452893000&source=images&cd=vfe&opi=89978449&ved=0CBMQjhxqFwoTCNDBse7vnIIDFQAAAAAdAAAAABAE',
        status: true,
      ),
      Pertenencia(
        nombre: 'Watch',
        descripcion: 'A stylish wristwatch with a metal strap.',
        foto:
            'https://www.google.com/url?sa=i&url=https%3A%2F%2Fpixabay.com%2Fes%2Fvectors%2Fimagen-icono-sitio-web-dibujo-2008484%2F&psig=AOvVaw2NOoiSnpHL3Jkj-qZWX3WE&ust=1698724452893000&source=images&cd=vfe&opi=89978449&ved=0CBMQjhxqFwoTCNDBse7vnIIDFQAAAAAdAAAAABAE',
        status: true,
      ),
      Pertenencia(
        nombre: 'Sunglasses',
        descripcion: 'Designer sunglasses with UV protection.',
        foto:
            'https://www.google.com/url?sa=i&url=https%3A%2F%2Fpixabay.com%2Fes%2Fvectors%2Fimagen-icono-sitio-web-dibujo-2008484%2F&psig=AOvVaw2NOoiSnpHL3Jkj-qZWX3WE&ust=1698724452893000&source=images&cd=vfe&opi=89978449&ved=0CBMQjhxqFwoTCNDBse7vnIIDFQAAAAAdAAAAABAE',
        status: true,
      )
    ];
    //PertenenciaCRUD pcrud = PertenenciaCRUD();
    for (Pertenencia p in samplePertenencias) {
      PertenenciaCRUD.instance.insert(p);
    } //AADB.instance.hashCode;
    objetos = PertenenciaCRUD.instance.getAllItems();
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
