import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../shared/application/learn_enhancements_provider.dart';
import '../../shared/application/learn_unified_provider.dart';
import '../../shared/domain/learn_unified_models.dart';
import '../../shared/presentation/learning_detail_page.dart';
import '../../shared/presentation/learning_expandable_section.dart';
import '../../shared/presentation/learning_lessons.dart';
import '../../shared/presentation/learning_references.dart';
import '../../shared/presentation/learning_reflection.dart';
import '../../shared/presentation/learning_related_content.dart';
import '../../shared/presentation/learning_section.dart';
import '../application/world_progress_provider.dart';
import '../data/world_curriculum_data.dart';
import '../domain/world_models.dart';

class WorldLessonPage extends ConsumerStatefulWidget {
  const WorldLessonPage({super.key, required this.lessonId});

  final String lessonId;

  @override
  ConsumerState<WorldLessonPage> createState() => _WorldLessonPageState();
}

class _WorldLessonPageState extends ConsumerState<WorldLessonPage> {
  bool _opened = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_opened) return;
    _opened = true;
    Future<void>.microtask(
      () =>
          ref.read(worldProgressProvider.notifier).openLesson(widget.lessonId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lesson = worldLessonById(widget.lessonId);
    if (lesson == null) {
      return AppPageScaffold(
        title: l10n.learnWorldSectionTitle,
        subtitle: l10n.learnContentNotFound,
        children: [PremiumCard(child: Text(l10n.learnContentNotFound))],
      );
    }

    final notifier = ref.read(worldProgressProvider.notifier);
    final qualityNotifier = ref.read(learnQualityProvider.notifier);
    final quality = ref.watch(
      learnQualityProvider.select(
        (state) =>
            state.byLessonKey['${LearnDomainType.world.name}:${lesson.id}'] ??
            LearnCompletionQuality.notRead,
      ),
    );

    final related = lesson.relatedLessonIds
        .where((id) => id != lesson.id)
        .toSet()
        .map(worldLessonById)
        .whereType<WorldLesson>()
        .toList();
    final crossDomainRelated = ref.watch(
      learnCrossDomainRelatedProvider(
        learnKeyFromLesson(domain: LearnDomainType.world, lessonId: lesson.id),
      ),
    );
    final citations = ref.watch(
      learnLessonCitationsProvider(
        learnKeyFromLesson(domain: LearnDomainType.world, lessonId: lesson.id),
      ),
    );

    WorldLesson? nextLesson;
    final ordered = worldCurriculum.suggestedThemeOrder
        .expand((themeId) => worldSubcategoriesForTheme(themeId))
        .expand((subcategory) => subcategory.lessonIds)
        .toList();
    final currentIndex = ordered.indexOf(lesson.id);
    if (currentIndex >= 0 && currentIndex < ordered.length - 1) {
      nextLesson = worldLessonById(ordered[currentIndex + 1]);
    }

    final relatedLessonLinks = related
        .map(
          (item) => LearningRelatedLink(
            label: item.title,
            onTap: () => context.pushNamed(
              'worldLessonDetail',
              pathParameters: {'lessonId': item.id},
            ),
          ),
        )
        .toList(growable: false);
    final relatedCrossDomainLinks = crossDomainRelated
        .map(
          (item) => LearningRelatedLink(
            label: item.title,
            onTap: () => context.pushNamed(
              item.routeName,
              pathParameters: item.pathParameters,
              queryParameters: item.queryParameters,
            ),
          ),
        )
        .toList(growable: false);
    final citationReferences = citations
        .map(
          (citation) => LearningReferenceItem(
            sourceTitle: citation.sourceTitle,
            rangeOrSection: citation.reference,
            label: '${citation.qualityBadge} • ${citation.confidenceNote}',
          ),
        )
        .toList(growable: false);

    return LearningDetailPage(
      title: lesson.title,
      subtitle: lesson.subtitle,
      sections: [
        LearningSection(
          title: l10n.learnContentOverviewTitle,
          body: lesson.overview,
        ),
        LearningSection(
          title: l10n.worldQuranicPerspectiveTitle,
          body: lesson.quranicPerspective,
        ),
        LearningSection(
          title: l10n.worldReflectiveTakeawayTitle,
          body: lesson.reflectiveTakeaway,
        ),
        LearningSection(
          title: l10n.worldPracticalTakeawayTitle,
          body: lesson.practicalTakeaway,
        ),
        LearningSection(
          title: l10n.learnContentThemesTitle,
          child: LearningLessons(
            items: lesson.keyConcepts
                .map((item) => LearningLessonItem(title: item))
                .toList(growable: false),
          ),
        ),
        LearningSection(
          title: l10n.learnContentReflectionPromptTitle,
          child: LearningReflection(prompts: [lesson.reflectionPrompt]),
        ),
        if (lesson.observationPrompt != null)
          LearningSection(
            title: l10n.worldObservationPromptTitle,
            body: lesson.observationPrompt,
          ),
        LearningExpandableSection(
          title: l10n.worldComparativeTeachingsTitle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: lesson.comparativeInsights
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.tradition,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(item.themeSummary),
                        if (item.referenceNote != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            item.referenceNote!,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        LearningSection(
          title: l10n.learnContentRelatedTopicsTitle,
          child: LearningRelatedContent(items: relatedLessonLinks),
        ),
        if (crossDomainRelated.isNotEmpty)
          LearningSection(
            title: l10n.learnContentReferencesTitle,
            child: LearningRelatedContent(items: relatedCrossDomainLinks),
          ),
        if (citations.isNotEmpty)
          LearningExpandableSection(
            title: l10n.learnCitationPanelTitle,
            child: LearningReferences(items: citationReferences),
          ),
        if (nextLesson != null)
          LearningSection(
            title: l10n.worldSuggestedNextLessonTitle,
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(nextLesson.title),
              subtitle: Text(nextLesson.subtitle),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.pushNamed(
                'worldLessonDetail',
                pathParameters: {'lessonId': nextLesson!.id},
              ),
            ),
          ),
        LearningSection(
          title: l10n.learnContentProgressTitle,
          child: Row(
            children: [
              Expanded(
                child: FilledButton.tonal(
                  onPressed: () => notifier.setStatus(
                    lesson.id,
                    WorldLessonStatus.inProgress,
                  ),
                  child: Text(l10n.worldMarkInProgress),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.tonal(
                  onPressed: () => notifier.setStatus(
                    lesson.id,
                    WorldLessonStatus.completed,
                  ),
                  child: Text(l10n.worldMarkCompleted),
                ),
              ),
            ],
          ),
        ),
        LearningSection(
          title: l10n.learnCompletionQualityTitle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: LearnCompletionQuality.values
                    .map(
                      (item) => ChoiceChip(
                        label: Text(_qualityLabel(l10n, item)),
                        selected: item == quality,
                        onSelected: (_) {
                          qualityNotifier.setQuality(
                            domain: LearnDomainType.world,
                            lessonId: lesson.id,
                            quality: item,
                          );
                          if (item == LearnCompletionQuality.notRead) {
                            notifier.setStatus(
                              lesson.id,
                              WorldLessonStatus.notStarted,
                            );
                          } else if (item == LearnCompletionQuality.read) {
                            notifier.setStatus(
                              lesson.id,
                              WorldLessonStatus.inProgress,
                            );
                          } else {
                            notifier.setStatus(
                              lesson.id,
                              WorldLessonStatus.completed,
                            );
                          }
                        },
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
        LearningSection(
          title: l10n.learnContentReflectionPromptTitle,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.worldAddReflectionTitle),
            subtitle: Text(l10n.worldAddReflectionSubtitle),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.pushNamed('journalCreate'),
          ),
        ),
        LearningSection(
          title: l10n.worldObservationPromptTitle,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.worldObservationCtaTitle),
            subtitle: Text(l10n.worldObservationCtaSubtitle),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.pushNamed('journalCreate'),
          ),
        ),
      ],
    );
  }

  String _qualityLabel(AppLocalizations l10n, LearnCompletionQuality quality) {
    switch (quality) {
      case LearnCompletionQuality.notRead:
        return l10n.learnQualityNotRead;
      case LearnCompletionQuality.read:
        return l10n.learnQualityRead;
      case LearnCompletionQuality.reflected:
        return l10n.learnQualityReflected;
      case LearnCompletionQuality.applied:
        return l10n.learnQualityApplied;
    }
  }
}
