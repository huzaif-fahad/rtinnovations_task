import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

/// A wrapper class for SQLite database operations in Flutter
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static DatabaseHelper get instance => _instance;

  static Database? _database;

  // Private constructor
  DatabaseHelper._internal();

  /// Get the database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'app_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE employees (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        position TEXT,
        start_date INTEGER,
        end_date INTEGER,
        created_at INTEGER NOT NULL
      )
    ''');
  }

  /// Insert a record into a table
  Future<int> insert(String table, Map<String, dynamic> data) async {
    Database db = await database;
    return await db.insert(table, data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> update(String table, Map<String, dynamic> data,
      String whereClause, List<dynamic> whereArgs) async {
    Database db = await database;
    return await db.update(table, data,
        where: whereClause, whereArgs: whereArgs);
  }

  Future<int> delete(
      String table, String whereClause, List<dynamic> whereArgs) async {
    Database db = await database;
    return await db.delete(table, where: whereClause, whereArgs: whereArgs);
  }

  Future<List<Map<String, dynamic>>> query(String sql,
      [List<dynamic>? arguments]) async {
    Database db = await database;
    return await db.rawQuery(sql, arguments);
  }

  Future<Map<String, dynamic>?> getById(String table, int id) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      table,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    return results.isNotEmpty ? results.first : null;
  }

  Future<bool> exists(
      String table, String whereClause, List<dynamic> whereArgs) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      table,
      where: whereClause,
      whereArgs: whereArgs,
      limit: 1,
    );

    return results.isNotEmpty;
  }

  /// Count records in a table (optionally with conditions)
  Future<int> count(String table,
      {String? whereClause, List<dynamic>? whereArgs}) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $table ${whereClause != null ? 'WHERE $whereClause' : ''}',
      whereArgs,
    );

    return Sqflite.firstIntValue(results) ?? 0;
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
