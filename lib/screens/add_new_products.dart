import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pixelone/providers/products.dart';
import 'package:provider/provider.dart';

import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../utils/constants.dart';

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
  String? barcodeResult;

  Future _scanBarcode() async {
    try {
      String barcode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'cancel',
        true,
        ScanMode.BARCODE,
      );
      setState(() => barcodeResult = barcode);
    } on PlatformException {
      barcodeResult = "Failed to get platform version";
    } on FormatException {
      setState(() => barcodeResult = 'Scan canceled');
    } catch (e) {
      setState(() => barcodeResult = 'Error: $e');
    }
  }

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
      _skuController.text as int,
      _weightController.text as int,
      _costPriceController.text as int,
      _barcodeController.text as int,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _discriptionController.dispose();
    _priceController.dispose();
    _salesPriceController.dispose();
    _skuController.dispose();
    _weightController.dispose();
    _costPriceController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Add New Products',
          ),
          elevation: 0,
          backgroundColor: primaryColor,
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
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
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
                    ElevatedButton(
                        onPressed: _scanBarcode,
                        child: const Text("Start Scan"))
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
