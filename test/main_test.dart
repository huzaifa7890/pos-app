import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixelone/providers/auth.dart';
import 'package:pixelone/screens/auth_screen.dart';
import 'package:pixelone/screens/homepage.dart';
import 'package:pixelone/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:pixelone/main.dart';

void main() {
  testWidgets('Auth screen is shown when not authenticated', (WidgetTester tester) async {
    // Create a mock Auth instance with the isAuth property set to false
    final auth = Auth();
    auth.token = null; // Simulate not being authenticated

    // Wrap the AuthScreen widget with the Auth provider
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: auth,
        child: MaterialApp(
          home: AuthScreen(),
        ),
      ),
    );

    // Verify that the AuthScreen widget is rendered
    expect(find.byType(AuthScreen), findsOneWidget);
  });


  testWidgets('Home screen is shown when authenticated', (WidgetTester tester) async {
    final auth = Auth();
    auth.token = 'dummyToken'; // Set the token to simulate authentication

    // Wrap the HomeScreen widget with the Auth provider
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: auth,
        child: MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    // Verify that the HomeScreen widget is rendered
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('Splash screen is shown when waiting for auto login', (WidgetTester tester) async {
  final auth = Auth();
  auth.token = 'dummyToken';

  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: auth),
      ],
      child: MaterialApp(
        home: MyApp(),
      ),
    ),
  );

  // Ensure the SplashScreen is rendered initially
  expect(find.byType(SplashScreen), findsOneWidget);

  // Simulate the auto login process by waiting for a future
  await tester.pump();

  // Ensure the SplashScreen is still shown while waiting for auto login
  expect(find.byType(SplashScreen), findsOneWidget);
});

}
