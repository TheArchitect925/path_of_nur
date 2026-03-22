import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../domain/bedtime_story_models.dart';

class BedtimeStoryCompletionBanner extends StatelessWidget {
  const BedtimeStoryCompletionBanner({
    super.key,
    required this.story,
    this.nextStory,
    this.onReplay,
    this.onNext,
  });

  final BedtimeStorySeed story;
  final BedtimeStorySeed? nextStory;
  final VoidCallback? onReplay;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.bedtimeStoriesStoryCompleteTitle,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            nextStory != null
                ? l10n.bedtimeStoriesStoryCompleteWithNextSubtitle(nextStory!.shortTitle)
                : l10n.bedtimeStoriesStoryCompleteSubtitle,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.icon(
                onPressed: onReplay,
                icon: const Icon(Icons.replay_rounded),
                label: Text(l10n.bedtimeStoriesReplayAction),
              ),
              if (nextStory != null)
                OutlinedButton.icon(
                  onPressed: onNext,
                  icon: const Icon(Icons.skip_next_rounded),
                  label: Text(
                    story.isMultipart
                        ? l10n.bedtimeStoriesNextPartAction
                        : l10n.bedtimeStoriesNextStoryAction,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
