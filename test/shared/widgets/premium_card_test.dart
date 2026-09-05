import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/core/theme/app_radii.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:path_of_nur/shared/widgets/app_layered_section_glass_card.dart';
import 'package:path_of_nur/shared/widgets/premium_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Widget> _wrap(Widget child) async {
  SharedPreferences.setMockInitialValues(const <String, Object>{});
  final prefs = await SharedPreferences.getInstance();
  return ProviderScope(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    child: MaterialApp(
      home: Scaffold(body: Center(child: child)),
    ),
  );
}

void main() {
  testWidgets('default density keeps the classic 36px glass radius', (
    tester,
  ) async {
    await tester.pumpWidget(
      await _wrap(const PremiumCard(child: Text('content'))),
    );

    final glass = tester.widget<AppLayeredSectionGlassCard>(
      find.byType(AppLayeredSectionGlassCard),
    );
    expect(glass.outerRadius, AppRadii.glassCard);
    expect(
      glass.contentPadding,
      const EdgeInsets.symmetric(horizontal: 28, vertical: 30),
    );
    expect(find.text('content'), findsOneWidget);
  });

  testWidgets('compact and tile densities shrink radius and padding', (
    tester,
  ) async {
    await tester.pumpWidget(
      await _wrap(
        const Column(
          children: [
            PremiumCard(
              density: PremiumCardDensity.compact,
              child: Text('compact'),
            ),
            PremiumCard(density: PremiumCardDensity.tile, child: Text('tile')),
          ],
        ),
      ),
    );

    final cards = tester
        .widgetList<AppLayeredSectionGlassCard>(
          find.byType(AppLayeredSectionGlassCard),
        )
        .toList();
    expect(cards[0].outerRadius, AppRadii.glassCompact);
    expect(cards[1].outerRadius, AppRadii.glassTile);
    expect(
      cards[1].contentPadding,
      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  });

  testWidgets('explicit padding wins over density default', (tester) async {
    await tester.pumpWidget(
      await _wrap(
        const PremiumCard(
          density: PremiumCardDensity.tile,
          padding: EdgeInsets.all(3),
          child: Text('padded'),
        ),
      ),
    );

    final glass = tester.widget<AppLayeredSectionGlassCard>(
      find.byType(AppLayeredSectionGlassCard),
    );
    expect(glass.contentPadding, const EdgeInsets.all(3));
  });

  testWidgets('onTap fires and header slots render', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      await _wrap(
        PremiumCard(
          onTap: () => taps++,
          leading: const Icon(Icons.star),
          title: const Text('Header title'),
          trailing: const Icon(Icons.chevron_right),
          child: const Text('body'),
        ),
      ),
    );

    expect(find.text('Header title'), findsOneWidget);
    expect(find.byIcon(Icons.star), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    expect(find.text('body'), findsOneWidget);

    await tester.tap(find.text('body'));
    expect(taps, 1);
  });

  testWidgets('card without header renders child directly', (tester) async {
    await tester.pumpWidget(
      await _wrap(const PremiumCard(child: Text('solo'))),
    );
    expect(find.text('solo'), findsOneWidget);
    // No header row scaffolding should exist.
    expect(find.byType(Spacer), findsNothing);
  });
}
