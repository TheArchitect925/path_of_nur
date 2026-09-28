import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/application/special_mode_provider.dart';
import '../../../shared/content/learning_quote.dart';
import '../../../shared/content/page_description_copy.dart';
import '../../../shared/widgets/quran_navigation.dart';
import '../../../shared/widgets/section_hub_scaffold.dart';
import 'growth_journey_page.dart';
import 'growth_paths_page.dart';
import 'growth_reflection_page.dart';
import 'growth_today_page.dart';
import '../../../core/theme/app_icons.dart';

class GrowthTodaySectionPage extends StatelessWidget {
  const GrowthTodaySectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _GrowthSectionScaffold(
      title: l10n.growthTabToday,
      descriptionKey: AppPageDescriptionKey.growthToday,
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
      descriptionKey: AppPageDescriptionKey.growthPaths,
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
      descriptionKey: AppPageDescriptionKey.growthJourney,
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
      descriptionKey: AppPageDescriptionKey.growthReflection,
      child: const GrowthReflectionPage(),
    );
  }
}

class _GrowthSectionScaffold extends StatelessWidget {
  const _GrowthSectionScaffold({
    required this.title,
    required this.descriptionKey,
    required this.child,
    this.shortcutActions = const <SectionShortcutAction>[],
  });

  final String title;
  final AppPageDescriptionKey descriptionKey;
  final Widget child;
  final List<SectionShortcutAction> shortcutActions;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final l10n = AppLocalizations.of(context);
        final isKidsMode = ref.watch(
          specialModeProvider.select((mode) => mode.isKids),
        );
        final quote = buildGrowthReflectionQuote();

        return SectionHubScaffold(
          headerIcon: AppIcons.growth,
          title: title,
          subtitle: localizedAppPageDescription(
            context,
            descriptionKey,
            kidsMode: isKidsMode,
          ),
          quote: quote,
          onQuoteTap: (selectedQuote) =>
              openQuranQuoteLocation(context, selectedQuote),
          shortcutOpenLabel: l10n.learnShortcutOpen,
          shortcutCloseLabel: l10n.learnShortcutClose,
          shortcutActions: shortcutActions,
          children: [child],
        );
      },
    );
  }
}
