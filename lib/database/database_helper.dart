import 'dart:io';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:time_tracker_app/models/entry.dart';

class DatabaseHelper {
  static Database _db;
  static DatabaseHelper _dbHelper;

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_dbHelper == null) {
      _dbHelper = DatabaseHelper._createInstance();
    }
    return _dbHelper;
  }

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }

    _db = await initDb();
    return _db;
  }

  void _onCreate(Database db, int newVersion) async {
    print("Database table created!");
    await db.execute("CREATE TABLE Entry(id INTEGER PRIMARY KEY, "
        "dayMonthYear TEXT UNIQUE, startDateTime INTEGER, endDateTime INTEGER, durationInMinutes INTEGER)");
  }

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = p.join(documentDirectory.path, "main.db");
    print(path);
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  //insertion
  Future<int> saveEntry(Entry entry) async {
    var dbClient = await db;
    var sql = """
    UPDATE Entry SET durationInMinutes = durationInMinutes + ? WHERE dayMonthYear = ?
    """;
    var res = await dbClient
        .rawUpdate(sql, [entry.durationInMinutes, entry.dayMonthYear]);

    res = await dbClient.rawInsert("""
    INSERT OR IGNORE INTO Entry(id, dayMonthYear, startDateTime, endDateTime, durationInMinutes)
    VALUES(?,?,?,?,?)
    """, [
      null, // SQLite will handle primary key (ROWID) automatically
      entry.dayMonthYear,
      entry.startDateTime,
      entry.endDateTime,
      entry.durationInMinutes
    ]);

    //var res = await dbClient.rawQuery('DELETE FROM Entry');
    //var res = await dbClient.rawQuery('DROP TABLE Entry');

    return res;
  }

  //deletion
  Future<int> deleteEntry(Entry entry) async {
    var dbClient = await db;
    int res = await dbClient.delete("Entry",
        where: 'endDateTime = ?', whereArgs: [entry.endDateTime]);
    return res;
  }

  //read
  Future<List> getAllEntries() async {
    var dbClient = await db;
    var res = await dbClient.query("Entry", columns: [
      'dayMonthYear',
      'startDateTime',
      'endDateTime',
      'durationInMinutes'
    ]);
    return res.toList();
  }
}
