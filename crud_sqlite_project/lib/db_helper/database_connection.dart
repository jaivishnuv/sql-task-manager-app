
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DatabaseConnection{
  

  static Database? _database;

  Future<Database?> setDatabase() async {
    if (_database == null) {
      _database = await openDatabase(
        join(await getDatabasesPath(), 'user_database.db'),
        onCreate: (db, version) {
          return db.execute(
            'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, contact TEXT, description TEXT)',
          );
        },
        version: 1,
      );
    }
    return _database;
  }
}