import 'package:activity_ally/Api/AADB.dart';
import 'package:activity_ally/Models/Activity.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ActivityCRUD {
  final String tabla = 'activity';
  static final instance = ActivityCRUD._init();

  ActivityCRUD._init();

  Future<int> insert(Activity item) async {
    final db = await AADB.instance.database;
    return await db.insert(tabla, item.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Activity>> getAllItems() async {
    final db = await AADB.instance.database;
    final List<Map<String, dynamic>> maps =
        await db.query(tabla, orderBy: "id desc");

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

  Future<List<Activity>> getActivitiesForToday() async {
    final db = await AADB.instance.database;

    // Get the current date in the format "yyyy-MM-dd"
    DateTime now = DateTime.now();
    String formattedDate = now.toIso8601String();

    // Calculate the start and end of today
    String startOfDay = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}T00:00:00.000Z";
    String endOfDay = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}T23:59:59.999Z";

    final List<Map<String, dynamic>> maps = await db.query(
      tabla,
      where: 'date BETWEEN ? AND ?',
      whereArgs: [startOfDay, endOfDay],
      orderBy: 'date DESC', // Order by date in ascending order
    );

    List<Activity> activities = List.generate(maps.length, (i) {
      return Activity.fromJson(maps[i]);
    });

    return activities;
  }


}
