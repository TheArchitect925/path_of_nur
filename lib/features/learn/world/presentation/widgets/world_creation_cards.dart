import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../shared/widgets/display/progress_bar.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../../../../../shared/widgets/quran_reference_block.dart';
import '../../domain/world_creation_models.dart';
import '../../../../../core/theme/app_palette.dart';

class WorldCategoryHeroCard extends StatelessWidget {
  const WorldCategoryHeroCard({
    super.key,
    required this.title,
    required this.description,
    required this.lessonCount,
    required this.progress,
    required this.featuredVerse,
    required this.onTap,
  });

  final String title;
  final String description;
  final int lessonCount;
  final double progress;
  final VerseContent featuredVerse;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(description),
            const SizedBox(height: 8),
            Text('Featured: Qur’an ${featuredVerse.referenceLabel}'),
            const SizedBox(height: 8),
            Text(
              '$lessonCount lessons • ${(progress * 100).round()}% complete',
            ),
            const SizedBox(height: 8),
            ProgressBar(value: progress, height: 7),
          ],
        ),
      ),
    );
  }
}

class WorldVerseCard extends ConsumerWidget {
  const WorldVerseCard({super.key, required this.verse});

  final VerseContent verse;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return QuranReferenceBlock(
      surahNumber: verse.surahNumber,
      surahName: verse.surahName,
      ayahStart: verse.ayahStart,
      ayahEnd: verse.ayahEnd,
    );
  }
}

class ScienceLensCard extends StatelessWidget {
  const ScienceLensCard({super.key, required this.content});

  final ScienceLensContent content;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Science Lens',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            content.title,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(content.summary),
          const SizedBox(height: 8),
          Text(content.explanation),
          const SizedBox(height: 8),
          _TimelineBlock(points: content.timelinePoints),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: context.palette.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: context.palette.caution),
            ),
            child: Text('Care note: ${content.cautionNote}'),
          ),
        ],
      ),
    );
  }
}

class ReflectionCard extends StatelessWidget {
  const ReflectionCard({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Reflection',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(text),
        ],
      ),
    );
  }
}

class ObservationPromptCard extends StatelessWidget {
  const ObservationPromptCard({
    super.key,
    required this.prompt,
    this.onObserve,
  });

  final String prompt;
  final VoidCallback? onObserve;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Try It / Observe It',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(prompt),
          if (onObserve != null) ...[
            const SizedBox(height: 8),
            FilledButton.tonalIcon(
              onPressed: onObserve,
              icon: const Icon(Icons.travel_explore_rounded),
              label: const Text('Open Explore Creation'),
            ),
          ],
        ],
      ),
    );
  }
}

class ChallengeCard extends StatelessWidget {
  const ChallengeCard({
    super.key,
    required this.challenge,
    required this.completed,
    required this.onComplete,
    this.onCapture,
  });

  final ObservationChallenge challenge;
  final bool completed;
  final VoidCallback onComplete;
  final VoidCallback? onCapture;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            challenge.title,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(challenge.prompt),
          const SizedBox(height: 6),
          Text(
            'Qur’an ${challenge.verseReference.referenceLabel} • ${challenge.xpReward} XP',
          ),
          const SizedBox(height: 6),
          Text('Reflection: ${challenge.reflectionPrompt}'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.tonalIcon(
                onPressed: completed ? null : onComplete,
                icon: const Icon(Icons.check_circle_outline_rounded),
                label: Text(completed ? 'Completed' : 'Mark done'),
              ),
              if (onCapture != null)
                OutlinedButton.icon(
                  onPressed: onCapture,
                  icon: const Icon(Icons.add_a_photo_outlined),
                  label: const Text('Capture sign'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class GalleryTile extends StatelessWidget {
  const GalleryTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.favorite,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool favorite;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      padding: const EdgeInsets.all(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFFF1E4CC),
              ),
              child: const Icon(Icons.image_outlined),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            Icon(
              favorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            ),
          ],
        ),
      ),
    );
  }
}

class _TimelineBlock extends StatelessWidget {
  const _TimelineBlock({required this.points});

  final List<ScienceTimelinePoint> points;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Scientific Timeline',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        ...points.map(
          (point) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Icon(Icons.circle, size: 8, color: Color(0xFF9B7A47)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${point.title} (${point.period})',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(point.note),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
