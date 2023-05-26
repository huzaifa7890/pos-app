import 'package:flutter/material.dart';
import 'package:pixelone/providers/auth.dart';
import 'package:pixelone/screens/homepage.dart';
import 'package:pixelone/screens/splash_screen.dart';

import 'package:provider/provider.dart';
import './screens/auth_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Pixelone',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: auth.isAuth
              ? const HomeScreen()
              : FutureBuilder(
                  future: auth.tryautoLogin(),
                  builder: (ctx, i) =>
                      i.connectionState == ConnectionState.waiting
                          ? const SplashScreen()
                          : const AuthScreen(),
                ),
        ),
      ),
    );
  }
}
