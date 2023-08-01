import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pixelone/model/homepageitems.dart';
import 'package:pixelone/widgets/homepageitems.dart';
import 'package:provider/provider.dart';
import 'package:pixelone/providers/auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isDeviceSupport = false;
  List<BiometricType>? availableBiometrics;
  LocalAuthentication? auth;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // auth = LocalAuthentication();

    // deviceCapability();
    // _getAvailableBiometrics();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/');
        break;
      case 1:
        Navigator.pushNamed(context, '/Setting');
        break;
      default:
        break;
    }
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
        actions: const [
          LogoutButton(),
        ],
        title: const Text("Home"),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.9,
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  // Future<void> _getAvailableBiometrics() async {
  //   try {
  //     availableBiometrics = await auth?.getAvailableBiometrics();

  //     if (availableBiometrics!.contains(BiometricType.strong) ||
  //         availableBiometrics!.contains(BiometricType.fingerprint)) {
  //       final bool didAuthenticate = await auth!.authenticate(
  //         localizedReason:
  //             'Unlock your screen with PIN, pattern, password, face, or fingerprint',
  //         options: const AuthenticationOptions(
  //           biometricOnly: true,
  //           stickyAuth: true,
  //         ),
  //       );
  //       if (!didAuthenticate) {}
  //     } else if (availableBiometrics!.contains(BiometricType.weak) ||
  //         availableBiometrics!.contains(BiometricType.face)) {
  //       final bool didAuthenticate = await auth!.authenticate(
  //         localizedReason:
  //             'Unlock your screen with PIN, pattern, password, face, or fingerprint',
  //         options: const AuthenticationOptions(stickyAuth: true),
  //       );
  //       if (!didAuthenticate) {}
  //     }
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // void deviceCapability() async {
  //   final bool isCapable = await auth!.canCheckBiometrics;
  //   isDeviceSupport = isCapable || await auth!.isDeviceSupported();
  // }

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
      case 3:
        Navigator.pushNamed(context, '/Orders');
        break;
      case 4:
        Navigator.pushNamed(context, '/ExtraScreen');
        break;
      default:
        break;
    }
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.logout),
      onPressed: () {
        Navigator.of(context).pop;
        Navigator.of(context).pushReplacementNamed('/');
        Provider.of<Auth>(context, listen: false).logout();
      },
    );
  }
}
