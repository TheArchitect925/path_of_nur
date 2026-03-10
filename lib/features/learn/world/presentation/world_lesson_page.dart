import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../shared/application/learn_enhancements_provider.dart';
import '../../shared/application/learn_unified_provider.dart';
import '../../shared/domain/learn_unified_models.dart';
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
        headerIcon: Icons.article_outlined,
        title: l10n.learnWorldSectionTitle,
        subtitle: l10n.learnContentNotFound,
        children: [PremiumCard(child: Text(l10n.learnContentNotFound))],
      );
    }

    final notifier = ref.read(worldProgressProvider.notifier);
    final qualityNotifier = ref.read(learnQualityProvider.notifier);
    final progress = ref
        .watch(worldProgressProvider)
        .lessonProgressById[lesson.id];
    final quality = ref.watch(
      learnQualityProvider.select(
        (state) =>
            state.byLessonKey['${LearnDomainType.world.name}:${lesson.id}'] ??
            LearnCompletionQuality.notRead,
      ),
    );
    final sub = worldSubcategoryById(lesson.subcategoryId);
    final theme = worldThemeById(lesson.themeId);

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

    return AppPageScaffold(
      headerIcon: Icons.menu_book_rounded,
      title: lesson.title,
      subtitle: lesson.subtitle,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${l10n.worldThemeLabel}: ${theme?.title ?? ''}'),
              Text('${l10n.worldSubcategoryLabel}: ${sub?.title ?? ''}'),
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
          title: l10n.worldQuranicPerspectiveTitle,
          body: lesson.quranicPerspective,
        ),
        _SectionCard(
          title: l10n.worldReflectiveTakeawayTitle,
          body: lesson.reflectiveTakeaway,
        ),
        _SectionCard(
          title: l10n.worldPracticalTakeawayTitle,
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
        if (lesson.observationPrompt != null)
          _SectionCard(
            title: l10n.worldObservationPromptTitle,
            body: lesson.observationPrompt,
          ),
        _ExpandableSectionCard(
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
                      'worldLessonDetail',
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
            title: l10n.worldSuggestedNextLessonTitle,
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(nextLesson.title),
              subtitle: Text(nextLesson.subtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.pushNamed(
                'worldLessonDetail',
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
                            domain: LearnDomainType.world,
                            lessonId: lesson.id,
                            quality: item,
                          );
                          if (item == LearnCompletionQuality.notRead) {
                            notifier.setStatus(lesson.id, WorldLessonStatus.notStarted);
                          } else if (item == LearnCompletionQuality.read) {
                            notifier.setStatus(lesson.id, WorldLessonStatus.inProgress);
                          } else {
                            notifier.setStatus(lesson.id, WorldLessonStatus.completed);
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
            title: Text(l10n.worldAddReflectionTitle),
            subtitle: Text(l10n.worldAddReflectionSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.pushNamed('journalCreate'),
          ),
        ),
        const SizedBox(height: 10),
        PremiumCard(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.worldObservationCtaTitle),
            subtitle: Text(l10n.worldObservationCtaSubtitle),
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

  String _statusLabel(AppLocalizations l10n, WorldLessonStatus? status) {
    switch (status ?? WorldLessonStatus.notStarted) {
      case WorldLessonStatus.notStarted:
        return l10n.worldStatusNotStarted;
      case WorldLessonStatus.inProgress:
        return l10n.worldStatusInProgress;
      case WorldLessonStatus.completed:
        return l10n.worldStatusCompleted;
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
