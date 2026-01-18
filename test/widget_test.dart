import 'package:flutter_test/flutter_test.dart';

import 'package:cozygame/main.dart';

void main() {
  testWidgets('App loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CozyCourierApp());

    // Verify the app widget loaded
    expect(find.byType(CozyCourierApp), findsOneWidget);
  });
}
