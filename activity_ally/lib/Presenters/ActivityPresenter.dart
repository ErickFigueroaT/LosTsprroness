import 'package:activity_ally/Models/Activity.dart';
import 'package:activity_ally/Views/Mochila/Mochila.dart';
import 'package:activity_ally/Api/ActivityCRUD.dart';
import 'package:activity_ally/services/Notificacion.dart';
import 'package:flutter/material.dart';

class ActivityPresenter{

late Mochila view;
final Notificacion notificaciones = Notificacion();
ActivityPresenter(){
  notificaciones.initialize();
}

  Future <void> onSubmit(String title, DateTime fecha_hora, String description,int minutos, String? location) async {
    int? id = await onSave(Activity(
                    id: 0,
                    title: title,
                    date: fecha_hora,
                    description: description,
                    duration: minutos,
                    location: location,
                  ));
    view.updateView();
  }

  Future <int> onSave( Activity actividad) async {
    return await ActivityCRUD.instance.insert(actividad);
  }


  Future<List<Activity>> getActivitys() async{
    return ActivityCRUD.instance.getAllItems();
  }

  Future<void> cancelar(bool rec, int id) async{
    Eliminar(id);
    if(rec){
      notificaciones.cancela(id);
    }

  }


  Future<void> Eliminar(int id) async{
    
    ActivityCRUD.instance.delete(id);
    //Navigator.of(context).pop();
    view.updateView();

  }
}