import 'dart:convert';

import 'package:flutter/material.dart';
import '../constants.dart' as Constants;
import 'package:http/http.dart' as http;

import '../model/HttpException.dart';

class Auth with ChangeNotifier {
  late String token;
  late String userId;

  bool get isAuth {
    return token != null;
  }

  Future<void> _authenticate(String email, String password, String fullname,
      String business, String phoneno, urlsegment) async {
    try {
      Map<String, String> requestBody = {
        'email': email,
        'password': password,
        'full_name': fullname,
        'business_name': business,
        'phone_no': phoneno,
      };

      Map<String, String> headers = {
        "content-type": "application/json",
        "Accept": "application/json",
      };
      final response = await http.post(
        Uri.parse('${Constants.BASE_API_URL}/auth/$urlsegment'),
        headers: headers,
        body: json.encode(requestBody),
      );
      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        print(responseData);
      }
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']);
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signup(email, password, fullname, business, phoneno) async {
    return _authenticate(
        email, password, fullname, business, phoneno, 'signup');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, "", "", "", 'login');
  }
}
