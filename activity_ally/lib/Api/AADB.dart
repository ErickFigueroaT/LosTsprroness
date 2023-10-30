import 'dart:io';

import 'package:activity_ally/Models/Pertenencia.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AADB {
  static final AADB instance = AADB._init();

  static Database? _database;

  AADB._init();

  //final String tableCartItems = 'cart_items';

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('ally.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 3, onCreate: _onCreateDB);
  }

  Future _onCreateDB(Database db, int version) async {
    await db.execute('''
--tabla pertenencia
CREATE TABLE possession (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre TEXT,
    status TEXT,
    descripcion TEXT,
    foto TEXT
);

-- Create the activity table
CREATE TABLE activity (
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    title TEXT,
    date DATE,
    duration INTEGER,
    location TEXT,
    description TEXT,
    finish_date DATE
);

CREATE TABLE checklist (
    activity_id INTEGER,
    possession_id INTEGER,
    FOREIGN KEY (activity_id) REFERENCES activity(id),
    FOREIGN KEY (possession_id) REFERENCES possession(id),
    PRIMARY KEY (activity_id, possession_id)
);

      ''');
  }

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
