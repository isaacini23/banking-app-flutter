import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_banking_app/main.dart';

void main() {
  testWidgets('banking dashboard starts and shows its main navigation', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });

  testWidgets('bottom navigation opens the wallet section', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    final navigation = find.byType(BottomNavigationBar);
    final walletIcon = find.descendant(
      of: navigation,
      matching: find.byType(Icon),
    ).at(1);

    await tester.tap(walletIcon);
    await tester.pumpAndSettle();

    expect(find.text('All Cards'), findsOneWidget);
  });
}
