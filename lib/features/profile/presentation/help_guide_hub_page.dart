import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/section_hub_scaffold.dart';
import '../../../shared/widgets/section_title.dart';
import '../../learn/presentation/widgets/learn_discovery_search_field.dart';
import 'help_guide_content.dart';

class HelpGuideHubPage extends StatefulWidget {
  const HelpGuideHubPage({super.key});

  @override
  State<HelpGuideHubPage> createState() => _HelpGuideHubPageState();
}

class _HelpGuideHubPageState extends State<HelpGuideHubPage> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final query = _searchController.text.trim();
    final guides = buildHelpGuideEntries(l10n);
    final filtered = guides
        .where((entry) => entry.matchesQuery(query))
        .toList(growable: false);

    return SectionHubScaffold(
      headerIcon: Icons.help_center_outlined,
      title: l10n.settingsHelpGuideTitle,
      subtitle: l10n.settingsHelpGuideSubtitle,
      shortcutOpenLabel: l10n.learnShortcutOpen,
      shortcutCloseLabel: l10n.learnShortcutClose,
      children: [
        PremiumCard(
          child: LearnDiscoverySearchField(
            controller: _searchController,
            hintText: l10n.settingsHelpGuideSearchHint,
            onChanged: (_) => setState(() {}),
            onClear: () => setState(() => _searchController.clear()),
          ),
        ),
        const SizedBox(height: 14),
        SectionTitle(
          title: query.isEmpty
              ? l10n.settingsHelpGuideBrowseTitle
              : l10n.settingsHelpGuideSearchResultsTitle,
          subtitle: query.isEmpty
              ? l10n.settingsHelpGuideBrowseSubtitle
              : l10n.settingsHelpGuideSearchResultsSubtitle,
        ),
        const SizedBox(height: 8),
        if (filtered.isEmpty)
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.settingsHelpGuideSearchEmptyTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(l10n.settingsHelpGuideSearchEmptySubtitle),
              ],
            ),
          )
        else
          SectionHubActionGrid(
            actions: filtered
                .map(
                  (entry) => SectionHubAction(
                    title: entry.title,
                    subtitle: entry.description,
                    icon: entry.icon,
                    color: entry.color,
                    accentColor: entry.accentColor,
                    onTap: () => context.pushNamed(
                      'settingsHelpGuideDetail',
                      pathParameters: <String, String>{'guideId': entry.id},
                    ),
                  ),
                )
                .toList(growable: false),
          ),
      ],
    );
  }
}
