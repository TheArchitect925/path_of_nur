import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/quran_navigation.dart';
import '../application/quran_ayah_enrichment_provider.dart';
import '../application/quran_learning_progression_provider.dart';
import '../application/quran_learning_personalization_provider.dart';
import '../domain/quran_ayah_enrichment_models.dart';

/// The ayah-insight pathways, as a section: merged into the Qur'an Pathways
/// page in calm-navigation Phase 7a (the standalone list route redirects
/// there; per-path detail routes remain canonical).
class QuranAyahInsightPathsSection extends ConsumerWidget {
  const QuranAyahInsightPathsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final paths = ref.watch(quranAyahInsightPathsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.quranAyahInsightPathsTitle,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(l10n.quranAyahInsightPathsSubtitle),
        const SizedBox(height: 10),
        if (paths.isEmpty)
          PremiumCard(child: Text(l10n.quranAyahInsightPathsEmpty))
        else
          ...paths.map((path) {
            final progress = ref.watch(
              quranAyahInsightPathProgressProvider(path.id),
            );
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PremiumCard(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(_pathTitle(l10n, path.id)),
                  subtitle: Text(
                    '${_domainTitle(l10n, path.domain)} • ${l10n.quranAyahInsightPathsCount(path.count)}\n${_pathDescription(l10n, path.id)}${progress == null ? '' : '\n${l10n.quranAyahInsightPathsCompletedCount(progress.completedCount, progress.totalCount)}'}',
                  ),
                  isThreeLine: progress == null,
                  trailing: Icon(
                    progress?.isCompleted ?? false
                        ? Icons.check_circle_rounded
                        : Icons.chevron_right_rounded,
                  ),
                  onTap: () => context.pushNamed(
                    'quranAyahInsightsPathDetail',
                    pathParameters: {'pathId': path.id},
                  ),
                ),
              ),
            );
          }),
      ],
    );
  }
}

class QuranAyahInsightPathDetailPage extends ConsumerWidget {
  const QuranAyahInsightPathDetailPage({super.key, required this.pathId});

  final String pathId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final resolvedPath = ref.watch(quranAyahInsightPathProvider(pathId));
    final progress = ref.watch(quranAyahInsightPathProgressProvider(pathId));

    if (resolvedPath == null) {
      return AppPageScaffold(
        headerIcon: Icons.route_rounded,
        title: l10n.quranAyahInsightPathsTitle,
        subtitle: l10n.quranAyahInsightPathsSubtitle,
        children: [PremiumCard(child: Text(l10n.quranAyahInsightPathsEmpty))],
      );
    }

    final path = resolvedPath.path;
    final firstEntry = resolvedPath.entries.first;

    return AppPageScaffold(
      headerIcon: Icons.route_rounded,
      title: _pathTitle(l10n, path.id),
      subtitle: _pathDescription(l10n, path.id),
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_domainTitle(l10n, path.domain)} • ${l10n.quranAyahInsightPathsCount(resolvedPath.count)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (progress != null) ...[
                const SizedBox(height: 6),
                Text(
                  l10n.quranAyahInsightPathsCompletedCount(
                    progress.completedCount,
                    progress.totalCount,
                  ),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              if (path.reflectionFocusKey != null) ...[
                const SizedBox(height: 10),
                Text(
                  l10n.quranAyahInsightPathsReflectionFocusTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(_pathReflectionFocus(l10n, path.id)),
              ],
              const SizedBox(height: 12),
              FilledButton.tonalIcon(
                onPressed: () {
                  ref
                      .read(quranLearningPersonalizationStateProvider.notifier)
                      .markPathOpened(pathId: path.id, entryId: firstEntry.id);
                  openQuranReferenceLocation(context, ref: firstEntry.ref);
                },
                icon: const Icon(Icons.play_arrow_rounded),
                label: Text(l10n.quranAyahInsightPathsStartAction),
              ),
              if (progress?.isCompleted ?? false) ...[
                const SizedBox(height: 8),
                Chip(
                  label: Text(l10n.quranAyahInsightPathCompletedLabel),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 10),
        ...resolvedPath.entries.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isCompleted = ref.watch(
            quranLearningEntryCompletedProvider(item.id),
          );
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: PremiumCard(
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      radius: 16,
                      child: Text('${index + 1}'),
                    ),
                    title: Text(item.title),
                    subtitle: Text(
                      '${l10n.quranReferenceViewerReferenceLabel(item.ref.locationLabel)} • ${_lessonTypeLabel(l10n, item.lessonType)}\n${item.summary}',
                    ),
                    isThreeLine: true,
                    trailing: Icon(
                      isCompleted
                          ? Icons.check_circle_rounded
                          : Icons.chevron_right_rounded,
                    ),
                    onTap: () {
                      ref
                          .read(
                            quranLearningPersonalizationStateProvider.notifier,
                          )
                          .markPathOpened(pathId: path.id, entryId: item.id);
                      openQuranReferenceLocation(context, ref: item.ref);
                    },
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FilledButton.tonalIcon(
                      onPressed: isCompleted
                          ? null
                          : () {
                              ref
                                  .read(
                                    quranLearningProgressStateProvider.notifier,
                                  )
                                  .completeEntry(
                                    entry: item,
                                    sourcePathId: path.id,
                                    sourceSurface: 'path_detail',
                                  );
                            },
                      icon: Icon(
                        isCompleted
                            ? Icons.check_circle_rounded
                            : Icons.task_alt_rounded,
                      ),
                      label: Text(
                        isCompleted
                            ? l10n.quranLearningStudiedAction
                            : l10n.quranAyahInsightPathCompleteStepAction,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

String _pathTitle(AppLocalizations l10n, String pathId) {
  switch (pathId) {
    case 'signs-in-creation-starter':
      return l10n.quranAyahInsightPathTitleSignsInCreationStarter;
    case 'worship-remembrance-starter':
      return l10n.quranAyahInsightPathTitleWorshipRemembranceStarter;
    case 'character-adab-starter':
      return l10n.quranAyahInsightPathTitleCharacterAdabStarter;
    case 'tawhid-belief-starter':
      return l10n.quranAyahInsightPathTitleTawhidBeliefStarter;
    case 'akhirah-accountability-starter':
      return l10n.quranAyahInsightPathTitleAkhirahAccountabilityStarter;
    case 'prophets-lessons-starter':
      return l10n.quranAyahInsightPathTitleProphetsLessonsStarter;
    default:
      return l10n.quranAyahInsightPathsTitle;
  }
}

String _pathDescription(AppLocalizations l10n, String pathId) {
  switch (pathId) {
    case 'signs-in-creation-starter':
      return l10n.quranAyahInsightPathDescriptionSignsInCreationStarter;
    case 'worship-remembrance-starter':
      return l10n.quranAyahInsightPathDescriptionWorshipRemembranceStarter;
    case 'character-adab-starter':
      return l10n.quranAyahInsightPathDescriptionCharacterAdabStarter;
    case 'tawhid-belief-starter':
      return l10n.quranAyahInsightPathDescriptionTawhidBeliefStarter;
    case 'akhirah-accountability-starter':
      return l10n.quranAyahInsightPathDescriptionAkhirahAccountabilityStarter;
    case 'prophets-lessons-starter':
      return l10n.quranAyahInsightPathDescriptionProphetsLessonsStarter;
    default:
      return l10n.quranAyahInsightPathsSubtitle;
  }
}

String _pathReflectionFocus(AppLocalizations l10n, String pathId) {
  switch (pathId) {
    case 'signs-in-creation-starter':
      return l10n.quranAyahInsightPathReflectionSignsInCreationStarter;
    case 'worship-remembrance-starter':
      return l10n.quranAyahInsightPathReflectionWorshipRemembranceStarter;
    case 'character-adab-starter':
      return l10n.quranAyahInsightPathReflectionCharacterAdabStarter;
    case 'tawhid-belief-starter':
      return l10n.quranAyahInsightPathReflectionTawhidBeliefStarter;
    case 'akhirah-accountability-starter':
      return l10n.quranAyahInsightPathReflectionAkhirahAccountabilityStarter;
    case 'prophets-lessons-starter':
      return l10n.quranAyahInsightPathReflectionProphetsLessonsStarter;
    default:
      return '';
  }
}

String _domainTitle(AppLocalizations l10n, QuranAyahEnrichmentDomain domain) {
  return switch (domain) {
    QuranAyahEnrichmentDomain.signsInCreation ||
    QuranAyahEnrichmentDomain.worldNature =>
      l10n.quranAyahInsightsDomainSignsInCreation,
    QuranAyahEnrichmentDomain.worshipRemembrance =>
      l10n.quranAyahInsightsDomainWorshipRemembrance,
    QuranAyahEnrichmentDomain.characterAdab =>
      l10n.quranAyahInsightsDomainCharacterAdab,
    QuranAyahEnrichmentDomain.tawhidBelief =>
      l10n.quranAyahInsightsDomainTawhidBelief,
    QuranAyahEnrichmentDomain.akhirahAccountability =>
      l10n.quranAyahInsightsDomainAkhirahAccountability,
    QuranAyahEnrichmentDomain.prophetsLessons =>
      l10n.quranAyahInsightsDomainProphetsLessons,
    QuranAyahEnrichmentDomain.guidanceDailyLife =>
      l10n.quranAyahInsightsDomainGuidanceDailyLife,
  };
}

String _lessonTypeLabel(
  AppLocalizations l10n,
  QuranAyahEnrichmentLessonType lessonType,
) {
  switch (lessonType) {
    case QuranAyahEnrichmentLessonType.coreLesson:
      return l10n.quranAyahInsightsBrowseLessonTypeCoreLesson;
    case QuranAyahEnrichmentLessonType.reflection:
      return l10n.quranAyahInsightsBrowseLessonTypeReflection;
    case QuranAyahEnrichmentLessonType.practicalTakeaway:
      return l10n.quranAyahInsightsBrowseLessonTypePracticalTakeaway;
    case QuranAyahEnrichmentLessonType.warning:
      return l10n.quranAyahInsightsBrowseLessonTypeWarning;
    case QuranAyahEnrichmentLessonType.reminder:
      return l10n.quranAyahInsightsBrowseLessonTypeReminder;
    case QuranAyahEnrichmentLessonType.connection:
      return l10n.quranAyahInsightsBrowseLessonTypeConnection;
  }
}
