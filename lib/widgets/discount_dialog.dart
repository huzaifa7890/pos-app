import 'package:flutter/material.dart';
import 'package:pixelone/providers/cart.dart';
import 'package:provider/provider.dart';

class DiscountDialog extends StatefulWidget {
  const DiscountDialog({super.key});

  @override
  State<DiscountDialog> createState() => _DiscountDialogState();
}

class _DiscountDialogState extends State<DiscountDialog> {
  final TextEditingController _discountAmount = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Cart cartProvider = Provider.of<Cart>(context, listen: false);

    return AlertDialog(
        title: const Text('Enter Discount'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                controller: _discountAmount,
                decoration: const InputDecoration(labelText: 'Enter Discount'),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              cartProvider
                  .setDiscount(double.tryParse(_discountAmount.text) ?? 0.0);
              Navigator.pop(context);
            },
            child: const Text('Submit'),
          ),
        ]);
  }
}
