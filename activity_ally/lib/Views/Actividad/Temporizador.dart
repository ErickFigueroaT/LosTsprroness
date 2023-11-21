import 'dart:async';
import 'package:activity_ally/services/DB/ActivityCRUD.dart';
import 'package:activity_ally/Models/Activity.dart';
import 'package:activity_ally/Presenters/ActivityPresenter.dart';
import 'package:activity_ally/Views/Updatable.dart';
import 'package:flutter/material.dart';

class Temporizador extends StatefulWidget {
  //const Temporizador({super.key});

  final Activity actividad;
  final ActivityPresenter presenter;
  final Updatable parent;

  const Temporizador(
      {required this.actividad, required this.presenter, required this.parent});

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
    // Calculate initial duration based on the difference between actividad.startDate and now
    DateTime now = DateTime.now();
    Duration difference = now.difference(widget.actividad.startDate!);
    duration = Duration(seconds: difference.inSeconds);
    startTimer();
  }

  void addTime() {
    final addSeconds = 1;
    if (mounted) {
      setState(() {
        final seconds = duration.inSeconds + addSeconds;

        duration = Duration(seconds: seconds);
      });
    }
  }

  void startTimer({bool resets = true}) {
    if (resets) {
      reset();
    }

    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  void reset() {
    setState(() => duration = Duration());
  }

  void stopTimer({bool resets = true}) {
    if (resets) {
      reset();
    }

    setState(() => timer?.cancel());
  }

  @override
  Widget build(BuildContext context) {
    final isRunning = timer == null ? false : timer!.isActive;
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
              setState(() => duration = const Duration());
              widget.parent.updateView();
              Navigator.of(context).pop();
              widget.presenter.finish(widget.actividad, context);
            },
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(15)),
            child: const Text("Terminar"),
          ),
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: () {
              if (isRunning) {
                widget.actividad.duration_r = duration.inSeconds;
                stopTimer(resets: false);
                widget.parent.updateView();
              } else {
                startTimer(resets: false);
              }
            },
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(15)),
            child: isRunning ? const Text("Pausar") : const Text("Continuar"),
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

  @override
  void dispose() {
    timer
        ?.cancel(); // Don't forget to cancel the timer when the widget is disposed
    super.dispose();
  }
}