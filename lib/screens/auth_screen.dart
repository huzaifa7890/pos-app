import 'dart:convert';

import 'package:flutter/material.dart';
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
        print('Login sninsi');
        final response = await http.post(
          Uri.parse('${Constants.BASE_API_URL}/auth/signup'),
          headers: headers,
          body: json.encode(requestBody),
        );

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          print(data);
          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      } else {
        final response = await http.post(
          Uri.parse('${Constants.BASE_API_URL}/auth/login'),
          headers: headers,
          body: json.encode(requestBody),
        );
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          print(data);
          // ignore: use_build_context_synchronously
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      }

      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text("Haha"),
        backgroundColor: Colors.black,
      ));
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
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
