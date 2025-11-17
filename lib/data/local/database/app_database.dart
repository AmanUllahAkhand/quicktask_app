import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../models/task_model.dart';
import '../../models/reminder_model.dart';

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
    isCompleted INTEGER NOT NULL,
    dueDate TEXT,
    category INTEGER NOT NULL DEFAULT 0,
    priority TEXT
  )
''');

    await db.execute('''
      CREATE TABLE reminders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        icon TEXT NOT NULL,
        date TEXT
      )
    ''');

    // Seed initial reminders
    await db.insert('reminders', Reminder(title: "Dentist Appointment", icon: "reminder.svg").toMap());
    await db.insert('reminders', Reminder(title: "Friend's Birthday", icon: "birthday.svg").toMap());
  }

  // Task CRUD
  Future<Task> createTask(Task task) async {
    final db = await instance.database;
    final id = await db.insert('tasks', task.toMap());
    return task.copyWith(id: id);
  }

  Future<List<Task>> getTasks() async {
    final db = await instance.database;
    final maps = await db.query('tasks', orderBy: 'id DESC');
    return maps.map((m) => Task.fromMap(m)).toList();
  }

  Future<int> updateTask(Task task) async {
    final db = await instance.database;
    return db.update('tasks', task.toMap(), where: 'id = ?', whereArgs: [task.id]);
  }

  // Reminder
  Future<List<Reminder>> getReminders() async {
    final db = await instance.database;
    final maps = await db.query('reminders');
    return maps.map((m) => Reminder.fromMap(m)).toList();
  }
}

extension on Task {
  Task copyWith({int? id, String? title, bool? isCompleted, DateTime? dueDate}) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}