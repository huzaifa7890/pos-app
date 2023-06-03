import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pixelone/model/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart' as constants;
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  Future<void> addProduct(
    String pickedName,
    String pickedDescription,
    double pickedPrice,
    double pickedSaleprice,
    double pickedSku,
    double pickedweight,
    double pickedCostprice,
    String pickedBarcode,
  ) async {
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

  Future<void> fetchandsetproduct() async {
    final pref = await SharedPreferences.getInstance();
    final userpref = pref.getString('key');
    final extractedUserData = json.decode(userpref!) as Map<String, dynamic>;
    final token = extractedUserData['user']['token'];
    final tenantid = extractedUserData['user']['tenant_id'];

    final url = Uri.parse('${constants.BASE_API_URL}/products');
    Map<String, String> headers = {
      "content-type": "application/json",
      "Authorization": "Bearer $token",
      "x-tenant": tenantid,
    };
    try {
      final response = await http.get(
        url,
        headers: headers,
      );
      if (response.statusCode == 200) {
        final respnsedata = jsonDecode(response.body.toString());
      } else {}
    } catch (error) {
      rethrow;
    }
    notifyListeners();
  }
}
