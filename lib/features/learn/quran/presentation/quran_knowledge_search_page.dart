import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/quran_navigation.dart';
import '../../presentation/widgets/learn_discovery_search_field.dart';
import '../application/quran_ayah_enrichment_provider.dart';
import '../application/quran_providers.dart';
import '../application/quran_surah_insights_provider.dart';
import '../domain/quran_ayah_enrichment_models.dart';
import '../domain/quran_surah.dart';
import '../domain/quran_surah_insight_models.dart';

class QuranKnowledgeSearchPage extends ConsumerStatefulWidget {
  const QuranKnowledgeSearchPage({super.key});

  @override
  ConsumerState<QuranKnowledgeSearchPage> createState() =>
      _QuranKnowledgeSearchPageState();
}

class _QuranKnowledgeSearchPageState
    extends ConsumerState<QuranKnowledgeSearchPage> {
  late final TextEditingController _searchController;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final entries = ref.watch(quranAyahEnrichmentEntriesProvider);
    final paths = ref.watch(quranAyahInsightResolvedPathsProvider);
    final surahInsights = ref.watch(quranSurahInsightsBrowseProvider);
    final surahMap = ref.watch(quranSurahMapProvider);
    final normalizedQuery = _normalizeForSearch(_query);
    final searchResults = normalizedQuery.isEmpty
        ? const _QuranKnowledgeSearchResults.empty()
        : _buildSearchResults(
            query: normalizedQuery,
            l10n: l10n,
            entries: entries,
            paths: paths,
            surahInsights: surahInsights,
            surahMap: surahMap,
          );

    return AppPageScaffold(
      headerIcon: Icons.manage_search_rounded,
      title: l10n.quranKnowledgeSearchTitle,
      subtitle: l10n.quranKnowledgeSearchSubtitle,
      children: [
        PremiumCard(
          child: LearnDiscoverySearchField(
            controller: _searchController,
            hintText: l10n.quranKnowledgeSearchHint,
            onChanged: (value) => setState(() => _query = value),
            onClear: () {
              _searchController.clear();
              setState(() => _query = '');
            },
          ),
        ),
        const SizedBox(height: 10),
        if (normalizedQuery.isEmpty)
          _DefaultSearchState(l10n: l10n)
        else if (searchResults.isEmpty)
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.quranKnowledgeSearchNoResultsTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(l10n.quranKnowledgeSearchNoResultsSubtitle),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilledButton.tonal(
                      onPressed: () =>
                          context.pushNamed('quranAyahInsightsBrowse'),
                      child: Text(l10n.quranAyahInsightsBrowseAction),
                    ),
                    FilledButton.tonal(
                      onPressed: () =>
                          context.pushNamed('quranAyahInsightsPaths'),
                      child: Text(l10n.quranAyahInsightPathsAction),
                    ),
                    FilledButton.tonal(
                      onPressed: () =>
                          context.pushNamed('quranSurahInsightsBrowse'),
                      child: Text(l10n.quranSurahInsightsBrowseAction),
                    ),
                  ],
                ),
              ],
            ),
          )
        else ...[
          if (searchResults.ayahInsights.isNotEmpty)
            _SearchResultSection(
              title: l10n.quranKnowledgeSearchSectionAyahInsights,
              results: searchResults.ayahInsights,
            ),
          if (searchResults.paths.isNotEmpty) ...[
            const SizedBox(height: 10),
            _SearchResultSection(
              title: l10n.quranKnowledgeSearchSectionPaths,
              results: searchResults.paths,
            ),
          ],
          if (searchResults.surahInsights.isNotEmpty) ...[
            const SizedBox(height: 10),
            _SearchResultSection(
              title: l10n.quranKnowledgeSearchSectionSurahInsights,
              results: searchResults.surahInsights,
            ),
          ],
        ],
      ],
    );
  }
}

class _DefaultSearchState extends StatelessWidget {
  const _DefaultSearchState({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.quranKnowledgeSearchEmptyTitle,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(l10n.quranKnowledgeSearchEmptySubtitle),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilledButton.tonalIcon(
                onPressed: () => context.pushNamed('quranAyahInsightsBrowse'),
                icon: const Icon(Icons.auto_awesome_outlined),
                label: Text(l10n.quranAyahInsightsBrowseAction),
              ),
              FilledButton.tonalIcon(
                onPressed: () => context.pushNamed('quranAyahInsightsPaths'),
                icon: const Icon(Icons.route_rounded),
                label: Text(l10n.quranAyahInsightPathsAction),
              ),
              FilledButton.tonalIcon(
                onPressed: () => context.pushNamed('quranSurahInsightsBrowse'),
                icon: const Icon(Icons.layers_outlined),
                label: Text(l10n.quranSurahInsightsBrowseAction),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SearchResultSection extends StatelessWidget {
  const _SearchResultSection({required this.title, required this.results});

  final String title;
  final List<_QuranKnowledgeSearchResult> results;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          ...results.map(
            (result) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(result.title),
              subtitle: Text(
                '${result.typeLabel} • ${result.supportingLabel}\n${result.summary}',
              ),
              isThreeLine: true,
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => result.open(context),
            ),
          ),
        ],
      ),
    );
  }
}

_QuranKnowledgeSearchResults _buildSearchResults({
  required String query,
  required AppLocalizations l10n,
  required List<QuranAyahEnrichmentEntry> entries,
  required List<QuranAyahInsightResolvedPath> paths,
  required List<QuranResolvedSurahInsight> surahInsights,
  required Map<int, QuranSurah> surahMap,
}) {
  final ayahResults =
      entries
          .map((entry) {
            final surah = surahMap[entry.ref.surah];
            final domainLabel = _domainLabel(l10n, entry.domain);
            final lessonTypeLabel = _lessonTypeLabel(l10n, entry.lessonType);
            final tagLabels = entry.tags
                .map((tag) => _tagLabel(l10n, tag))
                .join(' ');
            final surahNames = surah == null
                ? ''
                : '${surah.transliteratedName} ${surah.englishName} ${surah.arabicName}';
            final haystack = _combineSearchFields([
              entry.title,
              entry.summary,
              entry.body,
              entry.ref.locationLabel,
              domainLabel,
              lessonTypeLabel,
              tagLabels,
              surahNames,
            ]);
            final score = _scoreSearchMatch(
              query: query,
              title: entry.title,
              supporting:
                  '${entry.ref.locationLabel} $domainLabel $lessonTypeLabel',
              haystack: haystack,
            );
            if (score == 0) return null;
            return _QuranKnowledgeSearchResult(
              score: score,
              title: entry.title,
              summary: entry.summary,
              typeLabel: l10n.quranKnowledgeSearchTypeAyahInsight,
              supportingLabel: '${entry.ref.locationLabel} • $domainLabel',
              open: (context) =>
                  openQuranReferenceLocation(context, ref: entry.ref),
            );
          })
          .whereType<_QuranKnowledgeSearchResult>()
          .toList(growable: false)
        ..sort(_compareSearchResults);

  final pathResults =
      paths
          .map((resolvedPath) {
            final path = resolvedPath.path;
            final title = _pathTitle(l10n, path.id);
            final description = _pathDescription(l10n, path.id);
            final reflectionFocus = _pathReflectionFocus(l10n, path.id);
            final domainLabel = _domainLabel(l10n, path.domain);
            final entryText = resolvedPath.entries
                .map((entry) => '${entry.title} ${entry.ref.locationLabel}')
                .join(' ');
            final haystack = _combineSearchFields([
              title,
              description,
              reflectionFocus,
              domainLabel,
              entryText,
            ]);
            final score = _scoreSearchMatch(
              query: query,
              title: title,
              supporting:
                  '$domainLabel ${l10n.quranAyahInsightPathsCount(resolvedPath.count)}',
              haystack: haystack,
            );
            if (score == 0) return null;
            return _QuranKnowledgeSearchResult(
              score: score,
              title: title,
              summary: description,
              typeLabel: l10n.quranKnowledgeSearchTypePath,
              supportingLabel:
                  '$domainLabel • ${l10n.quranAyahInsightPathsCount(resolvedPath.count)}',
              open: (context) => context.pushNamed(
                'quranAyahInsightsPathDetail',
                pathParameters: {'pathId': path.id},
              ),
            );
          })
          .whereType<_QuranKnowledgeSearchResult>()
          .toList(growable: false)
        ..sort(_compareSearchResults);

  final surahResults =
      surahInsights
          .map((insight) {
            final surah = insight.surah;
            final description = _surahDescription(
              l10n,
              insight.definition.descriptionId,
            );
            final themes = _surahThemes(
              l10n,
              insight.definition.themeIds,
            ).join(' ');
            final lessons = _surahLessons(
              l10n,
              insight.definition.lessonIds,
            ).join(' ');
            final clusterDomains = insight.clusters
                .map((cluster) => _domainLabel(l10n, cluster.domain))
                .join(' ');
            final haystack = _combineSearchFields([
              surah.transliteratedName,
              surah.englishName,
              surah.arabicName,
              'surah ${surah.number}',
              description,
              themes,
              lessons,
              clusterDomains,
            ]);
            final score = _scoreSearchMatch(
              query: query,
              title:
                  '${surah.transliteratedName} ${surah.englishName} ${surah.arabicName}',
              supporting:
                  '${l10n.quranSurahInsightsClusterCount(insight.clusters.length)} ${surah.number}',
              haystack: haystack,
            );
            if (score == 0) return null;
            return _QuranKnowledgeSearchResult(
              score: score,
              title: '${surah.transliteratedName} • ${surah.arabicName}',
              summary: description,
              typeLabel: l10n.quranKnowledgeSearchTypeSurahInsight,
              supportingLabel:
                  '${surah.englishName} • ${l10n.quranSurahInsightsClusterCount(insight.clusters.length)}',
              open: (context) => context.pushNamed(
                'quranSurahInsights',
                pathParameters: {'surahNumber': surah.number.toString()},
              ),
            );
          })
          .whereType<_QuranKnowledgeSearchResult>()
          .toList(growable: false)
        ..sort(_compareSearchResults);

  return _QuranKnowledgeSearchResults(
    ayahInsights: ayahResults.take(8).toList(growable: false),
    paths: pathResults.take(6).toList(growable: false),
    surahInsights: surahResults.take(6).toList(growable: false),
  );
}

int _compareSearchResults(
  _QuranKnowledgeSearchResult a,
  _QuranKnowledgeSearchResult b,
) {
  final byScore = b.score.compareTo(a.score);
  if (byScore != 0) return byScore;
  return a.title.compareTo(b.title);
}

int _scoreSearchMatch({
  required String query,
  required String title,
  required String supporting,
  required String haystack,
}) {
  if (query.isEmpty) return 0;
  final normalizedTitle = _normalizeForSearch(title);
  final normalizedSupporting = _normalizeForSearch(supporting);
  final normalizedHaystack = _normalizeForSearch(haystack);
  final tokens = query.split(' ').where((token) => token.isNotEmpty).toList();
  if (tokens.isEmpty) return 0;

  final queryContained = normalizedHaystack.contains(query);
  final matchedTokens = tokens
      .where((token) => normalizedHaystack.contains(token))
      .length;
  if (!queryContained && matchedTokens < tokens.length) return 0;

  var score = 0;
  if (normalizedTitle == query) score += 160;
  if (normalizedSupporting == query) score += 140;
  if (normalizedTitle.contains(query)) score += 120;
  if (normalizedSupporting.contains(query)) score += 80;
  if (queryContained) score += 40;
  score += matchedTokens * 15;
  return score;
}

String _combineSearchFields(List<String> values) {
  return values.where((value) => value.trim().isNotEmpty).join(' ');
}

String _normalizeForSearch(String value) {
  return value
      .toLowerCase()
      .replaceAll(RegExp(r'[^\p{L}\p{N}: ]', unicode: true), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

String _domainLabel(AppLocalizations l10n, QuranAyahEnrichmentDomain domain) {
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

String _tagLabel(AppLocalizations l10n, QuranAyahEnrichmentTag tag) {
  switch (tag) {
    case QuranAyahEnrichmentTag.sabr:
      return l10n.quranAyahInsightsBrowseTagSabr;
    case QuranAyahEnrichmentTag.shukr:
      return l10n.quranAyahInsightsBrowseTagShukr;
    case QuranAyahEnrichmentTag.tawakkul:
      return l10n.quranAyahInsightsBrowseTagTawakkul;
    case QuranAyahEnrichmentTag.mercy:
      return l10n.quranAyahInsightsBrowseTagMercy;
    case QuranAyahEnrichmentTag.repentance:
      return l10n.quranAyahInsightsBrowseTagRepentance;
    case QuranAyahEnrichmentTag.justice:
      return l10n.quranAyahInsightsBrowseTagJustice;
    case QuranAyahEnrichmentTag.sincerity:
      return l10n.quranAyahInsightsBrowseTagSincerity;
    case QuranAyahEnrichmentTag.guidance:
      return l10n.quranAyahInsightsBrowseTagGuidance;
    case QuranAyahEnrichmentTag.signs:
      return l10n.quranAyahInsightsBrowseTagSigns;
    case QuranAyahEnrichmentTag.creation:
      return l10n.quranAyahInsightsBrowseTagCreation;
    case QuranAyahEnrichmentTag.prophets:
      return l10n.quranAyahInsightsBrowseTagProphets;
    case QuranAyahEnrichmentTag.worship:
      return l10n.quranAyahInsightsBrowseTagWorship;
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
      return l10n.quranSurahInsightsBrowseTitle;
  }
}

List<String> _surahLessons(AppLocalizations l10n, List<String> ids) {
  return ids.map((id) => _lessonText(l10n, id)).toList(growable: false);
}

String _lessonText(AppLocalizations l10n, String id) {
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
    case 'steadfastness_built_through_belief_and_character':
      return l10n
          .quranSurahInsightLessonSteadfastnessBuiltThroughBeliefAndCharacter;
    case 'prayer_keeps_revelation_connected_to_life':
      return l10n.quranSurahInsightLessonPrayerKeepsRevelationConnectedToLife;
    case 'sincere_learning_begins_with_humility':
      return l10n.quranSurahInsightLessonSincereLearningBeginsWithHumility;
    case 'remembrance_shapes_action':
      return l10n.quranSurahInsightLessonRemembranceShapesAction;
    case 'servants_of_the_merciful_known_by_conduct':
      return l10n.quranSurahInsightLessonServantsOfMercifulKnownByConduct;
    case 'signs_lead_to_remembrance':
      return l10n.quranSurahInsightLessonSignsLeadToRemembrance;
    case 'guidance_visible_in_conduct':
      return l10n.quranSurahInsightLessonGuidanceVisibleInConduct;
    case 'gratitude_is_worship':
      return l10n.quranSurahInsightLessonGratitudeIsWorship;
    case 'belief_and_character_together':
      return l10n.quranSurahInsightLessonBeliefAndCharacterTogether;
    case 'wisdom_shows_in_humility':
      return l10n.quranSurahInsightLessonWisdomShowsInHumility;
    default:
      return l10n.quranSurahInsightsLessonsTitle;
  }
}

class _QuranKnowledgeSearchResults {
  const _QuranKnowledgeSearchResults({
    required this.ayahInsights,
    required this.paths,
    required this.surahInsights,
  });

  const _QuranKnowledgeSearchResults.empty()
    : ayahInsights = const [],
      paths = const [],
      surahInsights = const [];

  final List<_QuranKnowledgeSearchResult> ayahInsights;
  final List<_QuranKnowledgeSearchResult> paths;
  final List<_QuranKnowledgeSearchResult> surahInsights;

  bool get isEmpty =>
      ayahInsights.isEmpty && paths.isEmpty && surahInsights.isEmpty;
}

class _QuranKnowledgeSearchResult {
  const _QuranKnowledgeSearchResult({
    required this.score,
    required this.title,
    required this.summary,
    required this.typeLabel,
    required this.supportingLabel,
    required this.open,
  });

  final int score;
  final String title;
  final String summary;
  final String typeLabel;
  final String supportingLabel;
  final void Function(BuildContext context) open;
}
