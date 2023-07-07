import 'package:pixelone/db_helper/db_tables.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'product.db'),
        onCreate: (db, version) async {
      await ProductTable.createTable(db);
      await OrdersTable.createTable(db);
      await OrderItemsTable.createTable(db);
    }, version: 1);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }

  static Future<void> deleteTable() async {
    final db = await DBHelper.database();
    await db.execute('DROP TABLE IF EXISTS products');
  }
}
