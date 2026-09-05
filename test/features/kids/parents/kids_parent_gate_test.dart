import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/kids/parents/application/kids_parent_gate_provider.dart';
import 'package:path_of_nur/features/kids/parents/presentation/kids_parent_gate.dart';
import 'package:path_of_nur/features/kids/rewards/application/kids_reward_world_provider.dart';
import 'package:path_of_nur/features/profile/application/profile_settings_provider.dart';
import 'package:path_of_nur/features/profile/domain/profile_age_preferences.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';

import '../../../test_helpers/app_test_harness.dart';

/// K5: while the kids UI is active a parent page sits behind "Grown-ups
/// only"; holding the button opens it, letting go early does not, and an
/// adult profile never meets the gate.
void main() {
  final now = DateTime(2026, 9, 5, 9);

  test('the gate opens for a while and then closes on its own', () {
    final controller = KidsParentGateController();
    expect(controller.state.isOpenAt(now), isFalse);
    controller.unlock(now);
    expect(controller.state.isOpenAt(now), isTrue);
    expect(
      controller.state.isOpenAt(now.add(const Duration(minutes: 9))),
      isTrue,
    );
    expect(
      controller.state.isOpenAt(now.add(const Duration(minutes: 11))),
      isFalse,
    );
    controller.lock();
    expect(controller.state.isOpenAt(now), isFalse);
  });

  Future<ProviderContainer> pumpGate(
    WidgetTester tester, {
    required bool kidsUi,
  }) async {
    final container = await makeTestContainer(
      overrides: [kidsRewardNowProvider.overrideWithValue(() => now)],
    );
    addTearDown(container.dispose);
    container
        .read(profileSettingsProvider.notifier)
        .setKidsUiThemeMode(kidsUi ? KidsUiThemeMode.on : KidsUiThemeMode.off);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: KidsParentGate(child: Scaffold(body: Text('parent page'))),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    return container;
  }

  testWidgets('an adult profile goes straight through', (tester) async {
    await pumpGate(tester, kidsUi: false);
    expect(find.text('parent page'), findsOneWidget);
  });

  testWidgets('in the kids UI the page waits behind a held button', (
    tester,
  ) async {
    final container = await pumpGate(tester, kidsUi: true);
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l10n.kidsParentGateTitle), findsOneWidget);
    expect(find.text('parent page'), findsNothing);

    // Letting go early winds the hold back and keeps the gate shut.
    final button = find.text(l10n.kidsParentGateHoldAction);
    // The first frame after a pointer lands only starts the hold's clock.
    final tapEarly = await tester.startGesture(tester.getCenter(button));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tapEarly.up();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('parent page'), findsNothing);
    expect(container.read(kidsParentGateProvider).isOpenAt(now), isFalse);

    // Holding long enough opens it.
    final hold = await tester.startGesture(tester.getCenter(button));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1600));
    await hold.up();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('parent page'), findsOneWidget);
    expect(container.read(kidsParentGateProvider).isOpenAt(now), isTrue);
  });
}
