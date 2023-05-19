import 'package:flutter/material.dart';

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
        _phoneno,
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
                TextFormField(
                  key: const ValueKey('email'),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'please enter a valid email address';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email Address'),
                  onSaved: (value) {
                    _userEmail = value!;
                  },
                ),
                if (!_isLogin)
                  TextFormField(
                    key: const ValueKey('Fullname'),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 4) {
                        return 'Please enter 4 digit long username';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(labelText: 'Full Name'),
                    onSaved: (value) {
                      _userName = value!;
                    },
                  ),
                TextFormField(
                  key: const ValueKey('password'),
                  validator: (value) {
                    if (value!.isEmpty || value.length < 6) {
                      return 'password must be 6 characters long';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  onSaved: (value) {
                    _userPassword = value!;
                  },
                ),
                if (!_isLogin)
                  TextFormField(
                    key: const ValueKey('phoneno'),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 10) {
                        return 'password must be 10 characters long';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(labelText: 'Phone'),
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      _userPassword = value!;
                    },
                  ),
                if (!_isLogin)
                  TextFormField(
                    key: const ValueKey('Business'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'password must be entered';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(labelText: 'Business'),
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
