import 'package:flutter/material.dart';
import 'package:pixelone/model/product_model.dart';
import 'package:pixelone/providers/products.dart';
import 'package:pixelone/screens/add_new_orders.dart';
import 'package:pixelone/screens/addingtocart_screen.dart';
import 'package:provider/provider.dart';

class SalesScreen extends StatelessWidget {
  const SalesScreen({super.key});
  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    Products productProvider = Provider.of<Products>(context);
    List<Product> cartItems = productProvider.cartItems;

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
      body: Container(
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.grey),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        labelText: 'Walk-in Customer',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                  ),
                  const SizedBox(width: 10.0),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.remove),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Warehouse',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      onChanged: (value) =>
                          productProvider.setSearchText(value),
                      decoration:
                          const InputDecoration(labelText: 'Search Product'),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      productProvider.clearCart();
                    },
                    child: const Text('Clear'),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(width: 1),
                  borderRadius: BorderRadius.circular(50)),
              child: Column(children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddingToCartScreen()),
                    );
                  },
                  child: const Text('Add Items'),
                ),
              ]),
            ),
            const SizedBox(height: 20.0),
            const Text('Cart Items'),
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (BuildContext context, int index) {
                  Product product = cartItems[index];
                  return ListTile(
                    title: Text(product.name),
                    subtitle: Text('Quantity: ${product.quantity}'),
                  );
                },
              ),
            ),
            // Container(
            //   padding: EdgeInsets.all(10.0),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(10.0),
            //     border: Border.all(color: Colors.grey),
            //   ),
            //   child: Column(
            //     children: [
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Text('Subtotal'),
            //           Text('\$35.00'), // Replace with actual subtotal value
            //         ],
            //       ),
            //       SizedBox(height: 10.0),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Text('Discount Amount'),
            //           Text(
            //               '-\$5.00'), // Replace with actual discount amount value
            //         ],
            //       ),
            //       SizedBox(height: 10.0),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Text('Total Amount'),
            //           Text('\$30.00'), // Replace with actual total amount value
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
