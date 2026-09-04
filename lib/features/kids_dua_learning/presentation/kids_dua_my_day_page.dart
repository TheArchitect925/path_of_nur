import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_palette.dart';
import '../../../core/theme/app_surfaces.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/premium_card.dart';
import '../application/kids_dua_experience_provider.dart';
import '../application/kids_dua_my_day_provider.dart';
import '../application/kids_dua_repository.dart';
import '../application/kids_dua_story_repository.dart';
import '../domain/kids_dua_models.dart';

class KidsDuaMyDayPage extends ConsumerStatefulWidget {
  const KidsDuaMyDayPage({super.key});

  @override
  ConsumerState<KidsDuaMyDayPage> createState() => _KidsDuaMyDayPageState();
}

class _KidsDuaMyDayPageState extends ConsumerState<KidsDuaMyDayPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(kidsDuaMyDayProvider.notifier).resetIfNeeded();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(kidsDuaMyDayProvider);
    final sections = ref.watch(kidsDuaMyDaySectionsProvider);
    final guidance = ref.watch(kidsDuaMyDayGuidanceProvider);
    final lessons = ref.watch(kidsDuaLessonsProvider);
    final lightSummary = ref.watch(kidsDuaLightSummaryProvider);
    final rightNowStories = guidance.rightNowLesson == null
        ? const <KidsDuaStory>[]
        : ref.watch(
            kidsDuaStoriesForLessonProvider(guidance.rightNowLesson!.id),
          );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.kidsDuaMyDayTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
        children: [
          PremiumCard(
            surfaceVariant: AppSurfaceVariant.island,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.kidsDuaMyDayTitle,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  state.isDayComplete
                      ? l10n.kidsDuaMyDayCompleteBody
                      : l10n.kidsDuaMyDaySubtitle,
                  style: TextStyle(
                    color: context.palette.onSurfaceSubtle,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 14),
                _LightProgressCard(summary: lightSummary),
                if (!state.isDayComplete &&
                    guidance.rightNowLesson != null) ...[
                  const SizedBox(height: 14),
                  _GuidanceCard(
                    icon: Icons.wb_twilight_rounded,
                    title: l10n.kidsDuaMyDayRightNowTitle,
                    subtitle: guidance.rightNowLesson!.title,
                    detail: _myDayReasonLabel(l10n, guidance.rightNowReasonKey),
                    actionLabel: switch (guidance.rightNowState) {
                      KidsDuaDailyDuaState.notLearned =>
                        l10n.kidsDuaSuggestedLearnNow,
                      KidsDuaDailyDuaState.inProgress =>
                        l10n.kidsDuaContinueAction,
                      KidsDuaDailyDuaState.learned =>
                        state.completedDuaIds.contains(
                              guidance.rightNowLesson!.id,
                            )
                            ? l10n.kidsDuaSuggestedPracticeNow
                            : l10n.kidsDuaMyDayUseNowAction,
                      null => l10n.kidsDuaSuggestedLearnNow,
                    },
                    onTap: () => context.pushNamed(
                      state.completedDuaIds.contains(
                            guidance.rightNowLesson!.id,
                          )
                          ? 'kidsDuaPractice'
                          : 'kidsDuaLesson',
                      pathParameters:
                          state.completedDuaIds.contains(
                            guidance.rightNowLesson!.id,
                          )
                          ? const <String, String>{}
                          : {'lessonId': guidance.rightNowLesson!.id},
                    ),
                  ),
                ],
                if (!state.isDayComplete && guidance.nextUpLesson != null) ...[
                  const SizedBox(height: 10),
                  _GuidanceCard(
                    icon: Icons.arrow_circle_right_rounded,
                    title: l10n.kidsDuaMyDayNextUpTitle,
                    subtitle: guidance.nextUpLesson!.title,
                    detail: _sectionLabel(l10n, guidance.nextUpSection),
                    actionLabel: l10n.kidsDuaMyDayNextUpAction,
                    onTap: () => context.pushNamed(
                      'kidsDuaLesson',
                      pathParameters: {'lessonId': guidance.nextUpLesson!.id},
                    ),
                  ),
                ],
                if (!state.isDayComplete && rightNowStories.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  _GuidanceCard(
                    icon: Icons.menu_book_rounded,
                    title: l10n.kidsDuaStoriesTitle,
                    subtitle: rightNowStories.first.title,
                    detail: l10n.kidsDuaStoriesMyDayDetail,
                    actionLabel: l10n.kidsDuaStoriesAction,
                    onTap: () => context.pushNamed(
                      'kidsDuaStoryPlayer',
                      pathParameters: {'storyId': rightNowStories.first.id},
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),
          _SectionHeader(
            title: l10n.kidsDuaMyDayJourneyTitle,
            subtitle: l10n.kidsDuaMyDayJourneySubtitle,
          ),
          const SizedBox(height: 10),
          ...sections.map((section) {
            final sectionDone = state.completedSectionIds.contains(section.id);
            final highlighted =
                guidance.activeSection.id == section.id && !state.isDayComplete;
            final upcoming =
                guidance.nextUpSection?.id == section.id && !highlighted;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _SectionCard(
                section: section,
                lessons: lessons,
                completedDuaIds: state.completedDuaIds,
                completed: sectionDone,
                highlighted: highlighted,
                upcoming: upcoming,
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _LightProgressCard extends StatelessWidget {
  const _LightProgressCard({required this.summary});

  final KidsDuaLightSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return PremiumCard(
      surfaceVariant: AppSurfaceVariant.panel,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.kidsDuaMyDayLightTitle,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.kidsDuaLightValue(
              _localizedCopy(context, summary.lightLabelKey),
            ),
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.kidsDuaStreakValue(summary.currentStreakDays),
            style: TextStyle(color: context.palette.accent),
          ),
          const SizedBox(height: 6),
          Text(
            summary.todayCompleted
                ? l10n.kidsDuaMyDayLightComplete
                : l10n.kidsDuaMyDayLightContinue,
            style: TextStyle(color: context.palette.onSurfaceSubtle),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends ConsumerWidget {
  const _SectionCard({
    required this.section,
    required this.lessons,
    required this.completedDuaIds,
    required this.completed,
    required this.highlighted,
    required this.upcoming,
  });

  final KidsDuaDaySection section;
  final List<KidsDuaLessonContent> lessons;
  final Set<String> completedDuaIds;
  final bool completed;
  final bool highlighted;
  final bool upcoming;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final service = ref.watch(kidsDuaMyDayServiceProvider);
    final state = ref.watch(kidsDuaMyDayProvider);
    final sectionLessons = section.duaIds
        .map((id) => lessons.firstWhere((lesson) => lesson.id == id))
        .toList(growable: false);
    final targetLesson = service.firstLessonForSection(
      section: section,
      lessons: lessons,
      state: state,
    );
    return InkWell(
      onTap: targetLesson == null
          ? null
          : () => context.pushNamed(
              'kidsDuaLesson',
              pathParameters: {'lessonId': targetLesson.id},
            ),
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: _kidsNoorPanelDecoration(
          context,
          borderColor: highlighted ? const Color(0xFFB58B4D) : null,
          borderWidth: highlighted ? 2 : 1,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: _kidsNoorPanelDecoration(context),
                  child: Icon(section.icon, color: context.palette.accent),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _sectionLabel(l10n, section),
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
                _TodayStatusBadge(
                  completed: completed,
                  highlighted: highlighted,
                  upcoming: upcoming,
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...sectionLessons.map(
              (lesson) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _DuaRow(
                  title: lesson.title,
                  completed: completedDuaIds.contains(lesson.id),
                  onTap: () => context.pushNamed(
                    'kidsDuaLesson',
                    pathParameters: {'lessonId': lesson.id},
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DuaRow extends StatelessWidget {
  const _DuaRow({
    required this.title,
    required this.completed,
    required this.onTap,
  });

  final String title;
  final bool completed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: _kidsNoorPanelDecoration(context),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            Text(
              completed
                  ? l10n.kidsDuaMyDayCompletedTodayLabel
                  : l10n.kidsDuaMyDayPendingTodayLabel,
              style: TextStyle(
                color: completed
                    ? const Color(0xFF4E7A39)
                    : context.palette.accent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TodayStatusBadge extends StatelessWidget {
  const _TodayStatusBadge({
    required this.completed,
    required this.highlighted,
    required this.upcoming,
  });

  final bool completed;
  final bool highlighted;
  final bool upcoming;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: _kidsNoorPillDecoration(
        context,
        tintColor: completed
            ? const Color(0xFFE5F3E0)
            : (highlighted ? const Color(0xFFFFE7C8) : const Color(0xFFFFF1DB)),
      ),
      child: Text(
        completed
            ? l10n.kidsDuaMyDaySectionDoneLabel
            : (highlighted
                  ? l10n.kidsDuaMyDaySectionNowLabel
                  : (upcoming
                        ? l10n.kidsDuaMyDaySectionNextLabel
                        : l10n.kidsDuaMyDaySectionOpenLabel)),
        style: TextStyle(
          color: completed ? const Color(0xFF4E7A39) : const Color(0xFF9B6B2E),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _GuidanceCard extends StatelessWidget {
  const _GuidanceCard({
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: PremiumCard(
        surfaceVariant: AppSurfaceVariant.panel,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: context.palette.accent),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              detail,
              style: TextStyle(color: context.palette.onSurfaceSubtle),
            ),
            const SizedBox(height: 12),
            FilledButton(onPressed: onTap, child: Text(actionLabel)),
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
        Text(
          subtitle,
          style: TextStyle(color: context.palette.onSurfaceSubtle),
        ),
      ],
    );
  }
}

BoxDecoration _kidsNoorPillDecoration(
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

BoxDecoration _kidsNoorPanelDecoration(
  BuildContext context, {
  Color? borderColor,
  double borderWidth = 1,
}) {
  final style = AppSurfaceTheme.resolve(
    context,
    variant: AppSurfaceVariant.panel,
  );
  return BoxDecoration(
    color: style.backgroundColor,
    gradient: style.gradient,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: borderColor ?? style.borderColor,
      width: borderWidth,
    ),
    boxShadow: style.boxShadows,
  );
}

String _myDayReasonLabel(AppLocalizations l10n, String key) {
  switch (key) {
    case 'kidsDuaMyDayRightNowMorningReason':
      return l10n.kidsDuaMyDayRightNowMorningReason;
    case 'kidsDuaMyDayRightNowMealsReason':
      return l10n.kidsDuaMyDayRightNowMealsReason;
    case 'kidsDuaMyDayRightNowGoingOutReason':
      return l10n.kidsDuaMyDayRightNowGoingOutReason;
    default:
      return l10n.kidsDuaMyDayRightNowNightReason;
  }
}

String _sectionLabel(AppLocalizations l10n, KidsDuaDaySection? section) {
  switch (section?.id) {
    case 'morning':
      return l10n.kidsDuaMyDayMorningTitle;
    case 'meals':
      return l10n.kidsDuaMyDayMealsTitle;
    case 'going-out':
      return l10n.kidsDuaMyDayGoingOutTitle;
    case 'night':
      return l10n.kidsDuaMyDayNightTitle;
    default:
      return l10n.kidsDuaMyDayTitle;
  }
}

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
    default:
      return key;
  }
}
