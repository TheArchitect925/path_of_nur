import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/shared/motion/drawn_check.dart';
import 'package:path_of_nur/shared/motion/glint_sweep.dart';
import 'package:path_of_nur/shared/motion/motion_preferences.dart';
import 'package:path_of_nur/shared/widgets/display/app_skeleton.dart';
import 'package:path_of_nur/shared/widgets/display/count_up_text.dart';

Widget _app(Widget child, {bool reduceMotion = false}) => ProviderScope(
  overrides: [effectiveReduceMotionProvider.overrideWithValue(reduceMotion)],
  child: MaterialApp(
    home: Scaffold(body: Center(child: child)),
  ),
);

void main() {
  testWidgets('DrawnCheck draws once when it turns on', (tester) async {
    Widget build(bool checked) => _app(
      DrawnCheck(
        checked: checked,
        color: Colors.green,
        emptyColor: Colors.grey,
      ),
    );
    await tester.pumpWidget(build(false));
    await tester.pumpAndSettle();
    expect(tester.binding.transientCallbackCount, 0);
    await tester.pumpWidget(build(true));
    // The draw is running…
    expect(tester.binding.transientCallbackCount, greaterThan(0));
    await tester.pumpAndSettle();
    // …and stays drawn with no ticker left.
    expect(tester.binding.transientCallbackCount, 0);
  });

  testWidgets('DrawnCheck under Reduce Motion is a state change', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        reduceMotion: true,
        const DrawnCheck(
          checked: false,
          color: Colors.green,
          emptyColor: Colors.grey,
        ),
      ),
    );
    await tester.pumpWidget(
      _app(
        reduceMotion: true,
        const DrawnCheck(
          checked: true,
          color: Colors.green,
          emptyColor: Colors.grey,
        ),
      ),
    );
    expect(tester.binding.transientCallbackCount, 0);
  });

  testWidgets('GlintSweep plays once on arrival and never repeats', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        const GlintSweep(play: true, child: SizedBox(width: 80, height: 40)),
      ),
    );
    expect(tester.binding.transientCallbackCount, greaterThan(0));
    await tester.pumpAndSettle();
    expect(tester.binding.transientCallbackCount, 0);
  });

  testWidgets('skeletons are still in a widget test and settle', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        const Column(
          children: [SkeletonCard(), SkeletonRow(), SkeletonParagraph()],
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(SkeletonBlock), findsWidgets);
  });

  testWidgets('CountUpText counts to its value', (tester) async {
    await tester.pumpWidget(_app(const CountUpText(133)));
    expect(find.text('133'), findsNothing);
    await tester.pumpAndSettle();
    expect(find.text('133'), findsOneWidget);
  });

  testWidgets('CountUpText under Reduce Motion shows the value at once', (
    tester,
  ) async {
    await tester.pumpWidget(_app(reduceMotion: true, const CountUpText(133)));
    expect(find.text('133'), findsOneWidget);
  });
}
