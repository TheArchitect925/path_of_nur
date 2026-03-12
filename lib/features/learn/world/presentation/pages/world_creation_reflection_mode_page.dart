import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../../../../../shared/widgets/quran_reference_block.dart';
import '../../data/world_creation_data.dart';

class WorldCreationReflectionModePage extends ConsumerStatefulWidget {
  const WorldCreationReflectionModePage({super.key});

  @override
  ConsumerState<WorldCreationReflectionModePage> createState() =>
      _WorldCreationReflectionModePageState();
}

class _WorldCreationReflectionModePageState
    extends ConsumerState<WorldCreationReflectionModePage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pool = worldCreationLessons
        .where((lesson) => lesson.featured)
        .toList(growable: false);
    if (pool.isEmpty) {
      return const AppPageScaffold(
        headerIcon: Icons.self_improvement_rounded,
        title: 'Reflection Mode',
        subtitle: 'No reflection lessons available',
        children: [PremiumCard(child: Text('Please check back later.'))],
      );
    }

    final cappedIndex = _index.clamp(0, pool.length - 1);
    final lesson = pool[cappedIndex];
    final verse = lesson.quranVerses.first;

    return AppPageScaffold(
      headerIcon: Icons.self_improvement_rounded,
      title: 'Reflection Mode',
      subtitle: '${cappedIndex + 1} of ${pool.length}',
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(
              colors: [Color(0xFFF8F0E2), Color(0xFFF2E7D3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lesson.title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                QuranReferenceBlock(
                  surahNumber: verse.surahNumber,
                  surahName: verse.surahName,
                  ayahStart: verse.ayahStart,
                  ayahEnd: verse.ayahEnd,
                  dense: true,
                ),
                const SizedBox(height: 10),
                Text(
                  lesson.quranObservation,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 10),
                Text(
                  lesson.reflection,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 10),
                Text('Prompt: ${lesson.observationPrompt}'),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    OutlinedButton.icon(
                      onPressed: cappedIndex == 0
                          ? null
                          : () => setState(() => _index = cappedIndex - 1),
                      icon: const Icon(Icons.chevron_left_rounded),
                      label: const Text('Previous'),
                    ),
                    FilledButton.tonalIcon(
                      onPressed: cappedIndex == pool.length - 1
                          ? null
                          : () => setState(() => _index = cappedIndex + 1),
                      icon: const Icon(Icons.chevron_right_rounded),
                      label: const Text('Next'),
                    ),
                    TextButton.icon(
                      onPressed: () => context.pushNamed(
                        'worldCreationLessonDetail',
                        pathParameters: {'lessonId': lesson.id},
                      ),
                      icon: const Icon(Icons.auto_stories_rounded),
                      label: const Text('Open full lesson'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
