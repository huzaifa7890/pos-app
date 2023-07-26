import 'package:flutter/material.dart';
import 'package:pixelone/db_helper/product_db.dart';
import 'package:sqflite/sqflite.dart';

enum OrderStatus {
  suspended,
  completed,
}

int _mapOrderStatusToInt(OrderStatus status) {
  switch (status) {
    case OrderStatus.suspended:
      return 0;
    case OrderStatus.completed:
      return 1;
    default:
      throw Exception('Invalid OrderStatus value');
  }
}

OrderStatus _mapIntToOrderStatus(int status) {
  switch (status) {
    case 0:
      return OrderStatus.suspended;
    case 1:
      return OrderStatus.completed;
    default:
      throw Exception('Invalid OrderStatus value');
  }
}

class Order {
  final int id;
  final int productid;
  final double subtotal;
  final double discount;
  final double returnAmount;
  final double dueAmount;
  final double total;
  final double paidAmount;
  final OrderStatus status;
  Order({
    required this.id,
    required this.productid,
    required this.subtotal,
    required this.discount,
    required this.returnAmount,
    required this.dueAmount,
    required this.total,
    required this.paidAmount,
    required this.status,
  });
}

class Orders with ChangeNotifier {
  List<Order> _orders = [];
  List<Order> get orders {
    return [..._orders];
  }

  Future<int> storeOrders(
    int? suspendedOrderId,
    double subtotal,
    double discount,
    double returnAmount,
    double dueAmount,
    double total,
    double paidAmount,
    OrderStatus status,
  ) async {
    final db = await DBHelper.database();
    int orderId;

    if (suspendedOrderId != null) {
      orderId = await db.update(
        'orders',
        {
          'subtotal': subtotal,
          'discount': discount,
          'returnAmount': returnAmount,
          'dueAmount': dueAmount,
          'total': total,
          'paidAmount': paidAmount,
          'status': _mapOrderStatusToInt(status),
        },
        where: 'id = ?',
        whereArgs: [suspendedOrderId],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      final newOrderData = {
        'subtotal': subtotal,
        'discount': discount,
        'returnAmount': returnAmount,
        'dueAmount': dueAmount,
        'total': total,
        'paidAmount': paidAmount,
        'status': _mapOrderStatusToInt(status),
      };
      orderId = await db.insert('orders', newOrderData);
    }

    notifyListeners();
    return orderId;
  }

  Future<void> storeOderItems(
    int orderId,
    int productId,
    String productName,
    double productPrice,
    int productQuantity,
    double discount,
  ) async {
    await DBHelper.insert('orderitems', {
      'order_id': orderId,
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
            productid: 123,
            subtotal: e['subtotal'],
            discount: e['discount'],
            returnAmount: e['returnAmount'],
            dueAmount: e['dueAmount'],
            total: e['total'],
            paidAmount: e['paidAmount'],
            status: _mapIntToOrderStatus(e['status']),
          ),
        )
        .toList();
    notifyListeners();
  }

  Future<List<int>> fetchingOrderItemsFromDB(int orderId) async {
    List<Map<String, dynamic>> orderItemsData =
        await DBHelper.getOrderItemsByOrderId(orderId);

    List<int> productIds = [];

    for (var itemData in orderItemsData) {
      int productId = itemData['product_id'];
      productIds.add(productId);
    }

    return productIds;
  }
}
