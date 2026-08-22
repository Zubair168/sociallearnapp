import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sociallearnapp/shared/widgets/support_chip.dart';

void main() {
  testWidgets('SupportChip renders support label and responds to tap',
      (WidgetTester tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SupportChip(
            onTap: () {
              tapped = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('Support'), findsOneWidget);
    await tester.tap(find.byType(SupportChip));
    expect(tapped, isTrue);
  });
}
