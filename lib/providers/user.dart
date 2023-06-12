import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User with ChangeNotifier {
  final String uid;

  final String uname;
  User({required this.uid, required this.uname});

  void userdata() async {
    final pref = await SharedPreferences.getInstance();
    final userpref = pref.getString('key');
    final extractedUserData = json.decode(userpref!) as Map<String, dynamic>;
  }
}
