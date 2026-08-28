import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import 'premium_card.dart';

/// Legacy descriptor for hub-specific search destinations. The launcher now
/// routes to the unified /search page, so these entries no longer drive a
/// per-hub search delegate; the type remains so hub pages compile while
/// their destination lists are retired incrementally.
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
}

/// Search entry card shown on the five main hub pages. Opens the canonical
/// global search (/search) — one search experience for the whole app.
class MainPageSearchLauncher extends StatelessWidget {
  const MainPageSearchLauncher({
    super.key,
    this.destinations = const <MainPageSearchDestination>[],
    this.hintText,
    this.supplementalBuilder,
  });

  final List<MainPageSearchDestination> destinations;
  final String? hintText;

  /// Unused since consolidation on /search; kept for call-site compatibility.
  final Widget? Function(
    BuildContext context,
    String query,
    ValueChanged<String> updateQuery,
  )?
  supplementalBuilder;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final resolvedHint = hintText ?? l10n.mainPageSearchHint;

    return PremiumCard(
      density: PremiumCardDensity.compact,
      onTap: () => context.pushNamed('allSearch'),
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
    );
  }
}
