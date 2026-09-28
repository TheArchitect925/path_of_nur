import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_of_nur/core/localization/locale_provider.dart';
import 'package:path_of_nur/features/learn/presentation/application/learn_discovery_providers.dart';
import 'package:path_of_nur/features/learn/presentation/data/learn_discovery_flags.dart';
import 'package:path_of_nur/features/learn/presentation/models/learn_discovery_models.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<ProviderContainer> makeContainer({Locale? locale}) async {
    SharedPreferences.setMockInitialValues(const <String, Object>{});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
    addTearDown(container.dispose);
    if (locale != null) {
      container.read(appLocaleProvider.notifier).setLocale(locale);
    }
    return container;
  }

  Map<String, String> flagsById(List<LearnDiscoveryIndexEntry> entries) {
    return <String, String>{
      for (final entry in entries)
        entry.id: [
          entry.startHere,
          entry.beginnerSafe,
          entry.difficulty.name,
          entry.contentType.name,
          entry.audience.name,
        ].join(' '),
    };
  }

  test(
    'guided paths are first-class discovery results for beginner queries',
    () async {
      final container = await makeContainer();
      final entries = container.read(learnDiscoveryIndexProvider);

      final results = searchLearnDiscoveryEntries(
        entries: entries,
        query: 'how to pray',
      );

      expect(
        results.take(5).map((result) => result.entry.id),
        contains('path:salah-starter'),
      );
    },
  );

  test('kids queries surface the kids starter path safely', () async {
    final container = await makeContainer();
    final entries = container.read(learnDiscoveryIndexProvider);

    final results = searchLearnDiscoveryEntries(
      entries: entries,
      query: 'kids arabic letters',
    );

    expect(
      results.take(5).map((result) => result.entry.id),
      contains('path:kids-starter'),
    );
    expect(
      results
          .firstWhere((result) => result.entry.id == 'path:kids-starter')
          .entry
          .audience,
      LearnDiscoveryAudience.kids,
    );
  });

  test(
    'quran discovery keeps canonical quran destinations available',
    () async {
      final container = await makeContainer();
      final entries = container.read(learnDiscoveryIndexProvider);

      final results = searchLearnDiscoveryEntries(
        entries: entries,
        query: 'quran',
      );
      final directQuranResult = results.firstWhere(
        (result) =>
            result.entry.contentType != LearnDiscoveryContentType.path &&
            result.entry.routeTarget.routeName.startsWith('quran'),
      );

      expect(
        directQuranResult.entry.routeTarget.routeName,
        anyOf(
          'quranSummaryPage',
          'quranExplorer',
          'quranLearningPaths',
          'quranDailyCompanion',
          // Arabic learning folded into Qur'an & Sunnah in Phase 4.
          'quranArabic',
        ),
      );
    },
  );

  test('path filter narrows discovery results to paths only', () async {
    final container = await makeContainer();
    final entries = container.read(learnDiscoveryIndexProvider);

    final results = searchLearnDiscoveryEntries(
      entries: entries,
      query: 'start',
      contentType: LearnDiscoveryContentType.path,
    );

    expect(results, isNotEmpty);
    expect(
      results.every(
        (result) => result.entry.contentType == LearnDiscoveryContentType.path,
      ),
      isTrue,
    );
  });

  test('bucketed discovery results do not repeat the same item', () async {
    final container = await makeContainer();
    final entries = container.read(learnDiscoveryIndexProvider);

    final results = searchLearnDiscoveryEntries(
      entries: entries,
      query: 'kids stories',
    );
    final sections = bucketLearnDiscoveryResults(
      results: results,
      allEntries: entries,
    );
    final ids = sections
        .expand((section) => section.results.map((result) => result.entry.id))
        .toList(growable: false);

    expect(ids, isNotEmpty);
    expect(ids.toSet().length, ids.length);
  });

  test(
    'curated discovery sections avoid duplicate entries across buckets',
    () async {
      final container = await makeContainer();
      final entries = container.read(learnDiscoveryIndexProvider);
      final sections = curatedLearnDiscoverySections(entries: entries);
      final ids = sections
          .expand((section) => section.results.map((result) => result.entry.id))
          .toList(growable: false);

      expect(ids, isNotEmpty);
      expect(ids.toSet().length, ids.length);
    },
  );

  test('flags come from data, so every language gets the same ones', () async {
    final english = flagsById(
      (await makeContainer()).read(learnDiscoveryIndexProvider),
    );
    for (final tag in const <String>['de', 'fr', 'ar', 'ur']) {
      final container = await makeContainer(locale: Locale(tag));
      expect(container.read(appLocaleProvider)?.languageCode, tag);
      expect(
        flagsById(container.read(learnDiscoveryIndexProvider)),
        english,
        reason: 'Learn discovery flags differ in $tag',
      );
    }
  });

  test('every flagged id names a discovery entry', () async {
    final container = await makeContainer();
    final ids = container
        .read(learnDiscoveryIndexProvider)
        .map((entry) => entry.id)
        .toSet();
    final flagged = <String>{
      ...learnDiscoveryStartHereIds,
      ...learnDiscoveryBeginnerIds,
      ...learnDiscoveryDeeperIds,
      ...learnDiscoveryToolContentTypes.keys,
    };

    expect(flagged.difference(ids), isEmpty);
  });
}
