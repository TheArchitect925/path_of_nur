import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import 'premium_card.dart';

class MainPageSearchDestination {
  const MainPageSearchDestination({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    this.keywords = const <String>[],
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final List<String> keywords;

  String get searchableText =>
      [title, subtitle, ...keywords].join(' ').toLowerCase();
}

class MainPageSearchLauncher extends StatelessWidget {
  const MainPageSearchLauncher({
    super.key,
    required this.destinations,
    this.hintText,
  });

  final List<MainPageSearchDestination> destinations;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final resolvedHint = hintText ?? l10n.mainPageSearchHint;

    return PremiumCard(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: destinations.isEmpty
            ? null
            : () {
                showSearch<void>(
                  context: context,
                  delegate: _MainPageSearchDelegate(
                    destinations: destinations,
                    searchFieldLabel: resolvedHint,
                    emptyTitle: l10n.mainPageSearchEmptyTitle,
                    emptySubtitle: l10n.mainPageSearchEmptySubtitle,
                  ),
                );
              },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          child: Row(
            children: [
              const Icon(Icons.search_rounded),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  resolvedHint,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MainPageSearchDelegate extends SearchDelegate<void> {
  _MainPageSearchDelegate({
    required this.destinations,
    required String searchFieldLabel,
    required this.emptyTitle,
    required this.emptySubtitle,
  }) : super(searchFieldLabel: searchFieldLabel);

  final List<MainPageSearchDestination> destinations;
  final String emptyTitle;
  final String emptySubtitle;

  List<MainPageSearchDestination> _filteredDestinations() {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return destinations;
    return destinations
        .where((destination) => destination.searchableText.contains(normalized))
        .toList(growable: false);
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: theme.appBarTheme.copyWith(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      inputDecorationTheme: theme.inputDecorationTheme.copyWith(
        border: InputBorder.none,
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    if (query.trim().isEmpty) return null;
    return [
      IconButton(
        onPressed: () => query = '',
        icon: const Icon(Icons.close_rounded),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const BackButtonIcon(),
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _SearchResultList(
      results: _filteredDestinations(),
      emptyTitle: emptyTitle,
      emptySubtitle: emptySubtitle,
      onTap: (destination) {
        close(context, null);
        destination.onTap();
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _SearchResultList(
      results: _filteredDestinations(),
      emptyTitle: emptyTitle,
      emptySubtitle: emptySubtitle,
      onTap: (destination) {
        close(context, null);
        destination.onTap();
      },
    );
  }
}

class _SearchResultList extends StatelessWidget {
  const _SearchResultList({
    required this.results,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.onTap,
  });

  final List<MainPageSearchDestination> results;
  final String emptyTitle;
  final String emptySubtitle;
  final ValueChanged<MainPageSearchDestination> onTap;

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.search_off_rounded, size: 32),
              const SizedBox(height: 12),
              Text(
                emptyTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                emptySubtitle,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: results.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final destination = results[index];
        return PremiumCard(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(destination.icon),
            title: Text(destination.title),
            subtitle: Text(destination.subtitle),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => onTap(destination),
          ),
        );
      },
    );
  }
}
