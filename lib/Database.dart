import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:example/fileModel.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHandler  {
  Future<Database> initializedDB() async {
  // Future<String> getDatabasesPath() => databaseFactory.getDatabasesPath();
  // Set path of the database
var databasesPath = await databaseFactory.getDatabasesPath();
String path = p.join(databasesPath, 'rta.db');

// Load the database (or create a new one, if it does not yet exist)
Database database = await openDatabase(path, version: 1,
    onCreate: (Database database, int version) async {
  // When creating the db, create the table
  await database.execute(
       '''
CREATE TABLE @importfile (id INTEGER PRIMARY KEY AUTOINCREMENT, name STRING NULL, vitri STRING NULL)
'''
);
}
);
  return database;
}


Future<int> insertFile(SaveFileModel file) async {
  var databasesPath = await databaseFactory.getDatabasesPath();
  String path = p.join(databasesPath, 'rta2.sqlite');
  Database db = await openDatabase(path, version: 1,
    onCreate: (Database database, int version) async {
  // When creating the db, create the table
  await database.execute(
      """
CREATE TABLE importfile (id INTEGER, name STRING NULL, vitri STRING NULL)
"""
);
print('tao duoc khong');
// List<Map> list = await database.rawQuery('SELECT * FROM importfile');
// print(list);
}
);

print(databasesPath);
print(db);
  return await db.insert('importfile', file.toMap());
}
Future<int> updateFile(SaveFileModel file) async {
  var databasesPath = await databaseFactory.getDatabasesPath();
  String path = p.join(databasesPath, 'rta2.sqlite');
  Database db = await openDatabase(path, version: 1,
    onCreate: (Database database, int version) async {
  // When creating the db, create the table
  await database.execute(
      """
CREATE TABLE importfile (id INTEGER, name STRING NULL, vitri STRING NULL)
"""
);
print('tao duoc khong');
// List<Map> list = await database.rawQuery('SELECT * FROM importfile');
// print(list);
}
);

print(databasesPath);
print(db);
  return await db.update('importfile', file.toMap());
}


}