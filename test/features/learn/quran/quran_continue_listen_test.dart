import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_of_nur/app/app_router.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_player_controller.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_providers.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_reader_playback_controller.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_playback_request.dart';
import 'package:path_of_nur/features/learn/quran/presentation/quran_focus_recitation_page.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/application/daily_clock_provider.dart';
import 'package:path_of_nur/shared/widgets/display/compact_list_tile.dart';

import '../../../test_helpers/app_test_harness.dart';

class _RecordingPlayerController extends QuranPlayerController {
  _RecordingPlayerController(super.ref, super.player);

  final List<(int, int)> playedAyahs = <(int, int)>[];

  @override
  Future<bool> playAyah({
    required int surahNumber,
    required int ayahNumber,
    Duration resumePosition = Duration.zero,
    QuranPlaybackReason playbackReason = QuranPlaybackReason.freshPlay,
    List<int>? ayahNumbers,
    bool pauseAfterStart = false,
  }) async {
    playedAyahs.add((surahNumber, ayahNumber));
    return true;
  }
}

/// Listening from the Qur'an tab as a fresh user, who has no playback session
/// and no remembered listen: the continue card starts the recitation, and the
/// Listen & recite row opens on the reading mark with a live play button.
void main() {
  Future<void> pumpRouteFrames(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 120));
    await tester.pump(const Duration(milliseconds: 180));
  }

  Future<ProviderContainer> makeContainer(
    WidgetTester tester, {
    List<Override> overrides = const <Override>[],
  }) async {
    await tester.binding.setSurfaceSize(const Size(1200, 3000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final container = await makeTestContainer(
      overrides: <Override>[
        dailyNowProvider.overrideWith(
          (ref) =>
              Stream<DateTime>.value(DateTime.parse('2026-03-14T12:00:00')),
        ),
        quranPlayerControllerProvider.overrideWith(
          (ref) => _RecordingPlayerController(ref, AudioPlayer()),
        ),
        ...overrides,
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  testWidgets(
    'listen on a fresh install starts the reading mark and opens a playable focus page',
    (tester) async {
      final container = await makeContainer(tester);
      final router = container.read(appRouterProvider);
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      final player =
          container.read(quranPlayerControllerProvider)
              as _RecordingPlayerController;
      final mark = container.read(quranContinueReadingSummaryProvider);

      await tester.pumpWidget(buildRouterTestApp(container));
      router.go('/quran');
      await pumpRouteFrames(tester);

      expect(container.read(quranActivePlaybackSessionProvider), isNull);
      await tester.tap(find.text(l10n.quranTabListenAction));
      await pumpRouteFrames(tester);

      expect(player.playedAyahs, <(int, int)>[
        (mark.surahNumber, mark.ayahNumber),
      ]);
      expect(find.byType(QuranFocusRecitationPage), findsOneWidget);
      expect(router.state.uri.queryParameters, <String, String>{
        'surah': '${mark.surahNumber}',
        'ayah': '${mark.ayahNumber}',
      });

      // The focus page's own play button is live too, not greyed out.
      final playButton = find.byKey(const ValueKey('quran-focus-play-pause'));
      expect(tester.widget<IconButton>(playButton).onPressed, isNotNull);
      await tester.tap(playButton);
      await tester.pump();
      expect(player.playedAyahs, hasLength(2));
      expect(player.playedAyahs.last, (mark.surahNumber, mark.ayahNumber));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('listen leaves a recitation of the same surah running', (
    tester,
  ) async {
    final container = await makeContainer(
      tester,
      overrides: <Override>[
        // Already reciting the reading mark's surah, a few ayahs on.
        quranGlobalPlaybackStateProvider.overrideWith((ref) {
          final surah = ref
              .watch(quranContinueReadingSummaryProvider)
              .surahNumber;
          return QuranReaderPlaybackState(
            pageSurahNumber: surah,
            reciterId: 'husary',
            reciterName: 'Husary',
            activeSurahNumber: surah,
            activeAyahKey: '$surah:3',
            activeAyahNumber: 3,
            hasPlayback: true,
            isPlaying: true,
            status: QuranReaderPlaybackStatus.playing,
            canPause: true,
          );
        }),
      ],
    );
    final router = container.read(appRouterProvider);
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    final player =
        container.read(quranPlayerControllerProvider)
            as _RecordingPlayerController;

    await tester.pumpWidget(buildRouterTestApp(container));
    router.go('/quran');
    await pumpRouteFrames(tester);

    await tester.tap(find.text(l10n.quranTabListenAction));
    await pumpRouteFrames(tester);

    expect(player.playedAyahs, isEmpty);
    expect(find.byType(QuranFocusRecitationPage), findsOneWidget);
  });

  testWidgets(
    'listen & recite on a fresh install opens on the reading mark, ready to play',
    (tester) async {
      final container = await makeContainer(tester);
      final router = container.read(appRouterProvider);
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      final player =
          container.read(quranPlayerControllerProvider)
              as _RecordingPlayerController;
      final mark = container.read(quranContinueReadingSummaryProvider);

      await tester.pumpWidget(buildRouterTestApp(container));
      router.go('/quran');
      await pumpRouteFrames(tester);

      final row = find.ancestor(
        of: find.text(l10n.quranTabListenTitle),
        matching: find.byType(CompactListTile),
      );
      await tester.ensureVisible(row);
      await pumpRouteFrames(tester);
      await tester.tap(row);
      await pumpRouteFrames(tester);

      expect(find.byType(QuranFocusRecitationPage), findsOneWidget);
      // Not the "start playback first" dead end: the reading mark's ayah.
      expect(find.text(l10n.quranFocusRecitationEmptyBody), findsNothing);
      expect(
        find.textContaining(
          l10n.quranReferenceViewerReferenceLabel(
            '${mark.surahNumber}:${mark.ayahNumber}',
          ),
        ),
        findsOneWidget,
      );
      // A row opens the page; it does not start audio by itself.
      expect(player.playedAyahs, isEmpty);

      final playButton = find.byKey(const ValueKey('quran-focus-play-pause'));
      expect(tester.widget<IconButton>(playButton).onPressed, isNotNull);
      await tester.tap(playButton);
      await tester.pump();
      expect(player.playedAyahs, <(int, int)>[
        (mark.surahNumber, mark.ayahNumber),
      ]);
      expect(tester.takeException(), isNull);
    },
  );
}
