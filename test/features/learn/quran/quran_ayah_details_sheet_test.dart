import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_providers.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_reader_playback_controller.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_ayah.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_reader_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/application/daily_clock_provider.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_quran_playback_feed.dart';
import 'support/fake_quran_word_timing_repository.dart';

const _ayahs = <QuranAyah>[
  QuranAyah(
    surahNumber: 1,
    ayahNumber: 1,
    arabic: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
    translation: 'In the name of Allah, the Most Merciful.',
  ),
  QuranAyah(
    surahNumber: 1,
    ayahNumber: 2,
    arabic: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
    translation: 'All praise is due to Allah, Lord of the worlds.',
  ),
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<Widget> wrapReader(FakeQuranPlaybackFeed feed) async {
    SharedPreferences.setMockInitialValues(const <String, Object>{});
    final prefs = await SharedPreferences.getInstance();
    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        dailyNowProvider.overrideWith(
          (ref) => Stream.value(DateTime(2026, 4, 10)),
        ),
        quranPlaybackFeedProvider.overrideWithValue(feed),
        quranWordTimingRepositoryProvider.overrideWithValue(
          FakeQuranWordTimingRepository(),
        ),
        quranSurahAyahsProvider(1).overrideWith((ref) async => _ayahs),
      ],
      child: MaterialApp(
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const QuranReaderPage(surahNumber: 1),
      ),
    );
  }

  Future<void> disposeReader(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();
  }

  testWidgets(
    'tapping an ayah opens the details sheet with every icon-row action',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 2600));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final feed = FakeQuranPlaybackFeed();
      addTearDown(feed.dispose);

      await tester.pumpWidget(await wrapReader(feed));
      await tester.pumpAndSettle();

      // The scroll is text-only now: no per-ayah icon row in the list.
      expect(
        find.byKey(const ValueKey('quran-ayah-sheet-bookmark')),
        findsNothing,
      );
      expect(
        find.byKey(const ValueKey('quran-reader-play-ayah-1:2')),
        findsNothing,
      );
      // The one-time hint invites the tap.
      expect(
        find.byKey(const ValueKey('quran-reader-tap-ayah-hint')),
        findsOneWidget,
      );

      await tester.tap(find.byKey(const ValueKey('quran-ayah-card-1:2')));
      await tester.pumpAndSettle();

      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      // Every action the old icon row had, plus the study stack.
      expect(
        find.byKey(const ValueKey('quran-reader-play-ayah-1:2')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('quran-ayah-sheet-bookmark')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('quran-ayah-sheet-memorize')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('quran-ayah-sheet-mistake')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('quran-ayah-sheet-note')),
        findsOneWidget,
      );
      expect(find.text(l10n.quranAyahDetailsMeaningTitle), findsOneWidget);
      // Twice when the explanation card also badges its depth.
      expect(find.text(l10n.quranAyahExplanationDetailSimple), findsWidgets);
      expect(find.text(l10n.quranAyahExplanationDetailDeep), findsWidgets);
      expect(
        find.byKey(const ValueKey('quran-ayah-sheet-reflection')),
        findsOneWidget,
      );
      // The repaired glossary glosses words of 1:2 (الحمد، لله، رب).
      expect(find.text(l10n.quranAyahDetailsWordByWordTitle), findsOneWidget);

      // Bookmarking from the sheet writes through to the provider, live.
      final container = ProviderScope.containerOf(
        tester.element(find.byType(QuranReaderPage)),
      );
      expect(container.read(quranBookmarksProvider), isEmpty);
      await tester.tap(find.byKey(const ValueKey('quran-ayah-sheet-bookmark')));
      await tester.pumpAndSettle();
      expect(container.read(quranBookmarksProvider), hasLength(1));

      // Dismiss and reopen: the hint is gone for good.
      await tester.tapAt(const Offset(600, 60));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey('quran-reader-tap-ayah-hint')),
        findsNothing,
      );
      await disposeReader(tester);
    },
  );
}
