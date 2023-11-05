
import 'package:activity_ally/Api/PertenenciaCRUD.dart';
import 'package:activity_ally/Models/Pertenencia.dart';
import 'package:activity_ally/Views/Mochila/Mochila.dart';
import 'package:activity_ally/Views/Mochila/Pagina.dart';
import 'package:activity_ally/Views/Mochila/formu.dart';
import 'package:flutter/material.dart';

class PertenenciaPresenter{

late Mochila view;

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


  Future<List<Pertenencia>> getPertenencias() async{
    return PertenenciaCRUD.instance.getAllItems();
  }

  Future<void> Eliminar(int id) async{
    PertenenciaCRUD.instance.delete(id);
    //Navigator.of(context).pop();
    view.updateView();

  }

}
