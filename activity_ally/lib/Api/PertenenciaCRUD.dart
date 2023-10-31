import 'package:activity_ally/Api/AADB.dart';
import 'package:activity_ally/Models/Pertenencia.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class PertenenciaCRUD {
  //static final instance = AADB.instance;
  final String tabla = 'possession';
  static final instance = PertenenciaCRUD._init();

  PertenenciaCRUD._init();

  Future<void> insert(Pertenencia item) async {
    final db = await AADB.instance.database;
    await db.insert(tabla, item.toSqlite(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Pertenencia>> getAllItems() async {
    final db = await AADB.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tabla, orderBy: "id desc");

    return List.generate(maps.length, (i) {
      return Pertenencia.fromJson(maps[i]);
    });
  }

  Future<List<Pertenencia>> getNItems(int n) async {
    final db = await AADB.instance.database;
    final List<Map<String, dynamic>> maps =
        await db.query(tabla, where: 'id > $n', orderBy: 'nombre');
  

    return List.generate(maps.length, (i) {
      return Pertenencia.fromJson(maps[i]);
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

  Future<int> update(Pertenencia item) async {
    final db = await AADB.instance.database;
    return await db.update(
      tabla,
      item.toJson(),
      where: "id=?",
      whereArgs: [item.id],
    );
  }
}
