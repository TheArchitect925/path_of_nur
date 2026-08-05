import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../core/theme/app_surfaces.dart';
import '../../application/quran_reader_playback_controller.dart';
import '../../../../../shared/widgets/premium_card.dart';

class QuranPlaybackControlsCard extends StatelessWidget {
  const QuranPlaybackControlsCard({
    super.key,
    required this.isPreparing,
    required this.hasPlayback,
    required this.isPlaying,
    required this.currentPosition,
    required this.totalDuration,
    required this.nowRecitingLabel,
    required this.sliderMax,
    required this.sliderValue,
    required this.onClose,
    this.onOpenExpandedPlayer,
    required this.onBack15,
    required this.onTogglePlayback,
    required this.onForward15,
    required this.canGoPreviousAyah,
    required this.canRestartAyah,
    required this.canGoNextAyah,
    this.canGoPreviousSurah = false,
    this.canGoNextSurah = false,
    this.followModeEnabled = false,
    this.showFollowModeToggle = true,
    this.isFollowSuspended = false,
    this.showFollowSuspendedHint = true,
    this.onPreviousAyah,
    this.onRestartAyah,
    this.onNextAyah,
    this.onPreviousSurah,
    this.onToggleFollowMode,
    this.onReturnToCurrentAyah,
    required this.onSeek,
    this.hasReachedEnd = false,
    this.previousSurahNumber,
    this.nextSurahNumber,
    this.onNextSurah,
    this.repeatSummaryLabel,
    this.sourceStatusLabel,
    this.showRetryAction = false,
  });

  final bool isPreparing;
  final bool hasPlayback;
  final bool isPlaying;
  final Duration currentPosition;
  final Duration totalDuration;
  final String? nowRecitingLabel;
  final double sliderMax;
  final double sliderValue;
  final VoidCallback? onClose;
  final VoidCallback? onOpenExpandedPlayer;
  final VoidCallback? onBack15;
  final VoidCallback? onTogglePlayback;
  final VoidCallback? onForward15;
  final bool canGoPreviousAyah;
  final bool canRestartAyah;
  final bool canGoNextAyah;
  final bool canGoPreviousSurah;
  final bool canGoNextSurah;
  final bool followModeEnabled;
  final bool showFollowModeToggle;
  final bool isFollowSuspended;
  final bool showFollowSuspendedHint;
  final VoidCallback? onPreviousAyah;
  final VoidCallback? onRestartAyah;
  final VoidCallback? onNextAyah;
  final VoidCallback? onPreviousSurah;
  final VoidCallback? onToggleFollowMode;
  final VoidCallback? onReturnToCurrentAyah;
  final ValueChanged<double>? onSeek;
  final bool hasReachedEnd;
  final int? previousSurahNumber;
  final int? nextSurahNumber;
  final VoidCallback? onNextSurah;
  final String? repeatSummaryLabel;
  final String? sourceStatusLabel;
  final bool showRetryAction;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final contentColors = AppSurfaceTheme.contentColors(context);
    final panelStyle = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.panel,
      tintColor: const Color(0xFFDABE8D),
      surfaceAlphaOverride: 0.62,
    );

    return PremiumCard(
      surfaceVariant: AppSurfaceVariant.panel,
      surfaceTintColor: const Color(0xFFDABE8D),
      surfaceAlphaOverride: 0.62,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconButton.filledTonal(
                key: const ValueKey('quran-reader-close-player'),
                onPressed: isPreparing ? null : onClose,
                icon: const Icon(Icons.close_rounded),
                tooltip: l10n.accessibilityClosePlayer,
              ),
              IconButton.filledTonal(
                key: const ValueKey('quran-reader-open-full-player'),
                onPressed: isPreparing ? null : onOpenExpandedPlayer,
                icon: const Icon(Icons.open_in_full_rounded),
                tooltip: l10n.quranPlaybackOpenPlayerAction,
              ),
              IconButton.filledTonal(
                key: const ValueKey('quran-reader-back-15'),
                onPressed: (isPreparing || !hasPlayback) ? null : onBack15,
                icon: const Icon(Icons.replay_10_rounded),
                tooltip: l10n.accessibilityBack15Seconds,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FilledButton.icon(
                  key: const ValueKey('quran-reader-play-pause-button'),
                  onPressed: isPreparing ? null : onTogglePlayback,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(
                      0xFF4A3C2F,
                    ).withValues(alpha: 0.94),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  icon: Icon(
                    showRetryAction
                        ? Icons.refresh_rounded
                        : isPlaying
                        ? Icons.pause_circle_filled_rounded
                        : Icons.play_circle_fill_rounded,
                  ),
                  label: Text(
                    isPreparing
                        ? l10n.accessibilityPreparingPlayback
                        : showRetryAction
                        ? l10n.quranPlaybackRetryAction
                        : (isPlaying
                              ? l10n.accessibilityPause
                              : l10n.accessibilityPlay),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton.filledTonal(
                key: const ValueKey('quran-reader-forward-15'),
                onPressed: (isPreparing || !hasPlayback) ? null : onForward15,
                icon: const Icon(Icons.forward_10_rounded),
                tooltip: l10n.accessibilityForward15Seconds,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              IconButton.filledTonal(
                key: const ValueKey('quran-reader-previous-ayah'),
                onPressed: canGoPreviousAyah ? onPreviousAyah : null,
                icon: const Icon(Icons.skip_previous_rounded),
                tooltip: l10n.quranReaderPreviousAyahAction,
              ),
              IconButton.filledTonal(
                key: const ValueKey('quran-reader-restart-ayah'),
                onPressed: canRestartAyah ? onRestartAyah : null,
                icon: const Icon(Icons.replay_rounded),
                tooltip: l10n.quranReaderRestartAyahAction,
              ),
              IconButton.filledTonal(
                key: const ValueKey('quran-reader-next-ayah'),
                onPressed: canGoNextAyah ? onNextAyah : null,
                icon: const Icon(Icons.skip_next_rounded),
                tooltip: l10n.quranReaderNextAyahAction,
              ),
              IconButton.filledTonal(
                key: const ValueKey('quran-reader-previous-surah'),
                onPressed: canGoPreviousSurah ? onPreviousSurah : null,
                icon: const Icon(Icons.keyboard_double_arrow_left_rounded),
                tooltip: l10n.quranReaderPreviousSurahAction,
              ),
              IconButton.filledTonal(
                key: const ValueKey('quran-reader-next-surah'),
                onPressed: canGoNextSurah ? onNextSurah : null,
                icon: const Icon(Icons.keyboard_double_arrow_right_rounded),
                tooltip: l10n.quranReaderNextSurahAction,
              ),
              if (showFollowModeToggle)
                FilterChip(
                  key: const ValueKey('quran-reader-follow-toggle'),
                  selected: followModeEnabled,
                  onSelected: isPreparing
                      ? null
                      : (_) => onToggleFollowMode?.call(),
                  avatar: Icon(
                    followModeEnabled
                        ? Icons.my_location_rounded
                        : Icons.location_searching_rounded,
                    size: 18,
                  ),
                  label: Text(l10n.quranReaderFollowModeLabel),
                ),
            ],
          ),
          if (repeatSummaryLabel != null) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: panelStyle.backgroundColor,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: panelStyle.borderColor),
                ),
                child: Text(
                  repeatSummaryLabel!,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: contentColors.foreground,
                  ),
                ),
              ),
            ),
          ],
          if (sourceStatusLabel != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: panelStyle.backgroundColor,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: panelStyle.borderColor),
                    ),
                    child: Text(
                      sourceStatusLabel!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: contentColors.foreground,
                      ),
                    ),
                  ),
                ),
                if (showRetryAction && onTogglePlayback != null) ...[
                  const SizedBox(width: 8),
                  TextButton.icon(
                    key: const ValueKey('quran-reader-retry-playback'),
                    onPressed: isPreparing ? null : onTogglePlayback,
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: Text(l10n.quranPlaybackRetryAction),
                  ),
                ],
              ],
            ),
          ],
          if (showFollowSuspendedHint && isFollowSuspended) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.quranReaderFollowSuspendedLabel,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: contentColors.subtleForeground,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  key: const ValueKey('quran-reader-return-to-current-ayah'),
                  onPressed: onReturnToCurrentAyah,
                  icon: const Icon(Icons.my_location_rounded, size: 18),
                  label: Text(l10n.quranReaderReturnToCurrentAyahAction),
                ),
              ],
            ),
          ],
          const SizedBox(height: 8),
          Slider(
            key: const ValueKey('quran-reader-progress-slider'),
            min: 0,
            max: sliderMax,
            value: sliderValue,
            onChanged: (isPreparing || !hasPlayback || sliderMax <= 0)
                ? null
                : onSeek,
          ),
          Row(
            children: [
              Text(
                formatQuranPlaybackDurationLabel(currentPosition),
                style: TextStyle(
                  fontSize: 12,
                  color: contentColors.subtleForeground,
                ),
              ),
              const Spacer(),
              if (hasPlayback && nowRecitingLabel != null)
                Text(
                  nowRecitingLabel!,
                  key: const ValueKey('quran-reader-now-reciting-label'),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: contentColors.foreground,
                  ),
                ),
              if (hasPlayback && nowRecitingLabel != null) const Spacer(),
              Text(
                formatQuranPlaybackDurationLabel(totalDuration),
                style: TextStyle(
                  fontSize: 12,
                  color: contentColors.subtleForeground,
                ),
              ),
            ],
          ),
          if (hasReachedEnd &&
              nextSurahNumber != null &&
              onNextSurah != null) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonalIcon(
                key: const ValueKey('quran-reader-next-surah-button'),
                onPressed: onNextSurah,
                icon: const Icon(Icons.skip_next_rounded),
                label: Text(
                  l10n.quranReaderNextSurahButtonLabel(nextSurahNumber!),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

String? buildQuranPlaybackRepeatSummaryLabel(
  AppLocalizations l10n,
  QuranReaderPlaybackState playbackState,
) {
  if (!playbackState.hasRepeatConfigured) {
    return null;
  }
  if (playbackState.hasRepeatRange && playbackState.hasRepeatLoop) {
    return l10n.quranReaderRepeatRangeLoopSummary(
      playbackState.repeatStartAyah!,
      playbackState.repeatEndAyah!,
      playbackState.ayahLoopCount,
    );
  }
  if (playbackState.hasRepeatRange) {
    return l10n.quranReaderRepeatRangeSummary(
      playbackState.repeatStartAyah!,
      playbackState.repeatEndAyah!,
    );
  }
  if (playbackState.hasRepeatLoop) {
    return l10n.quranReaderRepeatLoopSummary(playbackState.ayahLoopCount);
  }
  return null;
}

String formatQuranPlaybackDurationLabel(Duration value) {
  final minutes = value.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = value.inSeconds.remainder(60).toString().padLeft(2, '0');
  final hours = value.inHours;
  if (hours > 0) {
    return '$hours:$minutes:$seconds';
  }
  return '$minutes:$seconds';
}
