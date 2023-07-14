import 'package:flutter/material.dart';
import 'package:pixelone/model/product_model.dart';
import 'package:pixelone/providers/cart.dart';
import 'package:pixelone/providers/orders.dart';
import 'package:pixelone/providers/products.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      await Provider.of<Orders>(context, listen: false).fetchingOrdersFromDB();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<Orders>(context);
    final List<Order> orders = ordersProvider.orders;
    Cart cartProvider = Provider.of<Cart>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];

          return GestureDetector(
            onTap: () {
              if (order.status == OrderStatus.suspended) {
                Product? suspendedProduct =
                    Provider.of<Products>(context, listen: false)
                        .findbyid(order.productid);

                if (suspendedProduct != null) {
                  cartProvider.addToCart(suspendedProduct);
                  Navigator.pop(context);
                }
              }
            },
            child: ListTile(
              title: Text('Order ID: ${order.id}'),
              subtitle:
                  Text('Status: ${_mapOrderStatusToString(order.status)}'),
              trailing: Text('Total: RS ${order.total.toStringAsFixed(2)}'),
            ),
          );
        },
      ),
    );
  }
}

String _mapOrderStatusToString(OrderStatus status) {
  switch (status) {
    case OrderStatus.suspended:
      return 'Suspended';
    case OrderStatus.completed:
      return 'Completed';
    default:
      return 'Unknown';
  }
}
