import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../application/companion_surfaces_ui_state.dart';
import '../../journey/application/learning_journey_progress_provider.dart';
import '../../journey/data/learning_journey_localized_metadata.dart';
import '../../journey/data/learning_journey_registry.dart';
import '../../journey/domain/learning_journey_models.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../data/learn_companion_content.dart';
import '../domain/learn_companion_models.dart';
import '../../../../core/theme/app_icons.dart';

class SeerahCompanionPage extends ConsumerStatefulWidget {
  const SeerahCompanionPage({super.key, this.initialFocus});

  final String? initialFocus;

  @override
  ConsumerState<SeerahCompanionPage> createState() =>
      _SeerahCompanionPageState();
}

class _SeerahCompanionPageState extends ConsumerState<SeerahCompanionPage> {
  static const Set<String> _focusIds = <String>{
    'makkah',
    'hijrah',
    'madinah-society',
    'turning-points',
    'final-sermon',
  };

  String? _selectedFocus;

  @override
  void initState() {
    super.initState();
    final savedFocus = ref
        .read(companionSurfacesUiControllerProvider)
        .lastSeerahFocus;
    _selectedFocus =
        _normalizeFocus(widget.initialFocus) ?? _normalizeFocus(savedFocus);
  }

  @override
  void didUpdateWidget(covariant SeerahCompanionPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    final updatedFocus = _normalizeFocus(widget.initialFocus);
    if (updatedFocus != null && updatedFocus != _selectedFocus) {
      _setSelectedFocus(updatedFocus);
    }
  }

  String? _normalizeFocus(String? focus) {
    final normalized = focus?.trim();
    if (normalized == null || normalized.isEmpty) {
      return null;
    }
    if (!_focusIds.contains(normalized)) {
      return null;
    }
    return normalized;
  }

  void _setSelectedFocus(String? focus) {
    final normalized = _normalizeFocus(focus);
    if (_selectedFocus == normalized) {
      return;
    }
    setState(() {
      _selectedFocus = normalized;
    });
    ref
        .read(companionSurfacesUiControllerProvider.notifier)
        .setSeerahFocus(normalized);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final bodyStyle = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
      height: 1.5,
    );
    final subtleLabelStyle = theme.textTheme.labelLarge?.copyWith(
      fontWeight: FontWeight.w700,
    );
    final journey = LearningJourneyRegistry.journeyById('seerah-journey');
    if (journey == null) {
      return const SizedBox.shrink();
    }
    final focus = _selectedFocus;
    final periodLinks = _orderedPeriodLinks(
      buildSeerahPeriodLinks(l10n),
      focus,
    );
    final focusChips = buildSeerahPeriodLinks(l10n);
    final momentLinks = _orderedMomentLinks(
      buildSeerahMomentLinks(l10n),
      focus,
    );
    final sourceLinks = _orderedLinksForFocus(
      buildSeerahCompanionSources(l10n),
      focus,
    );
    final exploreLinks = _orderedLinksForFocus(
      buildSeerahExploreLinks(l10n),
      focus,
    );
    final progress = ref.watch(learningJourneyProgressProvider);
    final continueStageId = _continueStageId(
      journey,
      progress.completedStageIds,
    );
    final continueStage = continueStageId == null
        ? null
        : LearningJourneyRegistry.stageById(continueStageId);
    final focusedPeriod = focus == null || focus.isEmpty
        ? null
        : periodLinks.cast<LearnCompanionLinkItem?>().firstWhere(
            (item) => item?.id == focus,
            orElse: () => null,
          );

    return LearnHubPageScaffold(
      headerIcon: AppIcons.seerah,
      title: l10n.learningJourneySeerahJourneyTitle,
      subtitle: l10n.learningJourneySeerahJourneySubtitle,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.learningJourneySeerahJourneyDescription,
                style: bodyStyle,
              ),
              if (focus != null && focus.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _focusedLabel(l10n, focus),
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
                if (focusedPeriod != null) ...[
                  const SizedBox(height: 10),
                  Text(focusedPeriod.subtitle, style: bodyStyle),
                  if (focusedPeriod.description != null) ...[
                    const SizedBox(height: 8),
                    Text(focusedPeriod.description!, style: bodyStyle),
                  ],
                  if (focusedPeriod.whyItMatters != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      l10n.learnSeerahCompanionWhyItMattersTitle,
                      style: subtleLabelStyle,
                    ),
                    const SizedBox(height: 6),
                    Text(focusedPeriod.whyItMatters!, style: bodyStyle),
                  ],
                  if (focusedPeriod.nextExploration != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      l10n.learnSeerahCompanionNextExploreTitle,
                      style: subtleLabelStyle,
                    ),
                    const SizedBox(height: 6),
                    Text(focusedPeriod.nextExploration!, style: bodyStyle),
                  ],
                ],
              ],
            ],
          ),
        ),
        const SizedBox(height: 20),
        _SectionHeader(
          title: l10n.learnSeerahCompanionFocusTitle,
          subtitle: l10n.learnSeerahCompanionFocusSubtitle,
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Semantics(
                button: true,
                selected: focus == null,
                label: l10n.learnSeerahCompanionAllPeriodsChip,
                child: ChoiceChip(
                  label: Text(l10n.learnSeerahCompanionAllPeriodsChip),
                  selected: focus == null,
                  onSelected: (_) => _setSelectedFocus(null),
                ),
              ),
              for (final item in focusChips)
                Semantics(
                  button: true,
                  selected: focus == item.id,
                  label: item.title,
                  hint: item.subtitle,
                  child: ChoiceChip(
                    label: Text(item.title),
                    selected: focus == item.id,
                    onSelected: (_) => _setSelectedFocus(item.id),
                  ),
                ),
            ],
          ),
        ),
        if (focusedPeriod != null) ...[
          const SizedBox(height: 12),
          _ContinueCard(
            title: l10n.learnSeerahCompanionContinueExploringTitle,
            subtitle: l10n.learnSeerahCompanionContinueExploringSubtitle,
            actionLabel: l10n.learnSeerahCompanionContinueExploringAction,
            onTap: () => context.pushNamed(
              focusedPeriod.routeTarget.routeName,
              pathParameters: focusedPeriod.routeTarget.pathParameters,
              queryParameters: focusedPeriod.routeTarget.queryParameters,
            ),
          ),
        ],
        const SizedBox(height: 16),
        _SectionHeader(
          title: l10n.learnContentContinueTitle,
          subtitle: l10n.learnCompanionContinueSubtitle,
        ),
        const SizedBox(height: 10),
        _ContinueCard(
          title: continueStage == null
              ? l10n.learningJourneySeerahJourneyTitle
              : localizedStageTitle(context, continueStage),
          subtitle: continueStage == null
              ? l10n.learningJourneySeerahJourneySubtitle
              : localizedStageSummary(context, continueStage),
          actionLabel: continueStage == null
              ? l10n.learningJourneyDetailActionReviewJourney
              : l10n.learningJourneyDetailActionContinue,
          onTap: () => context.pushNamed(
            continueStage == null ? 'learnJourneyDetail' : 'learnJourneyStage',
            pathParameters: continueStage == null
                ? {'journeyId': journey.id}
                : {'journeyId': journey.id, 'stageId': continueStage.id},
          ),
        ),
        const SizedBox(height: 20),
        _SectionHeader(
          title: l10n.learnSeerahCompanionPeriodsTitle,
          subtitle: l10n.learnSeerahCompanionPeriodsSubtitle,
        ),
        const SizedBox(height: 10),
        ...periodLinks.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _LinkCard(item: item, highlighted: focus == item.id),
          ),
        ),
        const SizedBox(height: 16),
        _SectionHeader(
          title: l10n.learnSeerahCompanionMomentsTitle,
          subtitle: l10n.learnSeerahCompanionMomentsSubtitle,
        ),
        const SizedBox(height: 10),
        ...momentLinks.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _LinkCard(item: item),
          ),
        ),
        const SizedBox(height: 16),
        _SectionHeader(
          title: l10n.learnCompanionSourcesTitle,
          subtitle: l10n.learnCompanionSourcesSubtitle,
        ),
        const SizedBox(height: 10),
        ...sourceLinks.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _LinkCard(item: item),
          ),
        ),
        const SizedBox(height: 16),
        _SectionHeader(
          title: l10n.learnSeerahCompanionExploreTitle,
          subtitle: l10n.learnSeerahCompanionExploreSubtitle,
        ),
        const SizedBox(height: 10),
        ...exploreLinks.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _LinkCard(item: item),
          ),
        ),
      ],
    );
  }

  String? _continueStageId(
    LearningJourney journey,
    Set<String> completedStageIds,
  ) {
    final stages = LearningJourneyRegistry.stagesForJourney(journey.id);
    for (final stage in stages) {
      if (!completedStageIds.contains(stage.id)) {
        return stage.id;
      }
    }
    return null;
  }

  String _focusedLabel(AppLocalizations l10n, String focus) {
    switch (focus) {
      case 'hijrah':
        return l10n.learningJourneySeerahHijrahTitle;
      case 'madinah-society':
        return l10n.learningJourneySeerahMadinahTitle;
      case 'turning-points':
        return l10n.learnSeerahCompanionTurningPointsTitle;
      default:
        return l10n.learningJourneySeerahJourneyTitle;
    }
  }

  List<LearnCompanionLinkItem> _orderedPeriodLinks(
    List<LearnCompanionLinkItem> items,
    String? focus,
  ) {
    if (focus == null || focus.isEmpty) return items;
    final focused = items.where((item) => item.id == focus);
    final rest = items.where((item) => item.id != focus);
    return [...focused, ...rest];
  }

  List<LearnCompanionLinkItem> _orderedLinksForFocus(
    List<LearnCompanionLinkItem> items,
    String? focus,
  ) {
    if (focus == null || focus.isEmpty) {
      return items;
    }

    final preferredIds = switch (focus) {
      'hijrah' => <String>['history', 'timeline', 'hadith', 'hadith-guidance'],
      'madinah-society' => <String>[
        'hadith',
        'hadith-guidance',
        'quran-learning',
        'quran-study',
      ],
      _ => const <String>[],
    };

    if (preferredIds.isEmpty) {
      return items;
    }

    final ranked = <LearnCompanionLinkItem>[];
    for (final preferredId in preferredIds) {
      for (final item in items) {
        if (item.id == preferredId && !ranked.contains(item)) {
          ranked.add(item);
        }
      }
    }
    for (final item in items) {
      if (!ranked.contains(item)) {
        ranked.add(item);
      }
    }
    return ranked;
  }

  List<LearnCompanionLinkItem> _orderedMomentLinks(
    List<LearnCompanionLinkItem> items,
    String? focus,
  ) {
    if (focus == null || focus.isEmpty) {
      return items;
    }

    final preferredIds = switch (focus) {
      'madinah-society' => <String>[
        'hudaybiyyah',
        'conquest-of-makkah',
        'farewell-hajj',
      ],
      'turning-points' => <String>[
        'hudaybiyyah',
        'conquest-of-makkah',
        'farewell-hajj',
      ],
      'final-sermon' => <String>['farewell-hajj'],
      _ => const <String>[],
    };

    if (preferredIds.isEmpty) {
      return items;
    }

    final ranked = <LearnCompanionLinkItem>[];
    for (final preferredId in preferredIds) {
      for (final item in items) {
        if (item.id == preferredId && !ranked.contains(item)) {
          ranked.add(item);
        }
      }
    }
    for (final item in items) {
      if (!ranked.contains(item)) {
        ranked.add(item);
      }
    }
    return ranked;
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            height: 1.45,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _ContinueCard extends StatelessWidget {
  const _ContinueCard({
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      button: true,
      label: title,
      hint: subtitle,
      child: PremiumCard(
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          minVerticalPadding: 8,
          title: Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              height: 1.25,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.45,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          trailing: Tooltip(
            message: actionLabel,
            child: FilledButton.tonal(
              onPressed: onTap,
              child: Text(actionLabel),
            ),
          ),
        ),
      ),
    );
  }
}

class _LinkCard extends StatelessWidget {
  const _LinkCard({required this.item, this.highlighted = false});

  final LearnCompanionLinkItem item;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      button: true,
      selected: highlighted,
      label: item.title,
      hint: item.subtitle,
      child: PremiumCard(
        surfaceTintColor: highlighted ? const Color(0xFF9A6A15) : null,
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          minVerticalPadding: 8,
          title: Text(
            item.title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              height: 1.25,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item.sourceLabel != null) ...[
                const SizedBox(height: 4),
                _SourceLabelChip(label: item.sourceLabel!),
                const SizedBox(height: 10),
              ] else
                const SizedBox(height: 4),
              Text(
                item.subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.45,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              if (item.description != null) ...[
                const SizedBox(height: 8),
                Text(
                  item.description!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.45,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              if (item.whyItMatters != null) ...[
                const SizedBox(height: 12),
                Text(
                  AppLocalizations.of(
                    context,
                  ).learnSeerahCompanionWhyItMattersTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(item.whyItMatters!, style: const TextStyle(height: 1.35)),
              ],
              if (item.nextExploration != null) ...[
                const SizedBox(height: 12),
                Text(
                  AppLocalizations.of(
                    context,
                  ).learnSeerahCompanionNextExploreTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  item.nextExploration!,
                  style: const TextStyle(height: 1.35),
                ),
              ],
            ],
          ),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () => context.pushNamed(
            item.routeTarget.routeName,
            pathParameters: item.routeTarget.pathParameters,
            queryParameters: item.routeTarget.queryParameters,
          ),
        ),
      ),
    );
  }
}

class _SourceLabelChip extends StatelessWidget {
  const _SourceLabelChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(visualDensity: VisualDensity.comfortable, label: Text(label));
  }
}
