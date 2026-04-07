import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_player_controller.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_providers.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_reader_playback_controller.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_ayah.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_reference_models.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_reader_page.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_reader_playback_presentation.dart';
import 'package:path_of_nur/features/learn/quran/presentation/widgets/quran_playback_controls_card.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/fake_quran_playback_feed.dart';

class _ReaderPlaybackHarness extends ConsumerWidget {
  const _ReaderPlaybackHarness({required this.ayahs});

  final List<QuranAyah> ayahs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quranReaderPlaybackControllerProvider(1));
    final nowPlayingLabel = buildQuranReaderNowPlayingLabel(
      l10n: AppLocalizations.of(context),
      playbackState: state,
      surahMap: ref.read(quranSurahMapProvider),
    );
    return Column(
      children: [
        Text(state.activeAyahKey ?? 'idle', key: const ValueKey('active-ayah-key')),
        Text(
          nowPlayingLabel ?? 'No active label',
          key: const ValueKey('now-playing-label'),
        ),
        Text(state.reciterName, key: const ValueKey('reciter-name')),
        QuranPlaybackControlsCard(
          isPreparing: false,
          hasPlayback: state.hasPlayback,
          isPlaying: state.isPlaying,
          currentPosition: state.position,
          totalDuration: state.duration ?? Duration.zero,
          nowRecitingLabel: nowPlayingLabel,
          sliderMax: (state.duration ?? const Duration(seconds: 1))
              .inMilliseconds
              .toDouble(),
          sliderValue: state.position.inMilliseconds.toDouble(),
          onClose: () {},
          onBack15: () {},
          onTogglePlayback: () {},
          onForward15: () {},
          canGoPreviousAyah: false,
          canRestartAyah: false,
          canGoNextAyah: false,
          followModeEnabled: true,
          onPreviousAyah: () {},
          onRestartAyah: () {},
          onNextAyah: () {},
          onToggleFollowMode: () {},
          onSeek: (_) {},
        ),
        for (final ayah in ayahs)
          QuranAyahCard(
            ayah: ayah,
            isHighlighted: false,
            isNowPlaying:
                state.activeAyahKey == '${ayah.surahNumber}:${ayah.ayahNumber}',
            activeWordIndex: null,
            isBookmarked: false,
            isMarkedForMemorization: false,
            notesCount: 0,
            onBookmark: () {},
            onAddNote: () {},
            showArabic: false,
            showTranslation: true,
            showTransliteration: false,
            showWordByWord: false,
            showActions: false,
            hifzRevealMode: HifzRevealMode.full,
            arabicFontSize: 24,
            transliterationFontSize: 14,
            translationFontSize: 14,
            harakatColor: null,
            resolvedExplanation: null,
            actionRecommendation: null,
            spiritualMomentBundle: null,
            personalizedRecommendation: null,
            contextualLinks: const [],
            themeTopics: const [],
            studyMode: QuranReaderStudyMode.reading,
            onTap: () {},
            onPlayAyah: () {},
            onToggleMemorization: () {},
            onPlayWord: (_) async {},
            onMistakeCheckpoint: () {},
          ),
      ],
    );
  }
}

void main() {
  const ayahs = <QuranAyah>[
    QuranAyah(
      surahNumber: 1,
      ayahNumber: 1,
      arabic: 'بِسْمِ اللَّهِ',
      translation: 'In the name of Allah',
    ),
    QuranAyah(
      surahNumber: 1,
      ayahNumber: 2,
      arabic: 'الْحَمْدُ لِلَّهِ',
      translation: 'All praise is for Allah',
    ),
    QuranAyah(
      surahNumber: 1,
      ayahNumber: 3,
      arabic: 'الرَّحْمَٰنِ الرَّحِيمِ',
      translation: 'The Most Merciful, the Especially Merciful',
    ),
  ];

  Future<Widget> wrapHarness(FakeQuranPlaybackFeed feed) async {
    SharedPreferences.setMockInitialValues(const <String, Object>{});
    final prefs = await SharedPreferences.getInstance();
    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        quranPlaybackFeedProvider.overrideWithValue(feed),
        quranSurahAyahsProvider(1).overrideWith((ref) async => ayahs),
      ],
      child: MaterialApp(
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: _ReaderPlaybackHarness(ayahs: ayahs)),
      ),
    );
  }

  testWidgets('reader harness follows play pause seek-style index changes and reciter updates', (
    tester,
  ) async {
    final feed = FakeQuranPlaybackFeed()
      ..update(
        playing: true,
        hasPlaybackSource: true,
        currentIndex: 1,
        position: const Duration(seconds: 12),
        duration: const Duration(seconds: 90),
        processingState: ProcessingState.ready,
      );
    addTearDown(feed.dispose);

    await tester.pumpWidget(await wrapHarness(feed));

    final container = ProviderScope.containerOf(
      tester.element(find.byType(_ReaderPlaybackHarness)),
    );
    await container.read(quranSurahAyahsProvider(1).future);
    container.read(quranActivePlaybackSessionProvider.notifier).state =
        const QuranActivePlaybackSession(
          surahNumber: 1,
          ayahNumbers: <int>[1, 2, 3],
          reciterId: 'husary',
          playbackSpeed: 1,
          includeMediaTags: true,
          isSurahMode: true,
        );
    feed.emitIndex();
    feed.emitPlayerState();
    feed.emitPosition();
    await tester.pump();

    expect(find.text('1:2'), findsOneWidget);
    expect(find.textContaining('Verse 1:2'), findsWidgets);
    expect(find.byIcon(Icons.pause_circle_filled_rounded), findsOneWidget);

    feed.update(playing: false, processingState: ProcessingState.ready);
    feed.emitPlayerState();
    await tester.pump();
    expect(find.byIcon(Icons.play_circle_fill_rounded), findsOneWidget);

    feed.update(playing: true, currentIndex: 2, position: const Duration(seconds: 28));
    feed.emitIndex();
    feed.emitPlayerState();
    feed.emitPosition();
    await tester.pump();
    expect(find.text('1:3'), findsOneWidget);
    expect(find.textContaining('Verse 1:3'), findsWidgets);

    container.read(quranAudioSettingsProvider.notifier).setReciterId('alafasy');
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('reciter-name')), findsOneWidget);
    expect(find.textContaining('Alafasy'), findsOneWidget);

    container
        .read(quranRecitationSessionProvider.notifier)
        .save(surahNumber: 1, ayahNumber: 3, positionSeconds: 28);
    container.read(quranActivePlaybackSessionProvider.notifier).state = null;
    feed.update(
      playing: false,
      hasPlaybackSource: false,
      processingState: ProcessingState.idle,
    );
    feed.emitPlayerState();
    await tester.pump();
    expect(find.text('idle'), findsOneWidget);
  });
}
