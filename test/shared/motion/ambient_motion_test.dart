import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/shared/motion/ambient_motion.dart';
import 'package:path_of_nur/shared/motion/motion_preferences.dart';

void main() {
  group('AmbientMotion phases', () {
    test('a breath rises to full glow halfway through its four seconds', () {
      // 28 s cycle holds seven breaths: half a breath is 2/28 of the cycle.
      expect(AmbientMotion.breath(0), closeTo(0, 1e-9));
      expect(AmbientMotion.breath(2 / 28), closeTo(1, 1e-9));
      expect(AmbientMotion.breath(4 / 28), closeTo(0, 1e-9));
    });

    test('the light band restarts every seven seconds', () {
      expect(AmbientMotion.specular(0), 0);
      expect(AmbientMotion.specular(7 / 28), closeTo(0, 1e-9));
      expect(AmbientMotion.specular(3.5 / 28), closeTo(0.5, 1e-9));
    });
  });

  testWidgets('in a widget test the ticker is off and the page settles', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          effectiveReduceMotionProvider.overrideWithValue(false),
          appForegroundProvider.overrideWith((ref) => AppForegroundNotifier()),
        ],
        child: const MaterialApp(
          home: AmbientMotion(
            child: Scaffold(
              body: BreathingGlow(
                color: Colors.amber,
                child: SpecularSweep(borderRadius: 12, child: Text('hero')),
              ),
            ),
          ),
        ),
      ),
    );
    // No repeating animation: pumpAndSettle returns instead of timing out.
    await tester.pumpAndSettle();
    expect(find.text('hero'), findsOneWidget);
  });

  testWidgets('when continuous motion is allowed the cycle advances', (
    tester,
  ) async {
    Animation<double>? seen;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [continuousMotionProvider.overrideWithValue(true)],
        child: MaterialApp(
          home: AmbientMotion(
            child: Builder(
              builder: (context) {
                seen = AmbientMotion.maybeOf(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
    expect(seen, isNotNull);
    final before = seen!.value;
    await tester.pump(const Duration(seconds: 2));
    expect(seen!.value, isNot(before));
  });

  testWidgets('KindleGlow paints a glow only while active', (tester) async {
    Widget build(bool active) => ProviderScope(
      overrides: [effectiveReduceMotionProvider.overrideWithValue(false)],
      child: MaterialApp(
        home: KindleGlow(
          active: active,
          color: Colors.amber,
          child: const SizedBox(width: 40, height: 40),
        ),
      ),
    );
    await tester.pumpWidget(build(false));
    AnimatedContainer container() => tester.widget<AnimatedContainer>(
      find.descendant(
        of: find.byType(KindleGlow),
        matching: find.byType(AnimatedContainer),
      ),
    );
    expect((container().decoration as BoxDecoration).boxShadow, isEmpty);
    await tester.pumpWidget(build(true));
    await tester.pumpAndSettle();
    expect((container().decoration as BoxDecoration).boxShadow, isNotEmpty);
  });
}
