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
    if (widget.actividad.duration_r == null ||
        widget.actividad.duration_r == 0) {
      duration = Duration(seconds: difference.inSeconds);
      startTimer();
    } else {
      duration = Duration(seconds: widget.actividad.duration_r!);
      startTimer(resets: false);
    }
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
          const SizedBox(height: 200),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 120),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                    child: IconButton(
                        onPressed: () {
                          if (isRunning) {
                            widget.actividad.duration_r = duration.inSeconds;
                            stopTimer(resets: false);
                            widget.parent.updateView();
                          } else {
                            startTimer(resets: false);
                          }
                        },
                        icon: isRunning
                            ? const Icon(Icons.pause, color: Colors.white)
                            : const Icon(Icons.play_arrow,
                                color: Colors.white)),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                    child: IconButton(
                      onPressed: () {
                        widget.actividad.duration_r = duration.inSeconds;
                        setState(() => duration = const Duration());
                        widget.parent.updateView();
                        Navigator.of(context).pop();
                        widget.presenter.finish(widget.actividad, context);
                      },
                      icon: const Icon(Icons.stop, color: Colors.white),
                    ),
                  ),
                ]),
          )
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
