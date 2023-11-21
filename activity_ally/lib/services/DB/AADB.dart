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
        notify TEXT,
        latitude REAL, -- Added latitude field for coords
        longitude REAL -- Added longitude field for coords
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
    /*  
      final String checklist_items = '''
      CREATE TABLE checklist_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT,
        completado INTEGER
      );
    ''';
    */



  //final String tableCartItems = 'cart_items';

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('ally.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path, 
      version: 9,
      onCreate: _onCreateDB,
      onUpgrade: _onUpgradeDB,
    );
    

  }

  Future _onCreateDB(Database db, int version) async {
    await db.execute(pertenencia);
    await db.execute(actividad);
    await db.execute(checklist);
    //await db.execute(checklist_items);

  }

   Future _onUpgradeDB(Database db, int oldVersion, int newVersion) async {
    // Handle database schema upgrades here
    if (oldVersion == 8 && newVersion == 9) {
      // Example: Add a new column to the 'activity' table
      await db.execute('ALTER TABLE activity ADD COLUMN latitude REAL');
      await db.execute('ALTER TABLE activity ADD COLUMN longitude REAL');
    }
    // Add more upgrade logic as needed for other versions
  }
}
