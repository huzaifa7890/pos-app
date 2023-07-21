import 'package:flutter/material.dart';
import 'package:pixelone/components/c_elevated_button.dart';
import 'package:pixelone/model/product_model.dart';
import 'package:pixelone/providers/cart.dart';
import 'package:pixelone/providers/orders.dart';
import 'package:pixelone/screens/order_screen.dart';
import 'package:provider/provider.dart';

class CustomDialog extends StatefulWidget {
  final int? suspendedOrderId;
  const CustomDialog(this.suspendedOrderId, {super.key});
  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  int selectedAmount = 0;
  int? suspendedorderId;
  @override
  Widget build(BuildContext context) {
    List<Product> cartItems = Provider.of<Cart>(context).cartItems;
    Cart cartProvider = Provider.of<Cart>(context, listen: false);
    Orders orderProvider = Provider.of<Orders>(context, listen: false);
    double subtotal = cartProvider.calculateSubtotal();
    double discount = cartProvider.discount;
    double total = cartProvider.calculateTotal(subtotal);
    double remainingBalance = total - selectedAmount;
    double dueAmount = cartProvider.dueAmount(remainingBalance);
    double returnAmount = cartProvider.returnAmount(remainingBalance);
    double paidAmount = cartProvider.paidAmount;
    return Dialog(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'FINALIZE SALE',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        const TextField(
                          decoration: InputDecoration(
                            labelText: 'Field 1',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Amount',
                            border: OutlineInputBorder(),
                          ),
                          controller: TextEditingController(
                            text: selectedAmount.toString(),
                          ),
                          onSubmitted: (value) {
                            selectedAmount = value as int;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        const TextField(
                          decoration: InputDecoration(
                            labelText: 'Field 3',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Total Items ${cartItems.length}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: Text(
                                'Total Payable $total',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Subtotal $subtotal',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            const Text(
                              'Discount:',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: TextField(
                                onChanged: (value) {
                                  cartProvider.setDiscount(
                                      double.tryParse(value) ?? 0.0);
                                },
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Total Paying $selectedAmount',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            Expanded(
                              child: Text(
                                'Return Amount $returnAmount',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Due Amount $dueAmount',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 120.0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedAmount += 10;
                            });
                          },
                          child: const Text('10'),
                        ),
                        CElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedAmount += 20;
                            });
                          },
                          child: const Text('20'),
                        ),
                        CElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedAmount += 50;
                            });
                          },
                          child: const Text('50'),
                        ),
                        CElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedAmount += 100;
                            });
                          },
                          child: const Text('100'),
                        ),
                        CElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedAmount += 500;
                            });
                          },
                          child: const Text('500'),
                        ),
                        CElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedAmount += 1000;
                            });
                          },
                          child: const Text('1000'),
                        ),
                        CElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedAmount += 5000;
                            });
                          },
                          child: const Text('5000'),
                        ),
                        CElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedAmount = 0;
                            });
                          },
                          child: const Text('Clear'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8.0),
                  CElevatedButton(
                    onPressed: () async {
                      if (suspendedorderId != null) {
                        // Update existing order
                        await orderProvider.storeOrders(
                          suspendedorderId,
                          subtotal,
                          discount,
                          returnAmount,
                          dueAmount,
                          total,
                          paidAmount,
                          OrderStatus.completed,
                        );

                        for (Product product in cartItems) {
                          orderProvider.storeOderItems(
                            suspendedorderId!,
                            product.id,
                            product.name,
                            product.price,
                            product.quantity,
                            discount,
                          );
                        }
                      } else {
                        final orderId = await orderProvider.storeOrders(
                          null,
                          subtotal,
                          discount,
                          returnAmount,
                          dueAmount,
                          total,
                          paidAmount,
                          OrderStatus.completed,
                        );

                        for (Product product in cartItems) {
                          orderProvider.storeOderItems(
                            orderId,
                            product.id,
                            product.name,
                            product.price,
                            product.quantity,
                            discount,
                          );
                        }
                      }
                      cartProvider.clearCart();
                      if (!mounted) return;
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OrderScreen(),
                        ),
                      );
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
