import 'package:activity_ally/Models/Activity.dart';
import 'package:activity_ally/Views/Updatable.dart';
import 'package:activity_ally/Api/ActivityCRUD.dart';
import 'package:activity_ally/Views/checklist/Checklist.dart';
import 'package:activity_ally/services/Notificacion.dart';
import 'package:flutter/material.dart';

class ActivityPresenter{

late Updatable view;
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

  Future<void> onUpdate(Activity actividad) async{

    ActivityCRUD.instance.update(actividad);
    view.updateView();
  }

  Future <void> start(Activity actividad) async{
    actividad.startDate = DateTime.now();
    if (actividad.notify && actividad.startDate!.isBefore(actividad.date)){
      notificaciones.cancela(actividad.id);
    }
    return onUpdate(actividad);
  }

  Future <void> finish(Activity actividad, BuildContext context) async{
    actividad.finishDate = DateTime.now();
    onUpdate(actividad);
    completarCL(context, actividad);
  }

  void completarCL(BuildContext context, Activity actividad) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ListadoPage(act_id: actividad.id,)), // Specify the new page to navigate to
    );
  }
}