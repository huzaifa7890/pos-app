import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pixelone/providers/cart.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class PrintScreen extends StatefulWidget {
  const PrintScreen({Key? key}) : super(key: key);

  @override
  State<PrintScreen> createState() => _PrintScreenState();
}

class _PrintScreenState extends State<PrintScreen> {
  String _businessName = '';

  @override
  void initState() {
    super.initState();
    fetchDataFromSharedPreferences().then((data) {
      setState(() {
        _businessName = data;
      });
    });
  }

  Future<String> fetchDataFromSharedPreferences() async {
    final pref = await SharedPreferences.getInstance();
    final userpref = pref.getString('key');
    final extractedUserData = json.decode(userpref!) as Map<String, dynamic>;
    final businessName =
        extractedUserData['tenant']['business_name'].toString();

    return businessName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Print Screen'),
      ),
      body: Consumer<Cart>(
        builder: (context, cartProvider, _) {
          final cartItems = cartProvider.cartItems;
          final discount = cartProvider.discount;
          final subtotal = cartProvider.calculateSubtotal();
          final total = cartProvider.calculateTotal(subtotal);
          final now = DateTime.now();
          final formatter = DateFormat('yyyy/MM/dd HH:mm:ss');

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'PixelOne',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _businessName,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Save money. Live Better.',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Pakistan SGD',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Cart Items:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DataTable(
                  columns: const [
                    DataColumn(
                      label: Text(
                        'Product',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Price',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Quantity',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Subtotal',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                  rows: cartItems
                      .map((product) => DataRow(
                            cells: [
                              DataCell(Text(product.name)),
                              DataCell(Text(product.price.toString())),
                              DataCell(Row(
                                children: [
                                  Text(product.quantity.toString()),
                                ],
                              )),
                              DataCell(Text((product.price * product.quantity)
                                  .toString())),
                            ],
                          ))
                      .toList(),
                ),
                const SizedBox(height: 16),
                Text(
                  'Subtotal:     $subtotal',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Discount:    $discount',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Total:           $total',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '# ITEMS SOLD ${cartItems.length.toString()}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 30),
                ),
                const SizedBox(height: 16),
                Text(
                  formatter.format(now),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
