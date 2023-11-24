import 'package:activity_ally/Models/Activity.dart';
import 'package:activity_ally/Presenters/PertenenciaPresenter.dart';
import 'package:activity_ally/Views/checklist/Checklist.dart';
//import 'package:activity_ally/Views/Updatable.dart';
import 'package:activity_ally/Views/checklist/MochilaChecklist.dart';
import 'package:flutter/material.dart';

class ChecklistPresenter{
  

  Future<bool> makeChecklist(BuildContext context, int id)async{
    var _continue =  await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MochilaCheclist(
                  id: id,
                  presenter: PertenenciaPresenter(),
                )));
    if(_continue == null) return true;
    return false;
  }

  Future<bool> chelcklistMochila(BuildContext context, int id) async{
    var _continue =  await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MochilaCheclist(
                  id: id,
                  presenter: PertenenciaPresenter(),
                )));
    if(_continue == null) return true;
    return false;
  }

  Future <bool> completarCL(BuildContext context, Activity actividad) async {
    var resul = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Checklist(act_id: actividad.id,)));
    if (resul != null){
      return true;
    }
    return false;
  }

}