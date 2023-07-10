import 'package:flutter/material.dart';
import 'package:pixelone/providers/orders.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];

          return ListTile(
            title: Text('Order ID: ${order.id}'),
            // subtitle: Text('Status: ${order.status ? 'Completed' : 'Pending'}'),
            trailing: Text('Total: RS ${order.total.toStringAsFixed(2)}'),
          );
        },
      ),
    );
  }
}
