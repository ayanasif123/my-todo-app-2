import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'notes.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            note TEXT,
            date TEXT
          )
        ''');
      },
    );
  }

  // INSERT
  static Future<void> insertNote(
      String title, String note, String date) async {
    final db = await database;
    await db.insert('notes', {
      'title': title,
      'note': note,
      'date': date,
    });
  }

  // READ
  static Future<List<Map<String, dynamic>>> getNotes() async {
    final db = await database;
    return await db.query('notes', orderBy: 'id DESC');
  }

  // DELETE
  static Future<void> deleteNote(int id) async {
    final db = await database;
    await db.delete(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // UPDATE
  static Future<void> updateNote(
      int id, String title, String note) async {
    final db = await database;
    await db.update(
      'notes',
      {'title': title, 'note': note},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
