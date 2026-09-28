import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/journey/application/learning_path_provider.dart';
import 'package:path_of_nur/features/learn/journey/domain/learning_path_models.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_providers.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_reader_playback_controller.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_ayah.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_reader_level.dart';
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
        home: const Stack(
          children: [
            Scaffold(backgroundColor: Colors.transparent),
            QuranReaderPage(surahNumber: 1),
          ],
        ),
      ),
    );
  }

  Future<void> disposeReader(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();
  }

  testWidgets('level chip opens the sheet and applies the fluent preset', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 2600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final feed = FakeQuranPlaybackFeed();
    addTearDown(feed.dispose);

    await tester.pumpWidget(await wrapReader(feed));
    await tester.pumpAndSettle();

    final chip = find.byKey(const ValueKey('quran-reader-level-chip'));
    expect(chip, findsOneWidget);
    await tester.tap(chip);
    await tester.pumpAndSettle();

    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(find.text(l10n.quranReaderLevelSheetTitle), findsOneWidget);
    for (final level in QuranReaderLevel.values) {
      expect(
        find.byKey(ValueKey('quran-reader-level-option-${level.name}')),
        findsOneWidget,
      );
    }

    await tester.tap(
      find.byKey(const ValueKey('quran-reader-level-option-fluent')),
    );
    await tester.pumpAndSettle();

    final container = ProviderScope.containerOf(
      tester.element(find.byType(QuranReaderPage)),
    );
    final settings = container.read(quranReaderSettingsProvider);
    expect(settings.readerLevel, QuranReaderLevel.fluent);
    expect(settings.cleanReadingMode, isTrue);
    expect(container.read(quranAudioSettingsProvider).playbackSpeed, 1.0);
    // The chip now names the level.
    expect(find.text(l10n.quranReaderLevelFluentTitle), findsOneWidget);
    await disposeReader(tester);
  });

  testWidgets('fresh install announces the seeded level', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 2600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final feed = FakeQuranPlaybackFeed();
    addTearDown(feed.dispose);

    // The path level exists before the reader ever opens — the onboarding
    // order — so the post-frame seed finds it on first frame.
    SharedPreferences.setMockInitialValues(const <String, Object>{});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
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
    );
    addTearDown(container.dispose);
    container
        .read(learningPathSelectionProvider.notifier)
        .setLevel(LearningPathLevel.beginner);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Stack(
            children: [
              Scaffold(backgroundColor: Colors.transparent),
              QuranReaderPage(surahNumber: 1),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final settings = container.read(quranReaderSettingsProvider);
    expect(settings.readerLevel, QuranReaderLevel.newReader);
    expect(settings.arabicScalePercent, 130);
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    expect(
      find.text(
        l10n.quranReaderLevelSeededNote(l10n.quranReaderLevelNewReaderTitle),
      ),
      findsOneWidget,
    );
    await disposeReader(tester);
  });
}
