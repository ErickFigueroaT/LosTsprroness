import 'dart:io';

import 'package:activity_ally/Models/Pertenencia.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AADB {
  static final AADB instance = AADB._init();

  static Database? _database;

  AADB._init();
    final String pertenencia = '''
      --tabla pertenencia
      CREATE TABLE possession (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nombre TEXT,
          status TEXT,
          descripcion TEXT,
          foto TEXT
      );
    ''';
    final String actividad = '''
       -- Create the activity table
      CREATE TABLE activity (
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        title TEXT,
        date DATE,
        duration INTEGER,
        location TEXT,
        description TEXT,
        finish_date DATE,
        start_date DATE,
        duration_r INTEGER,
        notify TEXT
      );
    ''';

    final String checklist = '''
      CREATE TABLE checklist (
          activity_id INTEGER,
          possession_id INTEGER,
          FOREIGN KEY (activity_id) REFERENCES activity(id),
          FOREIGN KEY (possession_id) REFERENCES possession(id),
          PRIMARY KEY (activity_id, possession_id)
      );
      ''';
      
      final String checklist_items = '''
      CREATE TABLE checklist_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT,
        completado INTEGER
      );
    ''';



  //final String tableCartItems = 'cart_items';

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('ally.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 8, onCreate: _onCreateDB);

  }

  Future _onCreateDB(Database db, int version) async {
    await db.execute(pertenencia);
    await db.execute(actividad);
    await db.execute(checklist);
    await db.execute(checklist_items);

  }
}
