import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pixelone/db_helper/product_db.dart';
import 'package:pixelone/model/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pixelone/utils/constants.dart' as constants;
import 'package:http/http.dart' as http;

import '../model/http_exception.dart';

class Products with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String searchText = '';
  bool showProducts = false;
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  void setSearchText(String text) {
    searchText = text;
    notifyListeners();
  }

  List<Product> getFilteredProducts() {
    if (searchText.isEmpty) {
      return _items;
    } else {
      final lowercaseSearchText = searchText.toLowerCase();
      return _items
          .where((product) =>
              product.name.toLowerCase().contains(lowercaseSearchText))
          .toList();
    }
  }

  Product? findbyid(int idd) {
    try {
      return _items.firstWhere((pro) => pro.id == idd);
    } catch (e) {
      return null;
    }
  }

  Future<void> addProduct(
    String pickedName,
    String pickedDescription,
    double pickedPrice,
    double pickedSaleprice,
    int pickedSku,
    int pickedweight,
    double pickedCostprice,
    int pickedBarcode,
  ) async {
    final newProduct = Product(
      id: 234,
      name: pickedName,
      imageurl: '',
      description: pickedDescription,
      price: pickedPrice,
      quantity: pickedSku,
      saleprice: pickedSaleprice,
      sku: pickedSku,
      weight: pickedweight,
      costprice: pickedCostprice,
      barcode: pickedBarcode,
    );
    _items.add(newProduct);

    notifyListeners();
  }

  Future<void> storingDataInDbFromAPI() async {
    final pref = await SharedPreferences.getInstance();
    final userpref = pref.getString('key');
    final extractedUserData = json.decode(userpref!) as Map<String, dynamic>;
    final token = extractedUserData['user']['token'];
    final tenantid = extractedUserData['user']['tenant_id'].toString();

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
        String jsonData = response.body.toString();
        Map<String, dynamic> data = jsonDecode(jsonData);

        List<dynamic> objects = data['data'];
        if (objects.isEmpty) {
          throw HttpException(constants.SCAFFOLD_ERROR);
        } else {
          String jsonData = response.body.toString();
          Map<String, dynamic> data = jsonDecode(jsonData);

          List<dynamic> objects = data['data'];
          for (var i = 0; i < objects.length; i++) {
            DBHelper.insert('products', {
              'id': objects[i]['product_id'],
              'product_image': objects[i]['product_image_path'],
              'product_sku': objects[i]['product_sku'],
              'tag_price': objects[i]['tag_price'],
              'sale_price': objects[i]['sale_price'],
              'product_name': objects[i]['product_name'],
              'store_id': objects[i]['store_id'],
              'store_name': objects[i]['store_name'],
              'weight': objects[i]['weight'],
              'description': objects[i]['store_name'],
              'costprice': objects[i]['tag_price'],
              'barcode': objects[i]['product_sku']
            });
          }
        }
      }
    } catch (error) {
      rethrow;
    }
    notifyListeners();
  }

  Future<void> fetchingProductFromDB() async {
    try {
      _isLoading = true;
      final dataList = await DBHelper.getData('products');
      _items = dataList
          .map(
            (e) => Product(
                id: e['id'],
                name: e['product_name'],
                imageurl: e['product_image'],
                price: e['tag_price'],
                saleprice: e['sale_price'],
                sku: e['product_sku'],
                weight: e['weight'],
                description: e['store_name'],
                costprice: e['tag_price'],
                barcode: e['product_sku']),
          )
          .toList();
    } catch (e) {
      rethrow;
    }
    _isLoading = false;
    notifyListeners();
  }
}
