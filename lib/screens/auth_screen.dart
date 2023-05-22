import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:posapp/screens/homepage.dart';
import '../widgets/auth_form.dart';
import '/constants.dart' as Constants;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _isLoading = false;
  void _isSubmitted(
    String email,
    String password,
    String fullname,
    String phoneno,
    String business,
    bool isLogin,
    BuildContext ctx,
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });
      Map<String, String> requestBody = {
        'full_name': fullname,
        'phone_no': phoneno,
        'business_name': business,
        'password': password,
        'email': email,
      };

      Map<String, String> headers = {
        "content-type": "application/json",
        "Accept": "application/json",
      };
      if (!isLogin) {
        final response = await http.post(
          Uri.parse('${Constants.BASE_API_URL}/auth/signup'),
          headers: headers,
          body: json.encode(requestBody),
        );

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
        }
      } else {
        final response = await http.post(
          Uri.parse('${Constants.BASE_API_URL}/auth/login'),
          headers: headers,
          body: json.encode(requestBody),
        );
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
        }
      }
    } catch (err) {
      var message = 'An error occured please check your details';
      if (err != null) {
        message = err.toString();
      }
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Colors.black,
      ));
      print(err);
      setState(() {
        _isLoading = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_isSubmitted, _isLoading),
    );
  }
}
