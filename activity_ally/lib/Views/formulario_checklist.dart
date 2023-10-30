import 'package:activity_ally/Models/Checklist_modelo.dart';
import 'package:flutter/material.dart';

class FormularioPage extends StatefulWidget {
  FormularioPage({Key key = const Key('my_key')}) : super(key: key);

  _FormularioPageState createState() => _FormularioPageState();
}

class _FormularioPageState extends State<FormularioPage> {
  final idForm = GlobalKey<FormState>();

  Map<String, dynamic> nuevaTarea = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Formulario")),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20.0),
          child: Form(
            key: idForm,
            child: Column(
              children: <Widget>[
                _crearInputNombre(),
                _crearBotonAgregar(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _crearInputNombre() {
    return TextFormField(
      onSaved: (valor) {
        nuevaTarea['nombre'] = valor;
      },
      decoration: InputDecoration(hintText: "Nombre del Objeto"),
    );
  }

  _crearBotonAgregar(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: MaterialButton(
          onPressed: () {
            idForm.currentState?.save();
            nuevaTarea['estado'] = false;

            Tareas().agregarTarea(nuevaTarea);

            Navigator.pop(context);
          },
          child: Text("Crear")),
    );
  }
}
