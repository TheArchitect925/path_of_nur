import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../data/learn_content_data.dart';
import '../data/quran_50_lessons_mapping_data.dart';
import '../domain/learn_topic_category.dart';

class QuranLessonsMappingPage extends StatelessWidget {
  const QuranLessonsMappingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final grouped = <QuranSourceLessonCategory, List<QuranSourceLesson>>{};
    for (final lesson in quranSourceLessons) {
      grouped.putIfAbsent(lesson.category, () => []).add(lesson);
    }

    int covered = 0;
    for (final lesson in quranSourceLessons) {
      if ((lesson.mappedTopicId ?? '').isNotEmpty) covered += 1;
    }

    return AppPageScaffold(
      headerIcon: Icons.fact_check_outlined,
      title: 'Quran Lessons Source Mapping',
      subtitle:
          'Mapped from "50 Lessons of Quran" into current Learn categories (Life/World/Hadith/Aqidah/Community).',
      children: [
        PremiumCard(
          child: Text(
            'Mapped lessons: $covered / ${quranSourceLessons.length}\n'
            'This view highlights what is already covered and what still needs deeper dedicated tracks.',
            style: const TextStyle(height: 1.35),
          ),
        ),
        const SizedBox(height: 12),
        ...grouped.entries.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _categoryLabel(entry.key),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  ...entry.value.map((lesson) {
                    final route = _resolveLearnContentRoute(
                      lesson.mappedTopicId,
                    );
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text('${lesson.number}. ${lesson.title}'),
                        subtitle: Text(lesson.coverageNote),
                        trailing: route == null
                            ? const Icon(Icons.info_outline_rounded)
                            : const Icon(Icons.chevron_right_rounded),
                        onTap: route == null
                            ? null
                            : () => context.pushNamed(
                                'learnContentDetail',
                                pathParameters: route,
                              ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _categoryLabel(QuranSourceLessonCategory category) {
    switch (category) {
      case QuranSourceLessonCategory.life:
        return 'Life';
      case QuranSourceLessonCategory.world:
        return 'World';
      case QuranSourceLessonCategory.hadith:
        return 'Hadith';
      case QuranSourceLessonCategory.aqidah:
        return 'Aqidah / Belief';
      case QuranSourceLessonCategory.community:
        return 'Community';
    }
  }

  Map<String, String>? _resolveLearnContentRoute(String? topicId) {
    if (topicId == null || topicId.isEmpty) return null;
    if (topicById(LearnTopicCategory.life, topicId) != null) {
      return {'category': 'life', 'topicId': topicId};
    }
    if (topicById(LearnTopicCategory.world, topicId) != null) {
      return {'category': 'world', 'topicId': topicId};
    }
    if (topicById(LearnTopicCategory.hadith, topicId) != null) {
      return {'category': 'hadith', 'topicId': topicId};
    }
    return null;
  }
}
