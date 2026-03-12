import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../shared/presentation/learning_header.dart';
import '../../shared/presentation/learning_references.dart';
import '../../shared/presentation/learning_section.dart';
import '../application/hadith_foundation_repository.dart';

class HadithSubcategoryPage extends ConsumerWidget {
  const HadithSubcategoryPage({super.key, required this.subcategoryId});

  final String subcategoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collection = ref.watch(hadithCollectionByIdProvider(subcategoryId));
    if (collection == null) {
      return AppPageScaffold(
        headerIcon: Icons.collections_bookmark_rounded,
        title: 'Collections',
        subtitle: 'Collection not found',
        children: const [PremiumCard(child: Text('The requested collection was not found.'))],
      );
    }

    final entries = ref.watch(hadithEntriesForCollectionProvider(collection.id));
    final quranAnchors = entries
        .expand((entry) => entry.quranConnections)
        .take(4)
        .toList(growable: false);

    return AppPageScaffold(
      headerIcon: Icons.collections_bookmark_rounded,
      title: collection.title,
      subtitle: collection.subtitle,
      children: [
        LearningHeader(
          title: collection.title,
          summary: collection.description,
          chips: ['${entries.length} hadith', 'Collection'],
        ),
        const SizedBox(height: 10),
        if (quranAnchors.isNotEmpty)
          LearningSection(
            title: 'Related Verses',
            child: LearningReferences(
              items: quranAnchors
                  .map(
                    (anchor) => LearningReferenceItem(
                      sourceTitle: anchor.surahName,
                      sourceNumber: anchor.surahNumber,
                      rangeOrSection: anchor.verseRange,
                      label: anchor.label,
                    ),
                  )
                  .toList(growable: false),
            ),
          ),
        LearningSection(
          title: 'Hadith in This Collection',
          child: Column(
            children: entries
                .map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: PremiumCard(
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(entry.title),
                        subtitle: Text('${entry.source} • ${entry.grading}'),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => context.pushNamed(
                          'hadithLessonDetail',
                          pathParameters: {'lessonId': entry.id},
                        ),
                      ),
                    ),
                  ),
                )
                .toList(growable: false),
          ),
        ),
      ],
    );
  }
}
