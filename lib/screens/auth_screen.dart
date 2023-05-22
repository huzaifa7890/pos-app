import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:posapp/model/HttpException.dart';
import 'package:posapp/screens/homepage.dart';
import '../providers/auth.dart';
import '../widgets/auth_form.dart';
import '/constants.dart' as Constants;
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _isLoading = false;
  Future<void> _isSubmitted(
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

      if (!isLogin) {
        await Provider.of<Auth>(context, listen: false)
            .signup(email, password, fullname, phoneno, business);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: ((ctx) => const HomeScreen())),
        );
      } else {
        await Provider.of<Auth>(context, listen: false).login(email, password);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: ((ctx) => const HomeScreen())),
        );
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication Failed';
      if (error != null) {
        errorMessage = error.toString();
        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.black,
        ));
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      var errorMessage = 'Could not authenticate you. Please try again later.';

      if (error != null) {
        errorMessage = error.toString();

        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.black,
        ));
      }
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
