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

    double subtotal = productProvider.calculateSubtotal();
    double discount = productProvider.discount;
    double total = subtotal - discount;
    double paidAmount = productProvider.paidAmount;
    double returnAmount = productProvider.returnAmount(total);
    double dueAmount = productProvider.dueAmount(total);

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
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.grey),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  labelText: 'Walk-in Customer',
                ),
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Warehouse',
                ),
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      onChanged: (value) =>
                          productProvider.setSearchText(value),
                      decoration: const InputDecoration(
                        labelText: 'Search Product',
                      ),
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
              const SizedBox(height: 20.0),
              if (cartItems.isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(1),
                      color: Colors.grey),
                  child: const Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              'Cart Items',
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 70),
                            child: Text(
                              'Quantity',
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cartItems.length,
                itemBuilder: (BuildContext context, int index) {
                  Product product = cartItems[index];
                  double subtotal = product.price * product.quantity;

                  return ListTile(
                    title: Text(product.name),
                    subtitle: Text(
                      '${product.quantity} x ${product.price} = $subtotal',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            productProvider.decreaseQuantity(product);
                          },
                          icon: const Icon(Icons.remove),
                        ),
                        Text(product.quantity.toString()),
                        IconButton(
                          onPressed: () {
                            productProvider.addToCart(product);
                          },
                          icon: const Icon(Icons.add),
                        ),
                        IconButton(
                          onPressed: () {
                            productProvider.removeFromCart(product);
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 10.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddingToCartScreen(),
                    ),
                  );
                },
                child: const Text('Add Items'),
              ),
              const SizedBox(height: 20.0),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Subtotal:',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Text(
                    '\$${subtotal.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Discount:',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  SizedBox(
                    width: 50,
                    child: TextFormField(
                      initialValue: discount.toString(),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (value) {
                        productProvider
                            .setDiscount(double.tryParse(value) ?? 0.0);
                      },
                      decoration: const InputDecoration(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Paid Amount:',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  SizedBox(
                    width: 50.0,
                    child: TextFormField(
                      initialValue: paidAmount.toString(),
                      keyboardType: const TextInputType.numberWithOptions(),
                      onChanged: (value) {
                        productProvider
                            .setPaidAmount(double.tryParse(value) ?? 0.0);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Return Amount:',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Text(
                    '\$${returnAmount.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Due Amount:',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Text(
                    '\$${dueAmount.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              const SizedBox(height: 10.0),
            ],
          ),
        ),
      ),
    );
  }
}
