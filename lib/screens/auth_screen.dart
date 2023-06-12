import 'package:flutter/material.dart';
import 'package:pixelone/screens/homepage.dart';
import '../model/http_exception.dart';
import '../providers/auth.dart';
import '../widgets/auth_form.dart';
import '../utils/constants.dart' as constants;
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _isLoading = false;
  void _isSubmitted(
    String fullname,
    String business,
    String email,
    String password,
    String phoneno,
    bool isLogin,
    BuildContext ctx,
  ) async {
    try {
      setState(() {
        _isLoading = true;
      });

      if (!isLogin) {
        await Provider.of<Auth>(context, listen: false)
            .signup(fullname, business, email, password, phoneno);

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
      var errorMessage = constants.HT_ERROR;
      errorMessage = error.toString();
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.black,
      ));
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      var errorMessage = constants.HT_ERROR;

      errorMessage = error.toString();

      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.black,
      ));
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
