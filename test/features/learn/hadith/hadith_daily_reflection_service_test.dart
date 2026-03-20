import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:path_of_nur/features/learn/hadith/application/hadith_daily_reflection_service.dart';
import 'package:path_of_nur/features/learn/hadith/application/hadith_foundation_repository.dart';
import 'package:path_of_nur/features/learn/hadith/presentation/hadith_landing_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';

void main() {
  late SharedPreferences prefs;

  setUp(() async {
    // ensure a clean in-memory prefs for every test and obtain an instance
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  ProviderContainer makeContainer() {
    return ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
  }

  test('initial controller state is empty', () {
    final container = makeContainer();
    final state = container.read(hadithDailyReflectionControllerProvider);
    expect(state.assignedDateKey, isNull);
    expect(state.assignedEntryId, isNull);
    expect(state.history, isEmpty);
    expect(state.currentStreak, 0);
    expect(state.bestStreak, 0);
  });

  test('assignTodayEntry picks an entry and persists', () {
    final container = makeContainer();
    final controller = container.read(
      hadithDailyReflectionControllerProvider.notifier,
    );
    final entries = container.read(hadithEntriesProvider);
    final now = DateTime(2026, 3, 12);

    controller.assignTodayEntry(entries, now: now);
    final state = container.read(hadithDailyReflectionControllerProvider);

    expect(state.assignedDateKey, LocalStore.todayKey(now));
    expect(state.assignedEntryId, isNotNull);
    expect(state.history.length, 1);
    expect(state.history.first.dateKey, LocalStore.todayKey(now));
    expect(state.history.first.entryId, state.assignedEntryId);
  });

  test('completeToday updates streak correctly', () {
    final container = makeContainer();
    final controller = container.read(
      hadithDailyReflectionControllerProvider.notifier,
    );
    final entries = container.read(hadithEntriesProvider);
    final now = DateTime(2026, 3, 12);

    controller.assignTodayEntry(entries, now: now);
    final added = controller.completeToday(now: now);
    expect(added, isTrue);

    final state = container.read(hadithDailyReflectionControllerProvider);
    expect(state.currentStreak, 1);
    expect(state.bestStreak, 1);
    expect(state.completedDateKeys.contains(LocalStore.todayKey(now)), isTrue);
    expect(state.lastCompletedDateKey, LocalStore.todayKey(now));
  });

  test('bundle provider does not throw when read', () {
    final container = makeContainer();

    // the provider no longer mutates state during its own build; reading should
    // complete without error.
    expect(
      () => container.read(hadithDailyReflectionBundleProvider),
      returnsNormally,
    );
  });

  testWidgets('HadithLandingPage triggers assignment and renders', (
    tester,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final overrides = [sharedPreferencesProvider.overrideWithValue(prefs)];

    await tester.pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: HadithLandingPage()),
        ),
      ),
    );

    // allow the post-frame assignment to run without waiting on unrelated
    // page animations.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // controller state should have been updated by the page
    final container = ProviderScope.containerOf(
      tester.element(find.byType(HadithLandingPage)),
    );
    final state = container.read(hadithDailyReflectionControllerProvider);
    expect(state.assignedEntryId, isNotNull);
    expect(find.text('Hadith'), findsOneWidget);
  });
}
