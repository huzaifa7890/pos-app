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
    this.status = true,
  });
}

class Orders with ChangeNotifier {
  List<Order> _items = [];
  List<Order> get items {
    return [..._items];
  }

  Future<void> storeOrders(
    double subtotal,
    double discount,
    double returnAmount,
    double dueAmount,
    double total,
    double paidAmount,
    status,
  ) async {
    await DBHelper.insert('orders', {
      'order_id': 1,
      'subtotal': subtotal,
      'discount': discount,
      'returnAmount': returnAmount,
      'dueAmount': dueAmount,
      'total': total,
      'paidAmount': paidAmount,
      'status': status,
    });
    notifyListeners();
  }

  Future<void> storeOderItems(
    int productId,
    String productName,
    double productPrice,
    int productQuantity,
    double discount,
  ) async {
    await DBHelper.insert('orderitems', {
      'orderitem_id': 1,
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
    _items = dataList
        .map(
          (e) => Order(
              id: e['order_id'],
              subtotal: e['subtotal'],
              discount: e['discount'],
              returnAmount: e['returnAmount'],
              dueAmount: e['dueAmount'],
              total: e['total'],
              paidAmount: e['paidAmount']),
        )
        .toList();
    notifyListeners();
  }
}
