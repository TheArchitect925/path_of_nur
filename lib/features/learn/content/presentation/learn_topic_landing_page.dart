import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../application/learn_progress_provider.dart';
import '../data/learn_content_data.dart';
import '../domain/learn_content_page_data.dart';
import '../domain/learn_topic_category.dart';
import '../../../../core/theme/app_palette.dart';

class LearnTopicLandingPage extends ConsumerWidget {
  const LearnTopicLandingPage({super.key, required this.category});

  final LearnTopicCategory category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final topics = topicsForCategory(category);
    final summary = ref.watch(learnProgressSummaryProvider);

    return AppPageScaffold(
      headerIcon: _headerIcon(category),
      title: _title(l10n, category),
      subtitle: _subtitle(l10n, category),
      children: [
        PremiumCard(
          child: Row(
            children: [
              Expanded(
                child: Text(
                  l10n.learnProgressSummary(
                    summary.startedCount,
                    summary.completedCount,
                    summary.favoriteCount,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        ...topics.map((topic) => _TopicTile(category: category, topic: topic)),
      ],
    );
  }
}

class _TopicTile extends ConsumerWidget {
  const _TopicTile({required this.category, required this.topic});

  final LearnTopicCategory category;
  final LearnContentPageData topic;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final progress = ref.watch(learnProgressProvider).byTopicId[topic.id];
    final completed = progress?.completed ?? false;
    final saved = progress?.saved ?? false;
    final favorite = progress?.favorite ?? false;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: PremiumCard(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          onTap: () => context.pushNamed(
            'learnContentDetail',
            pathParameters: {
              'category': _categoryParam(category),
              'topicId': topic.id,
            },
          ),
          leading: Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: context.palette.accent.withValues(alpha: 0.22),
            ),
            child: Icon(_topicIcon(category), size: 18),
          ),
          title: Text(
            topic.title,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(topic.subtitle),
              const SizedBox(height: 4),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  if (completed)
                    _TopicStateChip(
                      icon: Icons.check_circle,
                      label: l10n.learnContentMarkComplete,
                    ),
                  if (saved)
                    _TopicStateChip(
                      icon: Icons.bookmark,
                      label: l10n.learnContentSaved,
                    ),
                  if (favorite)
                    _TopicStateChip(
                      icon: Icons.favorite,
                      label: l10n.learnContentFavorited,
                    ),
                ],
              ),
            ],
          ),
          trailing: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}

class _TopicStateChip extends StatelessWidget {
  const _TopicStateChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE3D3),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12),
          const SizedBox(width: 3),
          Text(label, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }
}

String _title(AppLocalizations l10n, LearnTopicCategory category) {
  switch (category) {
    case LearnTopicCategory.life:
      return l10n.learnLifeSectionTitle;
    case LearnTopicCategory.world:
      return l10n.learnWorldSectionTitle;
    case LearnTopicCategory.hadith:
      return l10n.learnHadithSectionTitle;
  }
}

String _subtitle(AppLocalizations l10n, LearnTopicCategory category) {
  switch (category) {
    case LearnTopicCategory.life:
      return l10n.learnLifeSectionSubtitle;
    case LearnTopicCategory.world:
      return l10n.learnWorldSectionSubtitle;
    case LearnTopicCategory.hadith:
      return l10n.learnHadithSectionSubtitle;
  }
}

IconData _headerIcon(LearnTopicCategory category) {
  switch (category) {
    case LearnTopicCategory.life:
      return Icons.family_restroom_rounded;
    case LearnTopicCategory.world:
      return Icons.public_rounded;
    case LearnTopicCategory.hadith:
      return Icons.menu_book_rounded;
  }
}

IconData _topicIcon(LearnTopicCategory category) {
  switch (category) {
    case LearnTopicCategory.life:
      return Icons.favorite_outline_rounded;
    case LearnTopicCategory.world:
      return Icons.landscape_rounded;
    case LearnTopicCategory.hadith:
      return Icons.auto_stories_outlined;
  }
}

String _categoryParam(LearnTopicCategory category) {
  switch (category) {
    case LearnTopicCategory.life:
      return 'life';
    case LearnTopicCategory.world:
      return 'world';
    case LearnTopicCategory.hadith:
      return 'hadith';
  }
}
