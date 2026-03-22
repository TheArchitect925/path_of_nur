import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../application/bedtime_story_audio_service.dart';
import '../application/bedtime_story_media_resolver.dart';
import '../application/bedtime_story_player_controller.dart';
import '../application/bedtime_story_progress_service.dart';
import '../domain/bedtime_story_models.dart';
import '../domain/bedtime_story_queue_models.dart';
import 'bedtime_story_full_player_sheet.dart';

class BedtimeStoryMiniPlayer extends ConsumerWidget {
  const BedtimeStoryMiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final story = ref.watch(bedtimeStoryCurrentQueueStoryProvider);
    if (story == null) {
      return const SizedBox.shrink();
    }

    final queueState = ref.watch(bedtimeStoryQueueControllerProvider);
    final queueController = ref.read(bedtimeStoryQueueControllerProvider.notifier);
    final audioState = ref.watch(bedtimeStoryAudioControllerProvider);
    final progress = ref.watch(
      bedtimeStoryProgressProvider.select(
        (value) => value.storyProgressById[story.id] ?? const BedtimeStoryProgress(),
      ),
    );
    final mediaAsync = ref.watch(bedtimeStoryResolvedMediaProvider(story));
    final resolved = mediaAsync.valueOrNull;

    final isCurrent = audioState.currentStoryId == story.id;
    final position = isCurrent
        ? audioState.currentPosition
        : Duration(milliseconds: progress.currentPositionMs);
    final total = isCurrent && audioState.totalDuration > Duration.zero
        ? audioState.totalDuration
        : Duration(
            milliseconds: progress.totalDurationMs > 0
                ? progress.totalDurationMs
                : story.estimatedDuration.inMilliseconds,
          );
    final progressValue = total.inMilliseconds <= 0
        ? 0.0
        : position.inMilliseconds / total.inMilliseconds;

    return PremiumCard(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => showBedtimeStoryFullPlayerSheet(context, ref),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: const Color(0xFFFFF8EF),
                  ),
                  child: resolved?.cover.resolvedAssetPath != null
                      ? Image.asset(
                          resolved!.cover.resolvedAssetPath!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.auto_stories_rounded),
                        )
                      : const Icon(Icons.auto_stories_rounded),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        story.shortTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        queueState.queueType == BedtimeStoryQueueType.continueSeries
                            ? l10n.bedtimeStoriesContinueSeriesLabel(
                                story.partNumber,
                                story.totalParts,
                              )
                            : l10n.bedtimeStoriesTonightTitle,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: resolved?.audio.isAvailable == true
                      ? queueController.togglePlayPause
                      : null,
                  icon: Icon(
                    audioState.isPlaying && isCurrent
                        ? Icons.pause_circle_filled_rounded
                        : Icons.play_circle_fill_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(value: progressValue.clamp(0.0, 1.0)),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: Text(
                    resolved?.audio.isAvailable == true
                        ? l10n.bedtimeStoriesMiniPlayerTapToExpand
                        : l10n.bedtimeStoriesReadAlongBadge,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Text(
                  '${position.inMinutes}:${position.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
