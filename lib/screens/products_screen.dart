import 'package:flutter/material.dart';
import 'package:pixelone/providers/products.dart';
import 'package:pixelone/screens/add_new_products.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';

class ProductScreen extends StatelessWidget {
  static const routeName = '/product';
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mange Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AddNewProducts.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Center(
        child: ElevatedButton(
          child: Text('data'),
          onPressed: () {
            Provider.of<Products>(context, listen: false).fetchandsetproduct();
          },
        ),
      ),
    );
  }
}
