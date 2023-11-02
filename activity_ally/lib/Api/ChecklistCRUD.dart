import 'package:activity_ally/Api/AADB.dart';
import 'package:activity_ally/Api/PertenenciaCRUD.dart';
import 'package:activity_ally/Models/ChecklistModelo.dart';
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
      WHERE activity_id = $id
      '''
    );
    return List.generate(maps.length, (i) {
        return Pertenencia.fromJson(maps[i]);
      });
  }

  Future<int> insertChecklistItem(ChecklistItem item) async {
    final db = await AADB.instance.database;
    return await db.insert('checklist_items', item.toSqlite());
  }


  Future<List<ChecklistItem>> getAllChecklistItems() async {
    final db = await AADB.instance.database;
    final List<Map<String, dynamic>> maps = await db.query('checklist_items');
    return List.generate(maps.length, (i) {
      return ChecklistItem.fromMap(maps[i]);
    });
  }

  Future<int> updateChecklistItem(ChecklistItem item) async {
    final db = await AADB.instance.database;

    return await db.update(
      'checklist_items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }
}
