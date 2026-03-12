import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../application/prophet_detail_repository.dart';
import '../application/revelation_progress_service.dart';
import '../domain/prophet_entry.dart';
import '../domain/prophets_tab.dart';
import '../domain/revelation_era.dart';
import 'widgets/revelation_era_card.dart';
import 'widgets/revelation_growth_link_card.dart';
import 'widgets/revelation_prophet_node.dart';
import 'widgets/revelation_reflection_card.dart';

class JourneyOfRevelationPage extends ConsumerWidget {
  const JourneyOfRevelationPage({
    super.key,
    required this.prophets,
    required this.onOpenDetail,
    required this.onSwitchTab,
    this.focusedEraId,
  });

  final List<ProphetEntry> prophets;
  final ValueChanged<ProphetEntry> onOpenDetail;
  final ValueChanged<ProphetsTab> onSwitchTab;
  final String? focusedEraId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eras = ref.watch(revelationErasProvider);
    final progress = ref.watch(revelationProgressProvider);
    final progressController = ref.read(revelationProgressProvider.notifier);
    final detailRepo = ref.watch(prophetDetailRepositoryProvider);
    final byId = {for (final p in prophets) p.id: p};

    final totalProphets = eras.fold<int>(
      0,
      (sum, era) => sum + era.prophetIds.length,
    );
    final completionPercent = progressController.completionPercent(eras);
    final completedEras = progress.completedEraIds.length;
    final continuityCalls = eras
        .expand((e) => e.coreMessages.map((m) => m.text))
        .toSet()
        .take(6)
        .toList(growable: false);

    final lastEra = progress.lastVisitedEraId == null
        ? null
        : eras.where((e) => e.id == progress.lastVisitedEraId).firstOrNull;
    final lastProphet = progress.lastVisitedProphetId == null
        ? null
        : byId[progress.lastVisitedProphetId!];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Journey of Revelation',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                'Walk the prophetic message across eras, regions, and recurring calls to truth.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceSubtle,
                ),
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(value: completionPercent),
              ),
              const SizedBox(height: 6),
              Text(
                'Progress: ${progress.openedProphetIds.length}/$totalProphets prophets explored · $completedEras/${eras.length} eras completed',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceSubtle,
                ),
              ),
              if (lastEra != null || lastProphet != null) ...[
                const SizedBox(height: 6),
                Text(
                  'Continue from: ${lastEra?.title ?? 'Era'}${lastProphet == null ? '' : ' · ${lastProphet.name}'}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceSubtle,
                  ),
                ),
              ],
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton(
                    onPressed: () {
                      progressController.startJourney();
                    },
                    child: const Text('Start Journey'),
                  ),
                  OutlinedButton(
                    onPressed: (lastEra == null && lastProphet == null)
                        ? null
                        : () {
                            if (lastEra != null) {
                              progressController.markEraOpened(lastEra.id);
                            }
                            if (lastEra != null && lastProphet != null) {
                              progressController.markProphetOpened(
                                eraId: lastEra.id,
                                prophetId: lastProphet.id,
                                eraProphetIds: lastEra.prophetIds,
                              );
                              onOpenDetail(lastProphet);
                            }
                          },
                    child: const Text('Continue Journey'),
                  ),
                  OutlinedButton(
                    onPressed: () => onSwitchTab(ProphetsTab.stories),
                    child: const Text('Explore Freely'),
                  ),
                  OutlinedButton(
                    onPressed: () => onSwitchTab(ProphetsTab.familyTree),
                    child: const Text('Family Tree'),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'One Message Across Time',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text(
                'Across different eras and peoples, the prophetic call remains clear and connected.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceSubtle,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: continuityCalls
                    .map((call) => _continuityChip(call))
                    .toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ...eras.map((era) {
          final eraProphets = era.prophetIds
              .map((id) => byId[id])
              .whereType<ProphetEntry>()
              .toList();
          final started = progress.startedEraIds.contains(era.id);
          final completed = progress.completedEraIds.contains(era.id);
          final current =
              progress.lastVisitedEraId == era.id || focusedEraId == era.id;
          final featuredNames = era.featuredProphetIds
              .map((id) => byId[id]?.name)
              .whereType<String>()
              .toList();
          final featuredLabel = featuredNames.isEmpty
              ? 'Featured: ${eraProphets.take(2).map((e) => e.name).join(', ')}'
              : 'Featured: ${featuredNames.join(', ')}';

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RevelationEraCard(
                  title: era.title,
                  summary: era.summary,
                  regionLabel: era.regionLabel,
                  civilizationTitle: era.civilizationTitle,
                  civilizationSummary: era.civilizationSummary,
                  coreMessages: era.coreMessages.map((m) => m.text).toList(),
                  humanPatternSummaries: era.humanPatterns
                      .map((pattern) => '${pattern.title}: ${pattern.summary}')
                      .toList(),
                  growthHabitLabels: _habitLabels(era.relatedGrowthHabitIds),
                  featuredProphetsLabel: featuredLabel,
                  started: started,
                  completed: completed,
                  current: current,
                  onStartOrContinue: () {
                    progressController.markEraOpened(era.id);
                    final target = _nextProphetForEra(
                      era,
                      progress.openedProphetIds,
                      byId,
                    );
                    if (target != null) {
                      progressController.markProphetOpened(
                        eraId: era.id,
                        prophetId: target.id,
                        eraProphetIds: era.prophetIds,
                      );
                      onOpenDetail(target);
                    }
                  },
                  onOpenTimeline: () => onSwitchTab(ProphetsTab.timeline),
                  onOpenMap: () => onSwitchTab(ProphetsTab.map),
                  onOpenQuiz: () => onSwitchTab(ProphetsTab.quiz),
                ),
                const SizedBox(height: 8),
                ...List.generate(eraProphets.length, (index) {
                  final prophet = eraProphets[index];
                  final detail = detailRepo.forProphet(prophet);
                  final completedNode = progress.openedProphetIds.contains(
                    prophet.id,
                  );
                  final currentNode =
                      progress.lastVisitedProphetId == prophet.id;
                  final reference = detail.quranReferences.isEmpty
                      ? ''
                      : '${detail.quranReferences.first.surahName} ${detail.quranReferences.first.verseRange}';
                  final keyLesson = detail.keyLessons.isEmpty
                      ? era.coreMessage
                      : detail.keyLessons.first.title;

                  return RevelationProphetNode(
                    name: prophet.name,
                    arabicName: prophet.arabicName,
                    summary: prophet.shortSummary,
                    regionLabel: prophet.regionLabel,
                    keyLesson: keyLesson,
                    coreCall: era.coreMessage,
                    referenceLabel: reference.isEmpty
                        ? ''
                        : 'Reference • $reference',
                    completed: completedNode,
                    current: currentNode,
                    isFirst: index == 0,
                    isLast: index == eraProphets.length - 1,
                    onOpenDetail: () {
                      progressController.markProphetOpened(
                        eraId: era.id,
                        prophetId: prophet.id,
                        eraProphetIds: era.prophetIds,
                      );
                      onOpenDetail(prophet);
                    },
                    onContinue: () {
                      progressController.markProphetOpened(
                        eraId: era.id,
                        prophetId: prophet.id,
                        eraProphetIds: era.prophetIds,
                      );
                      onOpenDetail(prophet);
                    },
                  );
                }),
                if (era.reflectionPrompts.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: RevelationReflectionCard(
                      prompts: era.reflectionPrompts,
                    ),
                  ),
                if (era.relatedGrowthHabitIds.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: RevelationGrowthLinkCard(
                      habitLabels: _habitLabels(era.relatedGrowthHabitIds),
                    ),
                  ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _continuityChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: AppColors.surface.withValues(alpha: 0.28),
        border: Border.all(
          color: AppColors.accentGoldSoft.withValues(alpha: 0.34),
        ),
      ),
      child: Text(text, style: const TextStyle(fontSize: 11.5)),
    );
  }

  ProphetEntry? _nextProphetForEra(
    RevelationEra era,
    Set<String> openedIds,
    Map<String, ProphetEntry> byId,
  ) {
    for (final id in era.prophetIds) {
      if (!openedIds.contains(id)) {
        return byId[id];
      }
    }
    if (era.prophetIds.isEmpty) return null;
    return byId[era.prophetIds.first];
  }

  List<String> _habitLabels(List<String> habitIds) {
    return habitIds
        .map((id) => _habitLabelById[id] ?? _toTitleCase(id))
        .toList(growable: false);
  }

  String _toTitleCase(String value) {
    final words = value
        .split('_')
        .where((part) => part.trim().isNotEmpty)
        .map((part) => '${part[0].toUpperCase()}${part.substring(1)}');
    return words.join(' ');
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return null;
    return iterator.current;
  }
}

const Map<String, String> _habitLabelById = {
  'daily_istighfar': 'Daily Istighfar',
  'make_dua_daily': 'Daily Dua',
  'study_islamic_knowledge': 'Study Knowledge',
  'practice_patience': 'Practice Patience',
  'read_quran_daily': 'Read Qur\'an',
  'practice_humility': 'Practice Humility',
  'practice_gratitude': 'Practice Gratitude',
  'end_day_with_reflection_and_tawbah': 'Night Reflection',
  'reconnect_with_family': 'Reconnect with Family',
  'help_someone': 'Help Someone',
  'send_salawat': 'Send Salawat',
};
