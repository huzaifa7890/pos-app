import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class ProductTable {
  static Future<void> createTable(Database db) async {
    await db.execute(
        'CREATE TABLE products(id INTEGER PRIMARY KEY,product_image TEXT, product_sku INTEGER,tag_price DOUBLE,sale_price DOUBLE,product_name TEXT,store_id INTEGER, store_name TEXT,weight INTEGER,description TEXT,costprice INTEGER,barcode INTEGER)');
  }
}

class OrdersTable {
  static Future<void> createTable(Database db) async {
    await db.execute(
        'CREATE TABLE orders(id INTEGER PRIMARY KEY AUTOINCREMENT,product_id INTEGER,subtotal DOUBLE ,discount DOUBLE,returnAmount DOUBLE,dueAmount DOUBLE,total DOUBLE,paidAmount DOUBLE, status INTEGER)');
  }
}

class OrderItemsTable {
  static Future<void> createTable(Database db) async {
    await db.execute(
        'CREATE TABLE orderitems(id INTEGER PRIMARY KEY AUTOINCREMENT,order_id INTEGER,product_id INTEGER,product_name TEXT,product_price DOUBLE,product_quantity INTEGER,discount DOUBLE,FOREIGN KEY (order_id) REFERENCES orders (id),FOREIGN KEY (product_id) REFERENCES products(id))');
  }
}

class CustomerTable {
  static Future<void> createTable(Database db) async {
    await db.execute(
        'CREATE TABLE customer(id INTEGER PRIMARY KEY AUTOINCREMENT,firstname TEXT, lastname TEXT, address TEXT,phoneno TEXT)');
  }
}
