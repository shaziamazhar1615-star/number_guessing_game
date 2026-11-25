import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> getDatabase() async {
    if (_database != null) return _database!;

    String dbPath = join(
      await getDatabasesPath(),
      'guess_game.db',
    );

    _database = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE history(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            number INTEGER,
            attempts INTEGER
          )
        ''');
      },
    );

    return _database!;
  }

  Future<void> insertGame(int number, int attempts) async {
    final db = await getDatabase();

    await db.insert('history', {
      'number': number,
      'attempts': attempts,
    });
  }

  Future<List<Map<String, Object?>>> getHistory() async {
    final db = await getDatabase();

    return await db.query('history');
  }
}