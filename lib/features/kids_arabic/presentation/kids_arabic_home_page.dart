import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_fonts.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_palette.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/display/compact_list_tile.dart';
import '../../../shared/widgets/display/hub_list_group.dart';
import '../../../shared/widgets/section_title.dart';
import '../../arabic/application/arabic_learning_asset_bundle.dart';
import '../../arabic/application/arabic_learning_progress_provider.dart';
import '../../arabic/domain/arabic_learning_continuity_models.dart';
import '../../kids/rewards/presentation/kids_invitation_card.dart';
import '../../kids/rewards/presentation/kids_reward_strip.dart';
import '../../kids/shared/presentation/kids_page_scaffold.dart';
import '../application/kids_arabic_audio_service.dart';
import '../application/kids_arabic_coloring_provider.dart';
import '../application/kids_arabic_parent_provider.dart';
import '../application/kids_arabic_progress_provider.dart';
import '../domain/kids_arabic_models.dart';
import 'kids_arabic_localized_content.dart';

/// The Letters door: one next thing, the alphabet, and three doors after it.
///
/// The adult Arabic track (search, lesson packs, the Qur'an bridge) used to
/// sit here dressed as `variant: kids`; a grown-up still reaches those from
/// the parents page.
class KidsArabicHomePage extends ConsumerStatefulWidget {
  const KidsArabicHomePage({super.key});

  @override
  ConsumerState<KidsArabicHomePage> createState() => _KidsArabicHomePageState();
}

class _KidsArabicHomePageState extends ConsumerState<KidsArabicHomePage> {
  bool _offlineWarmupQueued = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final progress = ref.watch(kidsArabicProgressProvider);
    final dailyMission = ref.watch(kidsArabicDailyMissionProvider);
    final dailyProgress = ref.watch(kidsArabicDailyProgressProvider);
    final parentActivity = ref.watch(
      kidsArabicParentRecommendedActivityProvider,
    );
    final parentReviewLetter = ref.watch(kidsArabicParentReviewLetterProvider);
    final orderedLetters = ref.watch(kidsArabicProgressionLettersProvider);
    final unlockedLetterIds = ref.watch(kidsArabicUnlockedLetterIdsProvider);
    final unlockedColoringPages = ref.watch(
      kidsArabicUnlockedColoringPagesCountProvider,
    );
    final progressSummary = ref.watch(
      arabicLearningProgressSummaryProvider(ArabicLearningAudience.kids),
    );
    final notifier = ref.read(kidsArabicProgressProvider.notifier);

    if (!_offlineWarmupQueued) {
      _offlineWarmupQueued = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        final warmer = ref.read(arabicLearningOfflineWarmupProvider);
        warmer.prewarmContinuationTarget(
          audience: ArabicLearningAudience.kids,
          continuation: progressSummary.continuation,
        );
        warmer.prewarmAudienceStartBundle(ArabicLearningAudience.kids);
      });
    }

    final nextStep = _nextStep(
      l10n: l10n,
      letterById: notifier.letterById,
      progress: progress,
      orderedLetters: orderedLetters,
      unlockedLetterIds: unlockedLetterIds,
      dailyMission: dailyMission,
      dailyProgress: dailyProgress,
      parentActivity: parentActivity,
      parentReviewLetter: parentReviewLetter,
    );
    final currentLetterId = _firstUnfinished(
      orderedLetters,
      unlockedLetterIds,
      progress,
    )?.id;

    return KidsPageScaffold(
      headerIcon: AppIcons.letters,
      title: l10n.kidsArabicHomeTitle,
      subtitle: l10n.kidsArabicHomeSubtitle,
      heroAsset: 'assets/images/learn_art/kids_arabic.webp',
      heroTitle: l10n.kidsDoorLettersTitle,
      heroSubtitle: l10n.kidsDoorLettersSubtitle,
      children: [
        // One next thing: a parent's pick, the first letter, or today's step.
        if (nextStep != null) ...[
          KidsInvitationCard(
            title: nextStep.title,
            subtitle: nextStep.subtitle,
            onTap: () => nextStep.open(context),
          ),
          const SizedBox(height: 18),
        ],
        // The alphabet. Every tile speaks; a locked one says its name and
        // waits, an open one opens its lesson.
        SectionTitle(
          title: l10n.kidsArabicAlphabetTitle,
          subtitle: l10n.kidsArabicAlphabetSubtitle,
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: orderedLetters
              .map((letter) {
                final locked = !unlockedLetterIds.contains(letter.id);
                final completed = progress.completedLetterIds.contains(
                  letter.id,
                );
                final state = locked
                    ? _LetterTileState.locked
                    : progress.reviewNeededLetterIds.contains(letter.id)
                    ? _LetterTileState.needsReview
                    : completed
                    ? _LetterTileState.completed
                    : letter.id == currentLetterId
                    ? _LetterTileState.current
                    : _LetterTileState.ready;
                return _LetterTile(
                  letter: letter,
                  state: state,
                  onTap: locked
                      ? () => ref
                            .read(kidsArabicAudioServiceProvider)
                            .speakLetter(letter)
                      : () => context.pushNamed(
                          'kidsArabicLesson',
                          pathParameters: {'letterId': letter.id},
                        ),
                );
              })
              .toList(growable: false),
        ),
        const SizedBox(height: 18),
        // After the letters.
        HubListGroup(
          title: l10n.kidsArabicHomeDoorsTitle,
          children: [
            CompactListTile(
              leading: const HubLeadingIcon(AppIcons.wordDeck),
              title: l10n.kidsArabicWordsTitle,
              subtitle: l10n.kidsArabicWordsSubtitle,
              onTap: () => context.pushNamed('kidsArabicWordsHome'),
            ),
            CompactListTile(
              leading: const HubLeadingIcon(AppIcons.practice),
              title: l10n.kidsArabicReviewTitle,
              subtitle: l10n.kidsArabicReviewSubtitle,
              onTap: () => context.pushNamed('kidsArabicReview'),
            ),
            CompactListTile(
              leading: const HubLeadingIcon(AppIcons.appearance),
              title: l10n.kidsArabicColoringPagesTitle,
              subtitle: l10n.kidsArabicColoringPagesProgressValue(
                unlockedColoringPages,
                5,
              ),
              onTap: () => context.pushNamed('kidsArabicColoringPages'),
            ),
            const KidsRewardStrip(),
          ],
        ),
      ],
    );
  }

  /// The first unlocked letter the child has not finished: the frontier.
  static KidsArabicLetter? _firstUnfinished(
    List<KidsArabicLetter> orderedLetters,
    Set<String> unlockedLetterIds,
    KidsArabicProgressState progress,
  ) {
    for (final letter in orderedLetters) {
      if (unlockedLetterIds.contains(letter.id) &&
          !progress.completedLetterIds.contains(letter.id)) {
        return letter;
      }
    }
    return null;
  }

  static _NextStep? _nextStep({
    required AppLocalizations l10n,
    required KidsArabicLetter? Function(String id) letterById,
    required KidsArabicProgressState progress,
    required List<KidsArabicLetter> orderedLetters,
    required Set<String> unlockedLetterIds,
    required KidsArabicDailyMission? dailyMission,
    required KidsArabicDailyProgress dailyProgress,
    required KidsArabicRecommendedActivity? parentActivity,
    required KidsArabicLetter? parentReviewLetter,
  }) {
    // A parent's pick comes first, even on a first open.
    if (parentActivity != null) {
      switch (parentActivity.source) {
        case KidsArabicRecommendedActivitySource.parentAssignedFocus:
          final letter = letterById(parentActivity.letterId);
          if (letter != null) {
            return _NextStep(
              title: l10n.kidsArabicParentTodayFocusTitle,
              subtitle: l10n.kidsArabicParentTodayFocusSubtitle(letter.nameAr),
              letterId: letter.id,
              opensReview: false,
            );
          }
        case KidsArabicRecommendedActivitySource.parentAssignedReview:
          final letter =
              parentReviewLetter ?? letterById(parentActivity.letterId);
          if (letter != null) {
            return _NextStep(
              title: l10n.kidsArabicParentReviewNextTitle,
              subtitle: l10n.kidsArabicParentReviewNextSubtitle(letter.nameAr),
              letterId: letter.id,
              opensReview: true,
            );
          }
        case KidsArabicRecommendedActivitySource.dailyMission:
        case KidsArabicRecommendedActivitySource.nextUnlockedLesson:
          break;
      }
    }
    // A first-time child gets one thing to do, not a row of zeros (K4).
    if (progress.completedLetterIds.isEmpty) {
      return _NextStep(
        title: l10n.kidsInvitationFirstLetterTitle,
        subtitle: l10n.kidsInvitationFirstLetterSubtitle,
        letterId: orderedLetters.first.id,
        opensReview: false,
      );
    }
    final frontier = _firstUnfinished(
      orderedLetters,
      unlockedLetterIds,
      progress,
    );
    final missionLetter = dailyMission == null
        ? null
        : letterById(dailyMission.targetLetterId);
    final completedToday =
        dailyMission != null &&
        (dailyMission.isCompleted || dailyProgress.todayMissionCompleted);
    if (completedToday || dailyMission == null) {
      // Today's step is done (or there is none): the next letter is open.
      final target = frontier ?? missionLetter;
      if (target == null) return null;
      return _NextStep(
        title: l10n.kidsArabicNextLetterTitle(target.nameEn),
        subtitle: completedToday
            ? l10n.kidsArabicNextLetterDoneSubtitle(target.nameEn)
            : l10n.kidsArabicDailyMissionNewLetterDescription(target.nameAr),
        letterId: target.id,
        opensReview: false,
      );
    }
    final letter = missionLetter ?? frontier;
    if (letter == null) return null;
    final opensReview = dailyMission.type == KidsArabicDailyMissionType.review;
    return _NextStep(
      title: opensReview
          ? l10n.kidsArabicDailyMissionReviewTitle(letter.nameEn)
          : l10n.kidsArabicNextLetterTitle(letter.nameEn),
      subtitle: localizedKidsArabicDailyMissionDescription(
        l10n,
        dailyMission,
        letter,
      ),
      letterId: letter.id,
      opensReview: opensReview,
    );
  }
}

class _NextStep {
  const _NextStep({
    required this.title,
    required this.subtitle,
    required this.letterId,
    required this.opensReview,
  });

  final String title;
  final String subtitle;
  final String letterId;
  final bool opensReview;

  void open(BuildContext context) {
    if (opensReview) {
      context.pushNamed('kidsArabicReview');
      return;
    }
    context.pushNamed(
      'kidsArabicLesson',
      pathParameters: {'letterId': letterId},
    );
  }
}

enum _LetterTileState { locked, ready, current, needsReview, completed }

class _LetterTile extends StatelessWidget {
  const _LetterTile({
    required this.letter,
    required this.state,
    required this.onTap,
  });

  final KidsArabicLetter letter;
  final _LetterTileState state;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.palette;
    final locked = state == _LetterTileState.locked;
    final (Color background, Color border) = switch (state) {
      _LetterTileState.locked => (palette.surface, palette.surfaceSoft),
      _LetterTileState.ready => (palette.surface, palette.border),
      _LetterTileState.current => (palette.accentSoft, palette.accent),
      _LetterTileState.needsReview => (
        palette.caution.withValues(alpha: 0.18),
        palette.caution,
      ),
      _LetterTileState.completed => (
        palette.success.withValues(alpha: 0.22),
        palette.success.withValues(alpha: 0.5),
      ),
    };
    return Semantics(
      button: true,
      label: locked
          ? '${letter.nameEn}. ${l10n.kidsArabicLockedStatus}'
          : letter.nameEn,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: 78,
          height: 86,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: border),
          ),
          child: Stack(
            children: [
              Center(
                child: Text(
                  letter.glyph,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: 34,
                    fontFamily: AppFonts.arabicLearning,
                    fontWeight: FontWeight.w700,
                    color: locked ? palette.onSurfaceSubtle : palette.onSurface,
                  ),
                ),
              ),
              if (locked)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Icon(
                    AppIcons.locked,
                    size: 14,
                    color: palette.onSurfaceSubtle,
                  ),
                ),
              if (state == _LetterTileState.completed)
                Positioned(
                  bottom: 7,
                  right: 8,
                  child: Icon(AppIcons.dot, size: 8, color: palette.successInk),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
