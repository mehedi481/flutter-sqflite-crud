import 'dart:io';
import 'package:flutter_sqlite_crud/models/contact_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DatabaseHelper {
  static const _databaseName = 'contactData.db';
  static const _databaseVersion = 1;

  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  Database? _database;
  Future<Database> get database async{
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory dataDirectory = await getApplicationDocumentsDirectory();
    String dbPath = path.join(dataDirectory.path, _databaseName);
    return await openDatabase(dbPath,
        version: _databaseVersion, onCreate: _onCreateDB);
  }

  _onCreateDB(Database db, int version) async {
    db.execute('''
    CREATE TABLE ${ContactModel.tableName}(
      ${ContactModel.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${ContactModel.colName} TEXT NOT NULL,
      ${ContactModel.colMobile} TEXT NOT NULL,
    )
    ''');
  }
}
