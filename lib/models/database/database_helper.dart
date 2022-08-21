import 'dart:io';
import 'package:flutter_sqlite_crud/models/contact_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DatabaseHelper {
  static const _databaseName = 'ContactData.db';
  static const _databaseVersion = 1;

  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory dataDirectory = await getApplicationDocumentsDirectory();
    String dbPath = path.join(dataDirectory.path, _databaseName);
    // String p = await getDatabasesPath();
    // String dbPath = path.join(p, _databaseName);
    return await openDatabase(dbPath,
        version: _databaseVersion, onCreate: _onCreateDB);
  }

  // Create Table
  _onCreateDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE IF NOT EXISTS ${ContactModel.tableName}(
      ${ContactModel.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${ContactModel.colName} TEXT NOT NULL,
      ${ContactModel.colMobile} TEXT NOT NULL 
      )
    ''');
  }

  // insert data to the Table
  Future<int> insertContact(ContactModel contactModel) async {
    Database db = await database;
    return await db.insert(ContactModel.tableName, contactModel.toMap());
  }

  // fetch data from database
  Future<List<ContactModel>> fetchContacts() async {
    Database db = await database;
    List<Map<String, dynamic>> contacts =
        await db.query(ContactModel.tableName);
    return contacts.isEmpty
        ? []
        : contacts.map((e) => ContactModel.fromMap(e)).toList();
  }

  // update data
  Future<int> updateContact(ContactModel contactModel) async {
    Database db = await database;
    return await db.update(ContactModel.tableName, contactModel.toMap(),
        where: '${ContactModel.colId}=?', whereArgs: [contactModel.id]);
  }

  // delete data
  Future<int> deleteContact(int id) async {
    Database db = await database;
    return await db.delete(ContactModel.tableName,
        where: '${ContactModel.colId}=?', whereArgs: [id]);
  }
}
