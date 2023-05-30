import 'dart:convert';

import 'package:flutter/material.dart';

import '../constants.dart' as Constants;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/HttpException.dart';

class Auth with ChangeNotifier {
  var _token;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_token != null) {
      return _token;
    }
    return null;
  }

  Future<void> signup(String fullname, String business, String email,
      String password, String phoneno) async {
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
        Uri.parse('${Constants.BASE_API_URL}/auth/signup'),
        headers: headers,
        body: json.encode(requestBody),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']);
      } else {
        _token = responseData['user']['token'];

        final pref = await SharedPreferences.getInstance();
        final userdata = json.encode({
          'token': _token,
        });
        pref.setString('key', userdata);
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      Map<String, String> requestBody = {
        'email': email,
        'password': password,
      };

      Map<String, String> headers = {
        "content-type": "application/json",
        "Accept": "application/json",
      };
      final response = await http.post(
        Uri.parse('${Constants.BASE_API_URL}/auth/login'),
        headers: headers,
        body: json.encode(requestBody),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']);
      } else {
        final id = responseData['user']['id'];
        print('id here $id');

        _token = responseData['user']['token'];
        final pref = await SharedPreferences.getInstance();
        final userdata = json.encode({
          'token': _token,
        });
        pref.setString('key', userdata);
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> tryautoLogin() async {
    final pref = await SharedPreferences.getInstance();
    if (!pref.containsKey('key')) {
      return false;
    }
    final userpref = pref.getString('key');
    final extractedUserData = json.decode(userpref!) as Map<String, dynamic>;

    _token = extractedUserData['token'];

    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    final pref = await SharedPreferences.getInstance();
    pref.clear();
    notifyListeners();
  }
}
