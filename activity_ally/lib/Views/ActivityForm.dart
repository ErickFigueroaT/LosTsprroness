import 'package:activity_ally/Models/Activity.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';

class ActivityForm extends StatefulWidget {
  const ActivityForm({super.key});

  @override
  State<ActivityForm> createState() => _ActivityFormState();
}

class _ActivityFormState extends State<ActivityForm> {
  //Pertenencia Pertenencia = Pertenencia(id: 0, nombre: '', descripcion: '');
  //List<Pertenencia> Pertenencias = [];
  final formkey = GlobalKey<FormState>();
  int id = 0;
  var title = '';
  var description = '';
  var location = '';
  DateTime duracion =  DateTime(2000, 1, 10, 00, 00);
  DateTime? fecha;
  TimeOfDay? hora;
  
  DateTime hoy =  DateTime.now();
  var hours = DateTime.now().add(Duration(hours: 1)).hour;
  var minutes = '00';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva actividad')),
      body: Center(
          child: Form(
        key: formkey,
        child: ListView(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: "nombre"),
              onSaved: (value) {
                title = value!;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Introduce nombre';
                }
              },
            ),

            ElevatedButton(
                  child: Text('${hoy.day}/${hoy.month}/${hoy.year}'),
                  onPressed: () async {
                    fecha = await pickDate();
                    if(fecha != null){
                      setState(() => hoy = fecha!);
                    }
                  },
                ),
            
            ElevatedButton(
                  child: Text('${hours}:${minutes}'),
                  onPressed: () async {
                    hora = await pickTime();
                    if(hora != null){
                      setState((){hours = hora!.hour; minutes = hora!.minute.toString();} );
                    }
                  },
                ),
            
          
                  const Text('Duracion'),
                  CupertinoButton(
                    // Display a CupertinoDatePicker in time picker mode.
                    onPressed: () => _showDialog(
                      CupertinoDatePicker(
                        initialDateTime: duracion,
                        mode: CupertinoDatePickerMode.time,
                        use24hFormat: true,
                        // This is called when the user changes the time.
                        onDateTimeChanged: (DateTime newTime) {
                          setState(() => duracion = newTime);
                        },
                      ),
                    ),
                    child: Text(
                      '${duracion.hour}:${duracion.minute}',
                      style: const TextStyle(
                        fontSize: 22.0,
                      ),
                    ),
                    
                  ),

            const SizedBox(height: 10),
            TextFormField(
              maxLines: 3,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: "Descripcion"),
              onSaved: (value) {
                description = value!;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Introduce descripcion';
                }
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: "Ubicacion"),
              onSaved: (value) {
                title = value!;
              },
              //validator: (value) {
              //  if (value == null || value.isEmpty) {
              //    return 'Introduce un lugar';
              //  }
              //},
            ),

            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                var form = formkey.currentState;
                if (form!.validate()) {
                  final minutos = (duracion.hour * 60) + duracion.minute; 
                  if (minutos <= 0){

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Agrega una duracion aproximada'),
                        backgroundColor: Colors.red, // Set snackbar color to red
                      ),
                    );
                    return ;
                  }
                  form.save();
                  final fecha_hora;
                  if(fecha != null && hora != null)
                    fecha_hora = new DateTime(fecha!.year, fecha!.month, fecha!.day, hora!.hour, hora!.minute, 0, 0, 0);
                  else{
                    fecha_hora = new DateTime(hoy!.year, hoy!.month, hoy!.day, hours, 0, 0, 0, 0);
                  }
                  Navigator.of(context).pop(Activity(
                      id: 0,
                      title: title,
                      date: fecha_hora,
                      description: description,
                      duration: minutos,
                      location: location,
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

  Future<DateTime?> pickDate() => 
  showDatePicker(
    context: context, 
    initialDate: DateTime.now(), 
    firstDate: DateTime(2000), 
    lastDate: DateTime(2100));

  Future<TimeOfDay?> pickTime() =>
  showTimePicker(
    context: context, 
    initialTime: TimeOfDay(hour: hours, minute: hoy.minute));

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system
        // navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }
}