import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pixelone/providers/products.dart';
import 'package:provider/provider.dart';

class AddNewProducts extends StatefulWidget {
  static const routeName = '/add-product';
  const AddNewProducts({super.key});

  @override
  State<AddNewProducts> createState() => _AddNewProductsState();
}

class _AddNewProductsState extends State<AddNewProducts> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _discriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _salesPriceController = TextEditingController();
  final _skuController = TextEditingController();
  final _weightController = TextEditingController();
  final _costPriceController = TextEditingController();
  final _sizeController = TextEditingController();
  final _barcodeController = TextEditingController();

  String? sscanresult;

  void _saveProduct() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    Provider.of<Products>(context, listen: false).addProduct(
      _nameController.text,
      _discriptionController.text,
      _priceController.text as double,
      _salesPriceController.text as double,
      _skuController.text as double,
      _weightController.text as double,
      _costPriceController.text as double,
      _barcodeController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add New Products'),
          actions: [
            IconButton(
              onPressed: _saveProduct,
              icon: const Icon(Icons.save),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    label: Text('Product Name'),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    label: Text('Price'),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _salesPriceController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    label: Text('Sale Price'),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _skuController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    label: Text('Sku'),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    label: Text('Weight'),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    label: Text('Select Category'),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _costPriceController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    label: Text('Cost Price'),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    label: Text('Select Brand'),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _sizeController,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    label: Text('Size'),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _discriptionController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    label: Text('Description'),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _barcodeController,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          label: Text('Bar Code'),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.camera),
                        label: Text("Start Scan"))
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
