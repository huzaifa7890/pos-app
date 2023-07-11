import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String _businessName = '';

  @override
  void initState() {
    super.initState();
    fetchDataFromSharedPreferences().then((data) {
      setState(() {
        _businessName = data;
      });
    });
  }

  Future<String> fetchDataFromSharedPreferences() async {
    final pref = await SharedPreferences.getInstance();
    final userpref = pref.getString('key');
    final extractedUserData = json.decode(userpref!) as Map<String, dynamic>;
    final businessName =
        extractedUserData['tenant']['business_name'].toString();

    return businessName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Settings'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.business),
              title: const Text(
                'Business Name',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Container(
                padding: const EdgeInsets.all(8),
                child: Text(
                  _businessName,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.currency_exchange),
              title: Text('Currency'),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
