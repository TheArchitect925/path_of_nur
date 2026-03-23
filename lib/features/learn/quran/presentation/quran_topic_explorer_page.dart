import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/quran_navigation.dart';
import '../application/quran_reference_graph_provider.dart';

class QuranTopicExplorerPage extends ConsumerWidget {
  const QuranTopicExplorerPage({super.key, this.topicId});

  final String? topicId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topics = ref.watch(quranTopicsProvider);
    final selectedTopic = topicId == null
        ? null
        : ref.watch(quranTopicByIdProvider(topicId!));

    return AppPageScaffold(
      headerIcon: Icons.account_tree_outlined,
      title: 'Qur’an Topics',
      subtitle:
          'Explore verses, lessons, hadith, prophets, and journeys by topic.',
      children: [
        if (selectedTopic == null)
          ...topics.map(
            (topic) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PremiumCard(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(topic.title),
                  subtitle: Text(
                    '${topic.description}\n${topic.verseReferences.length} references',
                  ),
                  onTap: () => context.pushNamed(
                    'quranTopicDetail',
                    pathParameters: {'topicId': topic.id},
                  ),
                ),
              ),
            ),
          )
        else
          _TopicDetail(topicId: selectedTopic.id),
      ],
    );
  }
}

class _TopicDetail extends ConsumerWidget {
  const _TopicDetail({required this.topicId});

  final String topicId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topic = ref.watch(quranTopicByIdProvider(topicId));
    final references = ref.watch(quranTopicReferencesProvider(topicId));
    if (topic == null) {
      return const PremiumCard(child: Text('Topic not found.'));
    }

    return Column(
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                topic.title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(topic.description),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _pill('Verses', '${topic.verseReferences.length}'),
                  _pill('Lessons', '${topic.relatedLessons.length}'),
                  _pill('Hadith', '${topic.relatedHadith.length}'),
                  _pill('Prophets', '${topic.relatedProphets.length}'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        ...references.map(
          (reference) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: PremiumCard(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Qur’an ${reference.referenceLabel}'),
                subtitle: Text(reference.contextSummary),
                onTap: () => openQuranAt(
                  context,
                  surahNumber: reference.surahNumber,
                  ayahNumber: reference.ayahStart,
                  endAyahNumber: reference.ayahEnd,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _pill(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF3E8),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFCEB07D)),
      ),
      child: Text('$label: $value'),
    );
  }
}
