import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task_item.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        priority TEXT NOT NULL,
        description TEXT NOT NULL,
        isCompleted INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  // Insert a new TaskItem
  Future<int> insertTask(TaskItem task) async {
    final db = await database;
    final json = task.toJson();
    json.remove('id'); // Remove id for auto-increment
    return await db.insert('tasks', json);
  }

  // Retrieve all TaskItems
  Future<List<TaskItem>> getAllTasks() async {
    final db = await database;
    final result = await db.query('tasks', orderBy: 'id DESC');
    return result.map((json) => TaskItem.fromJson(json)).toList();
  }

  // Delete a TaskItem by id (Bonus)
  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Update a TaskItem (useful for toggling completion)
  Future<int> updateTask(TaskItem task) async {
    final db = await database;
    return await db.update(
      'tasks',
      task.toJson(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}

