# Integration Tests

This folder contains end-to-end integration tests for the LABBY TV app.

## 📁 Structure

```
integration_test/
├── app_test.dart              # Main app flow tests (login, navigation)
├── helpers/
│   └── test_helpers.dart      # Reusable test utilities
└── README.md                  # This file
```

## 🚀 Running Tests

### Run all integration tests
```bash
flutter test integration_test
```

### Run a specific test file
```bash
flutter test integration_test/app_test.dart
```

### Run on a specific device
```bash
# On Android device/emulator
flutter test integration_test/app_test.dart -d android

# On iOS simulator
flutter test integration_test/app_test.dart -d ios

# On Chrome
flutter test integration_test/app_test.dart -d chrome
```

### Run with verbose output
```bash
flutter test integration_test/app_test.dart --verbose
```

## 📝 Current Test Coverage

### ✅ app_test.dart
- **Complete Login Flow** - First time user journey from welcome to home
- **Returning User Flow** - Auto-login for already authenticated users

### 🔜 Upcoming Tests (To be added)
- Video playback flow
- Search functionality
- Profile management
- Playlist creation
- Series navigation
- Live TV streaming

## 🎯 Test Strategy

We focus on **Critical Path Testing** - testing the main user journeys that cannot fail:

1. **Authentication** (Login/Signup/Logout)
2. **Core Features** (Video playback, Search)
3. **Navigation** (Screen transitions, Bottom nav)

## 📖 Writing New Tests

Use the `TestHelpers` class for common actions:

```dart
import 'helpers/test_helpers.dart';

testWidgets('My new test', (tester) async {
  // Log test steps
  TestHelpers.logStep('Starting test');
  
  // Perform login
  await TestHelpers.performLogin(
    tester,
    email: 'test@example.com',
    password: 'password123',
  );
  
  // Tap a button
  await TestHelpers.tapButtonByText(tester, 'Play Video');
  
  // Verify text exists
  TestHelpers.verifyTextExists('Now Playing');
  
  // Success
  TestHelpers.logSuccess('Test completed');
});
```

## 🔧 Tips

1. **Always use `pumpAndSettle()`** after actions to wait for animations
2. **Add delays** for network requests: `await tester.pumpAndSettle(Duration(seconds: 5))`
3. **Use Keys** in your widgets for easier testing: `key: Key('login_button')`
4. **Test on real devices** for accurate results
5. **Keep tests independent** - each test should work on its own

## 🐛 Troubleshooting

### Test fails with "Widget not found"
- Add more wait time: `await TestHelpers.wait(tester, seconds: 3)`
- Check if the widget actually exists in that screen
- Use `await tester.pumpAndSettle()` before finding widgets

### Test times out
- Increase timeout in the test: `timeout: Timeout(Duration(minutes: 5))`
- Check if there's an infinite loading state

### Network errors
- Make sure you have internet connection
- Check if the backend API is running
- Use mock data for faster tests (optional)

## 📊 Test Reports

After running tests, check the console output for:
- ✅ Passed tests
- ❌ Failed tests
- 📸 Screenshots (if enabled)
- ⏱️ Execution time

---

**Last Updated:** 2026-01-26
