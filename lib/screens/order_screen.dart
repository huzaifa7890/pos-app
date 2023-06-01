import 'package:flutter/material.dart';
import 'package:pixelone/screens/add_new_orders.dart';
import 'package:pixelone/widgets/app_drawer.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});
  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AddNewOders.routeName);
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      drawer: const AppDrawer(),
      body: Center(child: const Text('There Is No Order To Display')),
    );
  }
}
