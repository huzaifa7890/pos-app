import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'product.db'),
        onCreate: (db, version) {
      db.execute(
          'CREATE TABLE products(product_id INTEGER PRIMARY KEY,product_image TEXT, product_sku INTEGER,tag_price DOUBLE,sale_price DOUBLE,product_name TEXT,store_id INTEGER, store_name TEXT,weight INTEGER,description TEXT,costprice INTEGER,barcode INTEGER)');
      db.execute(
          'CREATE TABLE orders(order_id INTEGER PRIMARY KEY,subtotal DOUBLE ,discount DOUBLE,returnAmount DOUBLE,dueAmount DOUBLE,total DOUBLE,paidAmount DOUBLE, status INTEGER)');
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
