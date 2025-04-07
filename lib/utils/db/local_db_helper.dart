import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import '../../features/employee_home/models/position.dart';

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
        fromDate TEXT NOT NULL,
        toDate TEXT,
        createdAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
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

  Future<void> insertDummyData() async {
    final db = await database;

    final dummyData = [
      {
        'id': 1,
        'name': 'Alice Johnson',
        'position': 'prodDesigner',
        'fromDate': '2022-01-01T00:00:00.000',
        'toDate': null
      },
      {
        'id': 2,
        'name': 'Bob Smith',
        'position': 'flutterDev',
        'fromDate': '2021-06-15T00:00:00.000',
        'toDate': null
      },
      {
        'id': 3,
        'name': 'Charlie Brown',
        'position': 'qaTester',
        'fromDate': '2023-03-01T00:00:00.000',
        'toDate': '2023-08-01T00:00:00.000'
      },
      {
        'id': 4,
        'name': 'Diana Prince',
        'position': 'productOwner',
        'fromDate': '2020-11-20T00:00:00.000',
        'toDate': null
      },
      {
        'id': 5,
        'name': 'Ethan Hunt',
        'position': 'prodDesigner',
        'fromDate': '2021-03-10T00:00:00.000',
        'toDate': '2022-12-31T00:00:00.000'
      },
      {
        'id': 6,
        'name': 'Fiona Gallagher',
        'position': 'flutterDev',
        'fromDate': '2020-07-01T00:00:00.000',
        'toDate': null
      },
      {
        'id': 7,
        'name': 'George Clooney',
        'position': 'qaTester',
        'fromDate': '2022-05-15T00:00:00.000',
        'toDate': null
      },
      {
        'id': 8,
        'name': 'Hannah Montana',
        'position': 'productOwner',
        'fromDate': '2019-11-01T00:00:00.000',
        'toDate': '2021-06-30T00:00:00.000'
      }
    ];

    for (var employee in dummyData) {
      await db.insert('employees', employee,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  Future<void> deleteDatabase() async {
    try {
      // Close the database connection first
      await close();

      // Get the path to the database file
      String databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'app_database.db');

      // Delete the database file
      await databaseFactory.deleteDatabase(path);
      print('Database deleted successfully');
    } catch (error) {
      print('Error deleting database: $error');
      throw error; // Re-throw to allow caller to handle
    }
  }
}
