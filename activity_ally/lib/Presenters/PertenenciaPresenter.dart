
import 'package:activity_ally/services/DB/PertenenciaCRUD.dart';
import 'package:activity_ally/Models/Pertenencia.dart';
import 'package:activity_ally/Views/Updatable.dart';
import 'package:activity_ally/Views/Mochila/VistaPertenencia.dart';
import 'package:activity_ally/Views/Mochila/PertenenciaForm.dart';
import 'package:flutter/material.dart';

class PertenenciaPresenter{

late Updatable view;

  Future <void> onSubmit(String nombre, String descripcion, String? foto) async {
    int? id = await onSave(nombre, descripcion, foto);
    view.updateView();
  }

  Future <int> onSave( String nombre, String descripcion, String? foto) async {
    return await PertenenciaCRUD.instance.insert(Pertenencia(
      id: 0,
      nombre: nombre,
      descripcion: descripcion, 
      foto: foto));
  }

  Future<void> onUpdate(Pertenencia pertenencia)async{
    PertenenciaCRUD.instance.update(pertenencia);
    view.updateView();
  }


  Future<List<Pertenencia>> getPertenencias() async{
    return PertenenciaCRUD.instance.getAllItems();
  }
   Future<List<Pertenencia>> getPertenenciasOk() async{
    return PertenenciaCRUD.instance.getNItems(1);
  }


  Future<void> Eliminar(int id) async{
    PertenenciaCRUD.instance.delete(id);
    //Navigator.of(context).pop();
    view.updateView();

  }

}
