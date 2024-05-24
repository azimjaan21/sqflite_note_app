import 'package:flutter/foundation.dart' show immutable;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '/models/task.dart';

@immutable
class TasksDatabase {
  static const String _databaseName = 'tasks.db';
  static const int _databaseVersion = 1;

  // Create a singleton
  const TasksDatabase._privateConstructor();
  static const TasksDatabase instance = TasksDatabase._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String dbPath = await getDatabasesPath();
    final String path = join(dbPath, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createDB,
    );
  }

  //! Create Database method
  Future _createDB(
    Database db,
    int version,
  ) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const boolType = 'BOOLEAN NOT NULL';
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tasksTable (
        ${TasksFields.id} $idType,
        ${TasksFields.title} $textType,
        ${TasksFields.description} $textType,
        ${TasksFields.startDate} $textType,
        ${TasksFields.isCompleted} $boolType
      )
      ''');
  }

  //! C --> CRUD = Create
  Future<Task> createTask(Task task) async {
    final db = await instance.database;
    final id = await db.insert(
      tasksTable,
      task.toMap(),
    );

    return task.copy(id: id);
  }

  //! R -- CURD = Read
  Future<Task> readTask(int id) async {
    final db = await instance.database;

    final taskData = await db.query(
      tasksTable,
      columns: TasksFields.values,
      where: '${TasksFields.id} = ?',
      whereArgs: [id],
    );

    if (taskData.isNotEmpty) {
      return Task.fromMap(taskData.first);
    } else {
      throw Exception('Could not find a task with the given ID');
    }
  }

  // Get All Tasks
  Future<List<Task>> readAllTasks() async {
    final db = await instance.database;

    final result =
        await db.query(tasksTable, orderBy: '${TasksFields.startDate} ASC');

    return result.map((taskData) => Task.fromMap(taskData)).toList();
  }

  //! U --> CRUD = Update
  Future<int> updateTask(Task task) async {
    final db = await instance.database;

    return await db.update(
      tasksTable,
      task.toMap(),
      where: '${TasksFields.id} = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> markTaskAsCompleted({
    required int id,
    required bool isCompleted,
  }) async {
    final db = await instance.database;

    return await db.update(
      tasksTable,
      {
        TasksFields.isCompleted: isCompleted ? 1 : 0,
      },
      where: '${TasksFields.id} = ?',
      whereArgs: [id],
    );
  }

  //! D --> CRUD = Delete
  Future<int> deleteTask(int id) async {
    final db = await instance.database;

    return await db.delete(
      tasksTable,
      where: '${TasksFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
