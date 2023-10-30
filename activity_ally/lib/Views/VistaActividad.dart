import 'package:flutter/material.dart';

class Plantilla extends StatefulWidget {
  const Plantilla({super.key});

  @override
  State<Plantilla> createState() => _PlantillaState();
}

class _PlantillaState extends State<Plantilla> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Publicaciones"),
      ),
    );
  }
}
