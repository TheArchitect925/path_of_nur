import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/shared/widgets/app_transient_feedback.dart';

void main() {
  testWidgets('showSuccess renders the success overlay styling', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: FilledButton(
                onPressed: () => AppTransientFeedback.showSuccess(
                  context,
                  'Saved successfully',
                ),
                child: const Text('Show'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show'));
    await tester.pump();

    expect(find.text('Saved successfully'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);

    final decoratedBox = tester.widget<DecoratedBox>(
      find
          .ancestor(
            of: find.text('Saved successfully'),
            matching: find.byType(DecoratedBox),
          )
          .first,
    );
    final decoration = decoratedBox.decoration as BoxDecoration;
    expect(decoration.color, const Color(0xFF1F6F53));

    await tester.pump(const Duration(seconds: 3));
    expect(find.text('Saved successfully'), findsNothing);
  });

  testWidgets('showWarning renders the warning overlay styling', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: FilledButton(
                onPressed: () => AppTransientFeedback.showWarning(
                  context,
                  'Review needed',
                ),
                child: const Text('Warn'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Warn'));
    await tester.pump();

    expect(find.text('Review needed'), findsOneWidget);
    expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);

    final decoratedBox = tester.widget<DecoratedBox>(
      find
          .ancestor(
            of: find.text('Review needed'),
            matching: find.byType(DecoratedBox),
          )
          .first,
    );
    final decoration = decoratedBox.decoration as BoxDecoration;
    expect(decoration.color, const Color(0xFF8A5A12));

    await tester.pump(const Duration(seconds: 3));
    expect(find.text('Review needed'), findsNothing);
  });
}
