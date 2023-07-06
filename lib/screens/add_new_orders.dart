import 'package:flutter/material.dart';
import 'package:pixelone/providers/orders.dart';
import 'package:provider/provider.dart';

class AddNewOders extends StatelessWidget {
  static const routeName = '/new-order';
  const AddNewOders({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Order'),
      ),
      body: Column(
        children: [
          ElevatedButton(onPressed: () {}, child: const Text('data')),
          ElevatedButton(
              onPressed: () {
                Provider.of<Orders>(context, listen: false)
                    .fetchingProductFromDB();
              },
              child: const Text('fetch')),
        ],
      ),
    );
  }
}
