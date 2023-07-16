import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrintScreen extends StatefulWidget {
  const PrintScreen({Key? key}) : super(key: key);

  @override
  State<PrintScreen> createState() => _PrintScreenState();
}

class _PrintScreenState extends State<PrintScreen> {
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
      body: Container(
        margin: const EdgeInsets.only(top: 50),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      _businessName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    const Text(
                      'asfjlfj  ',
                      style: TextStyle(fontSize: 25),
                    ),
                    const Text(
                      'Biller adddress City Country',
                      style: TextStyle(fontSize: 20),
                    ),
                    const Text(
                      'Tel: 012345678',
                      style: TextStyle(fontSize: 20),
                    ),
                    const Text(
                      'GST Reg: 123456789',
                      style: TextStyle(fontSize: 20),
                    ),
                    const Text(
                      'VAT Reg: 987654321',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                        height:
                            16.0), // Add spacing between the existing and new Text widgets
                    const Text(
                      'Additional Text 1',
                      style: TextStyle(fontSize: 20),
                    ),
                    const Text(
                      'Additional Text 2',
                      style: TextStyle(fontSize: 20),
                    ),
                    const Text(
                      'Additional Text 3',
                      style: TextStyle(fontSize: 20),
                    ),
                    const Text(
                      'Additional Text 4',
                      style: TextStyle(fontSize: 20),
                    ),
                    const Text(
                      'Additional Text 5',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
