import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sociallearnapp/features/notifications/services/notification_service.dart';
import 'package:sociallearnapp/features/notifications/widgets/notification_center_modal.dart';

void main() {
  testWidgets('NotificationCenterModal displays header and notification items',
      (WidgetTester tester) async {
    final notificationService = NotificationService();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<NotificationService>.value(
            value: notificationService,
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: NotificationCenterModal(),
          ),
        ),
      ),
    );

    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('New Video Lesson Added'), findsOneWidget);
    expect(find.text('Daily Goal Reminder'), findsOneWidget);
  });
}
