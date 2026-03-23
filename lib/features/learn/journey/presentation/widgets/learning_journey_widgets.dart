import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/theme/islamic_icons.dart';
import '../../data/learning_journey_localized_metadata.dart';
import '../../domain/learning_journey_models.dart';

class JourneyHomeSectionHeader extends StatelessWidget {
  const JourneyHomeSectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.action,
  });

  final String title;
  final String subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2E261F),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Color(0xFF675B4E), height: 1.35),
              ),
            ],
          ),
        ),
        if (action != null) ...[const SizedBox(width: 12), action!],
      ],
    );
  }
}

class JourneyProgressBar extends StatelessWidget {
  const JourneyProgressBar({super.key, required this.value, this.label});

  final double value;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: clamped,
            minHeight: 7,
            backgroundColor: const Color(0xFFE8DED1),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF8B6A44)),
          ),
        ),
        if (label != null) ...[
          const SizedBox(height: 6),
          Text(
            label!,
            style: const TextStyle(
              fontSize: 12.2,
              fontWeight: FontWeight.w600,
              color: Color(0xFF7A6650),
            ),
          ),
        ],
      ],
    );
  }
}

class LearningJourneyIslandCard extends StatelessWidget {
  const LearningJourneyIslandCard({
    super.key,
    required this.island,
    required this.onTap,
    this.title,
    this.subtitle,
  });

  final LearningJourneyIsland island;
  final VoidCallback onTap;
  final String? title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: island.color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: island.accentColor.withValues(alpha: 0.18)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: island.accentColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(island.icon, color: island.accentColor),
            ),
            const SizedBox(height: 14),
            Text(
              title ?? localizedIslandTitle(context, island),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: island.accentColor,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle ?? localizedIslandSubtitle(context, island),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Color(0xFF675B4E), height: 1.35),
            ),
          ],
        ),
      ),
    );
  }
}

class LearningJourneyCard extends StatelessWidget {
  const LearningJourneyCard({
    super.key,
    required this.journey,
    required this.stageCount,
    required this.onTap,
    this.progress,
    this.showFeaturedBadge = false,
  });

  final LearningJourney journey;
  final int stageCount;
  final VoidCallback onTap;
  final double? progress;
  final bool showFeaturedBadge;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final effectiveProgress = progress?.clamp(0.0, 1.0);
    final leadingIcon = _journeyIcon(journey);
    final leadingColor = _journeyIconColor(journey);
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F1E8),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE0CEB4)),
          ),
          child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFEADCC7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(leadingIcon, color: leadingColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizedJourneyTitle(context, journey),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF30281F),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    localizedJourneySubtitle(context, journey),
                    style: const TextStyle(
                      fontSize: 12.8,
                      color: Color(0xFF675B4E),
                      height: 1.35,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _MetaPill(
                        label: _difficultyLabel(journey.difficulty, l10n),
                        color: const Color(0xFFEADCC7),
                        textColor: const Color(0xFF755937),
                      ),
                      _MetaPill(
                        label: l10n.learningJourneyDurationMinutes(
                          journey.estimatedDurationMinutes,
                        ),
                        color: const Color(0xFFF1E7D9),
                        textColor: const Color(0xFF7A6243),
                      ),
                      _MetaPill(
                        label: l10n.learningJourneyCardStageCount(stageCount),
                        color: const Color(0xFFF4EBDE),
                        textColor: const Color(0xFF866A49),
                      ),
                      if (showFeaturedBadge && journey.isFeatured)
                        _MetaPill(
                          label: l10n.learningJourneyFeaturedBadge,
                          color: const Color(0xFFE5EADF),
                          textColor: const Color(0xFF587047),
                        ),
                    ],
                  ),
                  if (effectiveProgress != null) ...[
                    const SizedBox(height: 10),
                    JourneyProgressBar(
                      value: effectiveProgress,
                      label: l10n.learningJourneyCardProgressLabel(
                        (effectiveProgress * stageCount).round(),
                        stageCount,
                      ),
                    ),
                    if (effectiveProgress > 0 && effectiveProgress < 1) ...[
                      const SizedBox(height: 6),
                      Text(
                        l10n.learningJourneyCardActionContinue,
                        style: const TextStyle(
                          fontSize: 12.2,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF7A6650),
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ],
          ),
        ),
      ),
    );
  }
}

class LearningJourneyStageCard extends StatelessWidget {
  const LearningJourneyStageCard({
    super.key,
    required this.stage,
    required this.isCurrent,
    required this.isCompleted,
    required this.isLocked,
    required this.onTap,
  });

  final LearningJourneyStage stage;
  final bool isCurrent;
  final bool isCompleted;
  final bool isLocked;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isPlaceholder =
        stage.status == LearningJourneyStageStatus.placeholder;
    final chipColor = switch (stage.status) {
      LearningJourneyStageStatus.real => const Color(0xFFE2ECDD),
      LearningJourneyStageStatus.partial => const Color(0xFFF3E8D9),
      LearningJourneyStageStatus.placeholder => const Color(0xFFEAE5E0),
    };
    final chipTextColor = switch (stage.status) {
      LearningJourneyStageStatus.real => const Color(0xFF4E7241),
      LearningJourneyStageStatus.partial => const Color(0xFF8B653A),
      LearningJourneyStageStatus.placeholder => const Color(0xFF6C6257),
    };

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isLocked
              ? const Color(0xFFF4F0EA)
              : isCurrent
              ? const Color(0xFFF4EBDD)
              : isCompleted
              ? const Color(0xFFF2F5EF)
              : const Color(0xFFF8F3EB),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isLocked
                ? const Color(0xFFE3D8CB)
                : isCurrent
                ? const Color(0xFFDDBF92)
                : isCompleted
                ? const Color(0xFFC9D7BF)
                : const Color(0xFFE5D8C7),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isLocked
                    ? const Color(0xFFE9E0D3)
                    : isCompleted
                    ? const Color(0xFFDDE9D6)
                    : isCurrent
                    ? const Color(0xFFF0DEC4)
                    : const Color(0xFFEADCC7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: isLocked
                  ? const Icon(
                      Icons.lock_outline_rounded,
                      size: 16,
                      color: Color(0xFF7A6A57),
                    )
                  : isCompleted
                  ? const Icon(
                      Icons.check_rounded,
                      size: 18,
                      color: Color(0xFF4E7241),
                    )
                  : isCurrent
                  ? const Icon(
                      Icons.play_arrow_rounded,
                      size: 18,
                      color: Color(0xFF6B4E2D),
                    )
                  : Text(
                      '${stage.order}',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: isLocked
                            ? const Color(0xFF7A6A57)
                            : isCurrent
                            ? const Color(0xFF6B4E2D)
                            : const Color(0xFF71593C),
                      ),
                    ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 3,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                color: isCompleted
                    ? const Color(0xFFAFC3A0)
                    : isLocked
                    ? const Color(0xFFE0D5C6)
                    : isCurrent
                    ? const Color(0xFFD9B888)
                    : const Color(0xFFE6DDD1),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        localizedStageTitle(context, stage),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF30281F),
                        ),
                      ),
                      if (isCurrent)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0DEC4),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            l10n.learningJourneyStageCurrentBadge,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF7D5B31),
                            ),
                          ),
                        ),
                      if (!isCurrent && !isCompleted && isPlaceholder)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0EBE3),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            l10n.learningJourneyStagePreviewBadge,
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF756857),
                            ),
                          ),
                        ),
                      if (isLocked)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0EBE3),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            l10n.learningJourneyStageLockedBadge,
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF756857),
                            ),
                          ),
                        ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: chipColor,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          _statusLabel(stage.status, l10n),
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: chipTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    localizedStageSummary(context, stage),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF675B4E),
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _MetaPill(
                        label: l10n.learningJourneyDurationMinutes(
                          stage.durationEstimateMinutes,
                        ),
                        color: const Color(0xFFF2E8D9),
                        textColor: const Color(0xFF725C42),
                      ),
                      _MetaPill(
                        label: l10n.learningJourneyStageReward(
                          stage.xpReward,
                          stage.dropReward,
                        ),
                        color: const Color(0xFFE7EEE1),
                        textColor: const Color(0xFF4C6540),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({
    required this.label,
    required this.color,
    required this.textColor,
  });

  final String label;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.8,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}

class LearningJourneyToolCard extends StatelessWidget {
  const LearningJourneyToolCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F1E8),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE3D6C4)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFE8DCC8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF71593C)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF30281F),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF675B4E),
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

IconData _journeyIcon(LearningJourney journey) {
  switch (journey.islandId) {
    case 'core-knowledge':
      return IslamicIcons.quran;
    case 'practice-worship':
      return IslamicIcons.prayer;
    case 'understanding-islam':
      return IslamicIcons.allahText;
    case 'arabic-learning':
      return IslamicIcons.lantern;
    case 'discovery':
      return IslamicIcons.ninetyNine;
    case 'kids-learning':
      return IslamicIcons.family;
    case 'browse-all':
      return IslamicIcons.community;
    case 'tools-other':
      return IslamicIcons.locationMosque;
    case 'legacy-learning':
      return IslamicIcons.kaaba;
    default:
      return IslamicIcons.lantern;
  }
}

Color _journeyIconColor(LearningJourney journey) {
  switch (journey.islandId) {
    case 'practice-worship':
      return const Color(0xFF5A6C49);
    case 'understanding-islam':
      return const Color(0xFF815A3D);
    case 'arabic-learning':
      return const Color(0xFF53608D);
    case 'discovery':
      return const Color(0xFF755C7C);
    case 'kids-learning':
      return const Color(0xFF9A6233);
    case 'browse-all':
      return const Color(0xFF4E5B8C);
    case 'tools-other':
      return const Color(0xFF45636D);
    case 'legacy-learning':
      return const Color(0xFF7D5E43);
    case 'core-knowledge':
    default:
      return const Color(0xFF7A6241);
  }
}

class RelatedToolsSection extends StatelessWidget {
  const RelatedToolsSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.tools,
  });

  final String title;
  final String subtitle;
  final List<LearningJourneyToolLink> tools;

  @override
  Widget build(BuildContext context) {
    if (tools.isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F1E8),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE3D6C4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2E261F),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Color(0xFF675B4E), height: 1.35),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: tools
                .map((tool) => LearningJourneyToolLinkButton(tool: tool))
                .toList(growable: false),
          ),
        ],
      ),
    );
  }
}

class PlaceholderLessonPageScaffold extends StatelessWidget {
  const PlaceholderLessonPageScaffold({
    super.key,
    required this.stageTitle,
    required this.summary,
    required this.learnLabel,
    required this.learnBody,
    required this.message,
    required this.onBackToJourney,
    this.note,
    this.relatedTools = const <LearningJourneyToolLink>[],
  });

  final String stageTitle;
  final String summary;
  final String learnLabel;
  final String learnBody;
  final String message;
  final String? note;
  final List<LearningJourneyToolLink> relatedTools;
  final VoidCallback onBackToJourney;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F1E8),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE3D6C4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                stageTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Color(0xFF2E261F),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                summary,
                style: const TextStyle(color: Color(0xFF675B4E), height: 1.35),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.learningJourneyPlaceholderBuiltTitle,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF312920),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: const TextStyle(color: Color(0xFF675B4E), height: 1.35),
              ),
              if (note != null && note!.trim().isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  note!,
                  style: const TextStyle(
                    color: Color(0xFF675B4E),
                    height: 1.35,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F1E8),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE3D6C4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                learnLabel,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Color(0xFF2E261F),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                learnBody,
                style: const TextStyle(color: Color(0xFF675B4E), height: 1.35),
              ),
            ],
          ),
        ),
        if (relatedTools.isNotEmpty) ...[
          const SizedBox(height: 14),
          RelatedToolsSection(
            title: l10n.learningJourneyPlaceholderExploreTitle,
            subtitle: l10n.learningJourneyPlaceholderExploreSubtitle,
            tools: relatedTools,
          ),
        ],
        const SizedBox(height: 14),
        FilledButton.tonalIcon(
          onPressed: onBackToJourney,
          icon: const Icon(Icons.arrow_back_rounded),
          label: Text(l10n.learningJourneyPlaceholderBackAction),
        ),
      ],
    );
  }
}

class LearningJourneyToolLinkButton extends StatelessWidget {
  const LearningJourneyToolLinkButton({super.key, required this.tool});

  final LearningJourneyToolLink tool;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FilledButton.tonalIcon(
      onPressed: () => context.pushNamed(
        tool.routeName,
        pathParameters: tool.pathParameters,
        queryParameters: tool.queryParameters,
      ),
      icon: const Icon(Icons.open_in_new_rounded),
      label: Text(_localizedToolTitle(tool, l10n)),
    );
  }
}

String _statusLabel(LearningJourneyStageStatus status, AppLocalizations l10n) {
  switch (status) {
    case LearningJourneyStageStatus.real:
      return l10n.learningJourneyStageStatusReady;
    case LearningJourneyStageStatus.partial:
      return l10n.learningJourneyStageStatusPartial;
    case LearningJourneyStageStatus.placeholder:
      return l10n.learningJourneyStageStatusPlanned;
  }
}

String _difficultyLabel(
  LearningJourneyDifficulty difficulty,
  AppLocalizations l10n,
) {
  return switch (difficulty) {
    LearningJourneyDifficulty.beginner => l10n.learningJourneyDifficultyBeginner,
    LearningJourneyDifficulty.intermediate =>
      l10n.learningJourneyDifficultyIntermediate,
    LearningJourneyDifficulty.advanced => l10n.learningJourneyDifficultyAdvanced,
  };
}

String _localizedToolTitle(
  LearningJourneyToolLink tool,
  AppLocalizations l10n,
) {
  switch (tool.routeName) {
    case 'quranSearch':
      return l10n.learningJourneyToolSearchTitle;
    case 'quranBookmarks':
      return l10n.learningJourneyToolBookmarksTitle;
    case 'quranNotes':
      return l10n.learningJourneyToolNotesTitle;
    case 'quranReader':
      return l10n.learningJourneyToolQuranReaderTitle;
    case 'quranExplorer':
      return l10n.learningJourneyToolExplorerTitle;
    case 'learnWuduGuide':
      return l10n.learningJourneyToolWuduGuideTitle;
    case 'learnWuduTrainer':
      return l10n.learningJourneyToolWuduTrainerTitle;
    case 'quranNamesOfAllah':
      return l10n.learningJourneyToolNamesOfAllahTitle;
    case 'quranArabic':
      return l10n.learningJourneyToolQuranArabicTitle;
    case 'quranTopWords':
      return l10n.learningJourneyToolWordsTitle;
    case 'quranWordReview':
      return l10n.learningJourneyToolWordReviewTitle;
    case 'quranLearningHub':
      return l10n.learningJourneyToolQuranStudyTitle;
    case 'learnSalahHub':
      return l10n.learningJourneyToolSalahHubTitle;
    case 'learnSalahGuidedPrayer':
      return l10n.learningJourneyToolGuidedPrayerTitle;
    case 'learnHadithLanding':
      return l10n.learningJourneyToolHadithHubTitle;
    case 'learnHadithImportant':
      return l10n.learningJourneyToolEssentialHadithTitle;
    case 'hadithReviewQuiz':
      return l10n.learningJourneyToolHadithReviewTitle;
    case 'learnTriviaKnowledgePaths':
      return l10n.learningJourneyToolTriviaPathsTitle;
    case 'learnTriviaReview':
      return l10n.learningJourneyToolTriviaReviewTitle;
    case 'learnWorldLanding':
      return l10n.learningJourneyToolWorldCreationTitle;
    case 'worldExploreCreation':
      return l10n.learningJourneyToolExploreCreationTitle;
    case 'worldSignsExplorer':
      return l10n.learningJourneyToolSignsExplorerTitle;
    case 'worldCreationReflectionMode':
      return l10n.learningJourneyToolReflectionModeTitle;
    case 'learnNotesLanding':
      return l10n.learningJourneyToolLearnNotesTitle;
    case 'knowledgeConstellation':
      return l10n.learningJourneyToolKnowledgeConstellationTitle;
    case 'learnLegacy':
      return l10n.learningJourneyHomeLegacyTitle;
    case 'learnDuaHub':
      return l10n.learningJourneyToolDuaHubTitle;
    case 'learnProphetsHub':
      final tab = tool.queryParameters['tab'];
      switch (tab) {
        case 'timeline':
          return l10n.learningJourneyToolProphetsTimelineTitle;
        case 'map':
          return l10n.learningJourneyToolProphetsMapTitle;
        case 'family-tree':
          return l10n.learningJourneyToolFamilyTreeTitle;
        default:
          return l10n.learningJourneyToolProphetsTitle;
      }
    default:
      return tool.title;
  }
}
