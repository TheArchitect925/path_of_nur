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
import '../application/life_progress_provider.dart';
import '../data/life_curriculum_data.dart';
import '../domain/life_models.dart';

class LifeLessonPage extends ConsumerStatefulWidget {
  const LifeLessonPage({super.key, required this.lessonId});

  final String lessonId;

  @override
  ConsumerState<LifeLessonPage> createState() => _LifeLessonPageState();
}

class _LifeLessonPageState extends ConsumerState<LifeLessonPage> {
  bool _opened = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_opened) return;
    _opened = true;
    Future<void>.microtask(
      () => ref.read(lifeProgressProvider.notifier).openLesson(widget.lessonId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final lesson = lifeLessonById(widget.lessonId);
    if (lesson == null) {
      return AppPageScaffold(
        headerIcon: Icons.article_outlined,
        title: l10n.learnLifeSectionTitle,
        subtitle: l10n.learnContentNotFound,
        children: [PremiumCard(child: Text(l10n.learnContentNotFound))],
      );
    }

    final notifier = ref.read(lifeProgressProvider.notifier);
    final qualityNotifier = ref.read(learnQualityProvider.notifier);
    final quality = ref.watch(
      learnQualityProvider.select(
        (state) =>
            state.byLessonKey['${LearnDomainType.life.name}:${lesson.id}'] ??
            LearnCompletionQuality.notRead,
      ),
    );

    final related = lesson.relatedLessonIds
        .where((id) => id != lesson.id)
        .toSet()
        .map(lifeLessonById)
        .whereType<LifeLesson>()
        .toList();
    final crossDomainRelated = ref.watch(
      learnCrossDomainRelatedProvider(
        learnKeyFromLesson(domain: LearnDomainType.life, lessonId: lesson.id),
      ),
    );
    final citations = ref.watch(
      learnLessonCitationsProvider(
        learnKeyFromLesson(domain: LearnDomainType.life, lessonId: lesson.id),
      ),
    );

    LifeLesson? nextLesson;
    final ordered = lifeCurriculum.suggestedThemeOrder
        .expand((themeId) => lifeSubcategoriesForTheme(themeId))
        .expand((sub) => sub.lessonIds)
        .toList();
    final currentIndex = ordered.indexOf(lesson.id);
    if (currentIndex >= 0 && currentIndex < ordered.length - 1) {
      nextLesson = lifeLessonById(ordered[currentIndex + 1]);
    }

    final relatedLessonLinks = related
        .map(
          (item) => LearningRelatedLink(
            label: item.title,
            onTap: () => context.pushNamed(
              'lifeLessonDetail',
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
      headerIcon: Icons.menu_book_rounded,
      title: lesson.title,
      subtitle: lesson.subtitle,
      sections: [
        LearningSection(
          title: l10n.learnContentOverviewTitle,
          body: lesson.overview,
        ),
        LearningSection(
          title: l10n.lifeQuranicPerspectiveTitle,
          body: lesson.quranicPerspective,
        ),
        LearningSection(
          title: l10n.lifePracticalTakeawayTitle,
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
        LearningExpandableSection(
          title: l10n.lifeComparativeTeachingsTitle,
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
            title: l10n.lifeSuggestedNextLessonTitle,
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(nextLesson.title),
              subtitle: Text(nextLesson.subtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.pushNamed(
                'lifeLessonDetail',
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
                    LifeLessonStatus.inProgress,
                  ),
                  child: Text(l10n.lifeMarkInProgress),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.tonal(
                  onPressed: () =>
                      notifier.setStatus(lesson.id, LifeLessonStatus.completed),
                  child: Text(l10n.lifeMarkCompleted),
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
                            domain: LearnDomainType.life,
                            lessonId: lesson.id,
                            quality: item,
                          );
                          if (item == LearnCompletionQuality.notRead) {
                            notifier.setStatus(
                              lesson.id,
                              LifeLessonStatus.notStarted,
                            );
                          } else if (item == LearnCompletionQuality.read) {
                            notifier.setStatus(
                              lesson.id,
                              LifeLessonStatus.inProgress,
                            );
                          } else {
                            notifier.setStatus(
                              lesson.id,
                              LifeLessonStatus.completed,
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
            title: Text(l10n.lifeAddReflectionTitle),
            subtitle: Text(l10n.lifeAddReflectionSubtitle),
            trailing: const Icon(Icons.chevron_right),
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
