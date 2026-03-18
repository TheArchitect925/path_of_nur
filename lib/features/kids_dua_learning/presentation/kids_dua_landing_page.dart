import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../learn/presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/kids_dua_creative_provider.dart';
import '../application/kids_dua_experience_provider.dart';
import '../application/kids_dua_my_day_provider.dart';
import '../application/kids_dua_story_repository.dart';
import '../domain/kids_dua_models.dart';

class KidsDuaLandingPage extends ConsumerWidget {
  const KidsDuaLandingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final summary = ref.watch(kidsDuaProgressSummaryProvider);
    final todayFocus = ref.watch(kidsDuaTodayFocusProvider);
    final continueLesson = ref.watch(kidsDuaContinueLessonItemProvider);
    final categoryProgress = ref.watch(kidsDuaCategoryProgressListProvider);
    final myDayState = ref.watch(kidsDuaMyDayProvider);
    final myDayGuidance = ref.watch(kidsDuaMyDayGuidanceProvider);
    final lightSummary = ref.watch(kidsDuaLightSummaryProvider);
    final creative = ref.watch(kidsDuaCreativeProvider);
    final stories = ref.watch(kidsDuaStoriesProvider);

    return LearnHubPageScaffold(
      headerIcon: Icons.volunteer_activism_rounded,
      title: l10n.kidsDuaLandingTitle,
      subtitle: l10n.kidsDuaLandingSubtitle,
      children: [
        _HeroCard(summary: summary),
        const SizedBox(height: 12),
        _LightCard(summary: lightSummary),
        const SizedBox(height: 12),
        if (todayFocus != null) ...[
          _FeatureCard(
            icon: Icons.wb_sunny_rounded,
            title: l10n.kidsDuaTodayTitle,
            subtitle: todayFocus.lesson.title,
            detail: todayFocus.lesson.whenToSay,
            actionLabel: switch (todayFocus.state) {
              KidsDuaDailyDuaState.notLearned => l10n.kidsDuaLearnTodayAction,
              KidsDuaDailyDuaState.inProgress =>
                l10n.kidsDuaContinueTodayAction,
              KidsDuaDailyDuaState.learned => l10n.kidsDuaPracticeTodayAction,
            },
            onTap: () => context.pushNamed(
              todayFocus.state == KidsDuaDailyDuaState.learned
                  ? 'kidsDuaPractice'
                  : 'kidsDuaLesson',
              pathParameters: todayFocus.state == KidsDuaDailyDuaState.learned
                  ? const <String, String>{}
                  : {'lessonId': todayFocus.lesson.id},
            ),
          ),
          const SizedBox(height: 12),
        ],
        if (continueLesson != null) ...[
          _FeatureCard(
            icon: Icons.play_circle_fill_rounded,
            title: l10n.kidsDuaContinueTitle,
            subtitle: continueLesson.title,
            detail: continueLesson.miniLesson,
            actionLabel: l10n.kidsDuaContinueAction,
            onTap: () => context.pushNamed(
              'kidsDuaLesson',
              pathParameters: {'lessonId': continueLesson.id},
            ),
          ),
          const SizedBox(height: 18),
        ] else
          const SizedBox(height: 6),
        _FeatureCard(
          icon: Icons.timeline_rounded,
          title: l10n.kidsDuaMyDayTitle,
          subtitle: myDayState.isDayComplete
              ? l10n.kidsDuaMyDayDoneTitle
              : (myDayGuidance.rightNowLesson?.title ?? l10n.kidsDuaMyDayTitle),
          detail: myDayState.isDayComplete
              ? l10n.kidsDuaMyDayCompleteBody
              : _myDayLandingDetail(l10n, myDayGuidance),
          actionLabel: myDayState.completedDuaIds.isEmpty
              ? l10n.kidsDuaMyDayStartAction
              : (myDayState.isDayComplete
                    ? l10n.kidsDuaMyDayReviewAction
                    : l10n.kidsDuaMyDayContinueAction),
          onTap: () => context.pushNamed('kidsDuaMyDay'),
        ),
        const SizedBox(height: 18),
        _SectionHeader(
          title: l10n.kidsDuaCategoriesTitle,
          subtitle: l10n.kidsDuaCategoriesSubtitle,
        ),
        const SizedBox(height: 10),
        ...categoryProgress.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _CategoryCard(item: item),
          ),
        ),
        const SizedBox(height: 14),
        _QuickEntryCard(
          icon: Icons.quiz_rounded,
          title: l10n.kidsDuaPracticeTitle,
          subtitle: l10n.kidsDuaPracticeModeMatchSituation,
          onTap: () => context.pushNamed('kidsDuaPractice'),
        ),
        const SizedBox(height: 10),
        _QuickEntryCard(
          icon: Icons.menu_book_rounded,
          title: l10n.kidsDuaStoriesTitle,
          subtitle: l10n.kidsDuaStoriesLandingSubtitle(stories.length),
          onTap: () => context.pushNamed('kidsDuaStories'),
        ),
        const SizedBox(height: 10),
        _QuickEntryCard(
          icon: Icons.brush_rounded,
          title: l10n.kidsDuaDrawingsTitle,
          subtitle: l10n.kidsDuaDrawingsLandingSubtitle(
            creative.drawings.length,
          ),
          onTap: () => context.pushNamed('kidsDuaDrawings'),
        ),
        const SizedBox(height: 10),
        _QuickEntryCard(
          icon: Icons.emoji_events_rounded,
          title: l10n.kidsDuaRewardsTitle,
          subtitle: l10n.kidsDuaRewardsEncouragement,
          onTap: () => context.pushNamed('kidsDuaRewards'),
        ),
        const SizedBox(height: 10),
        _QuickEntryCard(
          icon: Icons.family_restroom_rounded,
          title: l10n.kidsDuaParentTitle,
          subtitle: creative.parentViewEnabled
              ? l10n.kidsDuaParentLandingEnabled
              : l10n.kidsDuaParentLandingDisabled,
          onTap: () => context.pushNamed('kidsDuaParentDashboard'),
        ),
      ],
    );
  }
}

class _LightCard extends StatelessWidget {
  const _LightCard({required this.summary});

  final KidsDuaLightSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBF5),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE8DDD0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.kidsDuaLightCardTitle,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.kidsDuaLightValue(_lightLabel(context, summary.lightLabelKey)),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.kidsDuaStreakValue(summary.currentStreakDays),
            style: const TextStyle(color: Color(0xFF8A6A45)),
          ),
          const SizedBox(height: 6),
          Text(
            _localizedCopy(context, summary.lightDescriptionKey),
            style: const TextStyle(color: Color(0xFF675B4E), height: 1.4),
          ),
          const SizedBox(height: 6),
          Text(
            _localizedCopy(context, summary.reminderPrompt.bodyKey),
            style: const TextStyle(color: Color(0xFF675B4E)),
          ),
        ],
      ),
    );
  }
}

String _myDayLandingDetail(
  AppLocalizations l10n,
  KidsDuaMyDayGuidance guidance,
) {
  final reason = switch (guidance.rightNowReasonKey) {
    'kidsDuaMyDayRightNowMorningReason' =>
      l10n.kidsDuaMyDayRightNowMorningReason,
    'kidsDuaMyDayRightNowMealsReason' => l10n.kidsDuaMyDayRightNowMealsReason,
    'kidsDuaMyDayRightNowGoingOutReason' =>
      l10n.kidsDuaMyDayRightNowGoingOutReason,
    _ => l10n.kidsDuaMyDayRightNowNightReason,
  };
  if (guidance.nextUpLesson == null) return reason;
  return l10n.kidsDuaMyDayLandingDetail(reason, guidance.nextUpLesson!.title);
}

String _lightLabel(BuildContext context, String key) =>
    _localizedCopy(context, key);

String _localizedCopy(BuildContext context, String key) {
  final l10n = AppLocalizations.of(context);
  switch (key) {
    case 'kidsDuaLightSeedLabel':
      return l10n.kidsDuaLightSeedLabel;
    case 'kidsDuaLightGlowLabel':
      return l10n.kidsDuaLightGlowLabel;
    case 'kidsDuaLightLanternLabel':
      return l10n.kidsDuaLightLanternLabel;
    case 'kidsDuaLightMoonLabel':
      return l10n.kidsDuaLightMoonLabel;
    case 'kidsDuaLightStarLabel':
      return l10n.kidsDuaLightStarLabel;
    case 'kidsDuaLightRadiantLabel':
      return l10n.kidsDuaLightRadiantLabel;
    case 'kidsDuaLightStartMessage':
      return l10n.kidsDuaLightStartMessage;
    case 'kidsDuaLightBuildMessage':
      return l10n.kidsDuaLightBuildMessage;
    case 'kidsDuaLightSteadyMessage':
      return l10n.kidsDuaLightSteadyMessage;
    case 'kidsDuaLightRadiantMessage':
      return l10n.kidsDuaLightRadiantMessage;
    case 'kidsDuaLightRecoveryMessage':
      return l10n.kidsDuaLightRecoveryMessage;
    case 'kidsDuaLightCompleteTodayMessage':
      return l10n.kidsDuaLightCompleteTodayMessage;
    case 'kidsDuaReminderMorningTitle':
      return l10n.kidsDuaReminderMorningTitle;
    case 'kidsDuaReminderMorningBody':
      return l10n.kidsDuaReminderMorningBody;
    case 'kidsDuaReminderMiddayTitle':
      return l10n.kidsDuaReminderMiddayTitle;
    case 'kidsDuaReminderMiddayBody':
      return l10n.kidsDuaReminderMiddayBody;
    case 'kidsDuaReminderEveningTitle':
      return l10n.kidsDuaReminderEveningTitle;
    case 'kidsDuaReminderEveningBody':
      return l10n.kidsDuaReminderEveningBody;
    case 'kidsDuaReminderBedtimeTitle':
      return l10n.kidsDuaReminderBedtimeTitle;
    case 'kidsDuaReminderBedtimeBody':
      return l10n.kidsDuaReminderBedtimeBody;
    case 'kidsDuaReminderRecoveryTitle':
      return l10n.kidsDuaReminderRecoveryTitle;
    case 'kidsDuaReminderRecoveryBody':
      return l10n.kidsDuaReminderRecoveryBody;
    default:
      return key;
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.summary});

  final KidsDuaProgressSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF6EA),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE7D7BE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.kidsDuaHeroTitle,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.kidsDuaHeroSubtitle,
            style: const TextStyle(color: Color(0xFF675B4E), height: 1.4),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _Pill(
                label: l10n.kidsDuaLearnedCountValue(summary.learnedLessons),
              ),
              _Pill(label: l10n.kidsDuaLibraryCountValue(summary.totalLessons)),
              _Pill(
                label: l10n.kidsDuaCategoryCountValue(
                  summary.completedCategories,
                ),
              ),
              _Pill(
                label: l10n.kidsDuaRewardsCountValue(summary.unlockedRewards),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.detail,
    required this.actionLabel,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String detail;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE8DDD0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8EF),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(icon, color: const Color(0xFF8A6A45)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(detail, style: const TextStyle(color: Color(0xFF655A4C))),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(onPressed: onTap, child: Text(actionLabel)),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.item});

  final KidsDuaCategoryProgress item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return InkWell(
      onTap: () => context.pushNamed(
        'kidsDuaCategory',
        pathParameters: {'categoryId': item.category.id},
      ),
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFE8DDD0)),
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8EF),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(item.category.icon, color: const Color(0xFF8A6A45)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.category.title,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.category.subtitle,
                    style: const TextStyle(color: Color(0xFF6D6255)),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.kidsDuaCategoryProgressValue(
                      item.learnedCount,
                      item.totalCount,
                    ),
                    style: const TextStyle(
                      color: Color(0xFF8A6A45),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFF8A6A45)),
          ],
        ),
      ),
    );
  }
}

class _QuickEntryCard extends StatelessWidget {
  const _QuickEntryCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFFE8DDD0)),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8EF),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, color: const Color(0xFF8A6A45)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Color(0xFF6D6255)),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFF8A6A45)),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Text(subtitle, style: const TextStyle(color: Color(0xFF6D6255))),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE4D7C8)),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}
