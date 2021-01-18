import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqlLiteService {
  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'conexion.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE dispositivos(uuid TEXT PRIMARY KEY)",
        );
      },
      version: 1,
    );
  }

  Future<void> insertUuid(String uuid) async {
    // Get a reference to the database.
    final Database db = await this.database();
    await db.query("dispositivos", where: "uuid = ?", whereArgs: [uuid]).then(
        (value) async {
      if (value.length == 0) {
        await db.insert(
          '',
          {'uuid': uuid},
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      db.close();
    });
  }
}
