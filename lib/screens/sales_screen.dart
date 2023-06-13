import 'package:flutter/material.dart';
import 'package:pixelone/providers/products.dart';
import 'package:pixelone/screens/add_new_orders.dart';
import 'package:provider/provider.dart';

class SalesScreen extends StatelessWidget {
  const SalesScreen({super.key});
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
