import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/content/learning_quote.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../../../shared/widgets/quran_navigation.dart';
import '../../../../shared/widgets/section_hub_scaffold.dart';
import '../../../learn/knowledge_games/daily/application/daily_knowledge_challenge_hub_provider.dart';
import '../../application/journey_progression_provider.dart';
import '../application/spiritual_growth_provider.dart';
import 'spiritual_growth_ui_helpers.dart';
import '../../../../core/theme/app_icons.dart';

class SpiritualGrowthPage extends ConsumerWidget {
  const SpiritualGrowthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final quote = buildGrowthReflectionQuote();
    final todayKey = ref.watch(spiritualGrowthTodayKeyProvider);
    final activeIntention = ref.watch(spiritualGrowthActiveIntentionProvider);
    final actions = ref.watch(spiritualGrowthTodayActionStatusesProvider);
    final profile = ref.watch(spiritualGrowthProfileProvider);
    final themes = ref.watch(spiritualGrowthThemeSummariesProvider);
    final reflectionEntry = ref.watch(
      spiritualGrowthControllerProvider.select(
        (value) => value.reflectionEntryFor(todayKey),
      ),
    );
    final snapshot = ref.watch(journeyActivitySnapshotProvider);
    final hubProgress = ref.watch(dailyKnowledgeChallengeHubProgressProvider);

    return SectionHubScaffold(
      headerIcon: AppIcons.spiritualGrowth,
      title: l10n.spiritualGrowthTitle,
      subtitle: l10n.spiritualGrowthSubtitle,
      quote: quote,
      onQuoteTap: (selectedQuote) =>
          openQuranQuoteLocation(context, selectedQuote),
      shortcutOpenLabel: l10n.learnShortcutOpen,
      shortcutCloseLabel: l10n.learnShortcutClose,
      shortcutActions: [
        SectionShortcutAction(
          label: l10n.spiritualGrowthChooseIntentionAction,
          supportingText: l10n.spiritualGrowthChooseIntentionSubtitle,
          icon: Icons.track_changes_rounded,
          onTap: () => context.pushNamed('spiritualGrowthIntentions'),
        ),
        SectionShortcutAction(
          label: l10n.spiritualGrowthReflectionAction,
          supportingText: l10n.spiritualGrowthReflectionEntrySubtitle,
          icon: Icons.auto_stories_rounded,
          onTap: () => context.pushNamed('spiritualGrowthReflection'),
        ),
      ],
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.spiritualGrowthTodayIntentionTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Text(
                spiritualGrowthTitleFromKey(l10n, activeIntention.titleKey),
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(
                spiritualGrowthSubtitleFromKey(
                  l10n,
                  activeIntention.descriptionKey,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _chip(
                    context,
                    spiritualGrowthThemeLabel(l10n, activeIntention.theme),
                  ),
                  _chip(
                    context,
                    l10n.spiritualGrowthEffortLabel(
                      activeIntention.difficulty.toString(),
                    ),
                  ),
                  if (profile.reflectionStreak > 0)
                    _chip(
                      context,
                      l10n.spiritualGrowthReflectionStreakLabel(
                        profile.reflectionStreak.toString(),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton(
                    onPressed: () =>
                        context.pushNamed('spiritualGrowthIntentions'),
                    child: Text(l10n.spiritualGrowthChooseIntentionAction),
                  ),
                  OutlinedButton(
                    onPressed: () =>
                        context.pushNamed('spiritualGrowthReflection'),
                    child: Text(l10n.spiritualGrowthReflectionAction),
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
                l10n.spiritualGrowthDailyActionsTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Text(l10n.spiritualGrowthDailyActionsSubtitle),
              const SizedBox(height: 10),
              ...actions.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        item.isCompleted
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked_rounded,
                        size: 20,
                        color: item.isCompleted
                            ? const Color(0xFF597045)
                            : null,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              spiritualGrowthTitleFromKey(
                                l10n,
                                item.action.titleKey,
                              ),
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              spiritualGrowthSubtitleFromKey(
                                l10n,
                                item.action.descriptionKey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
                l10n.spiritualGrowthRealLifeActionsTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Text(l10n.spiritualGrowthRealLifeActionsSubtitle),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: actions
                    .where((item) => item.isManual)
                    .map(
                      (item) => FilterChip(
                        selected: item.isCompleted,
                        label: Text(
                          spiritualGrowthTitleFromKey(
                            l10n,
                            item.action.titleKey,
                          ),
                        ),
                        onSelected: (_) => ref
                            .read(spiritualGrowthControllerProvider.notifier)
                            .toggleManualAction(
                              dateKey: todayKey,
                              actionId: item.action.id,
                            ),
                      ),
                    )
                    .toList(growable: false),
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
                l10n.spiritualGrowthReflectionTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Text(
                reflectionEntry?.isCompleted == true
                    ? l10n.spiritualGrowthReflectionCompletedSubtitle
                    : l10n.spiritualGrowthReflectionEntrySubtitle,
              ),
              if (reflectionEntry?.isCompleted == true) ...[
                const SizedBox(height: 10),
                Text(
                  l10n.spiritualGrowthReflectionSavedBadge,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
              const SizedBox(height: 10),
              FilledButton.tonal(
                onPressed: () => context.pushNamed('spiritualGrowthReflection'),
                child: Text(l10n.spiritualGrowthReflectionAction),
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
                l10n.spiritualGrowthThemeSummaryTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Text(l10n.spiritualGrowthThemeSummarySubtitle),
              const SizedBox(height: 10),
              if (themes.isEmpty)
                Text(l10n.spiritualGrowthThemeSummaryEmpty)
              else ...[
                ...themes
                    .take(3)
                    .map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                spiritualGrowthThemeLabel(l10n, item.theme),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Text(
                              l10n.spiritualGrowthThemeCountLabel(
                                item.activityCount.toString(),
                                item.consistencyCount.toString(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () => context.pushNamed('spiritualGrowthThemes'),
                  child: Text(l10n.spiritualGrowthViewThemesAction),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.spiritualGrowthTodaySummaryTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _chip(
                    context,
                    l10n.spiritualGrowthPrayerSummaryLabel(
                      snapshot.prayerCompletedToday.toString(),
                    ),
                  ),
                  _chip(
                    context,
                    l10n.spiritualGrowthDhikrSummaryLabel(
                      snapshot.dhikrSessionsToday.toString(),
                    ),
                  ),
                  _chip(
                    context,
                    l10n.spiritualGrowthLearningSummaryLabel(
                      snapshot.learningStageCompletionsToday.toString(),
                    ),
                  ),
                  _chip(
                    context,
                    l10n.spiritualGrowthBundleSummaryLabel(
                      hubProgress.progressFor(todayKey).isCompleted
                          ? l10n.spiritualGrowthBundleDone
                          : l10n.spiritualGrowthBundleOpen,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _chip(BuildContext context, String label) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFF4ECDF),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(label, style: Theme.of(context).textTheme.bodySmall),
      ),
    );
  }
}
