import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';

import '../../../../../core/theme/app_palette.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../core/theme/app_surfaces.dart';
import '../../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../../application/quran_player_controller.dart';
import '../../application/quran_providers.dart';
import '../../application/quran_reader_playback_controller.dart';
import '../../domain/quran_audio_resilience_models.dart';
import '../quran_reader_playback_presentation.dart';
import 'quran_playback_controls_card.dart';

Future<void> showQuranExpandedPlayerSheet(
  BuildContext context, {
  required int surahNumber,
  int? ayahNumber,
}) {
  final container = ProviderScope.containerOf(context, listen: false);
  container.read(quranExpandedPlayerOpenProvider.notifier).state = true;
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    isDismissible: true,
    enableDrag: true,
    useSafeArea: true,
    showDragHandle: false,
    backgroundColor: Colors.transparent,
    builder: (context) => FractionallySizedBox(
      heightFactor: 0.94,
      child: _QuranExpandedPlayerDragDismiss(
        onDismiss: () => Navigator.of(context).maybePop(),
        child: Column(
          children: [
            _QuranExpandedPlayerSwipeHandle(
              onDismiss: () => Navigator.of(context).maybePop(),
            ),
            Expanded(
              child: _QuranExpandedPlayerSheet(
                surahNumber: surahNumber,
                ayahNumber: ayahNumber,
              ),
            ),
          ],
        ),
      ),
    ),
  ).whenComplete(() {
    container.read(quranExpandedPlayerOpenProvider.notifier).state = false;
  });
}

class _QuranExpandedPlayerDragDismiss extends StatelessWidget {
  const _QuranExpandedPlayerDragDismiss({
    required this.onDismiss,
    required this.child,
  });

  final VoidCallback onDismiss;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onVerticalDragEnd: (details) {
        final velocity = details.primaryVelocity ?? 0;
        if (velocity > 900) {
          onDismiss();
        }
      },
      child: child,
    );
  }
}

class _QuranExpandedPlayerSwipeHandle extends StatelessWidget {
  const _QuranExpandedPlayerSwipeHandle({required this.onDismiss});

  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: const ValueKey('quran-global-player-swipe-handle'),
      behavior: HitTestBehavior.opaque,
      onVerticalDragUpdate: (details) {
        if (details.primaryDelta != null && details.primaryDelta! > 10) {
          onDismiss();
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 6),
        child: Center(
          child: Container(
            width: 44,
            height: 5,
            decoration: BoxDecoration(
              color: const Color(0xFF9E8D7D).withValues(alpha: 0.72),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
      ),
    );
  }
}

class _QuranExpandedPlayerSheet extends ConsumerWidget {
  const _QuranExpandedPlayerSheet({required this.surahNumber, this.ayahNumber});

  final int surahNumber;
  final int? ayahNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final playbackState = ref.watch(quranGlobalPlaybackStateProvider);
    final controller = ref.read(quranPlayerControllerProvider);
    final nowPlayingLabel = buildQuranReaderNowPlayingLabel(
      l10n: l10n,
      playbackState: playbackState,
      surahMap: ref.read(quranSurahMapProvider),
    );
    final statusLabel = buildQuranPlaybackStatusLabel(
      l10n: l10n,
      playbackState: playbackState,
    );
    final sourceStatusLabel = buildQuranPlaybackSourceStatusLabel(
      l10n: l10n,
      playbackState: playbackState,
    );
    final isPreparing =
        playbackState.isLoading ||
        playbackState.isBuffering ||
        playbackState.sourceResolutionState ==
            QuranPlaybackSourceResolutionState.preparingTransition;
    final targetAyah =
        ayahNumber ??
        playbackState.activeAyahNumber ??
        playbackState.storedSession?.ayahNumber;
    final ayahTransitionKey =
        playbackState.activeAyahKey ??
        '${playbackState.activeSurahNumber ?? surahNumber}:${targetAyah ?? 0}:${playbackState.isPlaying}:${playbackState.isBuffering}';
    final sliderMax = playbackState.duration?.inMilliseconds.toDouble() ?? 1;
    final sliderValue = playbackState.position.inMilliseconds
        .clamp(0, playbackState.duration?.inMilliseconds ?? 0)
        .toDouble();
    Future<void> closeAndStopPlayer() async {
      await controller.stop();
      if (context.mounted) {
        Navigator.of(context).maybePop();
      }
    }

    return AppPageScaffold(
      key: const ValueKey('quran-global-player-sheet'),
      title: l10n.shellQuranMiniPlayerTitle,
      headerActions: [
        IconButton(
          key: const ValueKey('quran-global-player-collapse'),
          tooltip: l10n.accessibilityClosePlayer,
          onPressed: () => unawaited(closeAndStopPlayer()),
          icon: const Icon(Icons.close_rounded),
        ),
        IconButton(
          key: const ValueKey('quran-global-player-open-reader'),
          tooltip: l10n.shellQuranMiniPlayerOpenReaderAction,
          onPressed: playbackState.activeSurahNumber == null
              ? null
              : () {
                  Navigator.of(context).pop();
                  context.pushNamed(
                    'quranReader',
                    pathParameters: {
                      'surahNumber': playbackState.activeSurahNumber!
                          .toString(),
                    },
                    queryParameters: targetAyah == null
                        ? const <String, String>{}
                        : <String, String>{'ayah': targetAyah.toString()},
                  );
                },
          icon: const Icon(Icons.menu_book_rounded),
        ),
        IconButton(
          key: const ValueKey('quran-global-player-open-focus-mode'),
          tooltip: l10n.quranFocusRecitationModeAction,
          onPressed: playbackState.activeSurahNumber == null
              ? null
              : () {
                  final router = GoRouter.of(context);
                  Navigator.of(context).pop();
                  router.pushNamed(
                    'quranFocusRecitation',
                    queryParameters: <String, String>{
                      'surah': playbackState.activeSurahNumber!.toString(),
                      if (targetAyah != null) 'ayah': targetAyah.toString(),
                    },
                  );
                },
          icon: const Icon(Icons.filter_center_focus_rounded),
        ),
      ],
      children: [
        PremiumCard(
          surfaceVariant: AppSurfaceVariant.panel,
          surfaceTintColor: context.palette.accent,
          surfaceAlphaOverride: 0.62,
          child: _AnimatedExpandedPlayerSummary(
            transitionKey: ayahTransitionKey,
            title: nowPlayingLabel ?? l10n.shellQuranMiniPlayerTitle,
            subtitle: '${playbackState.reciterName} • $statusLabel',
          ),
        ),
        const SizedBox(height: 12),
        QuranPlaybackControlsCard(
          isPreparing: isPreparing,
          hasPlayback: playbackState.hasPlayback,
          isPlaying: playbackState.isPlaying,
          currentPosition: playbackState.position,
          totalDuration: playbackState.duration ?? Duration.zero,
          nowRecitingLabel: nowPlayingLabel,
          sliderMax: sliderMax > 0 ? sliderMax : 1,
          sliderValue: sliderMax > 0 ? sliderValue : 0,
          onClose: () async {
            await closeAndStopPlayer();
          },
          onOpenExpandedPlayer: null,
          onBack15: () async {
            final next = playbackState.position - const Duration(seconds: 15);
            await controller.seek(next < Duration.zero ? Duration.zero : next);
          },
          onTogglePlayback: () {
            if (playbackState.hasRecoverableFailure) {
              unawaited(controller.retryCurrentPlayback());
            } else if (playbackState.canPause) {
              unawaited(controller.pause());
            } else if (playbackState.canPlay) {
              unawaited(controller.resumeCurrentPlayback());
            }
          },
          onForward15: () async {
            final duration = playbackState.duration;
            final next = playbackState.position + const Duration(seconds: 15);
            await controller.seek(
              duration != null && next > duration ? duration : next,
            );
          },
          canGoPreviousAyah: playbackState.canGoPreviousAyah,
          canRestartAyah: playbackState.canRestartAyah,
          canGoNextAyah: playbackState.canGoNextAyah,
          canGoPreviousSurah: playbackState.canGoPreviousSurah,
          canGoNextSurah: playbackState.canGoNextSurah,
          showFollowModeToggle: false,
          onPreviousAyah: playbackState.canGoPreviousAyah
              ? () => unawaited(controller.playRelativeAyah(-1))
              : null,
          onRestartAyah: playbackState.canRestartAyah
              ? () => unawaited(controller.replayCurrentAyah())
              : null,
          onNextAyah: playbackState.canGoNextAyah
              ? () => unawaited(controller.playRelativeAyah(1))
              : null,
          onPreviousSurah: playbackState.canGoPreviousSurah
              ? () => unawaited(controller.playAdjacentSurah(-1))
              : null,
          onNextSurah: playbackState.canGoNextSurah
              ? () => unawaited(controller.playAdjacentSurah(1))
              : null,
          onSeek: playbackState.canSeek && sliderMax > 0
              ? (value) =>
                    controller.seek(Duration(milliseconds: value.round()))
              : null,
          repeatSummaryLabel: buildQuranPlaybackRepeatSummaryLabel(
            l10n,
            playbackState,
          ),
          sourceStatusLabel: sourceStatusLabel,
          showRetryAction: playbackState.hasRecoverableFailure,
        ),
      ],
    );
  }
}

class _AnimatedExpandedPlayerSummary extends StatelessWidget {
  const _AnimatedExpandedPlayerSummary({
    required this.transitionKey,
    required this.title,
    required this.subtitle,
  });

  final String transitionKey;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 280),
      reverseDuration: const Duration(milliseconds: 180),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        final offsetAnimation =
            Tween<Offset>(
              begin: const Offset(0, 0.06),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            );
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(position: offsetAnimation, child: child),
        );
      },
      layoutBuilder: (currentChild, previousChildren) {
        return Stack(
          alignment: Alignment.topLeft,
          children: [
            ...previousChildren,
            ...?(currentChild == null ? null : <Widget>[currentChild]),
          ],
        );
      },
      child: KeyedSubtree(
        key: ValueKey<String>(transitionKey),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: context.palette.onSurfaceSubtle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
