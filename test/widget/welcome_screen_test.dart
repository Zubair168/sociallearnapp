import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sociallearnapp/features/welcome/screens/welcome_screen.dart';

void main() {
  testWidgets('WelcomeScreen renders headline, roles, and continue button',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: WelcomeScreen(),
      ),
    );

    // Initial role selection view
    expect(find.byType(WelcomeScreen), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
    expect(find.text('Lets get to know you'), findsOneWidget);
    expect(find.text('I am Student preparing for YKS'), findsOneWidget);

    // Tap Continue to show login/signup role panel
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Signup'), findsOneWidget);
  });
}
