import 'package:activity_ally/Models/Activity.dart';
import 'package:activity_ally/Presenters/ChecklistPresenter.dart';
import 'package:activity_ally/Presenters/MapPresenter.dart';
import 'package:activity_ally/Views/Actividad/ActivityForm.dart';
import 'package:activity_ally/Views/Actividad/Temporizador.dart';
import 'package:activity_ally/Views/Actividad/widgets/info_actividad.dart';
import 'package:activity_ally/Views/Updatable.dart';
import 'package:activity_ally/services/DB/ActivityCRUD.dart';
//import 'package:activity_ally/Views/checklist/Checklist.dart';
import 'package:activity_ally/services/Notificacion.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ActivityPresenter{

late Updatable view;
final Notificacion notificaciones = Notificacion();
final List<String> ficha_colums = [
          'id', 
          'title',
          'duration', 
          'date', 
          //'description', 
          'finish_date',
          'start_date',
          'notify',
        ];
ActivityPresenter(){
  notificaciones.initialize();
}

  Future <void> onSubmit(BuildContext context) async {
    var res = await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ActivityForm(null,this)));
    if(res == null){
      return; 
    }
    onSave(Activity(
                    id: 0,
                    title: res['title'],
                    date: res['date'],
                    description: res['description'],
                    duration: res['duration'],
                    location: res['location'],
                    coords: res['coordenadas'],
                  ));
  }

   Future<int> onChange(BuildContext context, Activity activity) async {
    ActivityForm form = ActivityForm(activity, this);
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
    activity.coords = res['coordenadas'];
    int? id = await onUpdate(activity);
    //view.updateView(); 
    if(activity.notify){
      notificaciones.cancela(activity.id);
      notificaciones.NotificacionProgramada(activity);
    }
    return id;
  }

  Future <int> onSave( Activity actividad) async {
    int id = await ActivityCRUD.instance.insert(actividad);
    if (id > 0){
      view.updateView();
    }
    return id;
  }


  Future<List<Activity>> getActivitys() async{
    return ActivityCRUD.instance.getAllItems(ficha_colums);
  }

  /*
  Future<List<Activity>> getTodayAct() async{
    return  ActivityCRUD.instance.getActivitiesForToday(null);
  }
  */
  Future<void> cancelar(Activity actividad) async{
    Eliminar(actividad.id);
    if(actividad.notify || actividad.startDate != null){
      notificaciones.cancela(actividad.id);
    }

  }


  Future<void> Eliminar(int id) async{
    ActivityCRUD.instance.delete(id);
    view.updateView();

  }

  Future<int> onUpdate(Activity actividad) async{
    int id = await ActivityCRUD.instance.update(actividad);
    if(id > 0){
      view.updateView();
    }
    return id;
  }

  Future<bool> start(Activity actividad, BuildContext context) async {
  if (actividad.startDate == null) {
    bool shouldContinue = await openChecklist(context, actividad.id);
    if (!shouldContinue) {
      return false;
    }
    actividad.startDate = DateTime.now();
    if (actividad.notify && actividad.startDate!.isBefore(actividad.date)) {
      notificaciones.cancela(actividad.id);
    }
    notificaciones.NotificacionFin(actividad);
    onUpdate(actividad);
  }
  // Open Temporizador directly
  var result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Temporizador(
        actividad: actividad,
        presenter: this,
      ),
    ),
  );
  return true;
}

  Future<bool> openChecklist(BuildContext context, int id) async {
    ChecklistPresenter chPresenter = ChecklistPresenter();
    bool result = await chPresenter.chelcklistMochila(context, id);
    return result ; 
  }

  Future <int> finish(Activity actividad, BuildContext context) async{
    DateTime finishD = DateTime.now();
    if (finishD.isBefore(DateTime.now().add(Duration(minutes: actividad.duration)))){
        notificaciones.cancela(actividad.id);
      }
    bool complete = await completarCL(context, actividad);
    if(complete){
      actividad.finishDate = finishD;
      return onUpdate(actividad);
    }
    return 0;
  }

  Future <bool> completarCL(BuildContext context, Activity actividad) async {
    ChecklistPresenter chPresenter = ChecklistPresenter();
    return await chPresenter.completarCL(context, actividad);
  }

  Future<LatLng?> getCordenadas(BuildContext context, LatLng? coords)async{
    MapPresenter mp = MapPresenter();
    if(coords != null){
      mp.addMarker('1',
        coords.latitude,coords.longitude
      );
    }
    return mp.showMap(context);
  }

  Future <int> changeSub(BuildContext context, int id) async {
    Activity? actividad = await ActivityCRUD.instance.getItem(id);
    if(actividad!.date.isAfter(DateTime.now())){
      if(actividad.notify == false){
        notificaciones.NotificacionProgramada(actividad);
      }
      else{
        notificaciones.cancela(actividad.id);
      }
        actividad.notify = !actividad.notify;
        return ActivityCRUD.instance.update(actividad);
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Recordatorio fallido: actividad en una fecha pasada'),
          backgroundColor:
              Colors.red, // Set snackbar color to red
        ),
      );
      return 0;
    }
  }

  Future<Activity> getAcivity(int id) async {
    return await ActivityCRUD.instance.getItem(id) ?? Activity(id: 0, title: '', date: DateTime.now(), duration: 0);
  }

  Future<void> showDetails(BuildContext context ,int id) async {
    Activity act = await getAcivity(id);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) => InfoActividad(
                  actividad: act,
                  presenter: this,
                ))));
  }
}