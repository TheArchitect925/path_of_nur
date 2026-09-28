import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/app/app_router.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_providers.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_reader_playback_controller.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_reader_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/application/daily_clock_provider.dart';

import '../../../test_helpers/app_test_harness.dart';
import 'support/fake_quran_playback_feed.dart';

void main() {
  Future<void> drainReader(WidgetTester tester) async {
    // The reader schedules scroll-retry and session timers; let them run out
    // before the binding checks for pending timers.
    await tester.pumpWidget(const SizedBox.shrink());
    for (var i = 0; i < 40; i += 1) {
      await tester.pump(const Duration(milliseconds: 250));
    }
  }

  Future<void> pumpFrames(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
    await tester.pump(const Duration(milliseconds: 250));
  }

  Future<ProviderContainer> openReader(
    WidgetTester tester, {
    int surah = 1,
  }) async {
    await tester.binding.setSurfaceSize(const Size(1200, 2600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final feed = FakeQuranPlaybackFeed();
    addTearDown(feed.dispose);
    final container = await makeTestContainer(
      overrides: <Override>[
        dailyNowProvider.overrideWith(
          (ref) => Stream.value(DateTime(2026, 4, 10)),
        ),
        quranPlaybackFeedProvider.overrideWithValue(feed),
      ],
    );
    addTearDown(container.dispose);
    final router = container.read(appRouterProvider);
    await tester.pumpWidget(buildRouterTestApp(container));
    router.go('/quran/surah/$surah');
    await pumpFrames(tester);
    return container;
  }

  testWidgets(
    'the surah title opens the go-to sheet with surah and juz jumps',
    (tester) async {
      await openReader(tester);
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));

      await tester.tap(find.byKey(const ValueKey('app-page-title-tap')));
      await tester.pumpAndSettle();
      expect(find.text(l10n.quranReaderJumpSheetTitle), findsOneWidget);
      expect(
        find.byKey(const ValueKey('quran-reader-jump-surah-1')),
        findsWidgets,
      );

      // Jump to surah 2 from the surah tab.
      await tester.tap(
        find.byKey(const ValueKey('quran-reader-jump-surah-2')).first,
      );
      await tester.pumpAndSettle();
      final page = tester.widget<QuranReaderPage>(find.byType(QuranReaderPage));
      expect(page.surahNumber, 2);

      // The juz tab lists thirty entries and jumps carry an ayah target.
      await tester.tap(find.byKey(const ValueKey('app-page-title-tap')));
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10n.quranReaderJumpJuzTab).first);
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey('quran-reader-jump-juz-1')),
        findsOneWidget,
      );
      await tester.tap(find.byKey(const ValueKey('quran-reader-jump-juz-2')));
      await tester.pumpAndSettle();
      final jumped = tester.widget<QuranReaderPage>(
        find.byType(QuranReaderPage),
      );
      // Juz 2 starts at 2:142.
      expect(jumped.surahNumber, 2);
      expect(jumped.initialAyah, 142);
      await drainReader(tester);
    },
  );

  testWidgets('quick controls sit on top of the reader settings', (
    tester,
  ) async {
    final container = await openReader(tester);

    final quickRow = find.byKey(
      const ValueKey('quran-reader-quick-controls'),
      skipOffstage: false,
    );
    await tester.scrollUntilVisible(
      quickRow,
      600,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    final before = container.read(quranReaderSettingsProvider);
    await tester.tap(
      find.byKey(const ValueKey('quran-reader-quick-text-larger')),
      warnIfMissed: false,
    );
    await tester.pump();
    expect(
      container.read(quranReaderSettingsProvider).arabicScalePercent,
      before.arabicScalePercent + 10,
    );

    await tester.tap(
      find.byKey(const ValueKey('quran-reader-quick-transliteration')),
      warnIfMissed: false,
    );
    await tester.pump();
    expect(
      container.read(quranReaderSettingsProvider).showTransliteration,
      !before.showTransliteration,
    );
    await drainReader(tester);
  });

  testWidgets('the surah end offers previous and next without audio', (
    tester,
  ) async {
    await openReader(tester, surah: 2);
    expect(
      find.byKey(
        const ValueKey('quran-reader-footer-previous-surah'),
        skipOffstage: false,
      ),
      findsOneWidget,
    );
    expect(
      find.byKey(
        const ValueKey('quran-reader-footer-next-surah'),
        skipOffstage: false,
      ),
      findsOneWidget,
    );
    await drainReader(tester);
  });

  testWidgets('surah one has no previous neighbour in the footer', (
    tester,
  ) async {
    await openReader(tester);
    expect(
      find.byKey(
        const ValueKey('quran-reader-footer-previous-surah'),
        skipOffstage: false,
      ),
      findsNothing,
    );
    expect(
      find.byKey(
        const ValueKey('quran-reader-footer-next-surah'),
        skipOffstage: false,
      ),
      findsOneWidget,
    );
    await drainReader(tester);
  });

  testWidgets('ladder surahs carry the practice bridge; others do not', (
    tester,
  ) async {
    await openReader(tester, surah: 112);
    expect(
      find.byKey(
        const ValueKey('quran-reader-practice-surah-action'),
        skipOffstage: false,
      ),
      findsOneWidget,
    );
    await drainReader(tester);
  });

  testWidgets('a surah outside the ladder shows no practice bridge', (
    tester,
  ) async {
    await openReader(tester, surah: 3);
    expect(
      find.byKey(
        const ValueKey('quran-reader-practice-surah-action'),
        skipOffstage: false,
      ),
      findsNothing,
    );
    await drainReader(tester);
  });
}
