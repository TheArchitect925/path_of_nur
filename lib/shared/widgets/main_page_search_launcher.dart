import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import 'premium_card.dart';

/// Search entry card shown on the five main hub pages. Opens the canonical
/// global search (/search) — one search experience for the whole app.
class MainPageSearchLauncher extends StatelessWidget {
  const MainPageSearchLauncher({super.key, this.hintText});

  final String? hintText;

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
