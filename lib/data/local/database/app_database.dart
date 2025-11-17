
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/reminder_model.dart';
import '../../models/task_model.dart';

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('quicktask.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        isCompleted INTEGER NOT NULL DEFAULT 0,
        dueDate TEXT,
        category INTEGER NOT NULL DEFAULT 0,
        priority TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE reminders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        icon TEXT NOT NULL
      )
    ''');

    // Seed reminders
    await db.insert('reminders', Reminder(title: "Dentist Appointment", icon: "reminder.svg").toMap());
    await db.insert('reminders', Reminder(title: "Friend's Birthday", icon: "birthday.svg").toMap());
  }

  // ADD THESE METHODS BELOW

  Future<List<Map<String, dynamic>>> query(String table, {String? where, List<Object?>? whereArgs, String? orderBy}) async {
    final db = await database;
    return await db.query(table, where: where, whereArgs: whereArgs, orderBy: orderBy);
  }

  Future<int> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert(table, data);
  }

  Future<int> update(String table, Map<String, dynamic> data, {required String where, required List<Object?> whereArgs}) async {
    final db = await database;
    return await db.update(table, data, where: where, whereArgs: whereArgs);
  }

  Future<int> delete(String table, {required String where, required List<Object?> whereArgs}) async {
    final db = await database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }

  // Optional: Add createTask helper for convenience
  Future<Task> createTask(Task task) async {
    final id = await insert('tasks', task.toMap());
    return task.copyWith(id: id);
  }

  Future<int> updateTask(Task task) async {
    return await update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }
  Future<List<Reminder>> getReminders() async {
    final db = await database;
    final maps = await db.query('reminders');
    return maps.map((map) => Reminder.fromMap(map)).toList();
  }
}