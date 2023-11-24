import 'package:activity_ally/services/DB/AADB.dart';
import 'package:activity_ally/services/DB/PertenenciaCRUD.dart';
import 'package:activity_ally/Models/Pertenencia.dart';

class ChecklistCRUD {
  final String tabla = 'checklist';
  static final instance = ChecklistCRUD._init();

  ChecklistCRUD._init();

  Future<int> insertActivity_Object(int act_id, int obj_id) async {
    final db = await AADB.instance.database;
    return await db.insert('checklist', {'activity_id':act_id, 'possession_id': obj_id});
  }
  Future<int> delete(int act_id, int obj_id) async {
    final db = await AADB.instance.database;
    return await db.delete(
      tabla,
      where: "activity_id = ? and possession_id = ?",
      whereArgs: [act_id, obj_id],
    );
  }
  
  Future<bool> inCheck(int act_id, int obj_id) async {
    final db = await AADB.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tabla, where: "activity_id = ? and possession_id = ?",
      whereArgs: [act_id, obj_id],);
      return maps.isNotEmpty;
  }

  Future<List<Pertenencia>> getChecklistActivityItems(int id) async {
    final db = await AADB.instance.database;
    final List<Map<String, dynamic>> maps = 
    await db.rawQuery('''
      SELECT * 
      FROM $tabla
      JOIN possession ON $tabla.possession_id = possession.id
      WHERE activity_id = $id  AND possession.status = 1
      '''
    );
    return List.generate(maps.length, (i) {
        return Pertenencia.fromJson(maps[i]);
      });
  }

  Future<int> insertLabelActivity(int act_id, int label_id) async {
    final db = await AADB.instance.database;
    return await db.insert('activity_label', {'activity_id':act_id, 'label_id': label_id});
  }

  Future<int> insertLabels(String name) async {
    final db = await AADB.instance.database;
    return await db.insert('labels', {'name': name,});
  }

  Future<List<String>> getLabelsForActivity(int activityId) async {
    final db = await AADB.instance.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT labels.name
      FROM activity_label
      JOIN labels ON activity_label.label_id = labels.id
      WHERE activity_label.activity_id = $activityId
    ''');

    return List.generate(maps.length, (i) {
      return maps[i]['name'] as String;
    });
  }

 
}
