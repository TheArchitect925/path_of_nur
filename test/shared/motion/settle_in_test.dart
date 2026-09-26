import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/core/theme/app_motion.dart';
import 'package:path_of_nur/shared/motion/motion_preferences.dart';
import 'package:path_of_nur/shared/motion/settle_in.dart';

Widget _harness(Widget child, {bool reduceMotion = false}) {
  return ProviderScope(
    overrides: [effectiveReduceMotionProvider.overrideWithValue(reduceMotion)],
    child: MaterialApp(home: Scaffold(body: child)),
  );
}

/// The settle transform that wraps a card while it is arriving.
Finder _settleTransformOf(String label) => find.ancestor(
  of: find.text(label),
  matching: find.byWidgetPredicate(
    (widget) => widget is Transform && widget.transform.getTranslation().y > 0,
  ),
);

/// The opacity of the nearest fade around [label].
double _fadeOpacity(WidgetTester tester, String label) => tester
    .widget<FadeTransition>(
      find
          .ancestor(of: find.text(label), matching: find.byType(FadeTransition))
          .first,
    )
    .opacity
    .value;

void main() {
  testWidgets('only the first six cards of a page settle; the rest rest', (
    tester,
  ) async {
    await tester.pumpWidget(
      _harness(
        MotionStaggerScope(
          child: Column(
            children: [
              for (var i = 0; i < 8; i++) SettleIn(child: Text('card $i')),
            ],
          ),
        ),
      ),
    );
    // First frame: the arriving cards sit below their resting place.
    for (var i = 0; i < AppMotion.staggerLimit; i++) {
      expect(_settleTransformOf('card $i'), findsOneWidget, reason: 'card $i');
    }
    expect(_settleTransformOf('card 6'), findsNothing);
    expect(_settleTransformOf('card 7'), findsNothing);

    await tester.pumpAndSettle();
    for (var i = 0; i < 8; i++) {
      expect(_settleTransformOf('card $i'), findsNothing);
    }
  });

  testWidgets('a card inside a settling card rides its ancestor', (
    tester,
  ) async {
    await tester.pumpWidget(
      _harness(
        MotionStaggerScope(
          child: SettleIn(child: SettleIn(child: const Text('inner'))),
        ),
      ),
    );
    // One transform (the outer card's), not two.
    expect(_settleTransformOf('inner'), findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets('content marked SettleFade fades in with its card', (
    tester,
  ) async {
    await tester.pumpWidget(
      _harness(
        MotionStaggerScope(
          child: SettleIn(child: const SettleFade(child: Text('content'))),
        ),
      ),
    );
    final fade = tester.widget<FadeTransition>(
      find
          .ancestor(
            of: find.text('content'),
            matching: find.byType(FadeTransition),
          )
          .first,
    );
    expect(fade.opacity.value, 0);
    await tester.pumpAndSettle();
    // At rest the fade stays in the tree at full opacity, so the content
    // is not rebuilt when the card settles.
    expect(_fadeOpacity(tester, 'content'), 1);
  });

  testWidgets('Reduce Motion renders every card at rest', (tester) async {
    await tester.pumpWidget(
      _harness(
        reduceMotion: true,
        MotionStaggerScope(
          child: Column(
            children: [
              for (var i = 0; i < 3; i++)
                SettleIn(index: i, child: Text('card $i')),
            ],
          ),
        ),
      ),
    );
    for (var i = 0; i < 3; i++) {
      expect(_settleTransformOf('card $i'), findsNothing);
    }
  });

  testWidgets('a named slot takes its place in the sequence', (tester) async {
    await tester.pumpWidget(
      _harness(
        MotionStaggerScope(
          child: Column(
            children: [
              SettleIn(index: 0, fade: true, child: const Text('title')),
              SettleIn(child: const Text('card')),
            ],
          ),
        ),
      ),
    );
    // The card follows the title: it is still on its way when the title has
    // finished settling.
    await tester.pump(AppMotion.settleDuration);
    expect(_settleTransformOf('title'), findsNothing);
    expect(_settleTransformOf('card'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(_settleTransformOf('card'), findsNothing);
  });

  testWidgets('without a scope a card without an index is at rest', (
    tester,
  ) async {
    await tester.pumpWidget(_harness(SettleIn(child: const Text('lone'))));
    expect(_settleTransformOf('lone'), findsNothing);
  });
}
