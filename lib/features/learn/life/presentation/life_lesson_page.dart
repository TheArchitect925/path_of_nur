import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../shared/application/learn_enhancements_provider.dart';
import '../../shared/application/learn_unified_provider.dart';
import '../../shared/domain/learn_unified_models.dart';
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
    final progress = ref
        .watch(lifeProgressProvider)
        .lessonProgressById[lesson.id];
    final quality = ref.watch(
      learnQualityProvider.select(
        (state) =>
            state.byLessonKey['${LearnDomainType.life.name}:${lesson.id}'] ??
            LearnCompletionQuality.notRead,
      ),
    );
    final sub = lifeSubcategoryById(lesson.subcategoryId);
    final theme = lifeThemeById(lesson.themeId);

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

    return AppPageScaffold(
      headerIcon: Icons.menu_book_rounded,
      title: lesson.title,
      subtitle: lesson.subtitle,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${l10n.lifeThemeLabel}: ${theme?.title ?? ''}'),
              Text('${l10n.lifeSubcategoryLabel}: ${sub?.title ?? ''}'),
              const SizedBox(height: 6),
              Text(_statusLabel(l10n, progress?.status)),
              const SizedBox(height: 4),
              Text(
                l10n.learnQualityLabel(_qualityLabel(l10n, quality)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _SectionCard(
          title: l10n.learnContentOverviewTitle,
          body: lesson.overview,
        ),
        _SectionCard(
          title: l10n.lifeQuranicPerspectiveTitle,
          body: lesson.quranicPerspective,
        ),
        _SectionCard(
          title: l10n.lifePracticalTakeawayTitle,
          body: lesson.practicalTakeaway,
        ),
        _SectionCard(
          title: l10n.learnContentThemesTitle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: lesson.keyConcepts
                .map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text('• $item'),
                  ),
                )
                .toList(),
          ),
        ),
        _SectionCard(
          title: l10n.learnContentReflectionPromptTitle,
          body: lesson.reflectionPrompt,
        ),
        _ExpandableSectionCard(
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
        _SectionCard(
          title: l10n.learnContentRelatedTopicsTitle,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: related
                .map(
                  (item) => ActionChip(
                    label: Text(item.title),
                    onPressed: () => context.pushNamed(
                      'lifeLessonDetail',
                      pathParameters: {'lessonId': item.id},
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        if (crossDomainRelated.isNotEmpty)
          _SectionCard(
            title: l10n.learnContentReferencesTitle,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: crossDomainRelated
                  .map(
                    (item) => ActionChip(
                      label: Text(item.title),
                      onPressed: () => context.pushNamed(
                        item.routeName,
                        pathParameters: item.pathParameters,
                        queryParameters: item.queryParameters,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        if (citations.isNotEmpty)
          _ExpandableSectionCard(
            title: l10n.learnCitationPanelTitle,
            child: Column(
              children: citations
                  .map(
                    (citation) => Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F3EA),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  citation.sourceTitle,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEDE2D3),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  citation.qualityBadge,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(citation.confidenceNote),
                          if (citation.reference != null &&
                              citation.reference!.trim().isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              citation.reference!,
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
        if (nextLesson != null)
          _SectionCard(
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
        const SizedBox(height: 8),
        PremiumCard(
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
        const SizedBox(height: 10),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.learnCompletionQualityTitle,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
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
                            notifier.setStatus(lesson.id, LifeLessonStatus.notStarted);
                          } else if (item == LearnCompletionQuality.read) {
                            notifier.setStatus(lesson.id, LifeLessonStatus.inProgress);
                          } else {
                            notifier.setStatus(lesson.id, LifeLessonStatus.completed);
                          }
                        },
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        PremiumCard(
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

  String _statusLabel(AppLocalizations l10n, LifeLessonStatus? status) {
    switch (status ?? LifeLessonStatus.notStarted) {
      case LifeLessonStatus.notStarted:
        return l10n.lifeStatusNotStarted;
      case LifeLessonStatus.inProgress:
        return l10n.lifeStatusInProgress;
      case LifeLessonStatus.completed:
        return l10n.lifeStatusCompleted;
    }
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, this.body, this.child});

  final String title;
  final String? body;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            switch (body) {
              final text? => Text(text),
              null => const SizedBox.shrink(),
            },
            switch (child) {
              final section? => section,
              null => const SizedBox.shrink(),
            },
          ],
        ),
      ),
    );
  }
}

class _ExpandableSectionCard extends StatelessWidget {
  const _ExpandableSectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: PremiumCard(
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          childrenPadding: const EdgeInsets.only(top: 8),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          children: [child],
        ),
      ),
    );
  }
}
