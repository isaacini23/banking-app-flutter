import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_banking_app/main.dart';

void main() {
  testWidgets('banking dashboard starts and shows its main navigation', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.byIcon(Icons.home), findsNothing);
  });

  testWidgets('bottom navigation switches between app sections', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    final navigation = find.byType(BottomNavigationBar);
    expect(navigation, findsOneWidget);

    await tester.tap(find.descendant(
      of: navigation,
      matching: find.byIcon(Icons.wallet),
    ));
    await tester.pumpAndSettle();

    expect(find.text('All Cards'), findsOneWidget);
  });
}
