import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/app/app_router.dart';
import 'package:path_of_nur/features/journey/application/growth_models.dart';
import 'package:path_of_nur/features/journey/application/growth_providers.dart';
import 'package:path_of_nur/features/journey/presentation/widgets/growth_ui_helpers.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/application/daily_clock_provider.dart';
import 'package:intl/intl.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  Future<ProviderContainer> makeJourneyContainer() {
    return makeTestContainer(
      overrides: <Override>[
        dailyNowProvider.overrideWith(
          (ref) =>
              Stream<DateTime>.value(DateTime.parse('2026-03-22T12:00:00')),
        ),
      ],
    );
  }

  Future<void> pumpRouteFrames(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 120));
    await tester.pump(const Duration(milliseconds: 180));
  }

  test('growth recurrence helper returns localized labels', () {
    Intl.defaultLocale = 'en';
    const habit = GrowthHabit(
      id: 'habit',
      title: 'Habit',
      subtitle: 'Subtitle',
      description: 'Description',
      category: GrowthHabitCategory.knowledge,
      pathIds: <String>[],
      recurrenceType: GrowthHabitRecurrenceType.customWeekdays,
      weekdays: <int>[DateTime.monday, DateTime.wednesday],
      frequencyTarget: 2,
      difficulty: 1,
      lightReward: 2,
      streakEligible: true,
      reminderEnabled: false,
      reflectionPrompt: null,
      active: true,
      muted: false,
      hidden: false,
      entrustable: false,
      entrustToAllah: false,
      sortOrder: 0,
      isCustom: false,
      stage: 1,
    );

    expect(growthCategoryLabel(habit.category), 'Knowledge');
    expect(growthRecurrenceLabel(habit), 'Weekdays: Mon, Wed');
  });

  testWidgets('growth habit detail page shows localized sections', (
    tester,
  ) async {
    final container = await makeJourneyContainer();
    final router = container.read(appRouterProvider);
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    final habitId = container.read(growthAllHabitsProvider).first.id;

    await tester.pumpWidget(buildRouterTestApp(container));
    router.go('/journey/habit/$habitId');
    await pumpRouteFrames(tester);

    expect(find.text(l10n.growthHabitTodayActionsTitle), findsOneWidget);
    expect(find.text(l10n.growthHabitSettingsSectionTitle), findsOneWidget);
  });

  testWidgets('growth detail pages show localized unavailable messages', (
    tester,
  ) async {
    final container = await makeJourneyContainer();
    final router = container.read(appRouterProvider);
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    await tester.pumpWidget(buildRouterTestApp(container));

    router.go('/journey/habit/missing-habit');
    await pumpRouteFrames(tester);
    expect(
      find.text(l10n.growthHabitUnavailableMessage),
      findsAtLeastNWidgets(1),
    );

    router.go('/journey/path/missing-path');
    await pumpRouteFrames(tester);
    expect(
      find.text(l10n.growthPathUnavailableMessage),
      findsAtLeastNWidgets(1),
    );
  });
}
