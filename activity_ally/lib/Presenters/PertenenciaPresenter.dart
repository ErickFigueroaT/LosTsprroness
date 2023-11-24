
import 'package:activity_ally/services/DB/PertenenciaCRUD.dart';
import 'package:activity_ally/Models/Pertenencia.dart';
import 'package:activity_ally/Views/Updatable.dart';
import 'package:activity_ally/Views/Mochila/PertenenciaForm.dart';
import 'package:flutter/material.dart';

class PertenenciaPresenter{

late Updatable view;


  Future <void> onSubmit(BuildContext context) async {
    final res = await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => PertenenciaForm()));
    if(res == null){
      return; 
    }
      int? id = await onSave(res['nombre'], res['descripcion'], res['foto']);
      view.updateView();
  }

  Future <int> onSave( String nombre, String descripcion, String? foto) async {
    return await PertenenciaCRUD.instance.insert(Pertenencia(
      id: 0,
      nombre: nombre,
      descripcion: descripcion, 
      foto: foto));
  }

  Future <Pertenencia> onChange(BuildContext context, Pertenencia pertenencia) async {
    PertenenciaForm form = PertenenciaForm(
      nombre:  pertenencia.nombre,
      descripcion: pertenencia.descripcion,
      foto: pertenencia.foto,
    );
    final res = await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => form));
    if(res == null){
      return pertenencia; 
    }
    pertenencia.nombre = res['nombre'];
    pertenencia.descripcion = res['descripcion'];
    pertenencia.foto = res['foto'];
    onUpdate(pertenencia);
    return pertenencia;
  }
  

  Future<void> onUpdate(Pertenencia pertenencia)async{
    PertenenciaCRUD.instance.update(pertenencia);
    view.updateView();
  }


  Future<List<Pertenencia>> getPertenencias() async{
    return PertenenciaCRUD.instance.getAllItems();
  }
   Future<List<Pertenencia>> getPertenenciasOk() async{
    return PertenenciaCRUD.instance.getByStatus(1);
  }


  Future<void> Eliminar(int id) async{
    PertenenciaCRUD.instance.delete(id);
    //Navigator.of(context).pop();
    view.updateView();

  }

}
