import 'package:flutter/material.dart';
import '../constants.dart' as Constants;

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this.isLoading);

  final bool isLoading;
  final void Function(
    String email,
    String password,
    String fullname,
    String phoneno,
    String business,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  var _phoneno = '';
  var _business = '';

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _business.trim(),
        _phoneno.trim(),
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
      margin: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!_isLogin)
                  TextFormField(
                    key: const ValueKey('Fullname'),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 4) {
                        return Constants.SH_FULL_NAME_ERROR;
                      }
                      return null;
                    },
                    decoration:
                        const InputDecoration(hintText: Constants.HT_FULL_NAME),
                    onSaved: (value) {
                      _userName = value!;
                    },
                  ),
                if (!_isLogin)
                  TextFormField(
                    key: const ValueKey('Business'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return Constants.SH_PASSWORD_ERROR;
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        hintText: Constants.HT_BUSINESS_NAME),
                    onSaved: (value) {
                      _userPassword = value!;
                    },
                  ),
                TextFormField(
                  key: const ValueKey('email'),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return Constants.SH_EMAIL_ERROR;
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      hintText: Constants.HT_EMAIL_ADDRESS),
                  onSaved: (value) {
                    _userEmail = value!;
                  },
                ),
                TextFormField(
                  key: const ValueKey('password'),
                  validator: (value) {
                    if (value!.isEmpty || value.length < 6) {
                      return Constants.SH_PASSWORD_ERROR;
                    }
                    return null;
                  },
                  decoration:
                      const InputDecoration(hintText: Constants.HT_PASSWORD),
                  obscureText: true,
                  onSaved: (value) {
                    _userPassword = value!;
                  },
                ),
                if (!_isLogin)
                  TextFormField(
                    key: const ValueKey('phoneno'),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 6) {
                        return Constants.SH_PHONENO_ERROR;
                      }
                      return null;
                    },
                    decoration:
                        const InputDecoration(hintText: Constants.HT_PHONE_NO),
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      _userPassword = value!;
                    },
                  ),
                const SizedBox(
                  height: 12,
                ),
                if (widget.isLoading) const CircularProgressIndicator(),
                if (!widget.isLoading)
                  ElevatedButton(
                    onPressed: _trySubmit,
                    child: Text(_isLogin ? 'Login' : 'SignUp'),
                  ),
                if (!widget.isLoading)
                  ElevatedButton(
                    child: Text(_isLogin
                        ? 'Create New Account'
                        : 'i already have an account'),
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
