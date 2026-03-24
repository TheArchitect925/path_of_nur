import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_providers.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_reference_graph_provider.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_ayah.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_reference_models.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_reader_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<Widget> wrapHarness(Widget child) async {
    SharedPreferences.setMockInitialValues(const <String, Object>{});
    final prefs = await SharedPreferences.getInstance();
    return ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: MaterialApp(
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: child),
      ),
    );
  }

  TextStyle? firstHighlightedSpanStyle(InlineSpan span) {
    if (span is TextSpan) {
      final style = span.style;
      if (style?.backgroundColor != null) {
        return style;
      }
      for (final child in span.children ?? const <InlineSpan>[]) {
        final match = firstHighlightedSpanStyle(child);
        if (match != null) return match;
      }
    }
    return null;
  }

  testWidgets('playback controls harness reflects pause and resume cycles', (
    tester,
  ) async {
    var isPlaying = true;
    var followModeEnabled = true;
    var previousCount = 0;
    var restartCount = 0;
    var nextCount = 0;

    await tester.pumpWidget(
      await wrapHarness(
        StatefulBuilder(
          builder: (context, setState) {
            return QuranReaderPlaybackControlsCard(
              isPreparing: false,
              hasPlayback: true,
              isPlaying: isPlaying,
              currentPosition: const Duration(seconds: 12),
              totalDuration: const Duration(seconds: 90),
              nowRecitingLabel: 'Recitation Al-Fatihah • Verse 1:2',
              sliderMax: 90,
              sliderValue: 12,
              onClose: () {},
              onBack15: () {},
              onTogglePlayback: () => setState(() => isPlaying = !isPlaying),
              onForward15: () {},
              canGoPreviousAyah: true,
              canRestartAyah: true,
              canGoNextAyah: true,
              followModeEnabled: followModeEnabled,
              onPreviousAyah: () => previousCount += 1,
              onRestartAyah: () => restartCount += 1,
              onNextAyah: () => nextCount += 1,
              onToggleFollowMode: () =>
                  setState(() => followModeEnabled = !followModeEnabled),
              onSeek: (_) {},
            );
          },
        ),
      ),
    );

    expect(find.byIcon(Icons.pause_circle_filled_rounded), findsOneWidget);
    expect(find.textContaining('Recitation Al-Fatihah'), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey('quran-reader-play-pause-button')),
    );
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.play_circle_fill_rounded), findsOneWidget);

    await tester.tap(
      find.byKey(const ValueKey('quran-reader-play-pause-button')),
    );
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.pause_circle_filled_rounded), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('quran-reader-previous-ayah')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('quran-reader-restart-ayah')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('quran-reader-next-ayah')));
    await tester.pumpAndSettle();
    expect(previousCount, 1);
    expect(restartCount, 1);
    expect(nextCount, 1);

    expect(find.text('Follow mode'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('quran-reader-follow-toggle')));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.location_searching_rounded), findsOneWidget);
  });

  testWidgets('ayah card harness exposes active recitation highlight styling', (
    tester,
  ) async {
    const ayah = QuranAyah(
      surahNumber: 1,
      ayahNumber: 2,
      arabic: 'الْحَمْدُ لِلّٰهِ رَبِّ الْعَالَمِينَ',
      transliteration: 'Alhamdu lillahi rabbil alamin',
      translation: 'All praise is due to Allah, Lord of all worlds.',
    );

    await tester.pumpWidget(
      await wrapHarness(
        QuranAyahCard(
          ayah: ayah,
          isHighlighted: false,
          isNowPlaying: true,
          activeWordIndex: 1,
          isBookmarked: false,
          isMarkedForMemorization: false,
          notesCount: 0,
          onBookmark: () {},
          onAddNote: () {},
          showArabic: true,
          showTranslation: true,
          showTransliteration: true,
          showWordByWord: false,
          showActions: false,
          hifzRevealMode: HifzRevealMode.full,
          arabicFontSize: 24,
          transliterationFontSize: 15,
          translationFontSize: 14,
          harakatColor: null,
          contextualLinks: const [],
          themeTopics: const [],
          studyMode: QuranReaderStudyMode.reading,
          onTap: () {},
          onPlayAyah: () {},
          onToggleMemorization: () {},
          onPlayWord: (_) async {},
          onMistakeCheckpoint: () {},
        ),
      ),
    );

    expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);

    final richTexts = tester.widgetList<RichText>(
      find.descendant(
        of: find.byType(QuranAyahCard),
        matching: find.byType(RichText),
      ),
    );
    final hasHighlightedSpan = richTexts.any(
      (widget) => firstHighlightedSpanStyle(widget.text) != null,
    );
    expect(hasHighlightedSpan, isTrue);
  });

  testWidgets('ayah card learn more chip opens explanation sheet first', (
    tester,
  ) async {
    const ayah = QuranAyah(
      surahNumber: 2,
      ayahNumber: 153,
      arabic: 'يَا أَيُّهَا الَّذِينَ آمَنُوا',
      transliteration: 'Ya ayyuhalladhina amanu',
      translation: 'O you who have believed...',
    );

    await tester.pumpWidget(
      await wrapHarness(
        QuranAyahCard(
          ayah: ayah,
          isHighlighted: false,
          isNowPlaying: false,
          activeWordIndex: null,
          isBookmarked: false,
          isMarkedForMemorization: false,
          notesCount: 0,
          onBookmark: () {},
          onAddNote: () {},
          showArabic: true,
          showTranslation: true,
          showTransliteration: true,
          showWordByWord: false,
          showActions: false,
          hifzRevealMode: HifzRevealMode.full,
          arabicFontSize: 24,
          transliterationFontSize: 15,
          translationFontSize: 14,
          harakatColor: null,
          contextualLinks: const [
            QuranRelatedKnowledgeLink(
              id: 'hadith-test',
              title: 'Patience in difficulty',
              subtitle: 'Sahih Muslim',
              category: QuranRelatedKnowledgeCategory.hadith,
              knowledgeType: QuranKnowledgeType.hadith,
              connectionStrength: QuranConnectionStrength.direct,
              routeName: 'learnHadithLanding',
              relationReason:
                  'This Hadith reinforces the same lesson of patience and seeking help through worship.',
            ),
          ],
          themeTopics: const [],
          studyMode: QuranReaderStudyMode.study,
          onTap: () {},
          onPlayAyah: () {},
          onToggleMemorization: () {},
          onPlayWord: (_) async {},
          onMistakeCheckpoint: () {},
        ),
      ),
    );

    await tester.tap(find.text('Patience in difficulty'));
    await tester.pumpAndSettle();

    expect(find.text('Why this is related'), findsOneWidget);
    expect(
      find.text(
        'This Hadith reinforces the same lesson of patience and seeking help through worship.',
      ),
      findsOneWidget,
    );
    expect(find.text('Open Hadith lesson'), findsOneWidget);
  });

  testWidgets('ayah card keeps Learn More ahead of broader themes', (
    tester,
  ) async {
    const ayah = QuranAyah(
      surahNumber: 2,
      ayahNumber: 153,
      arabic: 'يَا أَيُّهَا الَّذِينَ آمَنُوا',
      transliteration: 'Ya ayyuhalladhina amanu',
      translation: 'O you who have believed...',
    );

    await tester.pumpWidget(
      await wrapHarness(
        QuranAyahCard(
          ayah: ayah,
          isHighlighted: false,
          isNowPlaying: false,
          activeWordIndex: null,
          isBookmarked: false,
          isMarkedForMemorization: true,
          notesCount: 0,
          onBookmark: () {},
          onAddNote: () {},
          showArabic: true,
          showTranslation: true,
          showTransliteration: true,
          showWordByWord: false,
          showActions: false,
          hifzRevealMode: HifzRevealMode.full,
          arabicFontSize: 24,
          transliterationFontSize: 15,
          translationFontSize: 14,
          harakatColor: null,
          contextualLinks: const [
            QuranRelatedKnowledgeLink(
              id: 'hadith-test',
              title: 'Patience in difficulty',
              subtitle: 'Sahih Muslim',
              category: QuranRelatedKnowledgeCategory.hadith,
              knowledgeType: QuranKnowledgeType.hadith,
              connectionStrength: QuranConnectionStrength.direct,
              routeName: 'learnHadithLanding',
            ),
            QuranRelatedKnowledgeLink(
              id: 'journey-test',
              title: 'Journey through patience',
              subtitle: 'Character journey',
              category: QuranRelatedKnowledgeCategory.learningJourney,
              knowledgeType: QuranKnowledgeType.journey,
              connectionStrength: QuranConnectionStrength.related,
              routeName: 'learnJourneyLanding',
            ),
          ],
          themeTopics: const [
            QuranTopic(
              id: 'patience',
              title: 'Patience',
              description: 'Stay steady with sabr.',
              primaryReferenceId: '2:153',
              suggestedReaderMode: QuranReaderStudyMode.study,
              verseReferences: ['2:153'],
              relatedLessons: ['character-sabr'],
              relatedHadith: ['patience'],
              relatedProphets: ['ayyub'],
              relatedSurahNumbers: [2],
            ),
          ],
          activeTopicId: 'patience',
          studyMode: QuranReaderStudyMode.study,
          onTap: () {},
          onPlayAyah: () {},
          onToggleMemorization: () {},
          onPlayWord: (_) async {},
          onMistakeCheckpoint: () {},
        ),
      ),
    );

    expect(find.text('Hadith'), findsOneWidget);
    expect(find.text('Journey lesson'), findsOneWidget);
    expect(find.text('Themes'), findsOneWidget);

    final learnMoreY = tester.getTopLeft(find.text('Learn More')).dy;
    final themesY = tester.getTopLeft(find.text('Themes')).dy;
    expect(learnMoreY, lessThan(themesY));
  });

  testWidgets(
    'ayah card keeps theme context ahead of learn more in theme mode',
    (tester) async {
      const ayah = QuranAyah(
        surahNumber: 55,
        ayahNumber: 13,
        arabic: 'فَبِأَيِّ آلَاءِ رَبِّكُمَا تُكَذِّبَانِ',
        transliteration: 'Fabia ayyi alaa i rabbikuma tukaththiban',
        translation: 'So which of the favors of your Lord would you deny?',
      );

      await tester.pumpWidget(
        await wrapHarness(
          QuranAyahCard(
            ayah: ayah,
            isHighlighted: false,
            isNowPlaying: false,
            activeWordIndex: null,
            isBookmarked: false,
            isMarkedForMemorization: false,
            notesCount: 0,
            onBookmark: () {},
            onAddNote: () {},
            showArabic: true,
            showTranslation: true,
            showTransliteration: true,
            showWordByWord: false,
            showActions: false,
            hifzRevealMode: HifzRevealMode.full,
            arabicFontSize: 24,
            transliterationFontSize: 15,
            translationFontSize: 14,
            harakatColor: null,
            contextualLinks: const [
              QuranRelatedKnowledgeLink(
                id: 'life-test',
                title: 'Gratitude in daily life',
                subtitle: 'Divine Life',
                category: QuranRelatedKnowledgeCategory.divineLife,
                knowledgeType: QuranKnowledgeType.lifeLesson,
                connectionStrength: QuranConnectionStrength.strong,
                routeName: 'lifeLanding',
              ),
            ],
            themeTopics: const [
              QuranTopic(
                id: 'gratitude',
                title: 'Gratitude',
                description: 'Receive blessings with shukr.',
                primaryReferenceId: '55:13',
                suggestedReaderMode: QuranReaderStudyMode.theme,
                verseReferences: ['55:13'],
                relatedLessons: ['character-gratitude'],
                relatedHadith: ['gratitude'],
                relatedProphets: [],
              ),
            ],
            activeTopicId: 'gratitude',
            studyMode: QuranReaderStudyMode.theme,
            onTap: () {},
            onPlayAyah: () {},
            onToggleMemorization: () {},
            onPlayWord: (_) async {},
            onMistakeCheckpoint: () {},
          ),
        ),
      );

      final themesY = tester.getTopLeft(find.text('Themes')).dy;
      final learnMoreY = tester.getTopLeft(find.text('Learn More')).dy;
      expect(themesY, lessThan(learnMoreY));
    },
  );
}
