// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:custom_qr_maker/main.dart';
import 'package:custom_qr_maker/providers/qr_provider.dart';

void main() {
  testWidgets('QR Maker app smoke test', (WidgetTester tester) async {
    // Build app with provider
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => QrProvider(),
        child: const QrMakerApp(),
      ),
    );

    // Verify app title is displayed
    expect(find.text('QR Code Styler'), findsOneWidget);

    // Verify tabs exist
    expect(find.text('Data'), findsOneWidget);
    expect(find.text('Styling'), findsOneWidget);
  });
}
