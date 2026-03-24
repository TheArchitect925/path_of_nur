import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/learn/quran_teaching/application/quran_teaching_audio_playback_service.dart';
import 'package:path_of_nur/features/learn/quran_teaching/application/quran_teaching_controller.dart';
import 'package:path_of_nur/features/learn/quran_teaching/domain/quran_teaching_models.dart';
import 'package:path_of_nur/features/learn/quran_teaching/presentation/quran_teaching_beginner_words_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';

import '../../../test_helpers/app_test_harness.dart';

class _FakeQuranTeachingAudioPlaybackService
    extends QuranTeachingAudioPlaybackService {
  final List<String> playedCueIds = <String>[];

  @override
  Future<bool> playCue(QuranAudioCue cue) async {
    playedCueIds.add(cue.id);
    return true;
  }

  @override
  Future<void> dispose() async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<ProviderContainer> pumpBeginnerWordsPage(
    WidgetTester tester, {
    List<Override> overrides = const <Override>[],
    String? initialWordId,
  }) async {
    final container = await makeTestContainer(overrides: overrides);
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: Scaffold(
            body: QuranTeachingBeginnerWordsPage(initialWordId: initialWordId),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    return container;
  }

  testWidgets(
    'adult beginner words page shows shared word guidance and plays audio for supported word',
    (tester) async {
      final audio = _FakeQuranTeachingAudioPlaybackService();
      await pumpBeginnerWordsPage(
        tester,
        overrides: <Override>[
          quranTeachingAudioPlaybackServiceProvider.overrideWithValue(audio),
        ],
        initialWordId: 'noor',
      );

      final l10n = AppLocalizations.of(
        tester.element(find.byType(QuranTeachingBeginnerWordsPage)),
      );

      expect(find.text(l10n.quranTeachingBeginnerWordsTitle), findsOneWidget);
      expect(find.text('نُور'), findsOneWidget);
      expect(find.text('Noor'), findsWidgets);
      expect(
        find.text(l10n.quranTeachingBeginnerWordsJoinedLettersTitle),
        findsOneWidget,
      );
      expect(
        find.text(l10n.quranTeachingBeginnerWordsReadingHelperTitle),
        findsOneWidget,
      );

      await tester.tap(
        find.byTooltip(l10n.quranTeachingBeginnerWordsReplayAction),
      );
      await tester.pump();

      expect(audio.playedCueIds, contains('word_nur'));
      expect(
        find.text(l10n.quranTeachingBeginnerWordsPlaying('Noor')),
        findsOneWidget,
      );
      await tester.pump(const Duration(seconds: 1));
    },
  );

  testWidgets('adult beginner words page moves between shared words', (
    tester,
  ) async {
    final container = await pumpBeginnerWordsPage(tester);
    final words = container.read(quranTeachingBeginnerWordsProvider);
    final l10n = AppLocalizations.of(
      tester.element(find.byType(QuranTeachingBeginnerWordsPage)),
    );

    expect(find.text(words.first.arabic), findsOneWidget);
    expect(find.text(words.first.transliteration), findsWidgets);

    await tester.scrollUntilVisible(
      find.text(l10n.quranTeachingBeginnerWordsNextAction),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text(l10n.quranTeachingBeginnerWordsNextAction));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.text(words[1].arabic), findsOneWidget);
    expect(find.text(words[1].transliteration), findsWidgets);

    await tester.tap(find.text(l10n.quranTeachingBeginnerWordsPreviousAction));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.text(words.first.arabic), findsOneWidget);
  });
}
