import 'dart:async';
import 'package:activity_ally/Api/ActivityCRUD.dart';
import 'package:activity_ally/Models/Activity.dart';
import 'package:flutter/material.dart';

class Temporizador extends StatefulWidget {
  //const Temporizador({super.key});

final Activity actividad;

const Temporizador({required this.actividad});

  @override
  State<Temporizador> createState() => _TemporizadorState();
}

class _TemporizadorState extends State<Temporizador> {
  Duration duration = Duration();
  Timer? timer;
  int total = 0;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void addTime() {
    final addSeconds = 1;
    if (mounted){
    setState(() {
      final seconds = duration.inSeconds + addSeconds;

      duration = Duration(seconds: seconds);
    });
      
    }
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Temporizador")),
      body: Center(
          child: Column(
        children: [
          const SizedBox(height: 100),
          buildTime(),
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: () {
              widget.actividad.duration_r = duration.inSeconds;
              ActivityCRUD.instance.update(widget.actividad);
              widget.actividad.finishDate = DateTime.now();
              setState(() => duration = const Duration());
              setState(() => timer?.cancel());
              Navigator.of(context).pop(widget.actividad.duration_r);
            },
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(15)),
            child: const Text("Terminar"),
          ),
        ],
      )),
    );
  }

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    int horas = int.parse(hours);
    int minutos = int.parse(minutes);
    int segundos = int.parse(seconds);
    total = horas * 3600 + minutos * 60 + segundos;

    return Text(
      '$hours:$minutes:$seconds',
      style: TextStyle(fontSize: 80),
    );
  }
}
