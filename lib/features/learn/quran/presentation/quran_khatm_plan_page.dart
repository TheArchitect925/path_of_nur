import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/display/progress_bar.dart';
import '../../../../shared/application/daily_clock_provider.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/quran_khatm_provider.dart';
import '../application/quran_providers.dart';
import '../domain/quran_khatm_models.dart';

/// The whole-Qur'an reading plan: pick a pace, see today's portion, and keep
/// a khatm moving. Replaces the old manual Ramadan juz slider.
class QuranKhatmPlanPage extends ConsumerWidget {
  const QuranKhatmPlanPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final status = ref.watch(quranKhatmStatusProvider);

    return LearnHubPageScaffold(
      headerIcon: Icons.flag_circle_outlined,
      title: l10n.quranKhatmPageTitle,
      subtitle: l10n.quranKhatmPageSubtitle,
      children: status == null
          ? [_PacePickerCard(status: null)]
          : [
              _ProgressCard(status: status),
              const SizedBox(height: 12),
              _TodayPortionCard(status: status),
              const SizedBox(height: 12),
              _PacePickerCard(status: status),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => _confirmRemove(context, ref),
                    child: Text(l10n.quranKhatmStopAction),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      final progress = ref.read(quranReadingProgressProvider);
                      ref
                          .read(quranKhatmPlanProvider.notifier)
                          .setCompletedThrough(
                            progress.surahNumber,
                            progress.ayahNumber,
                          );
                    },
                    icon: const Icon(Icons.my_location_rounded, size: 18),
                    label: Text(l10n.quranKhatmSyncAction),
                  ),
                ],
              ),
            ],
    );
  }

  Future<void> _confirmRemove(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final material = MaterialLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.quranKhatmStopAction),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(material.cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(material.okButtonLabel),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      ref.read(quranKhatmPlanProvider.notifier).clearPlan();
    }
  }
}

class _ProgressCard extends ConsumerWidget {
  const _ProgressCard({required this.status});

  final QuranKhatmStatus status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (status.plan.isComplete) ...[
            Text(
              l10n.quranKhatmCompleteTitle,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
          ],
          ProgressBar(value: status.progressFraction, height: 8),
          const SizedBox(height: 8),
          Text(
            l10n.quranKhatmProgressLabel(
              (status.progressFraction * 100).round(),
              status.currentJuz,
            ),
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _TodayPortionCard extends ConsumerWidget {
  const _TodayPortionCard({required this.status});

  final QuranKhatmStatus status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    if (status.plan.isComplete) return const SizedBox.shrink();
    final (startSurah, startAyah) = status.portion.startPosition;
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.quranKhatmTodayPortionTitle,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(status.portionLabel),
          Text(
            l10n.quranKhatmAyahCountLabel(status.portion.ayahCount),
            style: Theme.of(context).textTheme.labelSmall,
          ),
          const SizedBox(height: 10),
          if (status.portionDoneToday)
            Text(
              l10n.quranKhatmPortionDoneLabel,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: FilledButton.tonal(
                    onPressed: () => context.pushNamed(
                      'quranReader',
                      pathParameters: {'surahNumber': '$startSurah'},
                      queryParameters: {'ayah': '$startAyah'},
                    ),
                    child: Text(l10n.quranKhatmContinueAction),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      final now =
                          ref.read(dailyNowProvider).value ?? DateTime.now();
                      ref
                          .read(quranKhatmPlanProvider.notifier)
                          .markPortionDone(now);
                    },
                    child: Text(
                      l10n.quranKhatmMarkDoneAction,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _PacePickerCard extends ConsumerWidget {
  const _PacePickerCard({required this.status});

  final QuranKhatmStatus? status;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final plan = status?.plan;

    bool isJuz(double perDay) =>
        plan != null &&
        plan.paceMode == QuranKhatmPaceMode.juzPerDay &&
        (plan.juzPerDay - perDay).abs() < 0.01;
    final isPages = plan?.paceMode == QuranKhatmPaceMode.pagesPerDay;
    final isFinishBy = plan?.paceMode == QuranKhatmPaceMode.finishBy;

    void apply({
      required QuranKhatmPaceMode mode,
      double juzPerDay = 1,
      int pagesPerDay = 10,
      DateTime? targetDate,
    }) {
      final notifier = ref.read(quranKhatmPlanProvider.notifier);
      if (plan == null) {
        notifier.startPlan(
          paceMode: mode,
          juzPerDay: juzPerDay,
          pagesPerDay: pagesPerDay,
          targetDate: targetDate,
        );
      } else {
        notifier.updatePace(
          paceMode: mode,
          juzPerDay: juzPerDay,
          pagesPerDay: pagesPerDay,
          targetDate: targetDate,
        );
      }
    }

    Future<void> pickDate() async {
      final now = ref.read(dailyNowProvider).value ?? DateTime.now();
      final picked = await showDatePicker(
        context: context,
        initialDate: now.add(const Duration(days: 30)),
        firstDate: now.add(const Duration(days: 1)),
        lastDate: now.add(const Duration(days: 365 * 3)),
      );
      if (picked != null) {
        apply(mode: QuranKhatmPaceMode.finishBy, targetDate: picked);
      }
    }

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.quranKhatmPaceTitle,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ChoiceChip(
                label: Text(l10n.quranKhatmPaceHalfJuz),
                selected: isJuz(0.5),
                onSelected: (_) =>
                    apply(mode: QuranKhatmPaceMode.juzPerDay, juzPerDay: 0.5),
              ),
              ChoiceChip(
                label: Text(l10n.quranKhatmPaceOneJuz),
                selected: isJuz(1),
                onSelected: (_) =>
                    apply(mode: QuranKhatmPaceMode.juzPerDay, juzPerDay: 1),
              ),
              ChoiceChip(
                label: Text(l10n.quranKhatmPaceTwoJuz),
                selected: isJuz(2),
                onSelected: (_) =>
                    apply(mode: QuranKhatmPaceMode.juzPerDay, juzPerDay: 2),
              ),
              ChoiceChip(
                label: Text(l10n.quranKhatmPacePages(10)),
                selected: isPages,
                onSelected: (_) => apply(
                  mode: QuranKhatmPaceMode.pagesPerDay,
                  pagesPerDay: 10,
                ),
              ),
              ChoiceChip(
                label: Text(l10n.quranKhatmPaceRamadan),
                selected: false,
                onSelected: (_) {
                  final now =
                      ref.read(dailyNowProvider).value ?? DateTime.now();
                  apply(
                    mode: QuranKhatmPaceMode.finishBy,
                    targetDate: now.add(const Duration(days: 29)),
                  );
                },
              ),
              ChoiceChip(
                label: Text(l10n.quranKhatmPaceFinishBy),
                selected: isFinishBy,
                onSelected: (_) => pickDate(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
