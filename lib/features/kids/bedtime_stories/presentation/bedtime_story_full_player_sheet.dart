import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_surfaces.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../application/bedtime_story_audio_service.dart';
import '../application/bedtime_story_media_resolver.dart';
import '../application/bedtime_story_player_controller.dart';
import '../application/bedtime_story_progress_service.dart';
import '../domain/bedtime_story_models.dart';
import '../domain/bedtime_story_queue_models.dart';
import 'bedtime_story_completion_banner.dart';
import 'bedtime_story_cover_card.dart';

Future<void> showBedtimeStoryFullPlayerSheet(
  BuildContext context,
  WidgetRef ref,
) async {
  final currentStory = ref.read(bedtimeStoryCurrentQueueStoryProvider);
  if (currentStory == null) {
    return;
  }
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const _BedtimeStoryFullPlayerSheet(),
  );
}

class _BedtimeStoryFullPlayerSheet extends ConsumerWidget {
  const _BedtimeStoryFullPlayerSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final story = ref.watch(bedtimeStoryCurrentQueueStoryProvider);
    if (story == null) {
      return const SizedBox.shrink();
    }
    final mediaAsync = ref.watch(bedtimeStoryResolvedMediaProvider(story));
    final audioState = ref.watch(bedtimeStoryAudioControllerProvider);
    final queueState = ref.watch(bedtimeStoryQueueControllerProvider);
    final queueController = ref.read(
      bedtimeStoryQueueControllerProvider.notifier,
    );
    final sleepTimer = ref.watch(bedtimeStorySleepTimerProvider);
    final sleepController = ref.read(bedtimeStorySleepTimerProvider.notifier);
    final nextStory = ref.watch(bedtimeStoryNextQueueStoryProvider);
    final progress = ref.watch(
      bedtimeStoryProgressProvider.select(
        (value) =>
            value.storyProgressById[story.id] ?? const BedtimeStoryProgress(),
      ),
    );

    final isCurrent = audioState.currentStoryId == story.id;
    final duration = isCurrent && audioState.totalDuration > Duration.zero
        ? audioState.totalDuration
        : story.estimatedDuration;
    final position = isCurrent ? audioState.currentPosition : Duration.zero;
    final maxMs = duration.inMilliseconds <= 0
        ? 1.0
        : duration.inMilliseconds.toDouble();
    final sliderValue = position.inMilliseconds.clamp(
      0,
      duration.inMilliseconds,
    );

    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.56,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return DecoratedBox(
          decoration: _playerSheetDecoration(context),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: _playerSheetHandleDecoration(context),
                ),
              ),
              const SizedBox(height: 16),
              mediaAsync.when(
                loading: () => PremiumCard(
                  child: Text(l10n.bedtimeStoriesMediaLoadingLabel),
                ),
                error: (_, _) => PremiumCard(child: Text(story.shortTitle)),
                data: (media) => BedtimeStoryCoverCard(
                  story: story,
                  media: media,
                  height: 240,
                  overlayChips: <Widget>[
                    if (story.isMultipart)
                      _SoftChip(
                        label: l10n.bedtimeStoriesPartLabel(
                          story.partNumber,
                          story.totalParts,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                story.title,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Text(story.lesson, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _SoftChip(
                    label: queueState.autoplayEnabled
                        ? l10n.bedtimeStoriesAutoplayOnLabel
                        : l10n.bedtimeStoriesAutoplayOffLabel,
                  ),
                  if (sleepTimer.isActive)
                    _SoftChip(label: _sleepTimerLabel(l10n, sleepTimer)),
                  if (progress.isCompleted)
                    _SoftChip(label: l10n.bedtimeStoriesStatusCompleted),
                ],
              ),
              const SizedBox(height: 14),
              Slider(
                value: sliderValue.toDouble(),
                max: maxMs,
                onChanged: mediaAsync.valueOrNull?.audio.isAvailable == true
                    ? (next) => queueController.seekBy(
                        Duration(
                          milliseconds: next.round() - position.inMilliseconds,
                        ),
                      )
                    : null,
              ),
              Row(
                children: [
                  Expanded(child: Text(_formatDuration(position))),
                  Text(_formatDuration(duration)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton.filledTonal(
                    onPressed: queueState.hasPrevious
                        ? queueController.previous
                        : null,
                    icon: const Icon(Icons.skip_previous_rounded),
                  ),
                  IconButton.filledTonal(
                    onPressed: mediaAsync.valueOrNull?.audio.isAvailable == true
                        ? () => queueController.seekBy(
                            const Duration(seconds: -10),
                          )
                        : null,
                    icon: const Icon(Icons.replay_10_rounded),
                  ),
                  FilledButton(
                    onPressed: mediaAsync.valueOrNull?.audio.isAvailable == true
                        ? queueController.togglePlayPause
                        : null,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 18,
                      ),
                    ),
                    child: Icon(
                      audioState.isPlaying &&
                              audioState.currentStoryId == story.id
                          ? Icons.pause_circle_filled_rounded
                          : Icons.play_circle_fill_rounded,
                      size: 28,
                    ),
                  ),
                  IconButton.filledTonal(
                    onPressed: mediaAsync.valueOrNull?.audio.isAvailable == true
                        ? () => queueController.seekBy(
                            const Duration(seconds: 10),
                          )
                        : null,
                    icon: const Icon(Icons.forward_10_rounded),
                  ),
                  IconButton.filledTonal(
                    onPressed: queueState.hasNext ? queueController.next : null,
                    icon: const Icon(Icons.skip_next_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.pushNamed(
                        'kidsBedtimeStoryDetail',
                        pathParameters: {'storyId': story.id},
                      );
                    },
                    icon: const Icon(Icons.menu_book_rounded),
                    label: Text(l10n.bedtimeStoriesReadAlongBadge),
                  ),
                  OutlinedButton.icon(
                    onPressed: () =>
                        _showSleepTimerSheet(context, l10n, sleepController),
                    icon: const Icon(Icons.bedtime_rounded),
                    label: Text(l10n.bedtimeStoriesSleepTimerAction),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => queueController.setAutoplayEnabled(
                      !queueState.autoplayEnabled,
                    ),
                    icon: const Icon(Icons.playlist_play_rounded),
                    label: Text(
                      queueState.autoplayEnabled
                          ? l10n.bedtimeStoriesAutoplayDisableAction
                          : l10n.bedtimeStoriesAutoplayEnableAction,
                    ),
                  ),
                ],
              ),
              if (!mediaAsync.hasValue ||
                  mediaAsync.valueOrNull?.audio.isAvailable != true) ...[
                const SizedBox(height: 12),
                PremiumCard(
                  child: Text(l10n.bedtimeStoriesAudioUnavailableSubtitle),
                ),
              ],
              if (audioState.isCompleted &&
                  audioState.currentStoryId == story.id) ...[
                const SizedBox(height: 12),
                BedtimeStoryCompletionBanner(
                  story: story,
                  nextStory: nextStory,
                  onReplay: () =>
                      queueController.playCurrent(restartCompleted: true),
                  onNext: nextStory == null ? null : queueController.next,
                ),
              ],
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _showSleepTimerSheet(
    BuildContext context,
    AppLocalizations l10n,
    BedtimeStorySleepTimerController controller,
  ) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.bedtimeStoriesSleepTimerTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              ...<int>[5, 10, 15].map(
                (minutes) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.timer_outlined),
                  title: Text(l10n.bedtimeStoriesSleepTimerMinutes(minutes)),
                  onTap: () {
                    controller.setDurationMinutes(minutes);
                    Navigator.of(context).pop();
                  },
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.flag_circle_rounded),
                title: Text(l10n.bedtimeStoriesSleepTimerEndOfStory),
                onTap: () {
                  controller.setEndOfStory();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.close_rounded),
                title: Text(l10n.bedtimeStoriesSleepTimerOff),
                onTap: () {
                  controller.clear();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String _sleepTimerLabel(
    AppLocalizations l10n,
    BedtimeStorySleepTimerState timer,
  ) {
    switch (timer.mode) {
      case BedtimeStorySleepTimerMode.off:
        return l10n.bedtimeStoriesSleepTimerOff;
      case BedtimeStorySleepTimerMode.duration:
        final remaining = timer.remainingSeconds ?? 0;
        final minutes = remaining ~/ 60;
        final seconds = (remaining % 60).toString().padLeft(2, '0');
        return l10n.bedtimeStoriesSleepTimerRemaining('$minutes:$seconds');
      case BedtimeStorySleepTimerMode.endOfStory:
        return l10n.bedtimeStoriesSleepTimerEndOfStory;
    }
  }
}

class _SoftChip extends StatelessWidget {
  const _SoftChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: _playerSoftChipDecoration(context),
      child: Text(label, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}

BoxDecoration _playerSoftChipDecoration(BuildContext context) {
  final style = AppSurfaceTheme.resolve(
    context,
    variant: AppSurfaceVariant.pill,
  );
  return style.decoration(radius: 999);
}

BoxDecoration _playerSheetDecoration(BuildContext context) {
  final style = AppSurfaceTheme.resolve(
    context,
    variant: AppSurfaceVariant.island,
  );
  return style.decoration(radius: 28);
}

BoxDecoration _playerSheetHandleDecoration(BuildContext context) {
  final style = AppSurfaceTheme.resolve(
    context,
    variant: AppSurfaceVariant.pill,
    tintColor: Theme.of(context).dividerColor.withValues(alpha: 0.5),
  );
  return style.decoration(radius: 999);
}
