import 'package:flutter_test/flutter_test.dart';

import 'package:localingo/main.dart';

void main() {
  testWidgets('splash shows branding, then moves to onboarding', (
    tester,
  ) async {
    await tester.pumpWidget(const LocalingoApp());

    expect(find.text('LOCALINGO'), findsOneWidget);
    expect(find.text("Let's explore"), findsOneWidget);

    // Splash auto-advances after two seconds.
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('01 / TASTE'), findsOneWidget);
  });
}
