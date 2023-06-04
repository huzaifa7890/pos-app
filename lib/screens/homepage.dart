// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import '../widgets/app_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PixelOne"),
      ),
      drawer: const AppDrawer(),
      body: const Center(
        child: Text("HomePage"),
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
      // Handle the error here, e.g., display an error message or log the error
    }
  }

  void deviceCapability() async {
    final bool isCapable = await auth!.canCheckBiometrics;
    isDeviceSupport = isCapable || await auth!.isDeviceSupported();
  }
}
