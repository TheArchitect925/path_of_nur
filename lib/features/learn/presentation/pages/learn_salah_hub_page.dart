import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_surfaces.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/theme/islamic_icons.dart';
import '../../../../shared/widgets/display/compact_list_tile.dart';
import '../../../../shared/widgets/display/hub_list_group.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../salah/application/salah_sync_controller.dart';
import '../../salah/application/salah_trainer_provider.dart';
import '../../salah/models/salah_trainer_models.dart';
import '../widgets/learn_hub_page_scaffold.dart';
import '../../../../core/theme/app_icons.dart';

enum _SalahTrainerTab { learn, guided, ayah, recitations, essentials, wudu }

class LearnSalahHubPage extends ConsumerStatefulWidget {
  const LearnSalahHubPage({super.key, this.section});

  /// Null keeps the salah structure itself as the landing; the other five are
  /// destinations you can link to rather than segments behind a strip.
  final String? section;

  @override
  ConsumerState<LearnSalahHubPage> createState() => _LearnSalahHubPageState();
}

class _LearnSalahHubPageState extends ConsumerState<LearnSalahHubPage> {
  late final _SalahTrainerTab _tab = _sectionFor(widget.section);
  final TextEditingController _surahSearchController = TextEditingController();
  final TextEditingController _recitationSearchController =
      TextEditingController();
  String _surahQuery = '';
  String _recitationQuery = '';

  @override
  void dispose() {
    _surahSearchController.dispose();
    _recitationSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final progress = ref.watch(salahTrainerProgressProvider);
    final guidanceAccepted = ref.watch(salahTrainerGuidanceNoticeProvider);
    final prayers = ref.watch(salahTrainerPrayersProvider);
    final surahs = ref.watch(salahTrainerSurahsProvider);
    final recitations = ref.watch(salahTrainerRecitationsProvider);
    final essentials = ref.watch(salahTrainerEssentialsProvider);
    final recentPrayers = ref.watch(salahRecentPrayerModelsProvider);
    final unlockedSurahIds = ref.watch(salahUnlockedSurahIdsProvider);
    final memorizedCount = ref.watch(salahMemorizedSurahCountProvider);

    final filteredSurahs = surahs
        .where((surah) {
          final query = _surahQuery.trim().toLowerCase();
          if (query.isEmpty) return true;
          return surah.name.toLowerCase().contains(query) ||
              surah.arabicName.contains(_surahQuery.trim()) ||
              surah.summary.toLowerCase().contains(query);
        })
        .toList(growable: false);

    final filteredRecitations = recitations
        .where((recitation) {
          final query = _recitationQuery.trim().toLowerCase();
          if (query.isEmpty) return true;
          return recitation.title.toLowerCase().contains(query) ||
              recitation.category.toLowerCase().contains(query) ||
              recitation.searchTags.any(
                (tag) => tag.toLowerCase().contains(query),
              );
        })
        .toList(growable: false);

    return LearnHubPageScaffold(
      headerIcon: AppIcons.salah,
      title: l10n.learnSalahHubTitle,
      subtitle: l10n.learnSalahHubSubtitle,
      children: [
        if (!guidanceAccepted) ...[
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.learnSalahHubGuidanceNoticeTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(l10n.learnSalahHubGuidanceNoticeBody1),
                const SizedBox(height: 8),
                Text(l10n.learnSalahHubGuidanceNoticeBody2),
                const SizedBox(height: 8),
                Text(l10n.learnSalahHubGuidanceNoticeBody3),
                const SizedBox(height: 12),
                Text(
                  l10n.learnSalahHubGuidanceNoticeDua,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 10),
                Text(l10n.learnSalahHubGuidanceNoticeVerse),
                const SizedBox(height: 4),
                Text(
                  l10n.learnSalahHubGuidanceNoticeVerseReference,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                Text(l10n.learnSalahHubGuidanceNoticeAcknowledge),
                const SizedBox(height: 12),
                FilledButton.tonal(
                  onPressed: () => ref
                      .read(salahTrainerGuidanceNoticeProvider.notifier)
                      .acknowledge(),
                  child: Text(l10n.learnSalahHubAcknowledgeAction),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
        if (widget.section == null) ...[
          HubListGroup(
            title: l10n.learnLandingBrowseTitle,
            children: [
              for (final tab in _SalahTrainerTab.values)
                if (tab != _SalahTrainerTab.learn)
                  CompactListTile(
                    title: _tabLabel(tab),
                    leading: HubLeadingIcon(_sectionIcon(tab)),
                    onTap: () => context.pushNamed(
                      'learnSalahHub',
                      queryParameters: {'section': tab.name},
                    ),
                  ),
            ],
          ),
          const SizedBox(height: 10),
        ],
        PremiumCard(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _metricPill(l10n.learnSalahHubMetricSalahs, '${prayers.length}'),
              _metricPill(
                l10n.learnSalahHubMetricUnlockedSurahs,
                '${unlockedSurahIds.length}',
              ),
              _metricPill(l10n.learnSalahHubMetricMemorized, '$memorizedCount'),
              _metricPill(
                l10n.learnSalahHubMetricRecitations,
                '${progress.learnedRecitationIds.length}',
              ),
            ],
          ),
        ),
        if (recentPrayers.isNotEmpty) ...[
          const SizedBox(height: 10),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.learnSalahHubContinuePrayerPracticeTitle,
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                ...recentPrayers.take(2).map((prayer) {
                  final session = progress.sessionFor(prayer.id);
                  final sessionSurah = session == null
                      ? null
                      : ref.watch(
                          salahTrainerSurahByIdProvider(session.surahId),
                        );
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(prayer.title),
                    subtitle: Text(
                      session != null && session.hasProgress
                          ? l10n.salahTrainerHubResumeSubtitle(
                              session.stepIndex + 1,
                              session.totalSteps,
                              sessionSurah?.name ?? session.surahId,
                            )
                          : '${prayer.fardRakahs} • ${prayer.recitationStyle}',
                    ),
                    trailing: FilledButton.tonal(
                      onPressed: () => context.pushNamed(
                        'learnSalahGuidedPrayer',
                        pathParameters: {'prayerId': prayer.id.name},
                      ),
                      child: Text(
                        session != null && session.hasProgress
                            ? l10n.salahTrainerResumeAction
                            : l10n.learnSalahHubStartGuidedSalahAction,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
        const SizedBox(height: 10),
        if (_tab == _SalahTrainerTab.learn)
          _LearnTab(prayers: prayers)
        else if (_tab == _SalahTrainerTab.guided)
          _GuidedTab(prayers: prayers)
        else if (_tab == _SalahTrainerTab.ayah)
          _AyahTab(
            controller: _surahSearchController,
            query: _surahQuery,
            onQueryChanged: (value) => setState(() => _surahQuery = value),
            filteredSurahs: filteredSurahs,
            unlockedSurahIds: unlockedSurahIds,
          )
        else if (_tab == _SalahTrainerTab.recitations)
          _RecitationsTab(
            controller: _recitationSearchController,
            query: _recitationQuery,
            onQueryChanged: (value) => setState(() => _recitationQuery = value),
            recitations: filteredRecitations,
          )
        else if (_tab == _SalahTrainerTab.essentials)
          _EssentialsTab(essentials: essentials)
        else
          const _WuduTab(),
      ],
    );
  }

  _SalahTrainerTab _sectionFor(String? id) {
    for (final tab in _SalahTrainerTab.values) {
      if (tab.name == id) return tab;
    }
    return _SalahTrainerTab.learn;
  }

  IconData _sectionIcon(_SalahTrainerTab tab) {
    switch (tab) {
      case _SalahTrainerTab.learn:
        return Icons.school_rounded;
      case _SalahTrainerTab.guided:
        return AppIcons.guidedPrayer;
      case _SalahTrainerTab.ayah:
        return Icons.menu_book_rounded;
      case _SalahTrainerTab.recitations:
        return Icons.record_voice_over_rounded;
      case _SalahTrainerTab.essentials:
        return Icons.checklist_rounded;
      case _SalahTrainerTab.wudu:
        return Icons.water_drop_rounded;
    }
  }

  String _tabLabel(_SalahTrainerTab tab) {
    final l10n = AppLocalizations.of(context);
    switch (tab) {
      case _SalahTrainerTab.learn:
        return l10n.learnSalahHubTabLearn;
      case _SalahTrainerTab.guided:
        return l10n.learnSalahHubTabGuided;
      case _SalahTrainerTab.ayah:
        return l10n.learnSalahHubTabAyah;
      case _SalahTrainerTab.recitations:
        return l10n.learnSalahHubTabRecitations;
      case _SalahTrainerTab.essentials:
        return l10n.learnSalahHubTabEssentials;
      case _SalahTrainerTab.wudu:
        return l10n.learnSalahHubTabWudu;
    }
  }

  Widget _metricPill(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: _salahNoorPillDecoration(context),
      child: Text('$label  $value'),
    );
  }
}

class _LearnTab extends StatelessWidget {
  const _LearnTab({required this.prayers});

  final List<PrayerModel> prayers;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: prayers
          .map(
            (prayer) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PremiumCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      prayer.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(prayer.arabicTitle),
                    const SizedBox(height: 6),
                    Text(prayer.shortDescription),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _infoChip(context, prayer.sunnahRakahs),
                        _infoChip(context, prayer.fardRakahs),
                        _infoChip(context, prayer.recitationStyle),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      prayer.overview,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        FilledButton.tonal(
                          onPressed: () => context.pushNamed(
                            'learnSalahPrayerDetail',
                            pathParameters: {'prayerId': prayer.id.name},
                          ),
                          child: Text(l10n.learnSalahHubLearnStructureAction),
                        ),
                        OutlinedButton(
                          onPressed: () => context.pushNamed(
                            'learnSalahPrayerDetail',
                            pathParameters: {'prayerId': prayer.id.name},
                            queryParameters: {'focus': 'steps'},
                          ),
                          child: Text(
                            l10n.learnSalahHubStepByStepMovementsAction,
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () => context.pushNamed(
                            'learnSalahGuidedPrayer',
                            pathParameters: {'prayerId': prayer.id.name},
                          ),
                          child: Text(l10n.learnSalahHubStartGuidedSalahAction),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(growable: false),
    );
  }

  Widget _infoChip(BuildContext context, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: _salahNoorPillDecoration(context),
      child: Text(label),
    );
  }
}

class _GuidedTab extends ConsumerWidget {
  const _GuidedTab({required this.prayers});

  final List<PrayerModel> prayers;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(salahTrainerProgressProvider);
    final notifier = ref.read(salahTrainerProgressProvider.notifier);
    final surahs = ref.watch(salahTrainerSurahsProvider);
    final unlockedIds = ref.watch(salahUnlockedSurahIdsProvider);
    final unlockedSurahs = surahs
        .where((surah) => unlockedIds.contains(surah.id))
        .toList(growable: false);

    return Column(
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.learnSalahHubGuidedSurahSelectionTitle,
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: GuidedSurahMode.values
                    .map((mode) {
                      final selected = state.guidedSurahMode == mode;
                      return InkWell(
                        onTap: () => notifier.setGuidedSurahMode(mode),
                        borderRadius: BorderRadius.circular(999),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: _salahNoorPillDecoration(
                            context,
                            tintColor: selected
                                ? Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.14)
                                : null,
                          ),
                          child: Text(switch (mode) {
                            GuidedSurahMode.random =>
                              l10n.learnSalahHubGuidedModeRandom,
                            GuidedSurahMode.fixed =>
                              l10n.learnSalahHubGuidedModeFixed,
                            GuidedSurahMode.practiceSpecific =>
                              l10n.learnSalahHubGuidedModePracticeSpecific,
                          }),
                        ),
                      );
                    })
                    .toList(growable: false),
              ),
              if (state.guidedSurahMode == GuidedSurahMode.fixed) ...[
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: state.fixedSurahId,
                  items: unlockedSurahs
                      .map(
                        (surah) => DropdownMenuItem<String>(
                          value: surah.id,
                          child: Text(surah.name),
                        ),
                      )
                      .toList(growable: false),
                  onChanged: notifier.setFixedSurah,
                  decoration: InputDecoration(
                    labelText: l10n.learnSalahHubFixedSurahFieldLabel,
                  ),
                ),
              ],
              if (state.guidedSurahMode ==
                  GuidedSurahMode.practiceSpecific) ...[
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: state.practiceSurahId,
                  items: unlockedSurahs
                      .map(
                        (surah) => DropdownMenuItem<String>(
                          value: surah.id,
                          child: Text(surah.name),
                        ),
                      )
                      .toList(growable: false),
                  onChanged: notifier.setPracticeSurah,
                  decoration: InputDecoration(
                    labelText: l10n.learnSalahHubPracticeSurahFieldLabel,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 10),
        ...prayers.map(
          (prayer) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: PremiumCard(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(prayer.title),
                subtitle: Text(
                  '${prayer.fardRakahs} • ${prayer.recitationStyle}',
                ),
                trailing: const Icon(Icons.play_circle_fill_rounded),
                onTap: () => context.pushNamed(
                  'learnSalahGuidedPrayer',
                  pathParameters: {'prayerId': prayer.id.name},
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AyahTab extends ConsumerWidget {
  const _AyahTab({
    required this.controller,
    required this.query,
    required this.onQueryChanged,
    required this.filteredSurahs,
    required this.unlockedSurahIds,
  });

  final TextEditingController controller;
  final String query;
  final ValueChanged<String> onQueryChanged;
  final List<SurahModel> filteredSurahs;
  final Set<String> unlockedSurahIds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final progress = ref.watch(salahTrainerProgressProvider);
    return Column(
      children: [
        PremiumCard(
          child: TextField(
            controller: controller,
            onChanged: onQueryChanged,
            decoration: InputDecoration(
              hintText: l10n.learnSalahHubSearchSurahsHint,
              prefixIcon: const Icon(Icons.search_rounded),
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 10),
        ...filteredSurahs.map((surah) {
          final status =
              progress.surahProgressById[surah.id] ??
              SalahSurahProgress.notStarted;
          final unlocked =
              surah.id == 'al_fatihah' || unlockedSurahIds.contains(surah.id);
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: CompactListTile(
              title: '${surah.name} (${surah.surahNumber})',
              subtitle: unlocked
                  ? l10n.learnSalahHubSurahCardSubtitle(
                      surah.verses.length,
                      _statusLabel(l10n, status),
                    )
                  : l10n.learnSalahHubSurahLockedSubtitle,
              onTap: unlocked
                  ? () => context.pushNamed(
                      'learnSalahSurahDetail',
                      pathParameters: {'surahId': surah.id},
                    )
                  : null,
            ),
          );
        }),
      ],
    );
  }

  String _statusLabel(AppLocalizations l10n, SalahSurahProgress status) {
    switch (status) {
      case SalahSurahProgress.notStarted:
        return l10n.learnSalahHubStatusNotStarted;
      case SalahSurahProgress.learning:
        return l10n.learnSalahHubStatusLearning;
      case SalahSurahProgress.practiced:
        return l10n.learnSalahHubStatusPracticed;
      case SalahSurahProgress.memorized:
        return l10n.learnSalahHubStatusMemorized;
    }
  }
}

class _RecitationsTab extends ConsumerWidget {
  const _RecitationsTab({
    required this.controller,
    required this.query,
    required this.onQueryChanged,
    required this.recitations,
  });

  final TextEditingController controller;
  final String query;
  final ValueChanged<String> onQueryChanged;
  final List<RecitationModel> recitations;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final progress = ref.watch(salahTrainerProgressProvider);
    final notifier = ref.read(salahTrainerProgressProvider.notifier);
    final playingId = ref.watch(recitationPlaybackControllerProvider);
    final player = ref.read(recitationPlaybackControllerProvider.notifier);
    return Column(
      children: [
        PremiumCard(
          child: TextField(
            controller: controller,
            onChanged: onQueryChanged,
            decoration: InputDecoration(
              hintText: l10n.learnSalahHubSearchRecitationsHint,
              prefixIcon: const Icon(Icons.search_rounded),
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 10),
        ...recitations.map(
          (recitation) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          recitation.title,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      if (progress.learnedRecitationIds.contains(recitation.id))
                        const Icon(Icons.check_circle_rounded, size: 18),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    recitation.category,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    recitation.arabicText,
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(recitation.transliteration),
                  const SizedBox(height: 8),
                  Text(recitation.translation),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilledButton.tonalIcon(
                        onPressed: playingId == recitation.id
                            ? player.stop
                            : () => player.play(recitation),
                        icon: Icon(
                          playingId == recitation.id
                              ? Icons.stop_rounded
                              : Icons.volume_up_rounded,
                        ),
                        label: Text(
                          playingId == recitation.id
                              ? l10n.salahTrainerStopAction
                              : l10n.salahTrainerListenAction,
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () =>
                            notifier.markRecitationLearned(recitation.id),
                        child: Text(l10n.learnSalahHubMarkReviewedAction),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _EssentialsTab extends StatelessWidget {
  const _EssentialsTab({required this.essentials});

  final List<SalahEssentialTopic> essentials;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: essentials
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: PremiumCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(item.summary),
                    const SizedBox(height: 10),
                    ...item.bullets.map(
                      (bullet) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 4),
                              child: Icon(Icons.circle_rounded, size: 6),
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: Text(bullet)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _WuduTab extends StatelessWidget {
  const _WuduTab();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        PremiumCard(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(IslamicIcons.wudhu),
            title: Text(l10n.learnSalahHubWuduGuideTitle),
            subtitle: Text(l10n.learnSalahHubWuduGuideSubtitle),
            onTap: () => context.pushNamed('learnWuduGuide'),
          ),
        ),
        const SizedBox(height: 10),
        PremiumCard(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.play_circle_fill_rounded),
            title: Text(l10n.wuduTrainerPageTitle),
            subtitle: Text(l10n.learnSalahHubWuduTrainerSubtitle),
            onTap: () => context.pushNamed('learnWuduTrainer'),
          ),
        ),
      ],
    );
  }
}

BoxDecoration _salahNoorPillDecoration(
  BuildContext context, {
  Color? tintColor,
}) {
  final style = AppSurfaceTheme.resolve(
    context,
    variant: AppSurfaceVariant.pill,
    tintColor: tintColor,
  );
  return style.decoration(radius: 999);
}
