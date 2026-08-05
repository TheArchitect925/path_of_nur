import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../application/bedtime_story_audio_service.dart';
import '../application/bedtime_story_media_resolver.dart';
import '../application/bedtime_story_player_controller.dart';
import '../domain/bedtime_story_models.dart';
import 'bedtime_story_full_player_sheet.dart';

class BedtimeStoryPlayerBar extends ConsumerWidget {
  const BedtimeStoryPlayerBar({
    super.key,
    required this.story,
    required this.media,
    this.onReadAlong,
  });

  final BedtimeStorySeed story;
  final BedtimeStoryResolvedMedia media;
  final VoidCallback? onReadAlong;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final audioState = ref.watch(bedtimeStoryAudioControllerProvider);
    final queueState = ref.watch(bedtimeStoryQueueControllerProvider);
    final queueController = ref.read(
      bedtimeStoryQueueControllerProvider.notifier,
    );
    final isCurrentStory = audioState.currentStoryId == story.id;
    final audioAvailable = media.audio.isAvailable;
    final duration = isCurrentStory && audioState.totalDuration > Duration.zero
        ? audioState.totalDuration
        : story.estimatedDuration;
    final position = isCurrentStory
        ? audioState.currentPosition
        : Duration.zero;
    final maxMs = duration.inMilliseconds <= 0
        ? 1.0
        : duration.inMilliseconds.toDouble();
    final value = position.inMilliseconds.clamp(0, duration.inMilliseconds);

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (media.cover.resolvedAssetPath != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    media.cover.resolvedAssetPath!,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox.shrink(),
                  ),
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Text(
                  audioAvailable
                      ? l10n.bedtimeStoriesPlayerReady
                      : l10n.bedtimeStoriesAudioUnavailableTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              Text(
                _durationLabel(context, current: position, total: duration),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              IconButton(
                onPressed: () => showBedtimeStoryFullPlayerSheet(context, ref),
                icon: const Icon(Icons.open_in_full_rounded),
                tooltip: l10n.bedtimeStoriesOpenPlayerAction,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(story.shortTitle, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 10),
          Slider(
            value: value.toDouble(),
            max: maxMs,
            onChanged: audioAvailable && isCurrentStory
                ? (next) async {
                    await ref
                        .read(bedtimeStoryAudioControllerProvider.notifier)
                        .seek(Duration(milliseconds: next.round()));
                  }
                : null,
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.icon(
                onPressed: audioAvailable
                    ? () async {
                        if (isCurrentStory && audioState.isPlaying) {
                          await ref
                              .read(
                                bedtimeStoryAudioControllerProvider.notifier,
                              )
                              .pause();
                          return;
                        }
                        if (isCurrentStory &&
                            !audioState.isPlaying &&
                            audioState.currentPosition > Duration.zero) {
                          await ref
                              .read(
                                bedtimeStoryAudioControllerProvider.notifier,
                              )
                              .resume();
                          return;
                        }
                        await queueController.playStoryWithBestQueue(story);
                      }
                    : null,
                icon: Icon(
                  isCurrentStory && audioState.isPlaying
                      ? Icons.pause_circle_rounded
                      : Icons.play_circle_fill_rounded,
                ),
                label: Text(
                  isCurrentStory && audioState.isPlaying
                      ? l10n.bedtimeStoriesPauseAction
                      : (isCurrentStory && position > Duration.zero
                            ? l10n.bedtimeStoriesResumeAction
                            : l10n.bedtimeStoriesPlayAction),
                ),
              ),
              OutlinedButton.icon(
                onPressed: audioAvailable && isCurrentStory
                    ? () => ref
                          .read(bedtimeStoryAudioControllerProvider.notifier)
                          .restart()
                    : null,
                icon: const Icon(Icons.restart_alt_rounded),
                label: Text(l10n.bedtimeStoriesRestartAction),
              ),
              if (audioAvailable)
                OutlinedButton.icon(
                  onPressed: queueState.hasPrevious
                      ? queueController.previous
                      : null,
                  icon: const Icon(Icons.skip_previous_rounded),
                  label: Text(l10n.bedtimeStoriesPreviousAction),
                ),
              if (audioAvailable)
                OutlinedButton.icon(
                  onPressed: queueState.hasNext ? queueController.next : null,
                  icon: const Icon(Icons.skip_next_rounded),
                  label: Text(
                    story.isMultipart
                        ? l10n.bedtimeStoriesNextPartAction
                        : l10n.bedtimeStoriesNextStoryAction,
                  ),
                ),
              if (audioAvailable)
                OutlinedButton.icon(
                  onPressed: () =>
                      queueController.seekBy(const Duration(seconds: -10)),
                  icon: const Icon(Icons.replay_10_rounded),
                  label: Text(l10n.bedtimeStoriesBackShortAction),
                ),
              if (audioAvailable)
                OutlinedButton.icon(
                  onPressed: () =>
                      queueController.seekBy(const Duration(seconds: 10)),
                  icon: const Icon(Icons.forward_10_rounded),
                  label: Text(l10n.bedtimeStoriesForwardShortAction),
                ),
              if (!audioAvailable)
                OutlinedButton.icon(
                  onPressed: onReadAlong,
                  icon: const Icon(Icons.menu_book_rounded),
                  label: Text(l10n.bedtimeStoriesReadTonightAction),
                ),
            ],
          ),
          if (!audioAvailable) ...[
            const SizedBox(height: 8),
            Text(
              l10n.bedtimeStoriesAudioUnavailableSubtitle,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }

  String _durationLabel(
    BuildContext context, {
    required Duration current,
    required Duration total,
  }) {
    final l10n = AppLocalizations.of(context);
    String twoDigits(int value) => value.toString().padLeft(2, '0');
    final currentLabel =
        '${current.inMinutes}:${twoDigits(current.inSeconds.remainder(60))}';
    final totalLabel =
        '${total.inMinutes}:${twoDigits(total.inSeconds.remainder(60))}';
    return l10n.bedtimeStoriesPlaybackProgressLabel(currentLabel, totalLabel);
  }
}
