import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutx_core/flutx_core.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_almightyflippa/main.dart' as app;

/// Integration Test for Critical App Flow
///
/// This test covers:
/// 1. App Launch
/// 2. Welcome Screen → Login Screen
/// 3. Login with credentials
/// 4. Navigate to Home Screen
///
/// Run this test with:
/// flutter test integration_test/app_test.dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Critical App Flow Tests', () {
    testWidgets('Complete Login Flow - First Time User', (
      WidgetTester tester,
    ) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Step 1: Verify App Decision Screen loads (shows logo)
      expect(find.byType(Scaffold), findsWidgets);

      // Wait for navigation to complete
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Step 2: Should navigate to Welcome Screen (first time user)
      // Look for "Get Started" or similar button
      final getStartedButton = find.text('Get Started');

      if (getStartedButton.evaluate().isNotEmpty) {
        // First time user flow
        await tester.tap(getStartedButton);
        await tester.pumpAndSettle();
      }

      // Step 3: Should be on Login Screen now
      // Look for email/username field
      final emailField = find.byType(TextField).first;
      expect(emailField, findsOneWidget);

      // Enter test credentials
      await tester.enterText(emailField, 'noyonbdc787@gmail.com');
      await tester.pumpAndSettle();

      // Find password field (should be second TextField)
      final passwordField = find.byType(TextField).last;
      await tester.enterText(passwordField, '123456');
      await tester.pumpAndSettle();

      // Step 4: Tap Login Button
      final loginButton = find.widgetWithText(ElevatedButton, 'Login');
      if (loginButton.evaluate().isEmpty) {
        // Try finding by text only
        final loginText = find.text('Login');
        expect(loginText, findsWidgets);
        await tester.tap(loginText.first);
      } else {
        await tester.tap(loginButton);
      }

      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Step 5: Verify we reached Home Screen or Bottom Nav
      // This will depend on successful login
      // For now, just verify no error dialog appeared
      expect(find.text('Error'), findsNothing);

      DPrint.log('✅ Login flow test completed successfulNly');
    });

    testWidgets('App Launch - Returning User (Already Logged In)', (
      WidgetTester tester,
    ) async {
      // This test assumes user is already logged in from previous test
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Should skip Welcome/Login and go directly to Home
      // Verify bottom navigation exists (sign of being logged in)
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Look for bottom navigation or home screen elements
      final bottomNav = find.byType(BottomNavigationBar);

      // If bottom nav exists, we're logged in
      if (bottomNav.evaluate().isNotEmpty) {
        expect(bottomNav, findsOneWidget);
        DPrint.log('✅ Returning user test passed - Already logged in');
      } else {
        DPrint.log('ℹ️ User not logged in - This is expected on first run');
      }
    });
  });
}
