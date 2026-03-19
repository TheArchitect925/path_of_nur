import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/application/kids_ui_theme_provider.dart';
import '../../../../shared/content/learning_quote.dart';
import '../application/family_learning_provider.dart';
import '../application/learning_journey_progress_provider.dart';
import '../data/learning_journey_localized_metadata.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../data/learning_journey_registry.dart';
import '../domain/learning_journey_models.dart';
import 'widgets/learning_journey_widgets.dart';

class LearningJourneyIslandPage extends ConsumerWidget {
  const LearningJourneyIslandPage({super.key, required this.islandId});

  final String islandId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final kidsUi = ref.watch(activeKidsUiThemeProvider);
    final island = LearningJourneyRegistry.islandById(islandId);
    final visibilityPolicy = ref.watch(
      activeFamilyLearningContextProvider.select(
        (value) => value.visibilityPolicy,
      ),
    );
    final relatedTools = _relatedToolsForIsland(islandId);
    final journeys = LearningJourneyRegistry.journeysForIsland(islandId)
        .where(
          (journey) =>
              learningVisibilityAllowsJourney(visibilityPolicy, journey),
        )
        .toList(growable: false);
    final progress = ref.watch(learningJourneyProgressProvider);
    if (island == null) {
      return _LearningJourneyMissingPage(
        title: l10n.learningJourneyIslandNotFoundTitle,
        subtitle: l10n.learningJourneyIslandNotFoundSubtitle,
        body: l10n.learningJourneyIslandNotFoundBody,
      );
    }
    return LearnHubPageScaffold(
      headerIcon: island.icon,
      title: localizedIslandTitle(context, island),
      subtitle: localizedIslandDescription(context, island),
      quote: buildLearningCompactQuote(),
      children: [
        if (visibilityPolicy.isChildProfile && journeys.isEmpty)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F1E8),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE3D6C4)),
            ),
            child: Text(
              l10n.familyLearningIslandReducedSubtitle,
              style: const TextStyle(color: Color(0xFF675B4E), height: 1.35),
            ),
          ),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: island.color,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: island.accentColor.withValues(alpha: 0.2),
            ),
          ),
          child: Text(
            localizedIslandSubtitle(context, island),
            style: TextStyle(
              color: island.accentColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (journeys.isNotEmpty) ...[
          const SizedBox(height: 14),
          LearningJourneyCard(
            journey: journeys.first,
            stageCount: journeys.first.stageIds.length,
            progress: _journeyProgressValue(
              journeys.first.stageIds.length,
              progress.completedStageIds
                  .where((id) => journeys.first.stageIds.contains(id))
                  .length,
            ),
            onTap: () => context.pushNamed(
              'learnJourneyDetail',
              pathParameters: {'journeyId': journeys.first.id},
            ),
          ),
        ],
        if (journeys.isNotEmpty) ...[
          const SizedBox(height: 14),
          JourneyHomeSectionHeader(
            title: l10n.learningJourneyIslandJourneysTitle,
            subtitle: l10n.learningJourneyIslandJourneysSubtitle,
          ),
          const SizedBox(height: 12),
          ...journeys.map(
            (journey) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: LearningJourneyCard(
                journey: journey,
                stageCount: journey.stageIds.length,
                progress: _journeyProgressValue(
                  journey.stageIds.length,
                  progress.completedStageIds
                      .where((id) => journey.stageIds.contains(id))
                      .length,
                ),
                onTap: () => context.pushNamed(
                  'learnJourneyDetail',
                  pathParameters: {'journeyId': journey.id},
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
        ],
        if (relatedTools.isNotEmpty &&
            (visibilityPolicy.showSecondaryExploration ||
                island.relatedTools.isNotEmpty ||
                kidsUi.enabled))
          RelatedToolsSection(
            title: l10n.learningJourneyIslandRelatedToolsTitle,
            subtitle: l10n.learningJourneyIslandRelatedToolsSubtitle,
            tools: relatedTools,
          ),
        if (_whyThisMattersForIsland(island.id, l10n) case final why?)
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: Container(
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
                    l10n.learningJourneyDetailWhyThisMattersTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2E261F),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    why,
                    style: const TextStyle(
                      color: Color(0xFF675B4E),
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  double? _journeyProgressValue(int total, int complete) {
    if (total <= 0) return null;
    return (complete / total).clamp(0.0, 1.0);
  }

  List<LearningJourneyToolLink> _relatedToolsForIsland(String islandId) {
    final tools = <LearningJourneyToolLink>[];
    final island = LearningJourneyRegistry.islandById(islandId);
    if (island != null) {
      for (final tool in island.relatedTools) {
        final alreadyAdded = tools.any(
          (item) =>
              item.title == tool.title && item.routeName == tool.routeName,
        );
        if (!alreadyAdded) {
          tools.add(tool);
        }
      }
    }
    for (final journey in LearningJourneyRegistry.journeysForIsland(islandId)) {
      for (final tool in journey.relatedTools) {
        final alreadyAdded = tools.any(
          (item) =>
              item.title == tool.title && item.routeName == tool.routeName,
        );
        if (!alreadyAdded) {
          tools.add(tool);
        }
      }
    }
    return tools.take(6).toList(growable: false);
  }

  String? _whyThisMattersForIsland(String islandId, AppLocalizations l10n) {
    switch (islandId) {
      case 'core-knowledge':
        return l10n.learningJourneyIslandWhyCoreKnowledge;
      case 'practice-worship':
        return l10n.learningJourneyIslandWhyPracticeWorship;
      case 'understanding-islam':
        return l10n.learningJourneyIslandWhyUnderstandingIslam;
      case 'arabic-learning':
        return l10n.learningJourneyIslandWhyArabicLearning;
      case 'discovery':
        return l10n.learningJourneyIslandWhyDiscovery;
      case 'kids-learning':
        return l10n.learningJourneyIslandWhyKidsLearning;
      case 'browse-all':
        return l10n.learningJourneyIslandWhyBrowseAll;
      case 'tools-other':
        return l10n.learningJourneyIslandWhyToolsOther;
      case 'legacy-learning':
        return l10n.learningJourneyIslandWhyLegacyLearning;
      default:
        return null;
    }
  }
}

class _LearningJourneyMissingPage extends StatelessWidget {
  const _LearningJourneyMissingPage({
    required this.title,
    required this.subtitle,
    required this.body,
  });

  final String title;
  final String subtitle;
  final String body;

  @override
  Widget build(BuildContext context) {
    return LearnHubPageScaffold(
      headerIcon: Icons.error_outline_rounded,
      title: title,
      subtitle: subtitle,
      children: [Text(body, style: TextStyle(color: Color(0xFF675B4E)))],
    );
  }
}
