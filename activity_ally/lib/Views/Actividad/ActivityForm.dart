import 'package:activity_ally/Models/Activity.dart';
import 'package:activity_ally/Presenters/ActivityPresenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ActivityForm extends StatefulWidget {
  //const ActivityForm({super.key});
  final ActivityPresenter presenter;
  final Activity? activity;

  const ActivityForm(this.activity, this.presenter);

  @override
  State<ActivityForm> createState() => _ActivityFormState();
}

class _ActivityFormState extends State<ActivityForm> {
  final formkey = GlobalKey<FormState>();
  
  int id = 0;
  var title = '';
  var description = '';
  var location = '';
  LatLng? coordenadas;

  late DateTime duracion;
  late DateTime? fecha;
  late TimeOfDay? hora;

  late DateTime hoy;
  late TimeOfDay hours;

  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController locationController;
  late TextEditingController coordenadasController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.activity?.title ?? '');
    descriptionController = TextEditingController(text: widget.activity?.description ?? '');
    locationController = TextEditingController(text: widget.activity?.location ?? '');
    coordenadas = widget.activity?.coords;
    coordenadasController = TextEditingController(text: coordenadas!= null ?  
    '${coordenadas!.latitude.toStringAsFixed(2)}, ${coordenadas!.longitude.toStringAsFixed(2)}'
    : '');
    if(widget.activity == null){
      setDate(DateTime.now(), DateTime.now().add(Duration(hours: 1)).hour, 0);
      duracion = DateTime(2000, 1, 10, 00, 00);
    }
    else{
      DateTime date = widget.activity!.date;
      setDate(date, date.hour , date.minute);
      duracion = DateTime( date.year, date.month, date.day, widget.activity!.duration ~/ 60 , widget.activity!.duration % 60);
      //setDate(widget.activity!.date, widget.activity!.duration ~/ 60 , widget.activity!.duration % 60);
    }
  }

  void setDate(DateTime day, int hour, int minute){
    hoy = day;
    hours = TimeOfDay(hour: hour, minute: minute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.activity != null ? 'Editar Actividad' : 'Nueva Actividad'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          margin: const EdgeInsets.all(20),
          child: Form(
            key: formkey,
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: "Titulo"),
                  onSaved: (value) {
                    title = value!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Introduce nombre';
                    }
                  },
                ),
                const SizedBox(height: 10),
                const Text('Fecha'),
                Divider(
                  thickness: 1.0,
                  color: Colors.grey,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text('${hoy.day}/${hoy.month}/${hoy.year}'),
                    ),
                    getFecha(),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text('${hours.hour}:${hours.minute.toString().padLeft(2, '0')}'),
                    ),
                    getHora(),
                  ],
                ),
                SizedBox(height: 10),
                Text('Duracion estimada'),
                Divider(
                  thickness: 1.0,
                  color: Colors.grey,
                ),
                Row(
                  children: [
                    Expanded(
                      child: getDuracion(),
                    ),
                    // Add more buttons as needed
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  maxLines: 3,
                  controller: descriptionController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: "Descripcion"),
                  onSaved: (value) {
                    description = value!;
                  },
                ),
                const SizedBox(height: 10),
                const Text('Ubicacion'),
                Divider(
                  thickness: 1.0,
                  color: Colors.grey,
                ),
                const SizedBox(width: 8.0),
                TextFormField(
                  controller: locationController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), hintText: "Nombre"),
                  onSaved: (value) {
                    location = value!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Introduce ubicacion';
                    }
                  },
                ),
                Row(
                  children: [ // Add some space between the title and text field
                    Expanded(
                      child: TextFormField(
                        controller: coordenadasController,
                        readOnly: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Coordenadas',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                    getUbicacion(),
                  ],
                ),
                const SizedBox(height: 30),
                botonGuardar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<DateTime?> pickDate() => showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100));

  Future<TimeOfDay?> pickTime() => showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: hours.hour, minute: hours.minute));

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }

  botonGuardar(){
    return ElevatedButton(
      onPressed: () {
        var form = formkey.currentState;
        if (form!.validate()) {
          final minutos = (duracion.hour * 60) + duracion.minute;
          if (minutos <= 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Agrega una duracion aproximada'),
                backgroundColor:
                    Colors.red, // Set snackbar color to red
              ),
            );
            return;
          }
          form.save();
          final fecha_hora = new DateTime(
                hoy!.year, hoy!.month, hoy!.day, hours.hour, hours.minute, 0, 0, 0);
          //widget.presenter.onSubmit(title, fecha_hora, description, minutos, location);
          Navigator.of(context).pop({'title':title, 'date':fecha_hora, 'description':description, 'duration': minutos, 'location':location, 'coordenadas':coordenadas
          });
        }
      },
      style:
          ElevatedButton.styleFrom(padding: const EdgeInsets.all(15)),
      child: const Text("Guardar"),
    );
  }
  getUbicacion(){
    return IconButton(
      icon: Icon(Icons.location_on),
      onPressed: () async {
        LatLng? result = await widget.presenter.getCordenadas(context, coordenadas);
        if (result != null) {
          setState(() {
            coordenadasController.text = '${result.latitude.toStringAsFixed(2)}, ${result.longitude.toStringAsFixed(2)}';
            coordenadas= result;//'${result[0]},${result[1]}';
          });
        }
      },
    );
  }

  getFecha(){
    return IconButton(
      icon: Icon(Icons.date_range),
      onPressed: () async {
        fecha = await pickDate();
        if (fecha != null) {
          setState(() => hoy = fecha!);
        }
      },
    );
  }

  getHora(){
    return IconButton(
      icon: Icon(Icons.access_time),
      onPressed: () async {
        hora = await pickTime();
        if (hora != null) {
          setState(() {
            hours = hora!;
          });
        }
      },
    );
  }

  getDuracion(){
    return CupertinoButton(
      onPressed: () => _showDialog(
        CupertinoDatePicker(
          initialDateTime: duracion,
          mode: CupertinoDatePickerMode.time,
          use24hFormat: true,
          onDateTimeChanged: (DateTime newTime) {
            setState(() => duracion = newTime);
          },
        ),
      ),
      child: Text(
        '${duracion.hour}:${duracion.minute.toString().padLeft(2, '0')}',
        style: const TextStyle(fontSize: 22.0),
      ),
    );
  }
}
