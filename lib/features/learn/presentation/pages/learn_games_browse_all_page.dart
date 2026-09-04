import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/section_hub_scaffold.dart';
import '../data/games_island_catalog.dart';
import '../models/game_discovery_models.dart';
import '../widgets/learn_discovery_search_field.dart';
import '../widgets/learn_hub_page_scaffold.dart';
import '../../../../core/theme/app_icons.dart';

class LearnGamesBrowseAllPage extends StatefulWidget {
  const LearnGamesBrowseAllPage({super.key, this.initialQuery});

  final String? initialQuery;

  @override
  State<LearnGamesBrowseAllPage> createState() =>
      _LearnGamesBrowseAllPageState();
}

class _LearnGamesBrowseAllPageState extends State<LearnGamesBrowseAllPage> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery ?? '');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final entries = GamesIslandCatalog.entries(l10n);
    final filteredEntries = _filterEntries(entries, _searchController.text);

    return LearnHubPageScaffold(
      headerIcon: AppIcons.browseAll,
      title: l10n.learnGamesBrowseAllPageTitleText,
      subtitle: l10n.learnGamesBrowseAllPageSubtitleText,
      children: [
        LearnDiscoverySearchField(
          controller: _searchController,
          hintText: l10n.learnGamesSearchHintText,
          onChanged: (_) => setState(() {}),
          onClear: () {
            _searchController.clear();
            setState(() {});
          },
        ),
        const SizedBox(height: 12),
        if (filteredEntries.isEmpty)
          Text(l10n.learnHubCategoryEmptyState)
        else
          SectionHubActionGrid(
            actions: [
              for (final entry in filteredEntries)
                SectionHubAction(
                  title: entry.card.badgeLabel == null
                      ? entry.card.title
                      : '${entry.card.title} • ${entry.card.badgeLabel}',
                  subtitle: '${entry.section.title} • ${entry.card.subtitle}',
                  icon: entry.card.icon,
                  color: entry.card.baseColor,
                  accentColor: entry.card.accentColor,
                  onTap: () => context.pushNamed(
                    entry.card.routeTarget.routeName,
                    pathParameters: entry.card.routeTarget.pathParameters,
                    queryParameters: entry.card.routeTarget.queryParameters,
                  ),
                ),
            ],
          ),
      ],
    );
  }

  List<({GameDiscoverySection section, GameDiscoveryCard card})> _filterEntries(
    List<({GameDiscoverySection section, GameDiscoveryCard card})> entries,
    String query,
  ) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) {
      return entries;
    }
    return entries
        .where((entry) {
          final haystack = [
            entry.section.title,
            entry.section.subtitle,
            entry.card.title,
            entry.card.subtitle,
            entry.card.badgeLabel ?? '',
            ...entry.card.searchKeywords,
          ].join(' ').toLowerCase();
          return haystack.contains(normalized);
        })
        .toList(growable: false);
  }
}
