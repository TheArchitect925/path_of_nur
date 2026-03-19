import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/application/kids_ui_theme_provider.dart';
import '../../../../shared/content/learning_quote.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/family_learning_provider.dart';
import '../data/learning_journey_registry.dart';
import '../data/learning_journey_localized_metadata.dart';
import 'widgets/learning_journey_widgets.dart';

class LearnBrowseAllPage extends ConsumerWidget {
  const LearnBrowseAllPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final kidsUi = ref.watch(activeKidsUiThemeProvider);
    final visibilityPolicy = ref.watch(
      activeFamilyLearningContextProvider.select(
        (value) => value.visibilityPolicy,
      ),
    );
    final islands = [...LearningJourneyRegistry.islands]
      ..sort((a, b) => a.order.compareTo(b.order))
      ..removeWhere(
        (island) => !learningVisibilityAllowsIsland(visibilityPolicy, island),
      );
    return LearnHubPageScaffold(
      headerIcon: Icons.grid_view_rounded,
      title: l10n.learningJourneyBrowseAllTitle,
      subtitle: l10n.learningJourneyBrowseAllSubtitle,
      quote: buildLearningCompactQuote(),
      children: [
        if ((visibilityPolicy.isChildProfile || kidsUi.enabled) &&
            !visibilityPolicy.showBrowseAll) ...[
          LearningJourneyToolCard(
            title: l10n.familyLearningBrowseReducedTitle,
            subtitle: l10n.familyLearningBrowseReducedSubtitle,
            icon: Icons.route_rounded,
            onTap: () => context.pop(),
          ),
          const SizedBox(height: 12),
        ],
        JourneyHomeSectionHeader(
          title: l10n.learningJourneyBrowseIslandsTitle,
          subtitle: l10n.learningJourneyBrowseIslandsSubtitle,
        ),
        const SizedBox(height: 8),
        ...islands.map(
          (island) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: LearningJourneyIslandCard(
              island: island,
              title: localizedIslandTitle(context, island),
              subtitle: localizedIslandSubtitle(context, island),
              onTap: () => context.pushNamed(
                'learnJourneyIsland',
                pathParameters: {'islandId': island.id},
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        if ((!visibilityPolicy.isChildProfile ||
                visibilityPolicy.showBrowseAll) &&
            !kidsUi.enabled) ...[
          JourneyHomeSectionHeader(
            title: l10n.learningJourneyBrowseToolsTitle,
            subtitle: l10n.learningJourneyBrowseToolsSubtitle,
          ),
          const SizedBox(height: 8),
          LearningJourneyToolCard(
            title: l10n.learningJourneyBrowseQuranTitle,
            subtitle: l10n.learningJourneyBrowseQuranSubtitle,
            icon: Icons.menu_book_rounded,
            onTap: () => context.pushNamed('learnQuranHub'),
          ),
          const SizedBox(height: 10),
          LearningJourneyToolCard(
            title: l10n.learningJourneyBrowseQuranStudyTitle,
            subtitle: l10n.learningJourneyBrowseQuranStudySubtitle,
            icon: Icons.school_rounded,
            onTap: () => context.pushNamed('quranLearningHub'),
          ),
          const SizedBox(height: 10),
          LearningJourneyToolCard(
            title: l10n.learningJourneyBrowseQuranArabicTitle,
            subtitle: l10n.learningJourneyBrowseQuranArabicSubtitle,
            icon: Icons.translate_rounded,
            onTap: () => context.pushNamed('quranArabic'),
          ),
          const SizedBox(height: 10),
          if (visibilityPolicy.showDiscovery) ...[
            LearningJourneyToolCard(
              title: l10n.learningJourneyBrowseQuranUniverseTitle,
              subtitle: l10n.learningJourneyBrowseQuranUniverseSubtitle,
              icon: Icons.travel_explore_rounded,
              onTap: () => context.pushNamed('quranUniverse'),
            ),
            const SizedBox(height: 10),
          ],
          LearningJourneyToolCard(
            title: l10n.learningJourneyBrowseBabyNamesTitle,
            subtitle: l10n.learningJourneyBrowseBabyNamesSubtitle,
            icon: Icons.child_care_rounded,
            onTap: () => context.pushNamed('babyNamesHome'),
          ),
          const SizedBox(height: 10),
          LearningJourneyToolCard(
            title: l10n.learningJourneyBrowseNotesTitle,
            subtitle: l10n.learningJourneyBrowseNotesSubtitle,
            icon: Icons.sticky_note_2_outlined,
            onTap: () => context.pushNamed('learnNotesLanding'),
          ),
          const SizedBox(height: 10),
          LearningJourneyToolCard(
            title: l10n.learningJourneyBrowseQuranBookmarksTitle,
            subtitle: l10n.learningJourneyBrowseQuranBookmarksSubtitle,
            icon: Icons.bookmark_outline_rounded,
            onTap: () => context.pushNamed('quranBookmarks'),
          ),
          const SizedBox(height: 10),
          LearningJourneyToolCard(
            title: l10n.learningJourneyBrowseQuranNotesTitle,
            subtitle: l10n.learningJourneyBrowseQuranNotesSubtitle,
            icon: Icons.note_alt_outlined,
            onTap: () => context.pushNamed('quranNotes'),
          ),
          const SizedBox(height: 10),
          if (visibilityPolicy.showDiscovery) ...[
            LearningJourneyToolCard(
              title: l10n.learningJourneyBrowseKnowledgeConstellationTitle,
              subtitle:
                  l10n.learningJourneyBrowseKnowledgeConstellationSubtitle,
              icon: Icons.hub_outlined,
              onTap: () => context.pushNamed('knowledgeConstellation'),
            ),
            const SizedBox(height: 10),
          ],
          if (visibilityPolicy.showLegacyLearning)
            LearningJourneyToolCard(
              title: l10n.learningJourneyHomeLegacyTitle,
              subtitle: l10n.learningJourneyBrowseLegacySubtitle,
              icon: Icons.inventory_2_outlined,
              onTap: () => context.pushNamed('learnLegacy'),
            ),
        ],
      ],
    );
  }
}
