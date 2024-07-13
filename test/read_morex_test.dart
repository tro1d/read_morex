import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:read_morex/read_morex.dart';

void main() {
  group(
    'ReadMoreX Widget Tests',
    () {
      const String content =
          'This is a very long content that should be truncated by the ReadMoreX widget. '
          'Default value is 160 if not specified. '
          'The full content should not be visible initially.';

      MaterialApp myWidget(String content) {
        return MaterialApp(
          home: Scaffold(
            body: ReadMoreX(content),
          ),
        );
      }

      testWidgets(
        'Initial content displays correctly',
        (WidgetTester tester) async {
          const String content = 'This is a short content';
          await tester.pumpWidget(myWidget(content));

          expect(find.text(content), findsOneWidget);
        },
      );

      testWidgets(
        'Long content shows read more label',
        (WidgetTester tester) async {
          await tester.pumpWidget(myWidget(content));

          expect(find.textContaining('...Read more'), findsOneWidget);
        },
      );

      testWidgets('Clicking read more expands the content', (WidgetTester tester) async {
        await tester.pumpWidget(myWidget(content));

        await tester.tap(find.textContaining('...Read more'));
        await tester.pump();

        expect(
            find.textContaining(
              'This is a very long content that should be truncated by the ReadMoreX widget.',
            ),
            findsOneWidget);
        expect(find.textContaining('Default value is 160 if not specified.'), findsOneWidget);
        expect(find.textContaining('The full content should not be visible initially.'),
            findsOneWidget);

        expect(find.text('Show less'), findsOneWidget);
      });

      testWidgets(
        'Clicking show less collapses the content',
        (WidgetTester tester) async {
          await tester.pumpWidget(myWidget(content));

          await tester.tap(find.textContaining('...Read more'));
          await tester.pump();

          expect(find.text('Show less'), findsOneWidget);

          await tester.tap(find.text('Show less'));
          await tester.pump();

          expect(find.textContaining('...Read more'), findsOneWidget);
        },
      );

      testWidgets(
        'Content updates when widget properties change',
        (WidgetTester tester) async {
          const String initialContent = 'Initial content';
          const String updatedContent = 'Updated content';

          final widget = StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return myWidget(initialContent);
            },
          );

          await tester.pumpWidget(widget);
          expect(find.text(initialContent), findsOneWidget);

          await tester.pumpWidget(myWidget(updatedContent));
          await tester.pump();

          expect(find.text(updatedContent), findsOneWidget);
        },
      );
    },
  );
}
