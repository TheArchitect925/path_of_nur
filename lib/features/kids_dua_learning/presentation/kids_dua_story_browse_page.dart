import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../application/kids_dua_repository.dart';
import '../application/kids_dua_story_repository.dart';
import '../../../shared/widgets/app_page_scaffold.dart';

class KidsDuaStoryBrowsePage extends ConsumerWidget {
  const KidsDuaStoryBrowsePage({super.key, this.category = 'all_stories'});

  final String category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final stories = ref.watch(kidsDuaStoriesByCategoryProvider(category));
    return AppPageScaffold(
      title: _title(l10n, category),
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: stories.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final story = stories[index];
            final lesson = ref.watch(kidsDuaLessonByIdProvider(story.duaId));
            return InkWell(
              onTap: () => context.pushNamed(
                'kidsDuaStoryPlayer',
                pathParameters: {'storyId': story.id},
              ),
              borderRadius: BorderRadius.circular(22),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFFE8DDD0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      story.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      story.introLine,
                      style: const TextStyle(color: Color(0xFF675B4E)),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            lesson?.title ?? '',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Text(
                          l10n.kidsDuaStoriesDurationValue(
                            (story.estimatedDurationSec / 60).ceil(),
                          ),
                          style: const TextStyle(color: Color(0xFF8A6A45)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

String _title(AppLocalizations l10n, String category) {
  switch (category) {
    case 'bedtime_stories':
      return l10n.kidsDuaStoriesCategoryBedtime;
    case 'daily_life_stories':
      return l10n.kidsDuaStoriesCategoryDailyLife;
    case 'feelings_stories':
      return l10n.kidsDuaStoriesCategoryFeelings;
    case 'learning_stories':
      return l10n.kidsDuaStoriesCategoryLearning;
    case 'travel_nature_stories':
      return l10n.kidsDuaStoriesCategoryTravelNature;
    default:
      return l10n.kidsDuaStoriesBrowseAllTitle;
  }
}
