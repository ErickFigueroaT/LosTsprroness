import 'package:activity_ally/Models/Activity.dart';
import 'package:flutter/material.dart';
import 'dart:io';
//import 'package:activity_ally/Models/Pertenencia.dart';
//import 'package:activity_ally/Views/widgets/image_input.dart';

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
  DateTime? fecha;
  TimeOfDay? hora;
  
  DateTime hoy =  DateTime.now();
  var hours = DateTime.now().add(Duration(hours: 1)).hour;
  var minutes = '00';


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
            //const ImageInput(),
            //const SizedBox(height: 10),
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
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                var form = formkey.currentState;
                if (form!.validate()) {
                  form.save();
                  final fecha_hora = new DateTime(fecha!.year, fecha!.month, fecha!.day, hora!.hour, hora!.minute, 0, 0, 0);
                  Navigator.of(context).pop(Activity(
                      id: 0,
                      title: title,
                      date: fecha_hora,
                      description: description,
                      duration: 5
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

}