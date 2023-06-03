import 'package:flutter/material.dart';
import 'package:pixelone/model/product_model.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  void addProduct(
    String pickedName,
    String pickedDescription,
    double pickedPrice,
    double pickedSaleprice,
    double pickedSku,
    double pickedweight,
    double pickedCostprice,
    String pickedBarcode,
  ) {
    final newProduct = Product(
      id: DateTime.now().toString(),
      name: pickedName,
      description: pickedDescription,
      price: pickedPrice,
      saleprice: pickedSaleprice,
      sku: pickedSku,
      weight: pickedweight,
      costprice: pickedCostprice,
      barcode: pickedBarcode,
    );
    _items.add(newProduct);
    notifyListeners();
  }
}
