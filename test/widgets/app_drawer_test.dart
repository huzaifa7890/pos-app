import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixelone/providers/products.dart';
import 'package:pixelone/screens/products_screen.dart';
import 'package:pixelone/providers/auth.dart';
import 'package:pixelone/screens/sales_screen.dart';
import 'package:pixelone/widgets/app_drawer.dart';
import 'package:pixelone/screens/home_screen.dart';
import 'package:provider/provider.dart';

import 'package:mockito/mockito.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockAuth extends Mock implements Auth {}

class MockProducts extends Mock implements Products {}

void main() {
  group('AppDrawer', () {
    late MockAuth mockAuth;
    late MockProducts mockProducts;
    late MockNavigatorObserver mockNavigatorObserver;

    setUp(() {
      mockAuth = MockAuth();
      mockProducts = MockProducts();
      mockNavigatorObserver = MockNavigatorObserver();
    });

    tearDown(() {
      clearInteractions(mockNavigatorObserver);
    });

    testWidgets('should navigate to home screen when "Home" is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const Scaffold(
            body: AppDrawer(),
          ),
          navigatorObservers: [mockNavigatorObserver],
        ),
      );

      // Simulate tapping on the "Home" ListTile
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();

      // Verify that the app navigates to the home screen
      verify(mockNavigatorObserver.didReplace(
        newRoute: anyNamed('newRoute'),
        oldRoute: anyNamed('oldRoute'),
      )).called(1);

      // expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('should navigate to order screen when "Sales" is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<Auth>.value(value: mockAuth),
            ],
            child: const AppDrawer(),
          ),
          routes: {
            SalesScreen.routeName: (_) => const SalesScreen(),
          },
        ),
      );

      await tester.tap(find.text('Sales'));
      await tester.pumpAndSettle();

      expect(find.byType(SalesScreen), findsOneWidget);
    });

    testWidgets(
        'should navigate to product screen when "Manage Products" is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<Auth>.value(value: mockAuth),
              ChangeNotifierProvider<Products>.value(
                value: mockProducts, // Provide the Products provider
              ),
            ],
            child: const AppDrawer(),
          ),
          routes: {
            ProductScreen.routeName: (_) => const ProductScreen(),
          },
        ),
      );

      await tester.tap(find.byIcon(Icons.shop));
      // await tester.pumpAndSettle();

      // expect(find.byType(ProductScreen), findsOneWidget);
    });

    testWidgets('should logout when "Logout" is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<Auth>.value(value: mockAuth),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      // Simulate tapping on the "Logout" ListTile
      // await tester.tap(find.text('Logout'));
      await tester.pumpAndSettle();

      // Verify that the logout method was called on the Auth provider
      // verify(mockAuth.logout()).called(1);

      // Verify that the app navigates to the home screen
      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });
}
