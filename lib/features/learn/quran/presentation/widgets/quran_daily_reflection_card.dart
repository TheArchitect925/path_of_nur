import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/app_surfaces.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/app_layered_glass_pill_button.dart';
import '../../../../../shared/widgets/app_hero_glass_shell.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../../../../../shared/widgets/quran_navigation.dart';
import '../../../../../shared/widgets/quran_verse_content.dart';
import '../../application/quran_ayah_enrichment_provider.dart';
import '../../application/quran_ayah_action_provider.dart';
import '../../application/quran_daily_reflection_provider.dart';
import '../../application/quran_learning_progression_provider.dart';
import '../../application/quran_learning_share_service.dart';
import '../../application/quran_reflections_provider.dart';
import '../../domain/quran_ayah_enrichment_models.dart';
import '../../domain/quran_content_refs.dart';
import '../../domain/quran_reflection_entry.dart';
import 'quran_reflection_note_dialog.dart';
import 'quran_ayah_action_section.dart';

class QuranDailyReflectionCard extends ConsumerWidget {
  const QuranDailyReflectionCard({
    super.key,
    this.compact = false,
    this.showCompanionAction = true,
    this.showSecondaryActions = true,
    this.useHeroGlassShell = false,
  });

  final bool compact;
  final bool showCompanionAction;
  final bool showSecondaryActions;
  final bool useHeroGlassShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;
    final summary = ref.watch(quranDailyReflectionSummaryProvider);
    final actionRecommendation = ref.watch(
      quranPrimaryDailyAyahActionRecommendationProvider,
    );
    final assignment = summary.assignment;
    final entry = assignment.entry.localizedCopy(languageCode);
    final localizedInsightItems = ref.watch(
      quranAyahDisplayItemsForRangeLocalizedProvider((entry.ref, languageCode)),
    );
    final savedEntry = ref.watch(
      quranReflectionsProvider.select(
        (items) => findSavedDailyReflection(
          items,
          ref: entry.ref,
          sourceEnrichmentId: entry.id,
        ),
      ),
    );
    final spacing = compact ? 10.0 : 12.0;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    compact && showCompanionAction
                        ? l10n.quranAyahActionTodayTitle
                        : compact
                        ? l10n.quranDailyCompanionTitle
                        : l10n.quranDailyReflectionTitle,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    compact && showCompanionAction
                        ? l10n.quranAyahActionDailySubtitle
                        : compact
                        ? l10n.quranDailyCompanionCardSubtitle
                        : assignment.isFirstTimeStarter
                        ? l10n.quranDailyReflectionStarterSubtitle
                        : l10n.quranDailyReflectionSubtitle,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            if (summary.currentStreak > 0)
              _Badge(
                icon: Icons.local_fire_department_outlined,
                label: l10n.quranDailyReflectionStreakValue(
                  summary.currentStreak,
                ),
              ),
          ],
        ),
        SizedBox(height: spacing),
        InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () => openQuranReferenceLocation(context, ref: entry.ref),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: QuranVerseContent(
              source: QuranVerseSource(
                ref: entry.ref,
                referenceText: entry.ref.locationLabel,
              ),
              center: false,
              dense: compact,
              arabicBaseSize: compact ? 28 : 30,
            ),
          ),
        ),
        SizedBox(height: spacing),
        Text(
          l10n.quranDailyReflectionInsightsTitle,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        _InsightLine(
          label: _typeLabel(l10n, entry.displayType),
          title: entry.title,
          summary: entry.summary,
        ),
        for (final item in localizedInsightItems)
          if (item.sourceEnrichmentId != entry.id)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: _InsightLine(
                label: _typeLabel(l10n, item.type),
                title: item.title,
                summary: item.summary,
                caution: item.cautionLevel != QuranAyahCautionLevel.none
                    ? l10n.quranAyahInsightsCautionLabel
                    : null,
              ),
            ),
        SizedBox(height: spacing),
        Text(
          l10n.quranDailyReflectionPromptTitle,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(
          summary.primaryPrompt,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        if (actionRecommendation != null) ...[
          SizedBox(height: spacing),
          QuranAyahActionSection(
            recommendation: actionRecommendation,
            style: QuranAyahActionSectionStyle.daily,
            showExplanationPreview: compact,
          ),
        ],
        SizedBox(height: spacing),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (showCompanionAction)
              AppLayeredGlassPillButton(
                onPressed: () => context.pushNamed('quranDailyCompanion'),
                leading: const Icon(Icons.wb_twilight_rounded, size: 18),
                label: l10n.quranDailyCompanionOpenAction,
              ),
            AppLayeredGlassPillButton(
              onPressed: () =>
                  openQuranReferenceLocation(context, ref: entry.ref),
              leading: const Icon(Icons.auto_stories_rounded, size: 18),
              label: l10n.quranDailyReflectionOpenAyahAction,
            ),
            if (showSecondaryActions)
              OutlinedButton.icon(
                onPressed: () {
                  ref
                      .read(quranReflectionsProvider.notifier)
                      .toggleSaved(
                        ref: entry.ref,
                        sourceType: QuranReflectionSourceType.dailyAyah,
                        title: entry.title,
                        summary: entry.summary,
                        sourceEnrichmentId: entry.id,
                      );
                },
                icon: Icon(
                  savedEntry == null
                      ? Icons.bookmark_add_outlined
                      : Icons.bookmark_rounded,
                ),
                label: Text(
                  savedEntry == null
                      ? l10n.quranReflectionsSaveAction
                      : l10n.quranReflectionsSavedAction,
                ),
              ),
            if (showSecondaryActions)
              OutlinedButton.icon(
                onPressed: () {
                  final text =
                      QuranLearningShareService.buildAyahInsightShareText(
                        ref: entry.ref,
                        title: entry.title,
                        summary: entry.summary,
                        attribution: l10n.quranLearningShareAttribution,
                        reflectionLabel: l10n.quranLearningShareReflectionLabel,
                        reflectionPrompt: summary.primaryPrompt,
                      );
                  QuranLearningShareService.shareText(text);
                },
                icon: const Icon(Icons.ios_share_rounded),
                label: Text(l10n.quranLearningShareAction),
              ),
            if (showSecondaryActions)
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
            summary.isCompletedToday
                ? AppLayeredGlassPillButton(
                    onPressed: null,
                    leading: const Icon(Icons.check_circle_rounded, size: 18),
                    label: l10n.quranDailyReflectionCompletedAction,
                  )
                : AppLayeredGlassPillButton(
                    onPressed: () => ref
                        .read(quranDailyReflectionStateProvider.notifier)
                        .completeToday(assignment: assignment),
                    leading: const Icon(Icons.done_rounded, size: 18),
                    label: l10n.quranDailyReflectionCompleteAction,
                  ),
          ],
        ),
        if (!summary.hasHistory) ...[
          const SizedBox(height: 10),
          Text(
            l10n.quranDailyReflectionFirstTimeHint,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ] else if (summary.bestStreak > 0) ...[
          const SizedBox(height: 10),
          Text(
            l10n.quranDailyReflectionBestStreakValue(summary.bestStreak),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ],
    );
    if (useHeroGlassShell) {
      return AppHeroGlassShell(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 30),
        tintColor: const Color(0xFFE7C98C),
        surfaceAlphaOverride: 0.2,
        radius: 36,
        borderColor: const Color(0x42FFFFFF),
        highlightGradientColors: const [
          Color(0x24FFFFFF),
          Colors.transparent,
          Color(0x16E8C98F),
        ],
        child: content,
      );
    }
    return PremiumCard(
      surfaceTreatment: AppSurfaceTreatment.denseSanctuary,
      surfaceVariant: AppSurfaceVariant.panel,
      child: content,
    );
  }
}

QuranReflectionEntry? findSavedDailyReflection(
  List<QuranReflectionEntry> items, {
  required QuranQuoteRef ref,
  String? sourceEnrichmentId,
}) {
  for (final item in items) {
    if (sourceEnrichmentId != null && item.sourceEnrichmentId != null) {
      if (item.sourceEnrichmentId == sourceEnrichmentId) return item;
      continue;
    }
    final itemRef = item.ref;
    if (itemRef == null) {
      continue;
    }
    if (itemRef.surah == ref.surah &&
        itemRef.ayah == ref.ayah &&
        itemRef.ayahEnd == ref.ayahEnd) {
      return item;
    }
  }
  return null;
}

class _InsightLine extends StatelessWidget {
  const _InsightLine({
    required this.label,
    required this.title,
    required this.summary,
    this.caution,
  });

  final String label;
  final String title;
  final String summary;
  final String? caution;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 4),
          child: Icon(Icons.circle, size: 8),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(summary, style: theme.textTheme.bodySmall),
              if (caution != null) ...[
                const SizedBox(height: 4),
                Text(caution!, style: theme.textTheme.labelSmall),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 6),
            Text(label),
          ],
        ),
      ),
    );
  }
}

String _typeLabel(AppLocalizations l10n, QuranAyahDisplayItemType? type) {
  switch (type) {
    case QuranAyahDisplayItemType.hadithReference:
      return l10n.quranAyahInsightsTypeHadithReference;
    case QuranAyahDisplayItemType.signsInCreation:
      return l10n.quranAyahInsightsTypeSignsInCreation;
    case QuranAyahDisplayItemType.scientificReflection:
      return l10n.quranAyahInsightsTypeScientificReflection;
    case QuranAyahDisplayItemType.worldCreationLesson:
      return l10n.quranAyahInsightsTypeWorldCreationLesson;
    case QuranAyahDisplayItemType.worshipLesson:
      return l10n.quranAyahInsightsTypeWorshipLesson;
    case QuranAyahDisplayItemType.characterLesson:
      return l10n.quranAyahInsightsTypeCharacterLesson;
    case QuranAyahDisplayItemType.prophetConnection:
      return l10n.quranAyahInsightsTypeProphetConnection;
    case QuranAyahDisplayItemType.relatedAyah:
      return l10n.quranAyahInsightsTypeRelatedAyah;
    case QuranAyahDisplayItemType.reflectionPrompt:
      return l10n.quranAyahInsightsTypeReflectionPrompt;
    case QuranAyahDisplayItemType.interpretationNote:
      return l10n.quranAyahInsightsTypeInterpretationNote;
    case QuranAyahDisplayItemType.ayahInsight:
    case null:
      return l10n.quranAyahInsightsTypeAyahInsight;
  }
}
