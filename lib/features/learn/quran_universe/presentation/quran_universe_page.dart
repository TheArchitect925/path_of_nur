import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../../prophets/application/prophet_detail_repository.dart';
import '../../prophets/application/prophets_repository.dart';
import '../../prophets/application/prophets_ui_state.dart';
import '../../prophets/domain/prophet_entry.dart';
import '../../prophets/domain/prophets_tab.dart';
import '../../prophets/presentation/prophet_detail_page.dart';
import '../data/seeded_quran_universe_data.dart';
import '../domain/quran_universe_links.dart';

enum _UniverseMode { prophet, theme, location, lesson }

class QuranUniversePage extends ConsumerStatefulWidget {
  const QuranUniversePage({super.key});

  @override
  ConsumerState<QuranUniversePage> createState() => _QuranUniversePageState();
}

class _QuranUniversePageState extends ConsumerState<QuranUniversePage> {
  _UniverseMode _mode = _UniverseMode.prophet;

  @override
  Widget build(BuildContext context) {
    final prophets = ref.watch(prophetsProvider);
    final prophetById = {for (final p in prophets) p.id: p};

    return LearnHubPageScaffold(
      headerIcon: Icons.hub_rounded,
      title: 'Qur\'an Universe',
      subtitle:
          'Explore connections between verses, prophets, themes, locations, lessons, and growth habits.',
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Exploration Modes',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _modeChip(_UniverseMode.prophet, 'Explore by Prophet'),
                  _modeChip(_UniverseMode.theme, 'Explore by Theme'),
                  _modeChip(_UniverseMode.location, 'Explore by Location'),
                  _modeChip(_UniverseMode.lesson, 'Explore by Lesson'),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: _openJourney,
                    icon: const Icon(Icons.timeline_rounded),
                    label: const Text('Journey of Revelation'),
                  ),
                  OutlinedButton.icon(
                    onPressed: _openProphetQuiz,
                    icon: const Icon(Icons.quiz_rounded),
                    label: const Text('Prophet Quiz'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () =>
                        context.pushNamed('knowledgeConstellation'),
                    icon: const Icon(Icons.scatter_plot_rounded),
                    label: const Text('Knowledge Constellation'),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (_mode == _UniverseMode.prophet)
          _buildProphetMode(context, prophetById, prophets)
        else if (_mode == _UniverseMode.theme)
          _buildThemeMode(context, prophetById, prophets)
        else if (_mode == _UniverseMode.location)
          _buildLocationMode(context, prophetById, prophets)
        else
          _buildLessonMode(context, prophetById, prophets),
      ],
    );
  }

  Widget _buildProphetMode(
    BuildContext context,
    Map<String, ProphetEntry> prophetById,
    List<ProphetEntry> allProphets,
  ) {
    return Column(
      children: seededUniverseProphetLenses.map((lens) {
        final prophet = prophetById[lens.prophetId];
        if (prophet == null) return const SizedBox.shrink();
        final verses = _verseLinksFor(prophetId: lens.prophetId);
        final relatedNames = lens.relatedProphetIds
            .map((id) => prophetById[id]?.name)
            .whereType<String>()
            .toList();

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prophet.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  prophet.arabicName,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceSubtle,
                  ),
                ),
                const SizedBox(height: 8),
                Text(lens.summary),
                const SizedBox(height: 8),
                _chipWrap([
                  ..._namesForThemes(lens.themeIds),
                  ..._namesForLocations(lens.locationIds),
                  ..._titlesForLessons(lens.lessonIds),
                ]),
                if (relatedNames.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Related Prophets: ${relatedNames.join(', ')}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurfaceSubtle,
                    ),
                  ),
                ],
                if (verses.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  ...verses
                      .take(3)
                      .map(
                        (link) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: InkWell(
                            onTap: () => _openVerse(link),
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.surface.withValues(
                                  alpha: 0.24,
                                ),
                                border: Border.all(
                                  color: AppColors.accentGoldSoft.withValues(
                                    alpha: 0.32,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${link.verseReference} • ${link.label ?? 'Open verse'}',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.open_in_new_rounded,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                ],
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    OutlinedButton(
                      onPressed: () => _openProphetDetail(prophet, allProphets),
                      child: const Text('View Prophet'),
                    ),
                    OutlinedButton(
                      onPressed: _openJourney,
                      child: const Text('Open Journey'),
                    ),
                    OutlinedButton(
                      onPressed: _openProphetQuiz,
                      child: const Text('Take Quiz'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildThemeMode(
    BuildContext context,
    Map<String, ProphetEntry> prophetById,
    List<ProphetEntry> allProphets,
  ) {
    return Column(
      children: seededUniverseThemes.map((theme) {
        final links = _verseLinksFor(themeId: theme.id);
        final prophetIds = links
            .expand((l) => l.prophetIds)
            .toSet()
            .toList(growable: false);
        final lessonIds = links
            .expand((l) => l.lessonIds)
            .toSet()
            .toList(growable: false);

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: PremiumCard(
            child: ExpansionTile(
              tilePadding: EdgeInsets.zero,
              childrenPadding: EdgeInsets.zero,
              title: Text(
                theme.name,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              subtitle: Text(theme.summary),
              children: [
                const SizedBox(height: 8),
                _subsection(
                  context,
                  'Related Prophets',
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: prophetIds.map((id) {
                      final prophet = prophetById[id];
                      if (prophet == null) return const SizedBox.shrink();
                      return ActionChip(
                        label: Text(prophet.name),
                        onPressed: () =>
                            _openProphetDetail(prophet, allProphets),
                      );
                    }).toList(),
                  ),
                ),
                _subsection(
                  context,
                  'Representative Verses',
                  Column(
                    children: links.take(4).map((link) {
                      return ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text(link.verseReference),
                        subtitle: Text(link.label ?? 'Open verse'),
                        trailing: const Icon(
                          Icons.open_in_new_rounded,
                          size: 16,
                        ),
                        onTap: () => _openVerse(link),
                      );
                    }).toList(),
                  ),
                ),
                _subsection(
                  context,
                  'Connected Lessons',
                  _chipWrap(_titlesForLessons(lessonIds)),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLocationMode(
    BuildContext context,
    Map<String, ProphetEntry> prophetById,
    List<ProphetEntry> allProphets,
  ) {
    return Column(
      children: seededUniverseLocations.map((location) {
        final links = _verseLinksFor(locationId: location.id);
        final prophetIds = links
            .expand((l) => l.prophetIds)
            .toSet()
            .toList(growable: false);

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: PremiumCard(
            child: ExpansionTile(
              tilePadding: EdgeInsets.zero,
              childrenPadding: EdgeInsets.zero,
              title: Text(
                location.name,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              subtitle: Text('${location.regionLabel} • ${location.summary}'),
              children: [
                const SizedBox(height: 8),
                _subsection(
                  context,
                  'Associated Prophets',
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: prophetIds.map((id) {
                      final prophet = prophetById[id];
                      if (prophet == null) return const SizedBox.shrink();
                      return ActionChip(
                        label: Text(prophet.name),
                        onPressed: () =>
                            _openProphetDetail(prophet, allProphets),
                      );
                    }).toList(),
                  ),
                ),
                _subsection(
                  context,
                  'Related Stories and Verses',
                  Column(
                    children: links.take(4).map((link) {
                      return ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text(link.verseReference),
                        subtitle: Text(link.label ?? 'Open verse'),
                        trailing: const Icon(
                          Icons.open_in_new_rounded,
                          size: 16,
                        ),
                        onTap: () => _openVerse(link),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLessonMode(
    BuildContext context,
    Map<String, ProphetEntry> prophetById,
    List<ProphetEntry> allProphets,
  ) {
    return Column(
      children: seededUniverseLessons.map((lesson) {
        final links = _verseLinksFor(lessonId: lesson.id);
        final prophetIds = links
            .expand((l) => l.prophetIds)
            .toSet()
            .toList(growable: false);

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: PremiumCard(
            child: ExpansionTile(
              tilePadding: EdgeInsets.zero,
              childrenPadding: EdgeInsets.zero,
              title: Text(
                lesson.title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              subtitle: Text(lesson.summary),
              children: [
                const SizedBox(height: 8),
                _subsection(
                  context,
                  'Connected Prophets',
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: prophetIds.map((id) {
                      final prophet = prophetById[id];
                      if (prophet == null) return const SizedBox.shrink();
                      return ActionChip(
                        label: Text(prophet.name),
                        onPressed: () =>
                            _openProphetDetail(prophet, allProphets),
                      );
                    }).toList(),
                  ),
                ),
                _subsection(
                  context,
                  'Related Verses',
                  Column(
                    children: links.take(4).map((link) {
                      return ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text(link.verseReference),
                        subtitle: Text(link.label ?? 'Open verse'),
                        trailing: const Icon(
                          Icons.open_in_new_rounded,
                          size: 16,
                        ),
                        onTap: () => _openVerse(link),
                      );
                    }).toList(),
                  ),
                ),
                if (lesson.relatedGrowthHabitIds.isNotEmpty)
                  _subsection(
                    context,
                    'Practice Habit',
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: lesson.relatedGrowthHabitIds.map((habitId) {
                        return ActionChip(
                          label: Text(_habitName(habitId)),
                          onPressed: () => _openGrowthHabit(habitId),
                        );
                      }).toList(),
                    ),
                  ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _modeChip(_UniverseMode mode, String label) {
    final selected = _mode == mode;
    return InkWell(
      onTap: () => setState(() => _mode = mode),
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: selected
              ? AppColors.accentGold.withValues(alpha: 0.22)
              : AppColors.surface.withValues(alpha: 0.28),
          border: Border.all(
            color: selected
                ? AppColors.accentGold.withValues(alpha: 0.58)
                : AppColors.accentGoldSoft.withValues(alpha: 0.35),
          ),
        ),
        child: Text(label, style: const TextStyle(fontSize: 12.2)),
      ),
    );
  }

  Widget _subsection(BuildContext context, String title, Widget child) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }

  Widget _chipWrap(List<String> labels) {
    if (labels.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: labels
          .map(
            (label) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: AppColors.surface.withValues(alpha: 0.26),
                border: Border.all(
                  color: AppColors.accentGoldSoft.withValues(alpha: 0.33),
                ),
              ),
              child: Text(label, style: const TextStyle(fontSize: 11.4)),
            ),
          )
          .toList(),
    );
  }

  List<QuranUniverseVerseLink> _verseLinksFor({
    String? prophetId,
    String? themeId,
    String? lessonId,
    String? locationId,
  }) {
    return seededUniverseVerseLinks
        .where((link) {
          final prophetMatch =
              prophetId == null || link.prophetIds.contains(prophetId);
          final themeMatch = themeId == null || link.themeIds.contains(themeId);
          final lessonMatch =
              lessonId == null || link.lessonIds.contains(lessonId);
          final locationMatch =
              locationId == null || link.locationIds.contains(locationId);
          return prophetMatch && themeMatch && lessonMatch && locationMatch;
        })
        .toList(growable: false);
  }

  List<String> _namesForThemes(List<String> ids) {
    final byId = {for (final t in seededUniverseThemes) t.id: t};
    return ids.map((id) => byId[id]?.name).whereType<String>().toList();
  }

  List<String> _namesForLocations(List<String> ids) {
    final byId = {for (final l in seededUniverseLocations) l.id: l};
    return ids.map((id) => byId[id]?.name).whereType<String>().toList();
  }

  List<String> _titlesForLessons(List<String> ids) {
    final byId = {for (final l in seededUniverseLessons) l.id: l};
    return ids.map((id) => byId[id]?.title).whereType<String>().toList();
  }

  void _openVerse(QuranUniverseVerseLink link) {
    final queryParameters = <String, String>{};
    if (link.startAyah != null) {
      queryParameters['ayah'] = '${link.startAyah}';
    }
    context.pushNamed(
      'quranReader',
      pathParameters: {'surahNumber': '${link.surahNumber}'},
      queryParameters: queryParameters,
    );
  }

  void _openGrowthHabit(String habitId) {
    context.pushNamed('growthHabitAlias', pathParameters: {'habitId': habitId});
  }

  void _openJourney() {
    ref
        .read(prophetsUiControllerProvider.notifier)
        .setSelectedTab(ProphetsTab.journey);
    context.pushNamed(
      'learnSectionHub',
      pathParameters: {'sectionId': 'prophets'},
    );
  }

  void _openProphetQuiz() {
    ref
        .read(prophetsUiControllerProvider.notifier)
        .setSelectedTab(ProphetsTab.quiz);
    context.pushNamed(
      'learnSectionHub',
      pathParameters: {'sectionId': 'prophets'},
    );
  }

  void _openProphetDetail(
    ProphetEntry prophet,
    List<ProphetEntry> allProphets,
  ) {
    final detailRepo = ref.read(prophetDetailRepositoryProvider);
    final detail = detailRepo.forProphet(prophet);

    final index = allProphets.indexWhere((item) => item.id == prophet.id);
    final previous = index > 0 ? allProphets[index - 1] : null;
    final next = index >= 0 && index < allProphets.length - 1
        ? allProphets[index + 1]
        : null;

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProphetDetailPage(
          prophet: prophet,
          content: detail,
          allProphets: allProphets,
          previousProphetLabel: previous?.name,
          nextProphetLabel: next?.name,
          onOpenPreviousProphet: previous == null
              ? null
              : () {
                  Navigator.of(context).pop();
                  _openProphetDetail(previous, allProphets);
                },
          onOpenNextProphet: next == null
              ? null
              : () {
                  Navigator.of(context).pop();
                  _openProphetDetail(next, allProphets);
                },
          onOpenRelatedProphet: (relatedId) {
            final related = allProphets
                .where((p) => p.id == relatedId)
                .firstOrNull;
            if (related == null) return;
            Navigator.of(context).pop();
            _openProphetDetail(related, allProphets);
          },
          onViewInTimeline: () {
            Navigator.of(context).pop();
            ref
                .read(prophetsUiControllerProvider.notifier)
                .setSelectedTab(ProphetsTab.timeline);
            context.pushNamed(
              'learnSectionHub',
              pathParameters: {'sectionId': 'prophets'},
            );
          },
          onViewOnMap: prophet.hasMapLocation
              ? () {
                  Navigator.of(context).pop();
                  ref
                      .read(prophetsUiControllerProvider.notifier)
                      .setSelectedTab(ProphetsTab.map);
                  context.pushNamed(
                    'learnSectionHub',
                    pathParameters: {'sectionId': 'prophets'},
                  );
                }
              : null,
          onViewInFamilyTree: () {
            Navigator.of(context).pop();
            ref
                .read(prophetsUiControllerProvider.notifier)
                .setSelectedTab(ProphetsTab.familyTree);
            context.pushNamed(
              'learnSectionHub',
              pathParameters: {'sectionId': 'prophets'},
            );
          },
        ),
      ),
    );
  }

  String _habitName(String habitId) {
    switch (habitId) {
      case 'daily_istighfar':
        return 'Daily Istighfar';
      case 'practice_patience':
        return 'Practice Patience';
      case 'read_quran_daily':
        return 'Read Qur\'an';
      case 'make_dua_daily':
        return 'Daily Dua';
      case 'study_islamic_knowledge':
        return 'Study Knowledge';
      case 'pray_one_sunnah_prayer':
        return 'Sunnah Prayer';
      case 'help_someone':
        return 'Help Someone';
      case 'practice_humility':
        return 'Practice Humility';
      case 'end_day_with_reflection_and_tawbah':
        return 'Night Reflection';
      default:
        return habitId
            .split('_')
            .where((p) => p.isNotEmpty)
            .map((p) => '${p[0].toUpperCase()}${p.substring(1)}')
            .join(' ');
    }
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return null;
    return iterator.current;
  }
}
