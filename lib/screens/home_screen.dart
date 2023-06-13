import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pixelone/model/homepageitems.dart';
import 'package:pixelone/widgets/app_drawer.dart';
import 'package:pixelone/widgets/homepageitems.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const routeName = '/';

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isDeviceSupport = false;
  List<BiometricType>? availableBiometrics;
  LocalAuthentication? auth;

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();

    deviceCapability();
    _getAvailableBiometrics();
  }

  final List<ItemsData> items = [
    ItemsData(title: 'Products', imagePath: 'assets/images/products.png'),
    ItemsData(title: 'Purchase', imagePath: 'assets/images/purchase.png'),
    ItemsData(title: 'Sales', imagePath: 'assets/images/sales.png'),
    ItemsData(title: 'Profits', imagePath: 'assets/images/profit.png'),
    ItemsData(title: 'Reports', imagePath: 'assets/images/reports.png'),
    ItemsData(title: 'Stocks', imagePath: 'assets/images/profit.png'),
    ItemsData(title: 'Expense', imagePath: 'assets/images/expense.png'),
    ItemsData(title: 'Due List', imagePath: 'assets/images/duelist.png'),
    ItemsData(title: 'Parties', imagePath: 'assets/images/sales.png'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      drawer: const AppDrawer(),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.7,
          crossAxisSpacing: 5,
          mainAxisSpacing: 2,
        ),
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              navigateToBoxPage(context, index);
            },
            child: HomePageItems(
              title: items[index].title,
              imagePath: items[index].imagePath,
            ),
          );
        },
      ),
    );
  }

  Future<void> _getAvailableBiometrics() async {
    try {
      availableBiometrics = await auth?.getAvailableBiometrics();

      if (availableBiometrics!.contains(BiometricType.strong) ||
          availableBiometrics!.contains(BiometricType.fingerprint)) {
        final bool didAuthenticate = await auth!.authenticate(
          localizedReason:
              'Unlock your screen with PIN, pattern, password, face, or fingerprint',
          options: const AuthenticationOptions(
            biometricOnly: true,
            stickyAuth: true,
          ),
        );
        if (!didAuthenticate) {}
      } else if (availableBiometrics!.contains(BiometricType.weak) ||
          availableBiometrics!.contains(BiometricType.face)) {
        final bool didAuthenticate = await auth!.authenticate(
          localizedReason:
              'Unlock your screen with PIN, pattern, password, face, or fingerprint',
          options: const AuthenticationOptions(stickyAuth: true),
        );
        if (!didAuthenticate) {}
      }
    } catch (e) {
      rethrow;
    }
  }

  void deviceCapability() async {
    final bool isCapable = await auth!.canCheckBiometrics;
    isDeviceSupport = isCapable || await auth!.isDeviceSupported();
  }

  void navigateToBoxPage(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/Products');
        break;
      case 1:
        Navigator.pushNamed(context, '/Purchase');
        break;
      case 2:
        Navigator.pushNamed(context, '/Sales');
        break;
      // Add more cases for other boxes
      default:
        break;
    }
  }
}
