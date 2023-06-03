import 'package:flutter/material.dart';

class AddNewOders extends StatelessWidget {
  static const routeName = '/new-order';
  const AddNewOders({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Order'),
      ),
      body: Column(
        children: [
          Card(
            child: Text("data"),
          )
        ],
      ),
    );
  }
}
