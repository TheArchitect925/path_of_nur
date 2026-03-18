import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../application/kids_dua_story_repository.dart';

class KidsDuaStoriesPage extends ConsumerWidget {
  const KidsDuaStoriesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final featured = ref.watch(kidsDuaFeaturedStoryProvider);
    final continueStory = ref.watch(kidsDuaContinueStoryProvider);
    final categories = ref
        .watch(kidsDuaStoryCategoriesProvider)
        .where((item) => item != 'all_stories')
        .toList(growable: false);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.kidsDuaStoriesTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
        children: [
          Text(
            l10n.kidsDuaStoriesSubtitle,
            style: const TextStyle(color: Color(0xFF675B4E), height: 1.4),
          ),
          const SizedBox(height: 16),
          if (featured != null) ...[
            _StoryFeatureCard(
              title: l10n.kidsDuaStoriesFeaturedTitle,
              storyTitle: featured.title,
              subtitle: featured.introLine,
              actionLabel: l10n.kidsDuaStoriesAction,
              onTap: () => context.pushNamed(
                'kidsDuaStoryPlayer',
                pathParameters: {'storyId': featured.id},
              ),
            ),
            const SizedBox(height: 12),
          ],
          if (continueStory != null) ...[
            _StoryFeatureCard(
              title: l10n.kidsDuaStoriesContinueTitle,
              storyTitle: continueStory.title,
              subtitle: continueStory.introLine,
              actionLabel: l10n.kidsDuaContinueAction,
              onTap: () => context.pushNamed(
                'kidsDuaStoryPlayer',
                pathParameters: {'storyId': continueStory.id},
              ),
            ),
            const SizedBox(height: 18),
          ],
          Text(
            l10n.kidsDuaStoriesBrowseTitle,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          ...categories.map(
            (category) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: () => context.pushNamed(
                  'kidsDuaStoriesBrowse',
                  queryParameters: {'category': category},
                ),
                borderRadius: BorderRadius.circular(22),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: const Color(0xFFE8DDD0)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF8EF),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.auto_stories_rounded),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _categoryLabel(l10n, category),
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: () => context.pushNamed('kidsDuaStoriesBrowse'),
            child: Text(l10n.kidsDuaStoriesBrowseAllAction),
          ),
        ],
      ),
    );
  }
}

class _StoryFeatureCard extends StatelessWidget {
  const _StoryFeatureCard({
    required this.title,
    required this.storyTitle,
    required this.subtitle,
    required this.actionLabel,
    required this.onTap,
  });

  final String title;
  final String storyTitle;
  final String subtitle;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8EF),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE8DDD0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(
            storyTitle,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(subtitle, style: const TextStyle(color: Color(0xFF675B4E))),
          const SizedBox(height: 12),
          FilledButton(onPressed: onTap, child: Text(actionLabel)),
        ],
      ),
    );
  }
}

String _categoryLabel(AppLocalizations l10n, String category) {
  switch (category) {
    case 'bedtime_stories':
      return l10n.kidsDuaStoriesCategoryBedtime;
    case 'daily_life_stories':
      return l10n.kidsDuaStoriesCategoryDailyLife;
    case 'feelings_stories':
      return l10n.kidsDuaStoriesCategoryFeelings;
    case 'learning_stories':
      return l10n.kidsDuaStoriesCategoryLearning;
    default:
      return l10n.kidsDuaStoriesCategoryTravelNature;
  }
}
