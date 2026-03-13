import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../../application/world_creation_provider.dart';
import '../../data/world_creation_data.dart';
import '../../domain/world_creation_models.dart';
import '../widgets/world_creation_cards.dart';

class WorldCreationLessonPage extends ConsumerStatefulWidget {
  const WorldCreationLessonPage({super.key, required this.lessonId});

  final String lessonId;

  @override
  ConsumerState<WorldCreationLessonPage> createState() =>
      _WorldCreationLessonPageState();
}

class _WorldCreationLessonPageState
    extends ConsumerState<WorldCreationLessonPage> {
  bool _trackedOpen = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_trackedOpen) return;
    _trackedOpen = true;
    Future<void>.microtask(
      () => ref
          .read(worldCreationProgressProvider.notifier)
          .openLesson(widget.lessonId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lesson = worldCreationLessonById(widget.lessonId);
    if (lesson == null) {
      return const AppPageScaffold(
        headerIcon: Icons.public_rounded,
        title: 'World & Creation',
        subtitle: 'Lesson not found',
        children: [
          PremiumCard(child: Text('The requested lesson could not be found.')),
        ],
      );
    }

    final notifier = ref.read(worldCreationProgressProvider.notifier);
    final state = ref.watch(worldCreationProgressProvider);
    final isSaved = state.savedLessonIds.contains(lesson.id);
    final isCompleted = state.completedLessonIds.contains(lesson.id);
    final related = lesson.relatedLessonIds
        .map(worldCreationLessonById)
        .whereType<WorldCreationLesson>()
        .toList(growable: false);

    return AppPageScaffold(
      headerIcon: Icons.public_rounded,
      title: lesson.title,
      subtitle:
          worldCreationCategoryById(lesson.category)?.title ??
          'World & Creation',
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(lesson.summary),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.tonalIcon(
                    onPressed: () => notifier.toggleSavedLesson(lesson.id),
                    icon: Icon(
                      isSaved
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                    ),
                    label: Text(isSaved ? 'Saved' : 'Save'),
                  ),
                  FilledButton.tonalIcon(
                    onPressed: isCompleted
                        ? null
                        : () => notifier.markLessonCompleted(lesson.id),
                    icon: const Icon(Icons.check_circle_outline_rounded),
                    label: Text(isCompleted ? 'Completed' : 'Mark as read'),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        ...lesson.quranVerses.map(
          (verse) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: WorldVerseCard(verse: verse),
          ),
        ),
        const SizedBox(height: 2),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Quranic Observation',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(lesson.quranObservation),
            ],
          ),
        ),
        const SizedBox(height: 10),
        ScienceLensCard(content: lesson.scienceLens),
        const SizedBox(height: 10),
        ReflectionCard(text: lesson.reflection),
        const SizedBox(height: 10),
        ObservationPromptCard(
          prompt: lesson.observationPrompt,
          onObserve: () => context.pushNamed('worldExploreCreation'),
        ),
        if (related.isNotEmpty) ...[
          const SizedBox(height: 10),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Related Lessons',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                ...related.map(
                  (item) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(item.title),
                    subtitle: Text(item.summary),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.pushNamed(
                      'worldCreationLessonDetail',
                      pathParameters: {'lessonId': item.id},
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
