import 'package:flutter/material.dart';
import 'package:pixelone/utils/constants.dart' as constants;

class AuthForm extends StatefulWidget {
  const AuthForm(this.submitFn, this.isLoading, {super.key});

  final bool isLoading;
  final void Function(
    String fullname,
    String business,
    String email,
    String password,
    String phoneno,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  var _userName = '';
  var _business = '';
  var _userEmail = '';
  var _userPassword = '';
  var _phoneno = '';

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(
        _userName.trim(),
        _business,
        _userEmail.trim(),
        _userPassword.trim(),
        _phoneno.trim(),
        _isLogin,
        context,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
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
                    key: const ValueKey('fullname'),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 4) {
                        return constants.SH_FULL_NAME_ERROR;
                      }
                      return null;
                    },
                    decoration:
                        const InputDecoration(hintText: constants.HT_FULL_NAME),
                    onSaved: (value) {
                      _userName = value!;
                    },
                  ),
                if (!_isLogin)
                  TextFormField(
                    key: const ValueKey('business'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return constants.SH_BUSINESS_ERROR;
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        hintText: constants.HT_BUSINESS_NAME),
                    onSaved: (value) {
                      _business = value!;
                    },
                  ),
                TextFormField(
                  key: const ValueKey('email'),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return constants.SH_EMAIL_ERROR;
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                      hintText: constants.HT_EMAIL_ADDRESS),
                  onSaved: (value) {
                    _userEmail = value!;
                  },
                ),
                TextFormField(
                  key: const ValueKey('password'),
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 6) {
                      return constants.SH_PASSWORD_ERROR;
                    }
                    return null;
                  },
                  decoration:
                      const InputDecoration(hintText: constants.HT_PASSWORD),
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
                        return constants.SH_PHONENO_ERROR;
                      }
                      return null;
                    },
                    decoration:
                        const InputDecoration(hintText: constants.HT_PHONE_NO),
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      _phoneno = value!;
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
                        : 'I already have an account'),
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
