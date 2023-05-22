import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
            ),
            onPressed: () => {
              Provider.of<Auth>(context, listen: false).logout(),
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('homepage'),
      ),
    );
  }
}
