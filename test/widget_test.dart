import 'package:flutter_test/flutter_test.dart';
import 'package:dahuku_app/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DahuKuApp());

    // Verify that the app builds without errors
    expect(find.byType(DahuKuApp), findsOneWidget);
  });
}
