import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:read_morex/read_morex.dart';

void main() {
  testWidgets('ReadMoreX widget displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ReadMoreX('Example'),
      ),
    );
    expect(find.text('Example', findRichText: true), findsOneWidget);
  });
}
