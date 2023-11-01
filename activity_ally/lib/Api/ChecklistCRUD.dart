import 'package:activity_ally/Api/AADB.dart';
import 'package:activity_ally/Models/ChecklistModelo.dart';

class ChecklistCRUD {
  final String tabla = 'checklist';
  static final instance = ChecklistCRUD._init();

  ChecklistCRUD._init();

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
