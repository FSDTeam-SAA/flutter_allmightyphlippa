import 'package:flutter_almightyflippa/features/app/screens/app_decision_screen.dart';
import 'package:flutter_almightyflippa/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  testWidgets("Inital test flow", (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.byType(AppDecisionScreen), findsOneWidget);
  });
}