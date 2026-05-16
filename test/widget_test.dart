import 'package:flutter_test/flutter_test.dart';
import 'package:push_notification_lab/main.dart';

void main() {
  testWidgets('App renders Push Notification Lab title', (WidgetTester tester) async {
    await tester.pumpWidget(const PushNotificationLabApp());
    expect(find.text('Push Notification Lab'), findsOneWidget);
  });
}
