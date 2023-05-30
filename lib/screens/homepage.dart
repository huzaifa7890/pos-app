import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
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

  Future<void> _getAvailableBiometrics() async {
    try {
      availableBiometrics = await auth?.getAvailableBiometrics();

      if (availableBiometrics!.contains(BiometricType.strong) ||
          availableBiometrics!.contains(BiometricType.fingerprint)) {
        final bool didAuthenticate = await auth!.authenticate(
          localizedReason:
              'Unlock your screen with PIN, pattern, password, face, or fingerprint',
          options: const AuthenticationOptions(
              biometricOnly: true, stickyAuth: true),
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
    } on PlatformException catch (e) {
      // availableBiometrics = <BiometricType>[];
      print("error: $e");
    }
  }

  void deviceCapability() async {
    final bool isCapable = await auth!.canCheckBiometrics;
    isDeviceSupport = isCapable || await auth!.isDeviceSupported();
  }
}
