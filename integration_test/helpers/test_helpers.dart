import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Helper class for common integration test actions
class TestHelpers {
  /// Wait for a specific duration with pump and settle
  static Future<void> wait(WidgetTester tester, {int seconds = 2}) async {
    await tester.pumpAndSettle(Duration(seconds: seconds));
  }

  /// Find and tap a button by text
  static Future<void> tapButtonByText(
    WidgetTester tester,
    String buttonText, {
    bool shouldSettle = true,
  }) async {
    final button = find.text(buttonText);
    expect(button, findsOneWidget, reason: 'Button "$buttonText" not found');
    await tester.tap(button);

    if (shouldSettle) {
      await tester.pumpAndSettle();
    }
  }

  /// Find and tap a widget by key
  static Future<void> tapByKey(
    WidgetTester tester,
    String key, {
    bool shouldSettle = true,
  }) async {
    final widget = find.byKey(Key(key));
    expect(widget, findsOneWidget, reason: 'Widget with key "$key" not found');
    await tester.tap(widget);

    if (shouldSettle) {
      await tester.pumpAndSettle();
    }
  }

  /// Enter text into a TextField by finding it by key
  static Future<void> enterTextByKey(
    WidgetTester tester,
    String key,
    String text,
  ) async {
    final textField = find.byKey(Key(key));
    expect(
      textField,
      findsOneWidget,
      reason: 'TextField with key "$key" not found',
    );
    await tester.enterText(textField, text);
    await tester.pumpAndSettle();
  }

  /// Enter text into the first TextField found
  static Future<void> enterTextInFirstField(
    WidgetTester tester,
    String text,
  ) async {
    final textField = find.byType(TextField).first;
    await tester.enterText(textField, text);
    await tester.pumpAndSettle();
  }

  /// Verify a text exists on screen
  static void verifyTextExists(String text) {
    expect(
      find.text(text),
      findsOneWidget,
      reason: 'Text "$text" not found on screen',
    );
  }

  /// Verify a text does NOT exist on screen
  static void verifyTextNotExists(String text) {
    expect(
      find.text(text),
      findsNothing,
      reason: 'Text "$text" should not be on screen',
    );
  }

  /// Scroll until a widget is visible
  static Future<void> scrollUntilVisible(
    WidgetTester tester,
    Finder finder,
    Finder scrollable, {
    double delta = 300,
  }) async {
    await tester.scrollUntilVisible(finder, delta, scrollable: scrollable);
  }

  /// Login helper - performs complete login flow
  static Future<void> performLogin(
    WidgetTester tester, {
    required String email,
    required String password,
  }) async {
    // Wait for login screen to load
    await wait(tester, seconds: 2);

    // Enter email
    final emailField = find.byType(TextField).first;
    await tester.enterText(emailField, email);
    await tester.pumpAndSettle();

    // Enter password
    final passwordField = find.byType(TextField).last;
    await tester.enterText(passwordField, password);
    await tester.pumpAndSettle();

    // Tap login button
    final loginButton = find.text('Login');
    await tester.tap(loginButton.first);
    await tester.pumpAndSettle(const Duration(seconds: 5));
  }

  /// Verify we're on home screen (by checking for bottom navigation)
  static void verifyOnHomeScreen() {
    expect(
      find.byType(BottomNavigationBar),
      findsOneWidget,
      reason: 'Should be on home screen with bottom navigation',
    );
  }

  /// Take a screenshot (for debugging)
  static Future<void> takeScreenshot(WidgetTester tester, String name) async {
    // This is a placeholder - actual screenshot implementation
    // would require additional setup
    print('📸 Screenshot: $name');
  }

  /// Print test step for better logging
  static void logStep(String step) {
    print('🔹 Test Step: $step');
  }

  /// Print test success
  static void logSuccess(String message) {
    print('✅ $message');
  }

  /// Print test info
  static void logInfo(String message) {
    print('ℹ️ $message');
  }
}
