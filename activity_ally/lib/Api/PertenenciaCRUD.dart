import 'package:activity_ally/Api/AADB.dart';
import 'package:activity_ally/Models/Pertenencia.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class PertenenciaCRUD{
  static final  instance = AADB.instance;
  final String tabla = 'possession';

 Future<void> insert(Pertenencia item) async {
    final db = await instance.database;
    await db.insert(tabla, item.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Pertenencia>> getAllItems() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(tabla);

    return List.generate(maps.length, (i) {
      return Pertenencia.fromJson(maps[i]);
    });
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      tabla,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> update(Pertenencia item) async {
    final db = await instance.database;
    return await db.update(
      tabla,
      item.toJson(),
      where: "id=?",
      whereArgs: [item.id],
    );
  }

}