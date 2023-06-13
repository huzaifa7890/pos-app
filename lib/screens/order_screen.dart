import 'package:flutter/material.dart';
import 'package:pixelone/providers/products.dart';
import 'package:pixelone/screens/add_new_orders.dart';
import 'package:pixelone/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});
  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AddNewOders.routeName);
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                Provider.of<Products>(context, listen: false)
                    .storingDataInDbFromAPI();
              },
              child: const Text('update'))
        ],
      ),
    );
  }
}
