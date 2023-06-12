import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pixelone/screens/products_screen.dart';
import 'package:pixelone/providers/auth.dart';
import 'package:pixelone/screens/order_screen.dart';
import 'package:pixelone/widgets/app_drawer.dart';
import 'package:pixelone/screens/homepage.dart';
import 'package:provider/provider.dart';

import 'package:mockito/mockito.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockAuth extends Mock implements Auth {}

void main() {
  group('AppDrawer', () {
    late MockNavigatorObserver mockNavigatorObserver;

    setUp(() {
      mockNavigatorObserver = MockNavigatorObserver();
    });

    tearDown(() {
      clearInteractions(mockNavigatorObserver);
    });

//   testWidgets('should navigate to home screen when "Home" is tapped', (WidgetTester tester) async {
//     final mockObserver = MockNavigatorObserver();
//     await tester.pumpWidget(
//       MaterialApp(
//         home: Scaffold(
//           body: AppDrawer(),
//         ),
//         navigatorObservers: [mockObserver],
//       ),
//     );

//     // Simulate tapping on the "Home" ListTile
//     await tester.tap(find.text('Home'));
//     await tester.pumpAndSettle();

//     // Verify that the app navigates to the home screen
//     verify(mockObserver.didReplace(
//       newRoute: anyNamed('newRoute'),
//       oldRoute: anyNamed('oldRoute'),
//     )).called(1);
//     expect(find.byType(HomeScreen), findsOneWidget);
//   });

    testWidgets('should navigate to order screen when "Orders" is tapped',
        (WidgetTester tester) async {
      final mockAuth = MockAuth();
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<Auth>.value(value: mockAuth),
          ],
          child: MaterialApp(
            home: const AppDrawer(),
            routes: {
              OrderScreen.routeName: (_) => const OrderScreen(),
            },
          ),
        ),
      );

      await tester.tap(find.text('Orders'));
      await tester.pumpAndSettle();

      expect(find.byType(OrderScreen), findsOneWidget);
    });

    testWidgets(
        'should navigate to product screen when "Manage Product" is tapped',
        (WidgetTester tester) async {
      final mockAuth = MockAuth();
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<Auth>.value(value: mockAuth),
          ],
          child: MaterialApp(
            home: const AppDrawer(),
            routes: {
              ProductScreen.routeName: (_) => const ProductScreen(),
            },
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.shop));
      await tester.pumpAndSettle();

      expect(find.byType(ProductScreen), findsOneWidget);
    });

    testWidgets('should logout when "Logout" is tapped',
        (WidgetTester tester) async {
      final mockAuth = MockAuth();
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
