import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'product.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE productdata(product_id INTEGER,product_sku INTEGER,tag_price DOUBLE,sale_price DOUBLE,product_name TEXT,store_id INTEGER, store_name TEXT,weight INTEGER)');
    }, version: 1);
  }

  static Future<void> insert(Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.insert(
      'productdata',
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
    await db.execute('DROP TABLE IF EXISTS productdata');
  }
}
