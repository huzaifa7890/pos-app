import 'package:flutter/material.dart';
import 'package:pixelone/db_helper/product_db.dart';

class Order {
  final int id;
  final double subtotal;
  final double discount;
  final double returnAmount;
  final double dueAmount;
  final double total;
  final double paidAmount;
  bool status;

  Order({
    required this.id,
    required this.subtotal,
    required this.discount,
    required this.returnAmount,
    required this.dueAmount,
    required this.total,
    required this.paidAmount,
    this.status = false,
  });
}

class Orders with ChangeNotifier {
  List<Order> _orders = [];
  List<Order> get orders {
    return [..._orders];
  }

  Future<int> storeOrders(
    double subtotal,
    double discount,
    double returnAmount,
    double dueAmount,
    double total,
    double paidAmount,
    status,
  ) async {
    final db = await DBHelper.database();
    final orderId = await db.insert('orders', {
      'subtotal': subtotal,
      'discount': discount,
      'returnAmount': returnAmount,
      'dueAmount': dueAmount,
      'total': total,
      'paidAmount': paidAmount,
      'status': status,
    });

    notifyListeners();
    return orderId;
  }

  Future<void> storeOderItems(
    orderId,
    int productId,
    String productName,
    double productPrice,
    int productQuantity,
    double discount,
  ) async {
    await DBHelper.insert('orderitems', {
      'id': orderId,
      'product_id': productId,
      'product_name': productName,
      'product_price': productPrice,
      'product_quantity': productQuantity,
      'discount': discount,
    });
    notifyListeners();
  }

  Future<void> fetchingOrdersFromDB() async {
    final dataList = await DBHelper.getData('orders');
    _orders = dataList
        .map(
          (e) => Order(
            id: e['id'],
            subtotal: e['subtotal'],
            discount: e['discount'],
            returnAmount: e['returnAmount'],
            dueAmount: e['dueAmount'],
            total: e['total'],
            paidAmount: e['paidAmount'],
            // status: e['status'],
          ),
        )
        .toList();
    notifyListeners();
  }
}
