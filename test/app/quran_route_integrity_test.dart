import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/app/app_router.dart';
import 'package:path_of_nur/features/learn/quran/data/quran_repository.dart';
import 'package:path_of_nur/features/learn/presentation/pages/quran_app_hub_page.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_search_support.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_search_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_daily_companion_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_memorization_review_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_ayah_insights_paths_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_learning_paths_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_reader_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_reflections_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_surah_explorer_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_surah_insight_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_topic_explorer_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_word_review_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_words_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/application/daily_clock_provider.dart';

import '../test_helpers/app_test_harness.dart';

void main() {
  Future<void> pumpRouteFrames(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 120));
    await tester.pump(const Duration(milliseconds: 180));
  }

  Future<void> pumpReaderJumpFrames(WidgetTester tester) async {
    for (var i = 0; i < 80; i += 1) {
      await tester.pump(const Duration(milliseconds: 120));
    }
  }

  String quranSearchResultTitle({
    required int surahNumber,
    required int ayahNumber,
  }) {
    final repository = QuranRepository();
    final surah = repository.getSurahs()[surahNumber - 1];
    return '${surah.transliteratedName} $ayahNumber';
  }

  Finder ayahCardFinder({required int surahNumber, required int ayahNumber}) {
    return find.byKey(ValueKey('quran-ayah-card-$surahNumber:$ayahNumber'));
  }

  void expectAyahCardVisible(
    WidgetTester tester, {
    required int surahNumber,
    required int ayahNumber,
  }) {
    final finder = ayahCardFinder(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
    );
    expect(finder, findsOneWidget);
    final rect = tester.getRect(finder);
    final screenHeight =
        tester.view.physicalSize.height / tester.view.devicePixelRatio;
    expect(rect.bottom, greaterThan(0));
    expect(rect.top, lessThan(screenHeight));
  }

  Future<ProviderContainer> makeContainer({
    Map<String, Object> seed = const <String, Object>{},
  }) {
    return makeTestContainer(
      seed: seed,
      overrides: <Override>[
        dailyNowProvider.overrideWith(
          (ref) =>
              Stream<DateTime>.value(DateTime.parse('2026-03-14T12:00:00')),
        ),
      ],
    );
  }

  testWidgets('canonical and compatibility quran reflections routes resolve', (
    tester,
  ) async {
    final container = await makeContainer();
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    for (final path in <String>[
      '/quran/reflections',
      '/learn/quran/reflections',
    ]) {
      router.go(path);
      await pumpRouteFrames(tester);
      expect(find.byType(QuranReflectionsPage), findsOneWidget, reason: path);
      expect(tester.takeException(), isNull, reason: path);
    }
  });

  testWidgets(
    'quran reflections stays reachable by name after the hub rebuild',
    (tester) async {
      final container = await makeContainer();
      final router = container.read(appRouterProvider);

      await tester.pumpWidget(buildRouterTestApp(container));
      await pumpRouteFrames(tester);

      router.goNamed('quranReflections');
      await pumpRouteFrames(tester);

      expect(find.byType(QuranReflectionsPage), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('quran learning study hub routes load without exceptions', (
    tester,
  ) async {
    final container = await makeContainer();
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    for (final path in <String>[
      '/quran/learning?tab=reflect',
      '/learn/hub/quran/learning',
    ]) {
      router.go(path);
      await pumpRouteFrames(tester);
      expect(find.byType(QuranAppHubPage), findsOneWidget, reason: path);
      expect(tester.takeException(), isNull, reason: path);
    }
  });

  testWidgets('broader quran study routes stay directly reachable', (
    tester,
  ) async {
    final container = await makeContainer();
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    final cases = <(String, Type)>[
      // knowledge-search folded into the one Qur'an search (Phase 7a).
      ('/quran/knowledge-search', QuranSearchPage),
      ('/quran/daily', QuranDailyCompanionPage),
      (
        '/quran/insights/paths/character-adab-starter',
        QuranAyahInsightPathDetailPage,
      ),
      ('/quran/paths', QuranLearningPathsPage),
      ('/quran/paths/beginner-understanding', QuranLearningPathDetailPage),
      ('/quran/surah-insights', QuranSurahInsightsBrowsePage),
      ('/quran/topics', QuranTopicExplorerPage),
      ('/quran/topics/patience', QuranTopicExplorerPage),
      ('/quran/top-words', QuranWordsPage),
      ('/quran/word-review', QuranWordReviewPage),
      ('/quran/review', QuranMemorizationReviewPage),
    ];

    for (final (path, pageType) in cases) {
      router.go(path);
      await pumpRouteFrames(tester);
      expect(find.byType(pageType), findsOneWidget, reason: path);
      expect(tester.takeException(), isNull, reason: path);
    }
  });

  testWidgets('quran text search results open the reader at the exact ayah', (
    tester,
  ) async {
    final container = await makeContainer();
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    router.go('/quran/search');
    await pumpRouteFrames(tester);

    expect(find.byType(QuranSearchPage), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'recompense');
    await pumpRouteFrames(tester);
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(ListTile), findsWidgets);

    await tester.tap(find.byType(ListTile).first);
    await pumpRouteFrames(tester);
    await pumpReaderJumpFrames(tester);

    expect(find.byType(QuranReaderPage), findsOneWidget);
    final page = tester.widget<QuranReaderPage>(find.byType(QuranReaderPage));
    expect(page.initialAyah, 4);
    expect(page.initialSearchQuery, 'recompense');
    expect(page.initialSearchField, isNotNull);
    expectAyahCardVisible(tester, surahNumber: 1, ayahNumber: 4);
    expect(
      find.byKey(const ValueKey('quran-reader-search-pill')),
      findsOneWidget,
    );
    expect(find.text('recompense'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('quran search route supports type parameter and text mode', (
    tester,
  ) async {
    final container = await makeContainer();
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    router.go('/quran/search?q=recompense&type=text');
    await pumpRouteFrames(tester);

    expect(find.byType(QuranSearchPage), findsOneWidget);
    expect(find.text('recompense'), findsWidgets);

    await tester.tap(find.byType(ListTile).first);
    await pumpRouteFrames(tester);
    await pumpReaderJumpFrames(tester);

    expect(find.byType(QuranReaderPage), findsOneWidget);
    final page = tester.widget<QuranReaderPage>(find.byType(QuranReaderPage));
    expect(page.surahNumber, 1);
    expect(page.initialAyah, 4);
    expect(page.initialSearchQuery, 'recompense');
    expectAyahCardVisible(tester, surahNumber: 1, ayahNumber: 4);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'quran search mode switch preserves query and surah mode opens direct surah match',
    (tester) async {
      final container = await makeContainer();
      final router = container.read(appRouterProvider);

      await tester.pumpWidget(buildRouterTestApp(container));
      await pumpRouteFrames(tester);

      router.go('/quran/search');
      await pumpRouteFrames(tester);

      expect(find.byType(QuranSearchPage), findsOneWidget);
      await tester.enterText(find.byType(TextField).first, 'baqarah');
      await pumpRouteFrames(tester);

      final context = tester.element(find.byType(QuranSearchPage));
      final l10n = AppLocalizations.of(context);

      await tester.tap(find.text(l10n.quranSearchTypeSurah).first);
      await pumpRouteFrames(tester);

      expect(find.text('baqarah'), findsWidgets);
      expect(find.byType(ListTile), findsWidgets);

      await tester.tap(find.byType(ListTile).first);
      await pumpRouteFrames(tester);
      await pumpReaderJumpFrames(tester);

      expect(find.byType(QuranReaderPage), findsOneWidget);
      final page = tester.widget<QuranReaderPage>(find.byType(QuranReaderPage));
      expect(page.surahNumber, 2);
      expect(page.initialAyah, isNull);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'quran search theme mode opens theme detail without affecting knowledge search route',
    (tester) async {
      final container = await makeContainer();
      final router = container.read(appRouterProvider);

      await tester.pumpWidget(buildRouterTestApp(container));
      await pumpRouteFrames(tester);

      router.go('/quran/search?q=patience&type=theme');
      await pumpRouteFrames(tester);

      expect(find.byType(QuranSearchPage), findsOneWidget);
      expect(find.byType(ListTile), findsWidgets);

      await tester.tap(find.byType(ListTile).first);
      await pumpRouteFrames(tester);

      expect(find.byType(QuranTopicExplorerPage), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'reader route preserves search context and next match navigation',
    (tester) async {
      final container = await makeContainer();
      final router = container.read(appRouterProvider);

      await tester.pumpWidget(buildRouterTestApp(container));
      await pumpRouteFrames(tester);

      router.go('/quran/surah/1?ayah=6&search=path&searchField=translation');
      await pumpRouteFrames(tester);
      await pumpReaderJumpFrames(tester);

      expect(find.byType(QuranReaderPage), findsOneWidget);
      expect(find.text('path'), findsWidgets);
      expect(find.text('1 of 2'), findsOneWidget);
      expectAyahCardVisible(tester, surahNumber: 1, ayahNumber: 6);

      await tester.tap(
        find.byKey(const ValueKey('quran-reader-search-next-button')),
      );
      await pumpRouteFrames(tester);
      await pumpReaderJumpFrames(tester);

      expect(find.text('2 of 2'), findsOneWidget);
      expectAyahCardVisible(tester, surahNumber: 1, ayahNumber: 7);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('reader search sheet stores and shows recent searches', (
    tester,
  ) async {
    final container = await makeContainer();
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    router.go('/quran/surah/1?search=guide&searchField=translation');
    await pumpRouteFrames(tester);
    await pumpReaderJumpFrames(tester);

    await tester.tap(find.byKey(const ValueKey('quran-reader-search-pill')));
    await pumpRouteFrames(tester);

    expect(find.text('guide'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'reader search sheet shows shared suggested searches when query is empty',
    (tester) async {
      final container = await makeContainer();
      final router = container.read(appRouterProvider);
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));

      await tester.pumpWidget(buildRouterTestApp(container));
      await pumpRouteFrames(tester);

      router.go('/quran/surah/1');
      await pumpRouteFrames(tester);
      await pumpReaderJumpFrames(tester);

      await tester.tap(find.byKey(const ValueKey('quran-reader-search-pill')));
      await pumpRouteFrames(tester);

      expect(find.text(l10n.quranSuggestedSearches), findsOneWidget);
      expect(find.text('mercy'), findsWidgets);
      expect(find.text('guidance'), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('reader search sheet defaults to current surah scope', (
    tester,
  ) async {
    final container = await makeContainer();
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    router.go('/quran/surah/1');
    await pumpRouteFrames(tester);
    await pumpReaderJumpFrames(tester);

    await tester.tap(find.byKey(const ValueKey('quran-reader-search-pill')));
    await pumpRouteFrames(tester);

    expect(find.text('Current Surah'), findsOneWidget);
    expect(find.text('Whole Qur’an'), findsOneWidget);
    expect(find.text('Find matches in the current surah.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'reader search sheet whole quran mode opens exact ayah with query context',
    (tester) async {
      final container = await makeContainer();
      final router = container.read(appRouterProvider);

      await tester.pumpWidget(buildRouterTestApp(container));
      await pumpRouteFrames(tester);

      router.go('/quran/surah/2');
      await pumpRouteFrames(tester);
      await pumpReaderJumpFrames(tester);

      await tester.tap(find.byKey(const ValueKey('quran-reader-search-pill')));
      await pumpRouteFrames(tester);

      await tester.tap(find.text('Whole Qur’an'));
      await pumpRouteFrames(tester);

      await tester.enterText(find.byType(TextField).last, 'recompense');
      await pumpRouteFrames(tester);
      await tester.pump(const Duration(milliseconds: 300));

      final resultTitle = quranSearchResultTitle(surahNumber: 1, ayahNumber: 4);
      expect(find.text(resultTitle), findsWidgets);

      await tester.tap(find.text(resultTitle).first);
      await pumpRouteFrames(tester);
      await pumpReaderJumpFrames(tester);

      final page = tester.widget<QuranReaderPage>(
        find.byType(QuranReaderPage).last,
      );
      expect(page.surahNumber, 1);
      expect(page.initialAyah, 4);
      expect(page.initialSearchQuery, 'recompense');
      expect(page.initialSearchField, isNotNull);
      expectAyahCardVisible(tester, surahNumber: 1, ayahNumber: 4);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'reader search sheet current surah mode uses ayah result rows and preserves query context',
    (tester) async {
      final container = await makeContainer();
      final router = container.read(appRouterProvider);
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));

      await tester.pumpWidget(buildRouterTestApp(container));
      await pumpRouteFrames(tester);

      router.go('/quran/surah/1');
      await pumpRouteFrames(tester);
      await pumpReaderJumpFrames(tester);

      await tester.tap(find.byKey(const ValueKey('quran-reader-search-pill')));
      await pumpRouteFrames(tester);

      await tester.enterText(find.byType(TextField).last, 'recompense');
      await pumpRouteFrames(tester);
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text(l10n.quranSearchResultCountLabel(1)), findsWidgets);
      final sheetResultTiles = find.descendant(
        of: find.byType(BottomSheet),
        matching: find.byType(ListTile),
      );
      expect(sheetResultTiles, findsAtLeastNWidgets(1));

      await tester.tap(sheetResultTiles.first);
      await pumpRouteFrames(tester);
      await pumpReaderJumpFrames(tester);

      expect(find.byType(QuranReaderPage), findsOneWidget);
      expect(find.text('recompense'), findsWidgets);
      expect(find.text('1 of 1'), findsOneWidget);
      expectAyahCardVisible(tester, surahNumber: 1, ayahNumber: 4);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'reader highlights only the active translation query for father route context',
    (tester) async {
      final container = await makeContainer();
      final router = container.read(appRouterProvider);

      await tester.pumpWidget(buildRouterTestApp(container));
      await pumpRouteFrames(tester);

      router.go(
        '/quran/surah/2?ayah=233&search=father&searchField=translation',
      );
      await pumpRouteFrames(tester);
      await pumpReaderJumpFrames(tester);

      expect(find.byType(QuranReaderPage), findsOneWidget);
      final page = tester.widget<QuranReaderPage>(find.byType(QuranReaderPage));
      expect(page.initialAyah, 233);
      expect(page.initialSearchQuery, 'father');
      expect(page.initialSearchField, QuranSearchMatchField.translation);
      expect(find.text('father'), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('reader search sheet can dismiss immediately and reopen safely', (
    tester,
  ) async {
    final container = await makeContainer();
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    router.go('/quran/surah/1?search=guide&searchField=translation');
    await pumpRouteFrames(tester);
    await pumpReaderJumpFrames(tester);

    await tester.tap(find.byKey(const ValueKey('quran-reader-search-pill')));
    await tester.pump();
    await tester.tap(find.byType(ModalBarrier).first, warnIfMissed: false);
    await pumpRouteFrames(tester);

    await tester.tap(find.byKey(const ValueKey('quran-reader-search-pill')));
    await pumpRouteFrames(tester);

    expect(find.text('guide'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('quran search route preserves prefilled text query safely', (
    tester,
  ) async {
    final container = await makeContainer();
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    router.go('/quran/search?q=recompense');
    await pumpRouteFrames(tester);
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(QuranSearchPage), findsOneWidget);
    final field = tester.widget<TextField>(find.byType(TextField).first);
    expect(field.controller?.text, 'recompense');
    expect(
      find.text(quranSearchResultTitle(surahNumber: 1, ayahNumber: 4)),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'quran search empty state shows saved searches, recents, and suggestions',
    (tester) async {
      final container = await makeContainer(
        seed: <String, Object>{
          'learn.quran.recentSearches': jsonEncode(<Map<String, Object>>[
            <String, Object>{
              'query': 'father',
              'updatedAtIso': '2026-04-10T10:00:00.000Z',
              'fieldFilter': 'translation',
            },
          ]),
          'learn.quran.savedSearches': jsonEncode(<Map<String, Object>>[
            <String, Object>{
              'query': 'rahman',
              'updatedAtIso': '2026-04-10T10:00:00.000Z',
              'fieldFilter': 'transliteration',
            },
          ]),
        },
      );
      final router = container.read(appRouterProvider);
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));

      await tester.pumpWidget(buildRouterTestApp(container));
      await pumpRouteFrames(tester);

      router.go('/quran/search');
      await pumpRouteFrames(tester);

      expect(find.text(l10n.quranSavedSearches), findsOneWidget);
      expect(find.text(l10n.quranRecentSearches), findsOneWidget);
      // The header's navigation row pushes the third section below the
      // 600 px test viewport; the list builds it lazily, so scroll to it.
      await tester.scrollUntilVisible(
        find.text(l10n.quranSuggestedSearches),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text(l10n.quranSuggestedSearches), findsOneWidget);
      expect(find.text('rahman'), findsWidgets);
      expect(find.text('father'), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'quran search route preserves transliteration query and canonical result',
    (tester) async {
      final container = await makeContainer();
      final router = container.read(appRouterProvider);

      await tester.pumpWidget(buildRouterTestApp(container));
      await pumpRouteFrames(tester);

      router.go('/quran/search?q=naabudu');
      await pumpRouteFrames(tester);
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(QuranSearchPage), findsOneWidget);
      final field = tester.widget<TextField>(find.byType(TextField).first);
      expect(field.controller?.text, 'naabudu');
      expect(
        find.text(quranSearchResultTitle(surahNumber: 1, ayahNumber: 5)),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'quran search route preserves arabic query and opens the exact ayah',
    (tester) async {
      final container = await makeContainer();
      final router = container.read(appRouterProvider);

      await tester.pumpWidget(buildRouterTestApp(container));
      await pumpRouteFrames(tester);

      router.go('/quran/search?q=اهدنا');
      await pumpRouteFrames(tester);
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(QuranSearchPage), findsOneWidget);
      final field = tester.widget<TextField>(find.byType(TextField).first);
      expect(field.controller?.text, 'اهدنا');

      final resultTitle = quranSearchResultTitle(surahNumber: 1, ayahNumber: 6);
      expect(find.text(resultTitle), findsOneWidget);

      await tester.tap(find.text(resultTitle));
      await pumpRouteFrames(tester);
      await pumpReaderJumpFrames(tester);

      expect(find.byType(QuranReaderPage), findsOneWidget);
      final page = tester.widget<QuranReaderPage>(find.byType(QuranReaderPage));
      expect(page.initialAyah, 6);
      expectAyahCardVisible(tester, surahNumber: 1, ayahNumber: 6);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('quran search route preserves field filter query safely', (
    tester,
  ) async {
    final container = await makeContainer();
    final router = container.read(appRouterProvider);
    final repository = QuranRepository();
    final alBaqarah = repository.getSurahs()[1];

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    router.go('/quran/search?q=baqarah&field=surah');
    await pumpRouteFrames(tester);
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(QuranSearchPage), findsOneWidget);
    final field = tester.widget<TextField>(find.byType(TextField).first);
    expect(field.controller?.text, 'baqarah');
    expect(find.text(alBaqarah.transliteratedName), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('home search can surface canonical quran text results', (
    tester,
  ) async {
    final container = await makeContainer();
    final router = container.read(appRouterProvider);
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    router.go('/home');
    await pumpRouteFrames(tester);

    await tester.tap(find.byTooltip(l10n.homeSearchTooltip));
    await pumpRouteFrames(tester);
    await tester.enterText(find.byType(EditableText).first, 'recompense');
    await pumpRouteFrames(tester);
    await tester.pump(const Duration(milliseconds: 600));

    final resultTitle = quranSearchResultTitle(surahNumber: 1, ayahNumber: 4);
    expect(find.text(resultTitle), findsOneWidget);

    await tester.tap(find.text(resultTitle));
    await pumpRouteFrames(tester);
    await pumpReaderJumpFrames(tester);

    expect(find.byType(QuranReaderPage), findsOneWidget);
    final page = tester.widget<QuranReaderPage>(find.byType(QuranReaderPage));
    expect(page.initialAyah, 4);
    expectAyahCardVisible(tester, surahNumber: 1, ayahNumber: 4);
    expect(tester.takeException(), isNull);
  });

  testWidgets('home search can surface transliteration-backed quran results', (
    tester,
  ) async {
    final container = await makeContainer();
    final router = container.read(appRouterProvider);
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    router.go('/home');
    await pumpRouteFrames(tester);

    await tester.tap(find.byTooltip(l10n.homeSearchTooltip));
    await pumpRouteFrames(tester);
    await tester.enterText(find.byType(EditableText).first, 'naabudu');
    await pumpRouteFrames(tester);
    await tester.pump(const Duration(milliseconds: 600));

    expect(
      find.text(quranSearchResultTitle(surahNumber: 1, ayahNumber: 5)),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('home search can surface arabic-backed quran results', (
    tester,
  ) async {
    final container = await makeContainer();
    final router = container.read(appRouterProvider);
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    router.go('/home');
    await pumpRouteFrames(tester);

    await tester.tap(find.byTooltip(l10n.homeSearchTooltip));
    await pumpRouteFrames(tester);
    await tester.enterText(find.byType(EditableText).first, 'اهدنا');
    await pumpRouteFrames(tester);
    await tester.pump(const Duration(milliseconds: 600));

    expect(
      find.text(quranSearchResultTitle(surahNumber: 1, ayahNumber: 6)),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'quran hub search launcher surfaces canonical quran text results',
    (tester) async {
      final container = await makeContainer();
      final router = container.read(appRouterProvider);

      await tester.pumpWidget(buildRouterTestApp(container));
      await pumpRouteFrames(tester);

      router.go('/quran');
      await pumpRouteFrames(tester);

      // Phase 7a: the hub's search launcher card retired; search opens from
      // the title-row icon.
      await tester.tap(find.byIcon(Icons.search_rounded).first);
      await pumpRouteFrames(tester);

      await tester.enterText(find.byType(EditableText).first, 'recompense');
      await pumpRouteFrames(tester);
      await tester.pump(const Duration(milliseconds: 600));

      final resultTitle = quranSearchResultTitle(surahNumber: 1, ayahNumber: 4);
      expect(find.text(resultTitle), findsOneWidget);

      await tester.tap(find.text(resultTitle));
      await pumpRouteFrames(tester);
      await pumpReaderJumpFrames(tester);

      expect(find.byType(QuranReaderPage), findsOneWidget);
      final page = tester.widget<QuranReaderPage>(find.byType(QuranReaderPage));
      expect(page.initialAyah, 4);
      expectAyahCardVisible(tester, surahNumber: 1, ayahNumber: 4);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'quran hub search launcher surfaces transliteration-backed quran results',
    (tester) async {
      final container = await makeContainer();
      final router = container.read(appRouterProvider);

      await tester.pumpWidget(buildRouterTestApp(container));
      await pumpRouteFrames(tester);

      router.go('/quran');
      await pumpRouteFrames(tester);

      // Phase 7a: the hub's search launcher card retired; search opens from
      // the title-row icon.
      await tester.tap(find.byIcon(Icons.search_rounded).first);
      await pumpRouteFrames(tester);

      await tester.enterText(find.byType(EditableText).first, 'naabudu');
      await pumpRouteFrames(tester);
      await tester.pump(const Duration(milliseconds: 600));

      expect(
        find.text(quranSearchResultTitle(surahNumber: 1, ayahNumber: 5)),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'quran hub search launcher surfaces arabic-backed quran results',
    (tester) async {
      final container = await makeContainer();
      final router = container.read(appRouterProvider);

      await tester.pumpWidget(buildRouterTestApp(container));
      await pumpRouteFrames(tester);

      router.go('/quran');
      await pumpRouteFrames(tester);

      // Phase 7a: the hub's search launcher card retired; search opens from
      // the title-row icon.
      await tester.tap(find.byIcon(Icons.search_rounded).first);
      await pumpRouteFrames(tester);

      await tester.enterText(find.byType(EditableText).first, 'اهدنا');
      await pumpRouteFrames(tester);
      await tester.pump(const Duration(milliseconds: 600));

      expect(
        find.text(quranSearchResultTitle(surahNumber: 1, ayahNumber: 6)),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('read quran search uses canonical quran text results', (
    tester,
  ) async {
    final container = await makeContainer();
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    router.go('/quran/explorer');
    await pumpRouteFrames(tester);

    expect(find.byType(QuranSurahExplorerPage), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'recompense');
    await pumpRouteFrames(tester);
    await tester.pump(const Duration(milliseconds: 600));

    final resultTitle = quranSearchResultTitle(surahNumber: 1, ayahNumber: 4);
    expect(find.text(resultTitle), findsOneWidget);

    await tester.tap(find.text(resultTitle));
    await pumpRouteFrames(tester);
    await pumpReaderJumpFrames(tester);

    expect(find.byType(QuranReaderPage), findsOneWidget);
    final page = tester.widget<QuranReaderPage>(find.byType(QuranReaderPage));
    expect(page.initialAyah, 4);
    expectAyahCardVisible(tester, surahNumber: 1, ayahNumber: 4);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'read quran search surfaces transliteration-backed quran results',
    (tester) async {
      final container = await makeContainer();
      final router = container.read(appRouterProvider);

      await tester.pumpWidget(buildRouterTestApp(container));
      await pumpRouteFrames(tester);

      router.go('/quran/explorer');
      await pumpRouteFrames(tester);

      expect(find.byType(QuranSurahExplorerPage), findsOneWidget);

      await tester.enterText(find.byType(TextField).first, 'naabudu');
      await pumpRouteFrames(tester);
      await tester.pump(const Duration(milliseconds: 600));

      expect(
        find.text(quranSearchResultTitle(surahNumber: 1, ayahNumber: 5)),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('read quran search surfaces arabic-backed quran results', (
    tester,
  ) async {
    final container = await makeContainer();
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    router.go('/quran/explorer');
    await pumpRouteFrames(tester);

    expect(find.byType(QuranSurahExplorerPage), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'اهدنا');
    await pumpRouteFrames(tester);
    await tester.pump(const Duration(milliseconds: 600));

    expect(
      find.text(quranSearchResultTitle(surahNumber: 1, ayahNumber: 6)),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('journey-context quran reader entry remains route-safe', (
    tester,
  ) async {
    final container = await makeContainer();
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    router.go(
      '/quran/surah/9?ayah=40&journeyId=seerah-journey&stageId=seerah-hijrah&topicId=trust-in-allah',
    );
    await pumpRouteFrames(tester);
    await pumpReaderJumpFrames(tester);

    expect(find.byType(QuranReaderPage), findsOneWidget);
    final page = tester.widget<QuranReaderPage>(find.byType(QuranReaderPage));
    expect(page.initialAyah, 40);
    expect(page.learningJourneyId, 'seerah-journey');
    expect(page.learningJourneyStageId, 'seerah-hijrah');
    expect(page.highlightedTopicId, 'trust-in-allah');
    expectAyahCardVisible(tester, surahNumber: 9, ayahNumber: 40);
    expect(tester.takeException(), isNull);
  });

  testWidgets('journey context stays above surah-wide study cues', (
    tester,
  ) async {
    final container = await makeContainer();
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    router.go(
      '/quran/surah/20?ayah=14&journeyId=seerah-journey&stageId=seerah-hijrah&topicId=trust-in-allah',
    );
    await pumpRouteFrames(tester);

    final journeyContext = find.text('Journey context');
    final surahInsights = find.text('Surah themes & insights');

    expect(journeyContext, findsOneWidget);
    expect(surahInsights, findsOneWidget);
    expect(
      tester.getTopLeft(journeyContext).dy,
      lessThan(tester.getTopLeft(surahInsights).dy),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('memorization review quran reader entry remains route-safe', (
    tester,
  ) async {
    final container = await makeContainer();
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    router.go('/quran/surah/2?ayah=153&review=memorization');
    await pumpRouteFrames(tester);

    expect(find.byType(QuranReaderPage), findsOneWidget);
    final page = tester.widget<QuranReaderPage>(find.byType(QuranReaderPage));
    expect(page.initialAyah, 153);
    expect(find.text('Memorization focus'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('memorization review reader metadata query remains route-safe', (
    tester,
  ) async {
    final container = await makeContainer();
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    router.go(
      '/quran/surah/2?ayah=153&review=memorization&mode=memorization&reviewCount=3&lastReviewed=2026-03-23T00:00:00.000',
    );
    await pumpRouteFrames(tester);

    expect(find.byType(QuranReaderPage), findsOneWidget);
    expect(find.text('Memorization focus'), findsOneWidget);
    expect(find.textContaining('Reviewed 3 times'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('explicit study mode quran reader entry remains route-safe', (
    tester,
  ) async {
    final container = await makeContainer();
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    router.go('/quran/surah/18?ayah=1&mode=study');
    await pumpRouteFrames(tester);

    expect(find.byType(QuranReaderPage), findsOneWidget);
    final page = tester.widget<QuranReaderPage>(find.byType(QuranReaderPage));
    expect(page.initialAyah, 1);
    await tester.scrollUntilVisible(
      find.text('Study mode'),
      -400,
      scrollable: find.byType(Scrollable).first,
      maxScrolls: 60,
    );
    expect(find.text('Study mode'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'reader route preserves focused selection autoplay query arguments safely',
    (tester) async {
      final container = await makeContainer();
      final router = container.read(appRouterProvider);

      await tester.pumpWidget(buildRouterTestApp(container));
      await pumpRouteFrames(tester);

      router.go(
        '/quran/surah/2?ayah=255&endAyah=257&autoplay=1&playback=selectionLoop',
      );
      await pumpRouteFrames(tester);

      expect(find.byType(QuranReaderPage), findsOneWidget);
      final page = tester.widget<QuranReaderPage>(find.byType(QuranReaderPage));
      expect(page.initialAyah, 255);
      expect(page.endAyah, 257);
      expect(page.autoPlay, isTrue);
      expect(page.autoPlayFocusedSelectionLoop, isTrue);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('theme-focused quran reader entry infers theme mode safely', (
    tester,
  ) async {
    final container = await makeContainer();
    final router = container.read(appRouterProvider);

    await tester.pumpWidget(buildRouterTestApp(container));
    await pumpRouteFrames(tester);

    router.go('/quran/surah/55?topicId=gratitude');
    await pumpRouteFrames(tester);

    expect(find.byType(QuranReaderPage), findsOneWidget);
    expect(find.text('Theme mode'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'persisted reflection intent can shape default reader mode safely',
    (tester) async {
      final container = await makeContainer(
        seed: <String, Object>{
          'learn.quran.user_intent.v1': jsonEncode(<String, Object?>{
            'intent': 'reflect',
            'updatedAtIso': '2026-03-24T12:00:00.000Z',
          }),
        },
      );
      final router = container.read(appRouterProvider);

      await tester.pumpWidget(buildRouterTestApp(container));
      await pumpRouteFrames(tester);

      router.go('/quran/surah/18?ayah=1');
      await pumpRouteFrames(tester);

      expect(find.byType(QuranReaderPage), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('Reflection mode'),
        -400,
        scrollable: find.byType(Scrollable).first,
        maxScrolls: 60,
      );
      expect(find.text('Reflection mode'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
