import 'package:activity_ally/Models/Activity.dart';
import 'package:activity_ally/Views/Actividad/ActivityForm.dart';
import 'package:activity_ally/Views/Updatable.dart';
import 'package:activity_ally/services/DB/ActivityCRUD.dart';
import 'package:activity_ally/Views/checklist/Checklist.dart';
import 'package:activity_ally/services/Notificacion.dart';
import 'package:flutter/material.dart';

class ActivityPresenter{

late Updatable view;
final Notificacion notificaciones = Notificacion();
ActivityPresenter(){
  notificaciones.initialize();
}

  Future <void> onSubmit(BuildContext context) async {
    var res = await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ActivityForm(null)));
    if(res == null){
      return; 
    }
    int? id = await onSave(Activity(
                    id: 0,
                    title: res['title'],
                    date: res['date'],
                    description: res['description'],
                    duration: res['duration'],
                    location: res['location'],
                  ));
    view.updateView();
  }

   Future<int> onChange(BuildContext context, Activity activity) async {
    ActivityForm form = ActivityForm(activity,);
    final res = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => form),
    );

    if (res == null) {
      return 0; // Handle cancel or dismiss
    }

    activity.title = res['title'];
    activity.date = res['date'];
    activity.description = res['description'];
    activity.duration = res['duration'];
    activity.location = res['location'];
    int? id = await onUpdate(activity);
    view.updateView(); 
    if(activity.notify){
      notificaciones.cancela(activity.id);
      notificaciones.NotificacionProgramada(activity);
    }
    return id;
  }

  Future <int> onSave( Activity actividad) async {
    return await ActivityCRUD.instance.insert(actividad);
  }


  Future<List<Activity>> getActivitys() async{
    return ActivityCRUD.instance.getAllItems();
  }

  Future<List<Activity>> getTodayAct() async{
    return  ActivityCRUD.instance.getActivitiesForToday();
  }

  Future<void> cancelar(Activity actividad) async{
    Eliminar(actividad.id);
    if(actividad.notify || actividad.startDate != null){
      notificaciones.cancela(actividad.id);
    }

  }


  Future<void> Eliminar(int id) async{
    
    ActivityCRUD.instance.delete(id);
    //Navigator.of(context).pop();
    view.updateView();

  }

  Future<int> onUpdate(Activity actividad) async{
    return ActivityCRUD.instance.update(actividad);
  }

  Future <void> start(Activity actividad) async{
    if(actividad.startDate == null){
      actividad.startDate = DateTime.now();
      if (actividad.notify && actividad.startDate!.isBefore(actividad.date)){
        notificaciones.cancela(actividad.id);
      }
      notificaciones.NotificacionFin(actividad);
      onUpdate(actividad);
    }
  }

  Future <void> finish(Activity actividad, BuildContext context) async{
    actividad.finishDate = DateTime.now();
    if (actividad.finishDate!.isBefore(DateTime.now().add(Duration(minutes: actividad.duration)))){
        notificaciones.cancela(actividad.id);
      }
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