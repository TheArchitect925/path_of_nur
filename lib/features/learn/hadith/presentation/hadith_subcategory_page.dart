import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../shared/presentation/learning_references.dart';
import '../../shared/presentation/learning_section.dart';
import '../application/hadith_foundation_repository.dart';

class HadithSubcategoryPage extends ConsumerWidget {
  const HadithSubcategoryPage({super.key, required this.subcategoryId});

  final String subcategoryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final collection = ref.watch(hadithCollectionByIdProvider(subcategoryId));
    if (collection == null) {
      return AppPageScaffold(
        headerIcon: Icons.collections_bookmark_rounded,
        title: l10n.hadithCollectionPageTitle,
        subtitle: l10n.hadithCollectionNotFoundSubtitle,
        children: [PremiumCard(child: Text(l10n.hadithCollectionNotFoundBody))],
      );
    }

    final entries = ref.watch(
      hadithEntriesForCollectionProvider(collection.id),
    );
    final quranAnchors = entries
        .expand((entry) => entry.quranConnections)
        .take(4)
        .toList(growable: false);

    return AppPageScaffold(
      headerIcon: Icons.collections_bookmark_rounded,
      title: collection.title,
      subtitle: collection.subtitle,
      children: [
        if (quranAnchors.isNotEmpty)
          LearningSection(
            title: l10n.hadithSectionRelatedVerses,
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
          title: l10n.hadithSectionCollectionEntries,
          child: Column(
            children: entries
                .map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: PremiumCard(
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(entry.title),
                        subtitle: Text(
                          l10n.hadithCollectionEntrySubtitle(
                            entry.source,
                            entry.grading,
                          ),
                        ),
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
