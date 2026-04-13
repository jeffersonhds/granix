import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:granix/main.dart';

void main() {
  testWidgets('GranixApp carrega tela de login', (WidgetTester tester) async {
    await tester.pumpWidget(const GranixApp());

    expect(find.text('GRANIX'), findsOneWidget);
    expect(find.text('ENTRAR'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
  });
}
