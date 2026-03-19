import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/content/learning_quote.dart';
import '../../../shared/theme/islamic_icons.dart';
import '../../../shared/widgets/quran_navigation.dart';
import '../../../shared/widgets/section_hub_scaffold.dart';
import 'growth_journey_page.dart';
import 'growth_paths_page.dart';
import 'growth_reflection_page.dart';
import 'growth_today_page.dart';

class GrowthTodaySectionPage extends StatelessWidget {
  const GrowthTodaySectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _GrowthSectionScaffold(
      title: l10n.growthTabToday,
      subtitle: l10n.growthHomeTodaySubtitle,
      child: const GrowthTodayPage(),
    );
  }
}

class GrowthPathsSectionPage extends StatelessWidget {
  const GrowthPathsSectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _GrowthSectionScaffold(
      title: l10n.growthTabPaths,
      subtitle: l10n.growthHomePathsSubtitle,
      child: const GrowthPathsPage(),
    );
  }
}

class GrowthJourneySectionPage extends StatelessWidget {
  const GrowthJourneySectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _GrowthSectionScaffold(
      title: l10n.growthTabJourney,
      subtitle: l10n.growthHomeJourneySubtitle,
      shortcutActions: [
        SectionShortcutAction(
          label: l10n.gardenPageTitle,
          supportingText: l10n.gardenPageEntryHomeSubtitle,
          icon: Icons.local_florist_rounded,
          onTap: () => context.pushNamed('gardenPage'),
        ),
      ],
      child: const GrowthJourneyPage(),
    );
  }
}

class GrowthReflectionSectionPage extends StatelessWidget {
  const GrowthReflectionSectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _GrowthSectionScaffold(
      title: l10n.growthTabReflection,
      subtitle: l10n.growthHomeReflectionSubtitle,
      child: const GrowthReflectionPage(),
    );
  }
}

class _GrowthSectionScaffold extends StatelessWidget {
  const _GrowthSectionScaffold({
    required this.title,
    required this.subtitle,
    required this.child,
    this.shortcutActions = const <SectionShortcutAction>[],
  });

  final String title;
  final String subtitle;
  final Widget child;
  final List<SectionShortcutAction> shortcutActions;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final quote = buildLearningCompactQuote();

    return SectionHubScaffold(
      headerIcon: IslamicIcons.tasbih,
      title: title,
      subtitle: subtitle,
      quote: quote,
      onQuoteTap: (selectedQuote) =>
          openQuranQuoteLocation(context, selectedQuote),
      shortcutOpenLabel: l10n.learnShortcutOpen,
      shortcutCloseLabel: l10n.learnShortcutClose,
      shortcutActions: shortcutActions,
      children: [child],
    );
  }
}
