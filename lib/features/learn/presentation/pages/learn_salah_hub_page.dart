import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/theme/islamic_icons.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/segmented_pill_control.dart';
import '../../salah/application/salah_trainer_provider.dart';
import '../../salah/models/salah_trainer_models.dart';
import '../widgets/learn_hub_page_scaffold.dart';

enum _SalahTrainerTab { learn, guided, ayah, recitations, essentials, wudu }

class LearnSalahHubPage extends ConsumerStatefulWidget {
  const LearnSalahHubPage({super.key});

  @override
  ConsumerState<LearnSalahHubPage> createState() => _LearnSalahHubPageState();
}

class _LearnSalahHubPageState extends ConsumerState<LearnSalahHubPage> {
  _SalahTrainerTab _tab = _SalahTrainerTab.learn;
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
      headerIcon: IslamicIcons.prayer,
      title: 'Salah Trainer',
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
                  'O Allah, make the Qur’an easy for us to learn and remember.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 10),
                const Text(
                  '“And We have certainly made the Qur’an easy for remembrance, so is there any who will remember?”',
                ),
                const SizedBox(height: 4),
                Text(
                  'Qur’an 54:17',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                Text(l10n.learnSalahHubGuidanceNoticeAcknowledge),
                const SizedBox(height: 12),
                FilledButton.tonal(
                  onPressed: () => ref
                      .read(salahTrainerGuidanceNoticeProvider.notifier)
                      .acknowledge(),
                  child: const Text('I acknowledge'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
        SegmentedPillControl<_SalahTrainerTab>(
          items: _SalahTrainerTab.values,
          selectedItem: _tab,
          labelBuilder: _tabLabel,
          onChanged: (value) => setState(() => _tab = value),
        ),
        const SizedBox(height: 10),
        PremiumCard(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _metricPill('Salahs', '${prayers.length}'),
              _metricPill('Unlocked Surahs', '${unlockedSurahIds.length}'),
              _metricPill('Memorized', '$memorizedCount'),
              _metricPill(
                'Recitations',
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
                const Text(
                  'Continue prayer practice',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                ...recentPrayers
                    .take(2)
                    .map(
                      (prayer) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(prayer.title),
                        subtitle: Text(
                          '${prayer.fardRakahs} • ${prayer.recitationStyle}',
                        ),
                        trailing: FilledButton.tonal(
                          onPressed: () => context.pushNamed(
                            'learnSalahGuidedPrayer',
                            pathParameters: {'prayerId': prayer.id.name},
                          ),
                          child: const Text('Resume'),
                        ),
                      ),
                    ),
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

  String _tabLabel(_SalahTrainerTab tab) {
    switch (tab) {
      case _SalahTrainerTab.learn:
        return 'Learn Salah';
      case _SalahTrainerTab.guided:
        return 'Pray With Guidance';
      case _SalahTrainerTab.ayah:
        return 'Learn Ayah';
      case _SalahTrainerTab.recitations:
        return 'Duas & Recitations';
      case _SalahTrainerTab.essentials:
        return 'Essentials';
      case _SalahTrainerTab.wudu:
        return 'Wudu';
    }
  }

  Widget _metricPill(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
      ),
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
                        _infoChip(prayer.sunnahRakahs),
                        _infoChip(prayer.fardRakahs),
                        _infoChip(prayer.recitationStyle),
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

  Widget _infoChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: Colors.white.withValues(alpha: 0.08),
      ),
      child: Text(label),
    );
  }
}

class _GuidedTab extends ConsumerWidget {
  const _GuidedTab({required this.prayers});

  final List<PrayerModel> prayers;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              const Text(
                'Surah selection during guided prayer',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: GuidedSurahMode.values
                    .map((mode) {
                      final selected = state.guidedSurahMode == mode;
                      return ChoiceChip(
                        label: Text(switch (mode) {
                          GuidedSurahMode.random => 'Random Surahs',
                          GuidedSurahMode.fixed => 'Fixed Surah',
                          GuidedSurahMode.practiceSpecific =>
                            'Practice Specific',
                        }),
                        selected: selected,
                        onSelected: (_) => notifier.setGuidedSurahMode(mode),
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
                  decoration: const InputDecoration(labelText: 'Fixed surah'),
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
                  decoration: const InputDecoration(
                    labelText: 'Practice this surah',
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
    final progress = ref.watch(salahTrainerProgressProvider);
    return Column(
      children: [
        PremiumCard(
          child: TextField(
            controller: controller,
            onChanged: onQueryChanged,
            decoration: const InputDecoration(
              hintText: 'Search surahs for prayer',
              prefixIcon: Icon(Icons.search_rounded),
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
            child: PremiumCard(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('${surah.name} (${surah.surahNumber})'),
                subtitle: Text(
                  unlocked
                      ? '${surah.verses.length} ayahs • ${_statusLabel(status)}'
                      : 'Locked until more surahs are practiced',
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: unlocked
                    ? () => context.pushNamed(
                        'learnSalahSurahDetail',
                        pathParameters: {'surahId': surah.id},
                      )
                    : null,
              ),
            ),
          );
        }),
      ],
    );
  }

  String _statusLabel(SalahSurahProgress status) {
    switch (status) {
      case SalahSurahProgress.notStarted:
        return 'Not started';
      case SalahSurahProgress.learning:
        return 'Learning';
      case SalahSurahProgress.practiced:
        return 'Practiced';
      case SalahSurahProgress.memorized:
        return 'Memorized';
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
    final progress = ref.watch(salahTrainerProgressProvider);
    final notifier = ref.read(salahTrainerProgressProvider.notifier);
    return Column(
      children: [
        PremiumCard(
          child: TextField(
            controller: controller,
            onChanged: onQueryChanged,
            decoration: const InputDecoration(
              hintText: 'Search duas and recitations',
              prefixIcon: Icon(Icons.search_rounded),
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
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(recitation.transliteration),
                  const SizedBox(height: 8),
                  Text(recitation.translation),
                  const SizedBox(height: 10),
                  FilledButton.tonal(
                    onPressed: () =>
                        notifier.markRecitationLearned(recitation.id),
                    child: const Text('Mark reviewed'),
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
                              child: Icon(Icons.circle, size: 6),
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
    return Column(
      children: [
        PremiumCard(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(IslamicIcons.wudhu),
            title: const Text('Wudu Guide'),
            subtitle: const Text(
              'Review purification, sequence, and reminders before prayer.',
            ),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.pushNamed('learnWuduGuide'),
          ),
        ),
        const SizedBox(height: 10),
        PremiumCard(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.play_circle_fill_rounded),
            title: const Text('Wudu Trainer'),
            subtitle: const Text(
              'Interactive guided practice and checklist mode.',
            ),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.pushNamed('learnWuduTrainer'),
          ),
        ),
      ],
    );
  }
}
