import 'package:activity_ally/Models/Activity.dart';
import 'package:activity_ally/Models/Pertenencia.dart';
import 'package:activity_ally/Presenters/PertenenciaPresenter.dart';
import 'package:activity_ally/Views/Updatable.dart';
import 'package:activity_ally/Views/checklist/Checklist.dart';
import 'package:activity_ally/Views/checklist/ChecklistMaker.dart';
//import 'package:activity_ally/Views/Updatable.dart';
import 'package:activity_ally/Views/checklist/MochilaChecklist.dart';
import 'package:activity_ally/services/DB/ChecklistCRUD.dart';
import 'package:activity_ally/services/DB/PertenenciaCRUD.dart';
import 'package:activity_ally/services/DetectionApi.dart';
import 'package:flutter/material.dart';

class ChecklistPresenter{
  
  late Updatable view;
  Future<List<Pertenencia>> getObjects(int act_id) async {
    return ChecklistCRUD.instance.getChecklistActivityItems(act_id);
  } 

  Future<void> updateStatus(List<Pertenencia> pertenencias) async{
    for(Pertenencia p in pertenencias){
      if(!p.status){
        PertenenciaCRUD.instance.update(p);
      }
    }
  }

  Future<bool> makeChecklist(BuildContext context, int id)async{
    var _continue =  await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChecklistMaker(
                  act_id: id,
                  presenter: this,
                )));
    if(_continue == null) return false;
    return _continue;
  }

  Future<void> chelcklistMochila(BuildContext context, int id) async{
    var _continue =  await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MochilaCheclist(
                  id: id,
                  presenter: PertenenciaPresenter(),
                )));
    view.updateView();
  }

  Future <bool> completarCL(BuildContext context, Activity actividad) async {
    var resul = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Checklist(act_id: actividad.id, presenter: this)));
    if (resul != null){
      return true;
    }
    return false;
  }

  Future<bool> uploadImage(String path, int act_id) async{
    List<Map<String, dynamic>>? response = await DetectionApi.instance.detect(path);
    if(response != null){
    //print(response);
      //DetectionApi.instance.decode(response);
      Map<String, String> result = DetectionApi.instance.processResponse(response);
      result.forEach((box, label) async {
        int id = await ChecklistCRUD.instance.insertLabels(label);
        //print(id);
        if (id > 0){
         int inserts = await ChecklistCRUD.instance.insertLabelActivity(act_id, id);
        }
      });
      return true;
    }
    return false;
  }

  Future<List<String>?> compare(String path, int act_id) async {
    List<Map<String, dynamic>>? response = await DetectionApi.instance.detect(path);
    if (response != null) {
      Map<String, String> result = DetectionApi.instance.processResponse(response);
      List<String> detectedLabels = result.values.toList();
      List<String> activityLabels = await getActLabels(act_id);

      List<String> commonLabels = detectedLabels.where((label) => activityLabels.contains(label)).toList();
      print('Detected Labels: $detectedLabels');
      print('Common Labels with Activity: $commonLabels');
      return commonLabels;
    }
    return null;
  }
  
  Future<List<String>> getActLabels(int act_id) async{
    return await ChecklistCRUD.instance.getLabelsForActivity(act_id);
  }

}