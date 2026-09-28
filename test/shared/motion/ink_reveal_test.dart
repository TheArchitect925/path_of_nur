import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/shared/motion/ink_reveal.dart';
import 'package:path_of_nur/shared/motion/motion_preferences.dart';

void main() {
  group('InkRevealClipper', () {
    test('opens from the right for right-to-left text', () {
      const clipper = InkRevealClipper(
        fraction: 0.25,
        textDirection: TextDirection.rtl,
      );
      final rect = clipper.getClip(const Size(200, 40));
      expect(rect.left, 150);
      expect(rect.width, 50);
      // Vertical overscan so diacritics are never trimmed.
      expect(rect.top, lessThan(0));
      expect(rect.bottom, greaterThan(40));
    });

    test('opens from the left for left-to-right text', () {
      const clipper = InkRevealClipper(
        fraction: 0.25,
        textDirection: TextDirection.ltr,
      );
      final rect = clipper.getClip(const Size(200, 40));
      expect(rect.left, 0);
      expect(rect.width, 50);
    });

    test('clamps the fraction', () {
      const clipper = InkRevealClipper(
        fraction: 1.4,
        textDirection: TextDirection.ltr,
      );
      expect(clipper.getClip(const Size(100, 10)).width, 100);
    });
  });

  testWidgets('the line is clipped while revealing and whole at rest', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [effectiveReduceMotionProvider.overrideWithValue(false)],
        child: const MaterialApp(
          home: Scaffold(
            body: InkReveal(
              textDirection: TextDirection.rtl,
              child: Text('بِسْمِ اللَّهِ'),
            ),
          ),
        ),
      ),
    );
    final clip = find.descendant(
      of: find.byType(InkReveal),
      matching: find.byType(ClipRect),
    );
    expect(clip, findsOneWidget);
    InkRevealClipper clipper() =>
        tester.widget<ClipRect>(clip).clipper! as InkRevealClipper;
    expect(clipper().fraction, lessThan(1));
    await tester.pumpAndSettle();
    // The clip stays (it clips nothing at rest) so the line is not rebuilt.
    expect(clipper().fraction, 1);
    expect(find.text('بِسْمِ اللَّهِ'), findsOneWidget);
  });

  testWidgets('Reduce Motion shows the line whole at once', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [effectiveReduceMotionProvider.overrideWithValue(true)],
        child: const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                InkReveal(textDirection: TextDirection.ltr, child: Text('a')),
                FadeRise(child: Text('b')),
              ],
            ),
          ),
        ),
      ),
    );
    expect(
      find.descendant(
        of: find.byType(InkReveal),
        matching: find.byType(ClipRect),
      ),
      findsNothing,
    );
    expect(
      find.descendant(
        of: find.byType(FadeRise),
        matching: find.byType(Opacity),
      ),
      findsNothing,
    );
  });
}
