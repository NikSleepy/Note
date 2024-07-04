import 'dart:io';
import 'package:notenih/note_models.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  final String _databaseName = 'notes.db';
  final int _databaseVersion = 1;

  // notes table
  final String tableNotes = 'notes';
  final String columnId = 'id';
  final String columnSubject = 'subject';
  final String columnContent = 'content';
  final String columnDate = 'date';

  Database? _database;

  Future<Database> database() async {
    //pengecekan database sudah ada atau belum;
    if (_database != null) return _database!;

    _database = await _initDatabase();

    return _database!;
  }

  Future _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentsDirectory.path, _databaseName);
    return openDatabase(path, onCreate: _onCreate, version: _databaseVersion);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableNotes (
        $columnId INTEGER PRIMARY KEY,
        $columnSubject TEXT NOT NULL,
        $columnContent TEXT NOT NULL,
        $columnDate TEXT NOT NULL
      )
    ''');
  }

  Future<List<NoteModel>> getNotes() async {
    final Database db = await database();
    final List<Map<String, dynamic>> maps = await db.query(tableNotes, orderBy: "$columnDate DESC");
    return List.generate(maps.length, (i) {
      return NoteModel(
        id: maps[i][columnId],
        subject: maps[i][columnSubject],
        content: maps[i][columnContent],
        date: maps[i][columnDate],
      );
    });
  }

   Future<int> insertNote(NoteModel note) async {
    Database db = await database();
    int id = await db.insert(tableNotes, note.toJson());
    return id;
  }

  Future<int> updateNote(Map<String, dynamic> updatedNote) async {
    final db = await database();
    int rowsUpdated = await db.update(
      tableNotes,
      updatedNote,
      where: '$columnId = ?',
      whereArgs: [updatedNote['id']],
    );
    return rowsUpdated;
  }

  Future<int> deleteNote(int id) async {
    final db = await database();
  return await db.delete(
    tableNotes,
    where: '$columnId = ?',
    whereArgs: [id],
  );
  }
}