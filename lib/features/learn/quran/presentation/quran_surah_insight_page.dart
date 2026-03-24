import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/quran_navigation.dart';
import '../application/quran_learning_share_service.dart';
import '../application/quran_surah_insights_provider.dart';
import '../domain/quran_ayah_enrichment_models.dart';
import '../domain/quran_surah_insight_models.dart';
import 'quran_theme_copy.dart';

class QuranSurahInsightsBrowsePage extends ConsumerWidget {
  const QuranSurahInsightsBrowsePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final insights = ref.watch(quranSurahInsightsBrowseProvider);

    return AppPageScaffold(
      headerIcon: Icons.layers_outlined,
      title: l10n.quranSurahInsightsBrowseTitle,
      subtitle: l10n.quranSurahInsightsBrowseSubtitle,
      children: [
        if (insights.isEmpty)
          PremiumCard(child: Text(l10n.quranSurahInsightsEmpty))
        else
          ...insights.map(
            (insight) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PremiumCard(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    '${insight.surah.transliteratedName} • ${insight.surah.arabicName}',
                  ),
                  subtitle: Text(
                    '${insight.surah.englishName} • ${l10n.quranSurahInsightsClusterCount(insight.clusters.length)}\n${_surahDescription(l10n, insight.definition.descriptionId)}',
                  ),
                  isThreeLine: true,
                  onTap: () => context.pushNamed(
                    'quranSurahInsights',
                    pathParameters: {
                      'surahNumber': insight.surah.number.toString(),
                    },
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class QuranSurahInsightPage extends ConsumerWidget {
  const QuranSurahInsightPage({super.key, required this.surahNumber});

  final int surahNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final insight = ref.watch(quranSurahInsightProvider(surahNumber));

    if (insight == null) {
      return AppPageScaffold(
        headerIcon: Icons.layers_outlined,
        title: l10n.quranSurahInsightsBrowseTitle,
        subtitle: l10n.quranSurahInsightsBrowseSubtitle,
        children: [PremiumCard(child: Text(l10n.quranSurahInsightsEmpty))],
      );
    }

    return AppPageScaffold(
      headerIcon: Icons.layers_outlined,
      title:
          '${insight.surah.transliteratedName} • ${insight.surah.arabicName}',
      subtitle: insight.surah.englishName,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton.icon(
                  onPressed: () {
                    final text =
                        QuranLearningShareService.buildSurahInsightShareText(
                          insight: insight,
                          description: _surahDescription(
                            l10n,
                            insight.definition.descriptionId,
                          ),
                          themes: _surahThemes(
                            l10n,
                            insight.definition.themeIds,
                          ),
                          lessons: _surahLessons(
                            l10n,
                            insight.definition.lessonIds,
                          ),
                          attribution: l10n.quranLearningShareAttribution,
                          themesLabel: l10n.quranLearningShareThemesLabel,
                          lessonsLabel: l10n.quranLearningShareLessonsLabel,
                        );
                    QuranLearningShareService.shareText(text);
                  },
                  icon: const Icon(Icons.ios_share_rounded),
                  label: Text(l10n.quranLearningShareAction),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.quranSurahInsightsOverviewTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(_surahDescription(l10n, insight.definition.descriptionId)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _surahThemes(l10n, insight.definition.themeIds)
                    .map((theme) => Chip(label: Text(theme)))
                    .toList(growable: false),
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
                l10n.quranSurahInsightsWhyItMattersTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(_surahSignificance(l10n, insight.definition.significanceId)),
            ],
          ),
        ),
        if (insight.definition.studyPromptIds.isNotEmpty) ...[
          const SizedBox(height: 10),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.quranSurahInsightsReflectionPromptsTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                ...insight.definition.studyPromptIds.map(
                  (promptId) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 6),
                          child: Icon(Icons.circle, size: 8),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(_studyPromptLabel(l10n, promptId)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        if (insight.definition.relatedTopicIds.isNotEmpty) ...[
          const SizedBox(height: 10),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.quranSurahInsightsThemesAcrossQuranTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: insight.definition.relatedTopicIds
                      .map(
                        (topicId) => ActionChip(
                          label: Text(localizedQuranTopicTitle(l10n, topicId)),
                          onPressed: () => context.pushNamed(
                            'quranTopicDetail',
                            pathParameters: {'topicId': topicId},
                          ),
                        ),
                      )
                      .toList(growable: false),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 10),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.quranSurahInsightsLessonsTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              ..._surahLessons(l10n, insight.definition.lessonIds).map(
                (lesson) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: Icon(Icons.circle, size: 8),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: Text(lesson)),
                    ],
                  ),
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
                l10n.quranSurahInsightsClustersTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              ...insight.clusters.map(
                (cluster) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _SurahInsightClusterCard(cluster: cluster),
                ),
              ),
            ],
          ),
        ),
        if (insight.suggestedPaths.isNotEmpty) ...[
          const SizedBox(height: 10),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.quranSurahInsightsSuggestedPathsTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                ...insight.suggestedPaths.map(
                  (path) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(_pathTitle(l10n, path.id)),
                    subtitle: Text(_pathDescription(l10n, path.id)),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () => context.pushNamed(
                      'quranAyahInsightsPathDetail',
                      pathParameters: {'pathId': path.id},
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        if (insight.definition.relatedRoutes.isNotEmpty) ...[
          const SizedBox(height: 10),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.quranSurahInsightsRelatedLearningTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                ...insight.definition.relatedRoutes.map(
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
}

class _SurahInsightClusterCard extends ConsumerWidget {
  const _SurahInsightClusterCard({required this.cluster});

  final QuranResolvedSurahInsightCluster cluster;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _domainTitle(l10n, cluster.domain),
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            ...cluster.entries.map((entry) {
              final localizedEntry = entry.localizedCopy(languageCode);
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(localizedEntry.title),
                subtitle: Text(
                  '${l10n.quranReferenceViewerReferenceLabel(localizedEntry.ref.locationLabel)}\n${localizedEntry.summary}',
                ),
                isThreeLine: true,
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => openQuranReferenceLocation(
                  context,
                  ref: localizedEntry.ref,
                ),
              );
            }),
          ],
        ),
      ),
    );
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

String _surahDescription(AppLocalizations l10n, String id) {
  switch (id) {
    case 'al_baqarah':
      return l10n.quranSurahInsightDescriptionAlBaqarah;
    case 'ali_imran':
      return l10n.quranSurahInsightDescriptionAliImran;
    case 'ta_ha':
      return l10n.quranSurahInsightDescriptionTaHa;
    case 'al_furqan':
      return l10n.quranSurahInsightDescriptionAlFurqan;
    case 'luqman':
      return l10n.quranSurahInsightDescriptionLuqman;
    default:
      return l10n.quranSurahInsightsBrowseSubtitle;
  }
}

List<String> _surahThemes(AppLocalizations l10n, List<String> ids) {
  return ids.map((id) => _themeLabel(l10n, id)).toList(growable: false);
}

List<String> _surahLessons(AppLocalizations l10n, List<String> ids) {
  return ids.map((id) => _lessonLabel(l10n, id)).toList(growable: false);
}

String _themeLabel(AppLocalizations l10n, String id) {
  switch (id) {
    case 'guidance_and_devotion':
      return l10n.quranSurahInsightThemeGuidanceAndDevotion;
    case 'patience_and_reliance':
      return l10n.quranSurahInsightThemePatienceAndReliance;
    case 'supplication_and_response':
      return l10n.quranSurahInsightThemeSupplicationAndResponse;
    case 'steadfast_belief':
      return l10n.quranSurahInsightThemeSteadfastBelief;
    case 'character_under_pressure':
      return l10n.quranSurahInsightThemeCharacterUnderPressure;
    case 'reflecting_on_signs':
      return l10n.quranSurahInsightThemeReflectingOnSigns;
    case 'revelation_and_remembrance':
      return l10n.quranSurahInsightThemeRevelationAndRemembrance;
    case 'seeking_knowledge':
      return l10n.quranSurahInsightThemeSeekingKnowledge;
    case 'worship_with_presence':
      return l10n.quranSurahInsightThemeWorshipWithPresence;
    case 'discernment_and_reflection':
      return l10n.quranSurahInsightThemeDiscernmentAndReflection;
    case 'humble_servanthood':
      return l10n.quranSurahInsightThemeHumbleServanthood;
    case 'signs_in_time_and_creation':
      return l10n.quranSurahInsightThemeSignsInTimeAndCreation;
    case 'gratitude_and_wisdom':
      return l10n.quranSurahInsightThemeGratitudeAndWisdom;
    case 'tawhid_in_family_guidance':
      return l10n.quranSurahInsightThemeTawhidInFamilyGuidance;
    case 'humility_and_good_conduct':
      return l10n.quranSurahInsightThemeHumilityAndGoodConduct;
    default:
      return id;
  }
}

String _lessonLabel(AppLocalizations l10n, String id) {
  switch (id) {
    case 'steadfast_worship_needs_help':
      return l10n.quranSurahInsightLessonSteadfastWorshipNeedsHelp;
    case 'remembering_allah_reshapes_the_heart':
      return l10n.quranSurahInsightLessonRememberingAllahReshapesTheHeart;
    case 'dua_is_part_of_lived_faith':
      return l10n.quranSurahInsightLessonDuaIsPartOfLivedFaith;
    case 'taqwa_and_reflection_belong_together':
      return l10n.quranSurahInsightLessonTaqwaAndReflectionBelongTogether;
    case 'mercy_and_restraint_are_strengths':
      return l10n.quranSurahInsightLessonMercyAndRestraintAreStrengths;
    case 'steadfastness_is_built_through_belief_and_character':
      return l10n
          .quranSurahInsightLessonSteadfastnessBuiltThroughBeliefAndCharacter;
    case 'prayer_keeps_revelation_connected_to_life':
      return l10n.quranSurahInsightLessonPrayerKeepsRevelationConnectedToLife;
    case 'sincere_learning_begins_with_humility':
      return l10n.quranSurahInsightLessonSincereLearningBeginsWithHumility;
    case 'remembrance_is_meant_to_shape_action':
      return l10n.quranSurahInsightLessonRemembranceShapesAction;
    case 'the_servants_of_the_merciful_are_known_by_conduct':
      return l10n.quranSurahInsightLessonServantsOfMercifulKnownByConduct;
    case 'signs_in_creation_should_lead_to_remembrance':
      return l10n.quranSurahInsightLessonSignsLeadToRemembrance;
    case 'guidance_becomes_visible_in_how_one_walks_and_responds':
      return l10n.quranSurahInsightLessonGuidanceVisibleInConduct;
    case 'gratitude_is_a_form_of_worship':
      return l10n.quranSurahInsightLessonGratitudeIsWorship;
    case 'belief_and_character_are_taught_together':
      return l10n.quranSurahInsightLessonBeliefAndCharacterTogether;
    case 'wisdom_shows_in_humility_before_allah_and_people':
      return l10n.quranSurahInsightLessonWisdomShowsInHumility;
    default:
      return id;
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

String _surahSignificance(AppLocalizations l10n, String id) {
  switch (id) {
    case 'al_baqarah':
      return l10n.quranSurahInsightWhyItMattersAlBaqarah;
    case 'ali_imran':
      return l10n.quranSurahInsightWhyItMattersAliImran;
    case 'ta_ha':
      return l10n.quranSurahInsightWhyItMattersTaHa;
    case 'al_furqan':
      return l10n.quranSurahInsightWhyItMattersAlFurqan;
    case 'luqman':
      return l10n.quranSurahInsightWhyItMattersLuqman;
    default:
      return l10n.quranSurahInsightsBrowseSubtitle;
  }
}

String _studyPromptLabel(AppLocalizations l10n, String id) {
  switch (id) {
    case 'al_baqarah_worship_and_help':
      return l10n.quranSurahInsightPromptAlBaqarahWorshipAndHelp;
    case 'al_baqarah_dua_and_response':
      return l10n.quranSurahInsightPromptAlBaqarahDuaAndResponse;
    case 'ali_imran_pressure_and_character':
      return l10n.quranSurahInsightPromptAliImranPressureAndCharacter;
    case 'ali_imran_signs_and_belief':
      return l10n.quranSurahInsightPromptAliImranSignsAndBelief;
    case 'ta_ha_revelation_and_presence':
      return l10n.quranSurahInsightPromptTaHaRevelationAndPresence;
    case 'ta_ha_knowledge_and_humility':
      return l10n.quranSurahInsightPromptTaHaKnowledgeAndHumility;
    case 'al_furqan_conduct_and_discernment':
      return l10n.quranSurahInsightPromptAlFurqanConductAndDiscernment;
    case 'al_furqan_time_and_signs':
      return l10n.quranSurahInsightPromptAlFurqanTimeAndSigns;
    case 'luqman_family_and_tawhid':
      return l10n.quranSurahInsightPromptLuqmanFamilyAndTawhid;
    case 'luqman_gratitude_and_humility':
      return l10n.quranSurahInsightPromptLuqmanGratitudeAndHumility;
    default:
      return id;
  }
}
