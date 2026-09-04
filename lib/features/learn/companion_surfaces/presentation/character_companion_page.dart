import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_palette.dart';
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

class CharacterCompanionPage extends ConsumerStatefulWidget {
  const CharacterCompanionPage({super.key, this.initialFocus});

  final String? initialFocus;

  @override
  ConsumerState<CharacterCompanionPage> createState() =>
      _CharacterCompanionPageState();
}

class _CharacterCompanionPageState
    extends ConsumerState<CharacterCompanionPage> {
  static const Set<String> _traitIds = <String>{
    'ikhlas',
    'sabr',
    'shukr',
    'humility',
    'forgiveness',
    'anger',
    'kindness',
  };

  String? _selectedTraitId;

  @override
  void initState() {
    super.initState();
    final savedTrait = ref
        .read(companionSurfacesUiControllerProvider)
        .selectedCharacterTraitId;
    _selectedTraitId =
        _normalizeTrait(widget.initialFocus) ?? _normalizeTrait(savedTrait);
  }

  @override
  void didUpdateWidget(covariant CharacterCompanionPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    final updatedFocus = _normalizeTrait(widget.initialFocus);
    if (updatedFocus != null && updatedFocus != _selectedTraitId) {
      _setSelectedTrait(updatedFocus);
    }
  }

  String? _normalizeTrait(String? traitId) {
    final normalized = traitId?.trim();
    if (normalized == null || normalized.isEmpty) {
      return null;
    }
    if (!_traitIds.contains(normalized)) {
      return null;
    }
    return normalized;
  }

  void _setSelectedTrait(String? traitId) {
    final normalized = _normalizeTrait(traitId);
    if (_selectedTraitId == normalized) {
      return;
    }
    setState(() {
      _selectedTraitId = normalized;
    });
    ref
        .read(companionSurfacesUiControllerProvider.notifier)
        .setCharacterTrait(normalized);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final bodyStyle = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
      height: 1.5,
    );
    final journey = LearningJourneyRegistry.journeyById('beautiful-character');
    if (journey == null) {
      return const SizedBox.shrink();
    }
    final progress = ref.watch(learningJourneyProgressProvider);
    final continueStageId = _continueStageId(
      journey,
      progress.completedStageIds,
    );
    final continueStage = continueStageId == null
        ? null
        : LearningJourneyRegistry.stageById(continueStageId);
    final traitLinks = _orderedTraitLinks(
      buildCharacterTraitLinks(l10n),
      _selectedTraitId,
    );
    final scenarioLinks = _orderedScenarioLinks(
      buildCharacterScenarioLinks(l10n),
      _selectedTraitId,
    );
    final selectedTrait = _selectedTraitId == null
        ? null
        : traitLinks.cast<LearnCompanionLinkItem?>().firstWhere(
            (item) => item?.id == _selectedTraitId,
            orElse: () => null,
          );
    final suggestedScenario = _scenarioForTrait(
      scenarioLinks,
      _selectedTraitId,
    );
    final focus = _selectedTraitId;

    return LearnHubPageScaffold(
      headerIcon: AppIcons.character,
      title: l10n.learningJourneyBeautifulCharacterTitle,
      subtitle: l10n.learningJourneyBeautifulCharacterSubtitle,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.learningJourneyBeautifulCharacterDescription,
                style: bodyStyle,
              ),
              const SizedBox(height: 10),
              Text(l10n.learnCharacterCompanionHeroNote, style: bodyStyle),
              if (selectedTrait != null) ...[
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
                    selectedTrait.title,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(selectedTrait.subtitle, style: bodyStyle),
              ],
            ],
          ),
        ),
        const SizedBox(height: 20),
        _SectionHeader(
          title: l10n.learnCharacterCompanionFocusTitle,
          subtitle: l10n.learnCharacterCompanionFocusSubtitle,
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
                label: l10n.learnCharacterCompanionAllTraitsChip,
                child: ChoiceChip(
                  label: Text(l10n.learnCharacterCompanionAllTraitsChip),
                  selected: focus == null,
                  onSelected: (_) => _setSelectedTrait(null),
                ),
              ),
              for (final item in buildCharacterTraitLinks(l10n))
                Semantics(
                  button: true,
                  selected: focus == item.id,
                  label: item.title,
                  hint: item.subtitle,
                  child: ChoiceChip(
                    label: Text(item.title),
                    selected: focus == item.id,
                    onSelected: (_) => _setSelectedTrait(item.id),
                  ),
                ),
            ],
          ),
        ),
        if (selectedTrait != null && suggestedScenario != null) ...[
          const SizedBox(height: 12),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.learnCharacterCompanionPracticeTodayTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.learnCharacterCompanionPracticeTodaySubtitle,
                  style: TextStyle(
                    color: context.palette.onSurfaceSubtle,
                    height: 1.4,
                  ),
                ),
                if (selectedTrait.nextStep != null) ...[
                  const SizedBox(height: 10),
                  _InfoBlock(
                    title: l10n.learnCharacterCompanionNextStepTitle,
                    body: selectedTrait.nextStep!,
                  ),
                ],
                const SizedBox(height: 12),
                _LinkCard(item: suggestedScenario, highlighted: true),
              ],
            ),
          ),
        ],
        const SizedBox(height: 16),
        _SectionHeader(
          title: l10n.learnContentContinueTitle,
          subtitle: l10n.learnCompanionContinueSubtitle,
        ),
        const SizedBox(height: 10),
        _LinkCard(
          item: LearnCompanionLinkItem(
            id: continueStage?.id ?? journey.id,
            title: continueStage == null
                ? l10n.learningJourneyBeautifulCharacterTitle
                : localizedStageTitle(context, continueStage),
            subtitle: continueStage == null
                ? l10n.learningJourneyBeautifulCharacterSubtitle
                : localizedStageSummary(context, continueStage),
            routeTarget: LearnCompanionRouteTarget(
              routeName: continueStage == null
                  ? 'learnJourneyDetail'
                  : 'learnJourneyStage',
              pathParameters: continueStage == null
                  ? {'journeyId': journey.id}
                  : {'journeyId': journey.id, 'stageId': continueStage.id},
            ),
          ),
        ),
        const SizedBox(height: 20),
        _SectionHeader(
          title: l10n.learnCharacterCompanionTraitsTitle,
          subtitle: l10n.learnCharacterCompanionTraitsSubtitle,
        ),
        const SizedBox(height: 10),
        ...traitLinks.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _LinkCard(item: item, highlighted: focus == item.id),
          ),
        ),
        const SizedBox(height: 16),
        _SectionHeader(
          title: l10n.learnCharacterCompanionScenariosTitle,
          subtitle: l10n.learnCharacterCompanionScenariosSubtitle,
        ),
        const SizedBox(height: 10),
        ...scenarioLinks.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _LinkCard(item: item, isScenario: true),
          ),
        ),
        const SizedBox(height: 16),
        _SectionHeader(
          title: l10n.learnCompanionSourcesTitle,
          subtitle: l10n.learnCompanionSourcesSubtitle,
        ),
        const SizedBox(height: 10),
        ...buildCharacterCompanionSources(l10n).map(
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

  List<LearnCompanionLinkItem> _orderedTraitLinks(
    List<LearnCompanionLinkItem> items,
    String? selectedTraitId,
  ) {
    if (selectedTraitId == null || selectedTraitId.isEmpty) {
      return items;
    }
    final selected = items.where((item) => item.id == selectedTraitId);
    final rest = items.where((item) => item.id != selectedTraitId);
    return [...selected, ...rest];
  }

  LearnCompanionLinkItem? _scenarioForTrait(
    List<LearnCompanionLinkItem> scenarios,
    String? selectedTraitId,
  ) {
    final scenarioId = switch (selectedTraitId) {
      'ikhlas' => 'intentions',
      'sabr' => 'work-study-pressure',
      'shukr' => 'family',
      'humility' => 'neighbors',
      'forgiveness' => 'family',
      'anger' => 'anger-self-control',
      'kindness' => 'speech',
      _ => null,
    };
    if (scenarioId == null) {
      return null;
    }
    for (final scenario in scenarios) {
      if (scenario.id == scenarioId) {
        return scenario;
      }
    }
    return null;
  }

  List<LearnCompanionLinkItem> _orderedScenarioLinks(
    List<LearnCompanionLinkItem> items,
    String? selectedTraitId,
  ) {
    final suggested = _scenarioForTrait(items, selectedTraitId);
    if (suggested == null) {
      return items;
    }
    final prioritized = items.where((item) => item.id == suggested.id);
    final rest = items.where((item) => item.id != suggested.id);
    return [...prioritized, ...rest];
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

class _LinkCard extends StatelessWidget {
  const _LinkCard({
    required this.item,
    this.highlighted = false,
    this.isScenario = false,
  });

  final LearnCompanionLinkItem item;
  final bool highlighted;
  final bool isScenario;

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
                _InfoBlock(
                  title: isScenario
                      ? AppLocalizations.of(
                          context,
                        ).learnCharacterCompanionScenarioMeaningTitle
                      : AppLocalizations.of(
                          context,
                        ).learnCharacterCompanionMeaningTitle,
                  body: item.description!,
                ),
              ],
              if (item.practicalExpression != null) ...[
                const SizedBox(height: 10),
                _InfoBlock(
                  title: isScenario
                      ? AppLocalizations.of(
                          context,
                        ).learnCharacterCompanionScenarioPracticeTitle
                      : AppLocalizations.of(
                          context,
                        ).learnCharacterCompanionPracticalExpressionTitle,
                  body: item.practicalExpression!,
                ),
              ],
              if (item.nextStep != null) ...[
                const SizedBox(height: 10),
                _InfoBlock(
                  title: isScenario
                      ? AppLocalizations.of(
                          context,
                        ).learnCharacterCompanionScenarioCarryForwardTitle
                      : AppLocalizations.of(
                          context,
                        ).learnCharacterCompanionNextStepTitle,
                  body: item.nextStep!,
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

class _InfoBlock extends StatelessWidget {
  const _InfoBlock({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          body,
          style: theme.textTheme.bodyMedium?.copyWith(
            height: 1.45,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
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
