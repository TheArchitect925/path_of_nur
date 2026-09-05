import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_surfaces.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/quran_navigation.dart';
import '../../../../shared/widgets/quran_verse_content.dart';
import '../../journey/data/learning_journey_localized_metadata.dart';
import '../../journey/data/learning_journey_registry.dart';
import '../application/quran_daily_reflection_provider.dart';
import '../application/quran_guided_learning_paths_provider.dart';
import '../application/quran_learning_system_service.dart';
import '../application/quran_learning_progression_provider.dart';
import '../application/quran_reflections_provider.dart';
import '../application/quran_user_intent_provider.dart';
import '../domain/quran_ayah_enrichment_models.dart';
import '../domain/quran_daily_companion_models.dart';
import '../domain/quran_guided_learning_path_models.dart';
import '../domain/quran_reflection_entry.dart';
import '../domain/quran_reference_models.dart';
import '../domain/quran_user_intent_models.dart';
import 'quran_theme_copy.dart';
import 'widgets/quran_daily_reflection_card.dart';
import 'widgets/quran_reflection_note_dialog.dart';
import 'widgets/quran_related_reference_detail_sheet.dart';
import '../../../../core/theme/app_icons.dart';

class QuranDailyCompanionPage extends ConsumerWidget {
  const QuranDailyCompanionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final summary = ref.watch(quranDailyCompanionSummaryProvider);
    final intentSummary = ref.watch(quranUserIntentSummaryProvider);
    final reflection = summary.reflection;
    final entry = reflection.assignment.entry;
    final savedEntry = ref.watch(
      quranReflectionsProvider.select(
        (items) => findSavedDailyReflection(
          items,
          ref: entry.ref,
          sourceEnrichmentId: entry.id,
        ),
      ),
    );

    return AppPageScaffold(
      headerIcon: AppIcons.daily,
      title: l10n.quranDailyCompanionTitle,
      subtitle: l10n.quranDailyCompanionSubtitle,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.quranDailyCompanionTodayTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                reflection.assignment.entry.ref.locationLabel,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (reflection.currentStreak > 0)
                    _CompanionMetaChip(
                      label: l10n.quranDailyReflectionStreakValue(
                        reflection.currentStreak,
                      ),
                    ),
                  if (summary.isMemorized)
                    _CompanionMetaChip(
                      label: l10n.quranDailyCompanionMemorizedLabel,
                    ),
                  if (summary.themes.isNotEmpty)
                    _CompanionMetaChip(
                      label: localizedQuranTopicTitle(
                        l10n,
                        summary.themes.first.id,
                      ),
                    ),
                  if (summary.activeIntent != null)
                    _CompanionMetaChip(
                      label: _quranUserIntentLabel(l10n, summary.activeIntent!),
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const QuranDailyReflectionCard(
          showCompanionAction: false,
          showSecondaryActions: false,
        ),
        const SizedBox(height: 10),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.quranDailyCompanionMeaningTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () =>
                    openQuranReferenceLocation(context, ref: entry.ref),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: QuranVerseContent(
                    source: QuranVerseSource(
                      ref: entry.ref,
                      referenceText: entry.ref.locationLabel,
                    ),
                    center: false,
                    dense: true,
                    arabicBaseSize: 28,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                summary.meaningCue,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                reflection.primaryPrompt,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        if (summary.themes.isNotEmpty)
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.quranDailyCompanionThemeTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  localizedQuranTopicTitle(l10n, summary.themes.first.id),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(summary.themes.first.description),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () => context.pushNamed(
                    'quranTopicDetail',
                    pathParameters: {'topicId': summary.themes.first.id},
                  ),
                  icon: const Icon(Icons.account_tree_rounded),
                  label: Text(l10n.quranDailyCompanionOpenThemeAction),
                ),
              ],
            ),
          ),
        if (summary.themes.isNotEmpty) const SizedBox(height: 10),
        if (summary.journeyContext != null)
          _DailyJourneyConnectionCard(summary: summary),
        if (summary.journeyContext != null) const SizedBox(height: 10),
        if (summary.relatedLinks.isNotEmpty)
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.quranDailyCompanionRelatedInsightTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                ...summary.relatedLinks.map(
                  (link) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(link.title),
                      subtitle: Text(
                        '${quranKnowledgeTypeLabel(l10n, link.knowledgeType)} • ${link.subtitle}',
                      ),
                      onTap: () => showQuranRelatedKnowledgeDetailSheet(
                        context,
                        link: link,
                        anchorLabel: entry.ref.locationLabel,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        if (summary.relatedLinks.isNotEmpty) const SizedBox(height: 10),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.quranDailyCompanionTakeawayTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(summary.practicalTakeaway),
            ],
          ),
        ),
        const SizedBox(height: 10),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.quranDailyCompanionContinueTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _buildContinueActions(
                  context,
                  ref,
                  l10n: l10n,
                  entry: entry,
                  summary: summary,
                  intentSummary: intentSummary,
                  savedEntry: savedEntry,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

List<Widget> _buildContinueActions(
  BuildContext context,
  WidgetRef ref, {
  required AppLocalizations l10n,
  required QuranAyahEnrichmentEntry entry,
  required QuranDailyCompanionSummary summary,
  required QuranUserIntentSummary intentSummary,
  required QuranReflectionEntry? savedEntry,
}) {
  final actions = <Widget>[];

  void addOpenReader({required QuranReaderStudyMode mode}) {
    actions.add(
      FilledButton.tonalIcon(
        onPressed: () => context.pushNamed(
          'quranReader',
          pathParameters: {'surahNumber': entry.ref.surah.toString()},
          queryParameters: {
            'ayah': entry.ref.ayah.toString(),
            'mode': mode.wireName,
            if (summary.themes.isNotEmpty) 'topicId': summary.themes.first.id,
          },
        ),
        icon: const Icon(Icons.auto_stories_rounded),
        label: Text(l10n.quranDailyCompanionOpenReaderAction),
      ),
    );
  }

  switch (summary.activeIntent) {
    case QuranUserIntent.reflect:
      addOpenReader(mode: QuranReaderStudyMode.reflection);
      break;
    case QuranUserIntent.memorize:
      if (summary.isMemorized) {
        actions.add(
          FilledButton.tonalIcon(
            onPressed: () => context.pushNamed('quranMemorizationReview'),
            icon: const Icon(Icons.repeat_rounded),
            label: Text(l10n.quranDailyCompanionReviewMemoryAction),
          ),
        );
      } else {
        actions.add(
          FilledButton.tonalIcon(
            onPressed: () {
              ref
                  .read(quranMemorizationProgressProvider.notifier)
                  .toggleVerse(
                    surahNumber: entry.ref.surah,
                    ayahNumber: entry.ref.ayah,
                  );
            },
            icon: const Icon(Icons.bookmark_add_rounded),
            label: Text(l10n.quranMemorizationMarkAction),
          ),
        );
      }
      addOpenReader(mode: QuranReaderStudyMode.memorization);
      break;
    case QuranUserIntent.themes:
      if (summary.themes.isNotEmpty) {
        actions.add(
          FilledButton.tonalIcon(
            onPressed: () => context.pushNamed(
              'quranTopicDetail',
              pathParameters: {'topicId': summary.themes.first.id},
            ),
            icon: const Icon(Icons.account_tree_rounded),
            label: Text(l10n.quranDailyCompanionOpenThemeAction),
          ),
        );
      }
      addOpenReader(
        mode: summary.themes.isNotEmpty
            ? QuranReaderStudyMode.theme
            : QuranReaderStudyMode.study,
      );
      break;
    case QuranUserIntent.guidedPath:
      if (intentSummary.suggestedPath != null) {
        actions.add(
          FilledButton.tonalIcon(
            onPressed: () =>
                _openSuggestedPath(context, ref, intentSummary.suggestedPath!),
            icon: const Icon(Icons.route_rounded),
            label: Text(
              summary.continuePath != null
                  ? l10n.quranLearningPathsOpenContinueAction
                  : l10n.quranDailyCompanionPathAction,
            ),
          ),
        );
      }
      addOpenReader(mode: QuranReaderStudyMode.study);
      break;
    case QuranUserIntent.understand:
      addOpenReader(
        mode:
            summary.journeyContext?.suggestedReaderMode ??
            QuranReaderStudyMode.study,
      );
      break;
    case null:
      addOpenReader(
        mode:
            summary.journeyContext?.suggestedReaderMode ??
            QuranReaderStudyMode.reading,
      );
      break;
  }

  if (summary.themes.isNotEmpty &&
      summary.activeIntent != QuranUserIntent.themes) {
    actions.add(
      OutlinedButton.icon(
        onPressed: () => context.pushNamed(
          'quranTopicDetail',
          pathParameters: {'topicId': summary.themes.first.id},
        ),
        icon: const Icon(Icons.account_tree_rounded),
        label: Text(l10n.quranDailyCompanionOpenThemeAction),
      ),
    );
  }

  if (summary.activeIntent != QuranUserIntent.memorize) {
    if (summary.isMemorized) {
      actions.add(
        OutlinedButton.icon(
          onPressed: () => context.pushNamed('quranMemorizationReview'),
          icon: const Icon(Icons.repeat_rounded),
          label: Text(l10n.quranDailyCompanionReviewMemoryAction),
        ),
      );
    } else {
      actions.add(
        OutlinedButton.icon(
          onPressed: () {
            ref
                .read(quranMemorizationProgressProvider.notifier)
                .toggleVerse(
                  surahNumber: entry.ref.surah,
                  ayahNumber: entry.ref.ayah,
                );
          },
          icon: const Icon(Icons.bookmark_add_rounded),
          label: Text(l10n.quranMemorizationMarkAction),
        ),
      );
    }
  }

  if (intentSummary.suggestedPath != null &&
      summary.activeIntent != QuranUserIntent.guidedPath) {
    actions.add(
      OutlinedButton.icon(
        onPressed: () =>
            _openSuggestedPath(context, ref, intentSummary.suggestedPath!),
        icon: const Icon(Icons.route_rounded),
        label: Text(
          summary.continuePath != null
              ? l10n.quranLearningPathsOpenContinueAction
              : l10n.quranDailyCompanionPathAction,
        ),
      ),
    );
  }

  actions.add(
    OutlinedButton.icon(
      onPressed: () async {
        final note = await showQuranReflectionNoteDialog(
          context,
          title: savedEntry?.note?.trim().isNotEmpty ?? false
              ? l10n.quranReflectionsEditNoteAction
              : l10n.quranReflectionsAddNoteAction,
          initialNote: savedEntry?.note,
        );
        if (note == null) return;
        ref
            .read(quranReflectionsProvider.notifier)
            .upsertNote(
              ref: entry.ref,
              sourceType: QuranReflectionSourceType.dailyAyah,
              title: entry.title,
              summary: entry.summary,
              sourceEnrichmentId: entry.id,
              note: note,
            );
        if (note.trim().isNotEmpty) {
          ref
              .read(quranLearningProgressStateProvider.notifier)
              .rewardFirstReflectionNote(
                ref: entry.ref,
                sourceEnrichmentId: entry.id,
                sourceSurface: 'daily_reflection',
              );
        }
      },
      icon: const Icon(Icons.edit_note_rounded),
      label: Text(
        savedEntry?.note?.trim().isNotEmpty ?? false
            ? l10n.quranReflectionsEditNoteAction
            : l10n.quranReflectionsAddNoteAction,
      ),
    ),
  );

  actions.add(
    OutlinedButton.icon(
      onPressed: () => context.pushNamed('quran'),
      icon: const Icon(Icons.tune_rounded),
      label: Text(l10n.quranUserIntentChangeAction),
    ),
  );

  return actions;
}

class _DailyJourneyConnectionCard extends ConsumerWidget {
  const _DailyJourneyConnectionCard({required this.summary});

  final QuranDailyCompanionSummary summary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final journeyContext = summary.journeyContext;
    if (journeyContext == null) {
      return const SizedBox.shrink();
    }

    final journey = LearningJourneyRegistry.journeyById(
      journeyContext.journeyId,
    );
    final stage = LearningJourneyRegistry.stageById(journeyContext.stageId);
    if (journey == null || stage == null) {
      return const SizedBox.shrink();
    }

    final themeTitle = summary.themes.isNotEmpty
        ? localizedQuranTopicTitle(l10n, summary.themes.first.id)
        : null;

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.quranDailyCompanionJourneyTitle,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _CompanionMetaChip(
                label: localizedJourneyTitle(context, journey),
              ),
              _CompanionMetaChip(label: localizedStageTitle(context, stage)),
              if (summary.selectionSource ==
                  QuranDailyLoopSelectionSource.journeyTheme)
                _CompanionMetaChip(
                  label: l10n.quranDailyCompanionJourneyAlignedLabel,
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            themeTitle == null
                ? l10n.quranDailyCompanionJourneyBodyNoTheme
                : l10n.quranDailyCompanionJourneyBody(themeTitle),
          ),
          const SizedBox(height: 10),
          FilledButton.tonalIcon(
            onPressed: () => context.pushNamed(
              'learnJourneyStage',
              pathParameters: {'journeyId': journey.id, 'stageId': stage.id},
            ),
            icon: const Icon(Icons.route_rounded),
            label: Text(l10n.quranDailyCompanionJourneyAction),
          ),
        ],
      ),
    );
  }
}

String _quranUserIntentLabel(AppLocalizations l10n, QuranUserIntent intent) {
  return switch (intent) {
    QuranUserIntent.understand => l10n.quranUserIntentUnderstandLabel,
    QuranUserIntent.reflect => l10n.quranUserIntentReflectLabel,
    QuranUserIntent.memorize => l10n.quranUserIntentMemorizeLabel,
    QuranUserIntent.themes => l10n.quranUserIntentThemesLabel,
    QuranUserIntent.guidedPath => l10n.quranUserIntentGuidedPathLabel,
  };
}

void _openSuggestedPath(
  BuildContext context,
  WidgetRef ref,
  QuranGuidedLearningPath path,
) {
  final firstStep = path.steps.first;
  ref
      .read(quranGuidedLearningContinuityProvider.notifier)
      .markStepOpened(pathId: path.id, stepId: firstStep.id);
  context.pushNamed(
    'quranLearningPathDetail',
    pathParameters: {'pathId': path.id},
  );
}

class _CompanionMetaChip extends StatelessWidget {
  const _CompanionMetaChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final style = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.pill,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: style.decoration(radius: 999, includeShadow: false),
      child: Text(label),
    );
  }
}
