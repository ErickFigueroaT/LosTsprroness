//import 'package:activity_ally/services/DB/PertenenciaCRUD.dart';
import 'package:activity_ally/Models/Pertenencia.dart';
import 'package:activity_ally/Presenters/ChecklistPresenter.dart';
import 'package:activity_ally/Views/checklist/widgets/check_obj.dart';
import 'package:activity_ally/Views/checklist/widgets/check_label.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Checklist extends StatefulWidget {
  static final nombrePagina = "Checklist";
  final int act_id;
  final ChecklistPresenter presenter;


  const Checklist({required this.act_id, required this.presenter});


  @override
  _ChecklistState createState() => _ChecklistState();
}

class _ChecklistState extends State<Checklist> {

  late Future<List<Pertenencia>> objetos;
  late List<Pertenencia>? pertenencias;
  late List<int> checked; 
   late Future<List<String>> labels;
   late List<String>? labelList; 
   File? seleccion;

   List<String> commonLabels = [''];


  void initState() {
    objetos = widget.presenter.getObjects(widget.act_id);
    labels = widget.presenter.getActLabels(widget.act_id);
    super.initState();
  }
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Listado de Objetos")),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text('Mochila'),
                Divider(
                  thickness: 1.0,
                  color: Colors.grey,
                ),
             SizedBox(
              height: 250,
              child: FutureBuilder<List<Pertenencia>>(
          future: objetos, //ChecklistCRUD.instance.getAllChecklistItems(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // Muestra un indicador de carga mientras se obtienen los datos.
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.data?.isEmpty ?? true) {
              pertenencias = null;
              return Center(child: Text(""));
            } 
            else {
              pertenencias = snapshot.data!;
              //checked = [pertenencias!.length];
              return ListView.builder(
                itemCount: pertenencias!.length,
                itemBuilder: (context, index) {
                  final item = pertenencias![index];
                  return ChecklistItemWidget(
                    item: item,
                    onChanged: (bool newValue) {
                      setState(() {
                        item.status = newValue; // Update the item's status
                      });
                    },
                  );
                },
              );
            }
          },
        ),
        ),
        Text('Camara'),
                Divider(
                  thickness: 1.0,
                  color: Colors.grey,
                ),
        SizedBox(height: 250,
        child: 
        FutureBuilder<List<String>>(
            future: labels,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.data?.isEmpty ?? true) {
                return Center(child: Text(""));
              } else {
                List<String> labelList = snapshot.data!;
                return ListView.builder(
                  itemCount: labelList.length,
                  itemBuilder: (context, index) {
                  final item = labelList[index];
                  return ChecklistLabelWidget(
                    item: item,
                    labels: commonLabels,
                    onChanged: (bool newValue) {
                      setState(() {
                        //item. = newValue; // Update the item's status
                      });
                    },
                  );
                  },
                );
              }
            },
          ),),
          Row(
              
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FloatingActionButton(
                  heroTag: 'camera',
                  onPressed: () {
                    elegirImagen();
                  },
                  child: Icon(Icons.camera),
                ),
                SizedBox(width: 16),
                FloatingActionButton(
                  heroTag: 'paloma',
                  onPressed: () {
                    if(pertenencias != null){
                      widget.presenter.updateStatus(pertenencias!);
                    }
                    Navigator.of(context).pop(true);
                    // Acción a realizar al pulsar el botón "Finalizar"
                  },
                  child: Icon(Icons.done),
                ),
                
              ],
            ),
          
          ],)
      ),
    );
  }

    void elegirImagen() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );

    if (pickedImage == null) {
      return;
    }

    seleccion = File(pickedImage.path);
    List<String>? resul = await widget.presenter.compare(seleccion!.path, widget.act_id);
    if(resul != null){
      setState(() {
        commonLabels.addAll(resul);
        labels =  widget.presenter.getActLabels(widget.act_id);
        //widget.presenter.uploadImage(seleccion!.path, widget.act_id);
      });
    }
  }
}
