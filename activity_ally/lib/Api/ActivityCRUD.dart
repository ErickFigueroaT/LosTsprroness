import 'package:activity_ally/Api/AADB.dart';
import 'package:activity_ally/Models/Activity.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ActivityCRUD {
  final String tabla = 'activity';
  static final instance = ActivityCRUD._init();

  ActivityCRUD._init();

  Future<void> insert(Activity item) async {
    final db = await AADB.instance.database;
    await db.insert(tabla, item.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Activity>> getAllItems() async {
    final db = await AADB.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tabla);

    return List.generate(maps.length, (i) {
      return Activity.fromJson(maps[i]);
    });
  }

  Future<List<Activity>> getNItems(int n) async {
    final db = await AADB.instance.database;
    final List<Map<String, dynamic>> maps =
        await db.query(tabla, where: 'id > $n', orderBy: 'nombre');

    return List.generate(maps.length, (i) {
      return Activity.fromJson(maps[i]);
    });
  }

  Future<int> delete(int id) async {
    final db = await AADB.instance.database;
    return await db.delete(
      tabla,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> update(Activity item) async {
    final db = await AADB.instance.database;
    return await db.update(
      tabla,
      item.toJson(),
      where: "id=?",
      whereArgs: [item.id],
    );
  }
}
