import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/app_router.dart';
import '../../../features/worship/domain/fasting_status.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/application/app_summary_providers.dart';
import '../../../shared/application/special_mode_provider.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/section_title.dart';

class ProfileSummaryPage extends ConsumerWidget {
  const ProfileSummaryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final summary = ref.watch(homeDashboardSummaryProvider);
    final worship = summary.worship;
    final learn = summary.learn;
    final journey = summary.journey;
    final mode = summary.mode.activeMode;
    final assistant = summary.assistant;
    final circles = summary.circles;
    final ocean = summary.ocean;
    final journal = summary.journal;
    final wallpaper = summary.wallpaper;
    final prayerProgressText = l10n.homeFractionValue(
      _formatCount(context, worship.prayerCompleted),
      _formatCount(context, worship.prayerTotal),
    );
    final dhikrProgressText = l10n.homeFractionValue(
      _formatCount(context, worship.dhikrCount),
      _formatCount(context, worship.dhikrTarget),
    );

    return AppPageScaffold(
      headerIcon: Icons.summarize_outlined,
      title: l10n.homeOverviewHeroTitle,
      subtitle: l10n.homeOverviewHeroSubtitle,
      children: [
        SectionTitle(
          title: l10n.homeOverviewHeroTitle,
          subtitle: l10n.homeOverviewHeroSubtitle,
        ),
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _ValueTile(
                      title: l10n.homePrayerProgressTitle,
                      value: prayerProgressText,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ValueTile(
                      title: l10n.homeDhikrProgressTitle,
                      value: dhikrProgressText,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _ValueTile(
                      title: l10n.homeCurrentStreakTitle,
                      value: l10n.homeDaysCount(journey.currentStreakDays),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ValueTile(
                      title: l10n.homeXpLevelTitle,
                      value: l10n.homeLevelValue(
                        _formatCount(context, journey.level),
                        _formatCount(context, journey.level),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: journey.xpProgress,
                  minHeight: 8,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SectionTitle(
          title: l10n.homeWorshipSummaryTitle,
          subtitle: l10n.homeWorshipSummarySubtitle,
        ),
        PremiumCard(
          child: Column(
            children: [
              _SummaryRow(
                label: l10n.homePrayerProgressTitle,
                value: prayerProgressText,
                onTap: () => goToTab(context, NavTab.worship),
              ),
              const Divider(height: 10),
              _SummaryRow(
                label: l10n.homeDhikrProgressTitle,
                value: dhikrProgressText,
                onTap: () => goToTab(context, NavTab.worship),
              ),
              const Divider(height: 10),
              _SummaryRow(
                label: l10n.homeFastingStatusTitle,
                value: _fastingLabel(l10n, worship.fastingStatus),
                onTap: () => goToTab(context, NavTab.worship),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SectionTitle(
          title: l10n.homeLearnSummaryTitle,
          subtitle: l10n.homeLearnSummarySubtitle,
        ),
        PremiumCard(
          child: Column(
            children: [
              _SummaryRow(
                label: l10n.homeLearnContinueQuran,
                value: l10n.homeContinueQuranValue(
                  learn.continueSurahName,
                  _formatCount(context, learn.continueAyah),
                  learn.continueSurahName,
                  _formatCount(context, learn.continueAyah),
                ),
                onTap: () => context.pushNamed('quranExplorer'),
              ),
              const Divider(height: 10),
              _SummaryRow(
                label: l10n.homeLearnFeaturedLife,
                value: _lifeTopicLabel(l10n, learn.featuredLifeTopic),
                onTap: () => context.pushNamed('learnLifeLanding'),
              ),
              const Divider(height: 10),
              _SummaryRow(
                label: l10n.homeLearnFeaturedWorld,
                value: _worldTopicLabel(l10n, learn.featuredWorldTopic),
                onTap: () => context.pushNamed('learnWorldLanding'),
              ),
              const Divider(height: 10),
              _SummaryRow(
                label: l10n.homeLearnFeaturedHadith,
                value: _hadithTopicLabel(l10n, learn.featuredHadithTopic),
                onTap: () => context.pushNamed('learnHadithLanding'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SectionTitle(
          title: l10n.homeJourneySummaryTitle,
          subtitle: l10n.homeJourneySummarySubtitle,
        ),
        PremiumCard(
          child: Column(
            children: [
              _SummaryRow(
                label: l10n.homeXpLevelTitle,
                value: l10n.homeLevelValue(
                  _formatCount(context, journey.level),
                  _formatCount(context, journey.level),
                ),
                onTap: () => goToTab(context, NavTab.journey),
              ),
              const Divider(height: 10),
              _SummaryRow(
                label: l10n.homeJourneyXpProgressTitle,
                value: l10n.homeXpValue(
                  _formatCount(context, journey.xp),
                  _formatCount(context, journey.xp),
                ),
                onTap: () => goToTab(context, NavTab.journey),
              ),
              if (mode != AppSpecialMode.gentle) ...[
                const Divider(height: 10),
                _SummaryRow(
                  label: l10n.homeCurrentStreakTitle,
                  value: l10n.homeDaysCount(journey.currentStreakDays),
                  onTap: () => goToTab(context, NavTab.journey),
                ),
              ],
              const Divider(height: 10),
              _SummaryRow(
                label: l10n.homeJourneyNextUnlockTitle,
                value: _nextUnlockLabel(l10n, journey.nextUnlockPreviewKey),
                onTap: () => goToTab(context, NavTab.journey),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SectionTitle(
          title: l10n.homeEcosystemSummaryTitle,
          subtitle: l10n.homeEcosystemSummarySubtitle,
        ),
        PremiumCard(
          child: Column(
            children: [
              _SummaryRow(
                label: l10n.oceanTitle,
                value: _formatCount(context, ocean.totalDrops),
                onTap: () => context.pushNamed('oceanDrops'),
              ),
              const Divider(height: 10),
              _SummaryRow(
                label: l10n.wallpaperLibraryTitle,
                value: l10n.homeCountAndLabel(
                  _formatCount(context, wallpaper.unlockedCount),
                  wallpaper.selectedTitle,
                ),
                onTap: () => context.pushNamed('wallpaperLibrary'),
              ),
              const Divider(height: 10),
              _SummaryRow(
                label: l10n.circlesTitle,
                value: l10n.homeCountAndLabel(
                  _formatCount(context, circles.joinedCount),
                  circles.featuredCircleTitle,
                ),
                onTap: () => context.pushNamed('circlesDiscovery'),
              ),
              const Divider(height: 10),
              _SummaryRow(
                label: l10n.journalTitle,
                value: l10n.homeCountAndLabel(
                  _formatCount(context, journal.entriesCount),
                  journal.favoriteEntries,
                ),
                onTap: () => context.pushNamed('journalTimeline'),
              ),
              const Divider(height: 10),
              _SummaryRow(
                label: l10n.assistantTitle,
                value: l10n.homeCountAndLabel(
                  _formatCount(context, assistant.recentMessages),
                  assistant.recentPrompts,
                ),
                onTap: () => context.pushNamed('assistant'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _lifeTopicLabel(AppLocalizations l10n, LearnLifeTopic topic) {
    switch (topic) {
      case LearnLifeTopic.marriage:
        return l10n.learnLifeMarriage;
      case LearnLifeTopic.parents:
        return l10n.learnLifeParents;
      case LearnLifeTopic.children:
        return l10n.learnLifeChildren;
      case LearnLifeTopic.wealth:
        return l10n.learnLifeWealth;
      case LearnLifeTopic.patience:
        return l10n.learnLifePatience;
      case LearnLifeTopic.justice:
        return l10n.learnLifeJustice;
      case LearnLifeTopic.character:
        return l10n.learnLifeCharacter;
      case LearnLifeTopic.gratitude:
        return l10n.learnLifeGratitude;
    }
  }

  String _worldTopicLabel(AppLocalizations l10n, LearnWorldTopic topic) {
    switch (topic) {
      case LearnWorldTopic.moon:
        return l10n.learnWorldMoon;
      case LearnWorldTopic.bees:
        return l10n.learnWorldBees;
      case LearnWorldTopic.mountains:
        return l10n.learnWorldMountains;
      case LearnWorldTopic.rain:
        return l10n.learnWorldRain;
      case LearnWorldTopic.oceans:
        return l10n.learnWorldOceans;
      case LearnWorldTopic.animals:
        return l10n.learnWorldAnimals;
      case LearnWorldTopic.plants:
        return l10n.learnWorldPlants;
      case LearnWorldTopic.nightAndDay:
        return l10n.learnWorldNightDay;
    }
  }

  String _hadithTopicLabel(AppLocalizations l10n, LearnHadithTopic topic) {
    switch (topic) {
      case LearnHadithTopic.lifeLessons:
        return l10n.learnHadithLifeLessonsTitle;
      case LearnHadithTopic.worldLessons:
        return l10n.learnHadithWorldLessonsTitle;
      case LearnHadithTopic.characterAndManners:
        return l10n.learnHadithCharacterTitle;
      case LearnHadithTopic.worshipAndIntention:
        return l10n.learnHadithWorshipTitle;
      case LearnHadithTopic.familyAndSociety:
        return l10n.learnHadithFamilyTitle;
    }
  }

  String _nextUnlockLabel(AppLocalizations l10n, String unlockKey) {
    switch (unlockKey) {
      case 'wallpaper':
        return l10n.journeyUnlockWallpaper;
      case 'reflection':
        return l10n.journeyUnlockReflection;
      case 'theme':
        return l10n.journeyUnlockTheme;
      default:
        return l10n.journeyUnlockFuture;
    }
  }

  String _fastingLabel(AppLocalizations l10n, FastingStatus status) {
    switch (status) {
      case FastingStatus.completed:
        return l10n.homeFastingCompleted;
      case FastingStatus.intending:
        return l10n.homeFastingIntending;
      case FastingStatus.broken:
        return l10n.homeFastingBroken;
      case FastingStatus.notFasting:
        return l10n.homeFastingNotFasting;
    }
  }
}

String _formatCount(BuildContext context, num value) {
  final locale = Localizations.localeOf(context).toLanguageTag();
  return NumberFormat.decimalPattern(locale).format(value);
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Expanded(child: Text(label)),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right_rounded, size: 18),
          ],
        ),
      ),
    );
  }
}

class _ValueTile extends StatelessWidget {
  const _ValueTile({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFEEE6DA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
