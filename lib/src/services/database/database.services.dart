import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBServices {
  static Database? _database;

  static Future<void> initialize() async {
    // Open the database, creating it if it doesn't exist.
    _database = await openDatabase(
      join(await getDatabasesPath(), 'test.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)',
        );
      },
      version: 1,
    );
  }

  static Future<int> insertDog(Map<String, dynamic> dog) async {
    // Insert a dog into the database.
    return await _database!.insert('dogs', dog);
  }

  static Future<List<Map<String, dynamic>>> getAllDogs() async {
    // Retrieve all dogs from the database.
    return await _database!.query('dogs');
  }
}
