import 'package:gallerycubit/dataprovider/database/database_config.dart';
import 'package:gallerycubit/dataprovider/database/database_table.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/utils/utils.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  DatabaseService._init();
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, DatabaseConfig.databaseName);
    Sqflite.setDebugModeOn(false);
    return await openDatabase(path,
        version: DatabaseConfig.databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(DataBaseTable.imageTable);
  }

  // closign the database connection
  Future close() async {
    final db = await instance.database;
    db!.close();
  }

  // delete User Table
  Future<void> _deleteTable(String _tableName) async {
    try {
      Database? db = await DatabaseService.instance.database;
      await db!.transaction((txn) async {
        var batch = txn.batch();
        batch.delete(_tableName);
        await batch.commit();
      });
    } catch (error) {
      throw Exception('DbBase.cleanDatabase: ' + error.toString());
    }
  }

  Future _deleteDataBase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, DatabaseConfig.databaseName);
    return await deleteDatabase(path);
  }

  // schema information

  //Check if a table exists
  Future<bool> tableExists(DatabaseExecutor db, String table) async {
    var count = firstIntValue(await db.query('sqlite_master',
        columns: ['COUNT(*)'],
        where: 'type = ? AND name = ?',
        whereArgs: ['table', table]));
    return count! > 0;
  }

  // List table names
  Future<List<String>> getTableNames(DatabaseExecutor db) async {
    var tableNames = (await db
            .query('sqlite_master', where: 'type = ?', whereArgs: ['table']))
        .map((row) => row['name'] as String)
        .toList(growable: false)
      ..sort();
    return tableNames;
  }
}
