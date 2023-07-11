import 'package:flutter/material.dart';
import 'package:pixelone/providers/auth.dart';
import 'package:pixelone/providers/cart.dart';
import 'package:pixelone/providers/orders.dart';
import 'package:pixelone/providers/products.dart';
import 'package:pixelone/screens/add_new_orders.dart';
import 'package:pixelone/screens/add_new_products.dart';
import 'package:pixelone/screens/home_screen.dart';
import 'package:pixelone/screens/order_screen.dart';
import 'package:pixelone/screens/product_detail_screen.dart';
import 'package:pixelone/screens/sales_screen.dart';
import 'package:pixelone/screens/products_screen.dart';
import 'package:pixelone/screens/settings_screen.dart';
import 'package:pixelone/screens/splash_screen.dart';
import 'package:pixelone/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:pixelone/screens/auth_screen.dart';
import 'utils/pallete.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Orders(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          themeMode: ThemeMode.system,
          debugShowCheckedModeBanner: false,
          title: 'Pixelone',
          theme: ThemeData(
            primarySwatch: Palette.primaryPaletteColor,
            textSelectionTheme: const TextSelectionThemeData(
              cursorColor: primaryColor,
              selectionColor: primaryColor,
              selectionHandleColor: primaryColor,
            ),
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
          routes: {
            '/Products': (context) => const ProductScreen(),
            '/Purchase': (context) => const SalesScreen(),
            '/Sales': (context) => const SalesScreen(),
            '/Orders': (context) => const OrderScreen(),
            '/Setting': (context) => const SettingScreen(),
            ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
            AddNewProducts.routeName: (ctx) => const AddNewProducts(),
            AddNewOders.routeName: (context) => const AddNewOders(),
          },
        ),
      ),
    );
  }
}
