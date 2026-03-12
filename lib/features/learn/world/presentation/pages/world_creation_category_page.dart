import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../../application/world_creation_provider.dart';
import '../../data/world_creation_data.dart';
import '../../domain/world_creation_models.dart';

class WorldCreationCategoryPage extends ConsumerWidget {
  const WorldCreationCategoryPage({super.key, required this.categoryName});

  final String categoryName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = WorldCreationCategoryId.values.firstWhere(
      (item) => item.name == categoryName,
      orElse: () => WorldCreationCategoryId.reflectionSigns,
    );
    final categoryData = worldCreationCategoryById(category);
    if (categoryData == null) {
      return const AppPageScaffold(
        headerIcon: Icons.public_rounded,
        title: 'World & Creation',
        subtitle: 'Category not found',
        children: [
          PremiumCard(child: Text('This category could not be found.')),
        ],
      );
    }

    final lessons = ref.watch(
      worldCreationLessonsForCategoryProvider(category),
    );
    final progress = ref.watch(
      worldCreationProgressByCategoryProvider(category),
    );

    return AppPageScaffold(
      headerIcon: Icons.layers_rounded,
      title: categoryData.title,
      subtitle: categoryData.description,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Featured verse: Qur\'an ${categoryData.featuredVerse.referenceLabel}',
              ),
              const SizedBox(height: 8),
              Text(
                '${lessons.length} lessons • ${(progress * 100).round()}% complete',
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(value: progress, minHeight: 7),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        if (lessons.isEmpty)
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('No direct lessons in this category yet.'),
                const SizedBox(height: 8),
                if (category == WorldCreationCategoryId.exploreCreation)
                  FilledButton.tonalIcon(
                    onPressed: () => context.pushNamed('worldExploreCreation'),
                    icon: const Icon(Icons.travel_explore_rounded),
                    label: const Text('Open Explore Creation'),
                  ),
                if (category == WorldCreationCategoryId.muslimScientists)
                  FilledButton.tonalIcon(
                    onPressed: () => context.pushNamed('worldMuslimScientists'),
                    icon: const Icon(Icons.biotech_rounded),
                    label: const Text('Open Muslim Scientists'),
                  ),
              ],
            ),
          )
        else
          ...lessons.map(
            (lesson) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PremiumCard(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(lesson.title),
                  subtitle: Text(
                    '${lesson.summary}\nQur\'an ${lesson.quranVerses.first.referenceLabel}',
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => context.pushNamed(
                    'worldCreationLessonDetail',
                    pathParameters: {'lessonId': lesson.id},
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
