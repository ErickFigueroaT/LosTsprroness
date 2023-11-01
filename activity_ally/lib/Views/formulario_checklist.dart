import 'package:activity_ally/Models/Checklist_modelo.dart';
import 'package:activity_ally/Models/ChecklistModelo.dart';
import 'package:activity_ally/Api/ChecklistCRUD.dart';

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

  _crearBotonGuardar(BuildContext context) async {
    if (idForm.currentState != null && idForm.currentState!.validate()) {
      idForm.currentState!.save();
      nuevaTarea['estado'] = false; // Puedes establecer el estado inicial aquí

      final checklistItem = ChecklistItem(
        id: 0, // Deja que la base de datos genere el ID automáticamente
        nombre: nuevaTarea['nombre'],
        completado: nuevaTarea['estado'],
      );

      // Llamar al CRUD para insertar el nuevo elemento en la base de datos
      final checklistCRUD = ChecklistCRUD.instance;
      final result = await checklistCRUD.insertChecklistItem(checklistItem);

      if (result != -1) {
        // La inserción se realizó con éxito
        Navigator.pop(context);
      }
    }
  }

// En tu método build, utiliza el botón "Guardar" para llamar al _crearBotonGuardar.
  _crearBotonAgregar(context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: MaterialButton(
        onPressed: () => _crearBotonGuardar(context),
        child: Text("Guardar"),
      ),
    );
  }
}
