import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/quran_navigation.dart';
import '../../journey/data/learning_journey_localized_metadata.dart';
import '../../journey/data/learning_journey_registry.dart';
import '../../journey/data/learning_journey_theme_mapping.dart';
import '../../journey/domain/learning_journey_models.dart';
import '../application/quran_providers.dart';
import '../application/quran_reference_graph_provider.dart';
import '../domain/quran_reference_models.dart';
import '../domain/quran_surah.dart';
import 'quran_theme_copy.dart';

class QuranTopicExplorerPage extends ConsumerWidget {
  const QuranTopicExplorerPage({super.key, this.topicId});

  final String? topicId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final topics = ref.watch(quranTopicsProvider);
    final selectedTopic = topicId == null
        ? null
        : ref.watch(quranTopicByIdProvider(topicId!));

    return AppPageScaffold(
      headerIcon: Icons.account_tree_outlined,
      title: l10n.quranTopicsTitle,
      subtitle: l10n.quranThemeMapBrowseSubtitle,
      children: [
        if (selectedTopic == null)
          ...topics.map(
            (topic) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PremiumCard(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(localizedQuranTopicTitle(l10n, topic.id)),
                  subtitle: Text(
                    '${localizedQuranTopicDescription(l10n, topic.id)}\n${l10n.quranThemeMapStarterAyahCount(topic.verseReferences.length)}',
                  ),
                  isThreeLine: true,
                  trailing: const Icon(Icons.chevron_right_rounded),
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
    final l10n = AppLocalizations.of(context);
    final topic = ref.watch(quranTopicByIdProvider(topicId));
    final references = ref.watch(quranTopicReferencesProvider(topicId));
    final surahMap = ref.watch(quranSurahMapProvider);
    if (topic == null) {
      return PremiumCard(child: Text(l10n.quranThemeMapTopicNotFound));
    }

    final relatedSurahs = topic.relatedSurahNumbers
        .map((number) => surahMap[number])
        .whereType<QuranSurah>()
        .toList(growable: false);
    final relatedJourneyMappings = learningJourneyThemeMappingsForTopic(topic.id)
        .map((mapping) {
          final stage = LearningJourneyRegistry.stageById(mapping.stageId);
          final journey = LearningJourneyRegistry.journeyById(mapping.journeyId);
          if (stage == null || journey == null) return null;
          return (stage, journey);
        })
        .whereType<(LearningJourneyStage, LearningJourney)>()
        .toList(growable: false);
    QuranReference? primaryReference;
    if (topic.primaryReferenceId != null) {
      for (final reference in references) {
        if (reference.id == topic.primaryReferenceId) {
          primaryReference = reference;
          break;
        }
      }
    }
    primaryReference ??= references.isEmpty ? null : references.first;

    return Column(
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizedQuranTopicTitle(l10n, topic.id),
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(localizedQuranTopicDescription(l10n, topic.id)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _pill(
                    l10n.quranThemeMapAyahsLabel,
                    '${topic.verseReferences.length}',
                  ),
                  _pill(
                    l10n.quranThemeMapSurahsLabel,
                    '${relatedSurahs.length}',
                  ),
                  _pill(
                    l10n.quranThemeMapLearningLinksLabel,
                    '${topic.relatedRoutes.length}',
                  ),
                  _pill(
                    l10n.quranThemeMapBestModeLabel,
                    localizedQuranTopicModeLabel(
                      l10n,
                      topic.suggestedReaderMode,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                l10n.quranThemeMapWhyItMattersTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(localizedQuranTopicWhyItMatters(l10n, topic.id)),
              const SizedBox(height: 12),
              Text(
                l10n.quranThemeMapStudyFocusTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(localizedQuranTopicStudyFocus(l10n, topic.id)),
              if (primaryReference != null || topic.suggestedPathId != null) ...[
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    if (primaryReference != null)
                      Builder(
                        builder: (context) {
                          final reference = primaryReference!;
                          return FilledButton.tonalIcon(
                            onPressed: () => context.pushNamed(
                              'quranReader',
                              pathParameters: {
                                'surahNumber': reference.surahNumber
                                    .toString(),
                              },
                              queryParameters: {
                                'ayah': reference.ayahStart.toString(),
                                if (reference.ayahEnd > reference.ayahStart)
                                  'endAyah': reference.ayahEnd.toString(),
                                'mode': topic.suggestedReaderMode.wireName,
                                'topicId': topic.id,
                              },
                            ),
                            icon: const Icon(Icons.menu_book_rounded),
                            label: Text(l10n.quranThemeMapStudyThemeAction),
                          );
                        },
                      ),
                    if (topic.suggestedPathId?.trim().isNotEmpty ?? false)
                      TextButton.icon(
                        onPressed: () => context.pushNamed(
                          'quranLearningPathDetail',
                          pathParameters: {'pathId': topic.suggestedPathId!},
                        ),
                        icon: const Icon(Icons.route_rounded),
                        label: Text(l10n.quranThemeMapOpenPathAction),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
        if (references.isNotEmpty) ...[
          const SizedBox(height: 10),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.quranThemeMapRepresentativeAyahsTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                ...references.map(
                  (reference) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      l10n.quranReferenceViewerReferenceLabel(
                        reference.referenceLabel,
                      ),
                    ),
                    subtitle: Text(reference.contextSummary),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => openQuranAt(
                      context,
                      surahNumber: reference.surahNumber,
                      ayahNumber: reference.ayahStart,
                      endAyahNumber: reference.ayahEnd,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        if (relatedSurahs.isNotEmpty) ...[
          const SizedBox(height: 10),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.quranThemeMapRelatedSurahsTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: relatedSurahs
                      .map(
                        (surah) => ActionChip(
                          label: Text(surah.transliteratedName),
                          onPressed: () => context.pushNamed(
                            'quranReader',
                            pathParameters: {
                              'surahNumber': surah.number.toString(),
                            },
                          ),
                        ),
                      )
                      .toList(growable: false),
                ),
              ],
            ),
          ),
        ],
        if (relatedJourneyMappings.isNotEmpty) ...[
          const SizedBox(height: 10),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.quranReferenceViewerRelatedJourneys,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                ...relatedJourneyMappings.map((item) {
                  final stage = item.$1;
                  final journey = item.$2;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(localizedStageTitle(context, stage)),
                    subtitle: Text(localizedJourneyTitle(context, journey)),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.pushNamed(
                      'learnJourneyStage',
                      pathParameters: {
                        'journeyId': journey.id,
                        'stageId': stage.id,
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
        if (topic.relatedRoutes.isNotEmpty) ...[
          const SizedBox(height: 10),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.quranThemeMapRelatedLearningTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                ...topic.relatedRoutes.map(
                  (route) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(localizedQuranTopicRouteTitle(l10n, route)),
                    subtitle: Text(
                      localizedQuranTopicRouteSubtitle(l10n, route),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.pushNamed(
                      route.routeName,
                      pathParameters: route.pathParameters,
                      queryParameters: route.queryParameters,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
