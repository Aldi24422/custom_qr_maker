import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:custom_qr_maker/providers/qr_provider.dart';
import 'package:custom_qr_maker/screens/home_screen.dart';

void main() {
  group('HomeScreen Widget Tests', () {
    /// Helper function to build the widget tree with provider
    Widget buildTestableWidget({QrProvider? provider}) {
      return MaterialApp(
        home: ChangeNotifierProvider<QrProvider>(
          create: (_) => provider ?? QrProvider(),
          child: const HomeScreen(),
        ),
      );
    }

    group('Rendering', () {
      testWidgets('should display app title', (WidgetTester tester) async {
        await tester.pumpWidget(buildTestableWidget());
        await tester.pumpAndSettle();

        expect(find.text('QR Code Styler'), findsOneWidget);
      });

      testWidgets('should display AppBar', (WidgetTester tester) async {
        await tester.pumpWidget(buildTestableWidget());
        await tester.pumpAndSettle();

        expect(find.byType(AppBar), findsOneWidget);
      });

      testWidgets('should display Preview section', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(buildTestableWidget());
        await tester.pumpAndSettle();

        expect(find.text('Preview'), findsOneWidget);
      });

      testWidgets('should display Data and Styling tabs', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(buildTestableWidget());
        await tester.pumpAndSettle();

        expect(find.text('Data'), findsOneWidget);
        expect(find.text('Styling'), findsOneWidget);
      });

      testWidgets('should display URL/Link tab', (WidgetTester tester) async {
        await tester.pumpWidget(buildTestableWidget());
        await tester.pumpAndSettle();

        expect(find.text('URL/Link'), findsOneWidget);
      });

      testWidgets('should display reset button', (WidgetTester tester) async {
        await tester.pumpWidget(buildTestableWidget());
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.refresh_rounded), findsOneWidget);
      });
    });

    group('UI Structure', () {
      testWidgets('should have TextFormField for input', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(buildTestableWidget());
        await tester.pumpAndSettle();

        expect(find.byType(TextFormField), findsWidgets);
      });

      testWidgets('should have TabBar', (WidgetTester tester) async {
        await tester.pumpWidget(buildTestableWidget());
        await tester.pumpAndSettle();

        expect(find.byType(TabBar), findsWidgets);
      });

      testWidgets('should have scrollable content', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(buildTestableWidget());
        await tester.pumpAndSettle();

        expect(find.byType(Scrollable), findsWidgets);
      });
    });

    group('Provider Integration', () {
      testWidgets('provider starts with empty content', (
        WidgetTester tester,
      ) async {
        final provider = QrProvider();

        await tester.pumpWidget(buildTestableWidget(provider: provider));
        await tester.pumpAndSettle();

        expect(provider.data.content, isEmpty);
      });

      testWidgets('provider state is reflected', (WidgetTester tester) async {
        final provider = QrProvider();
        provider.updateContent('Pre-set content');

        await tester.pumpWidget(buildTestableWidget(provider: provider));
        await tester.pumpAndSettle();

        expect(provider.data.content, 'Pre-set content');
      });
    });

    group('Empty State', () {
      testWidgets('should show empty state message', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(buildTestableWidget());
        await tester.pumpAndSettle();

        expect(find.textContaining('Masukkan data'), findsOneWidget);
      });
    });
  });
}
