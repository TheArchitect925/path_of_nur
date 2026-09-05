import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../shared/widgets/app_page_scaffold.dart';
import '../../shared/widgets/premium_card.dart';

class AttributionsLicensesPage extends StatelessWidget {
  const AttributionsLicensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppPageScaffold(
      title: l10n.settingsAttributionsLicensesTitle,
      subtitle: l10n.legalAttributionsSubtitle,
      children: [
        _AttributionCard(
          title: l10n.legalAttributionsQuranTitle,
          body: l10n.legalAttributionsQuranBody,
        ),
        const SizedBox(height: 10),
        _AttributionCard(
          title: l10n.legalAttributionsTransliterationTitle,
          body: l10n.legalAttributionsTransliterationBody,
        ),
        const SizedBox(height: 10),
        _AttributionCard(
          title: l10n.legalAttributionsRecitationTitle,
          body: l10n.legalAttributionsRecitationBody,
        ),
        const SizedBox(height: 10),
        _AttributionCard(
          title: l10n.legalAttributionsAdhanTitle,
          body: l10n.legalAttributionsAdhanBody,
        ),
        const SizedBox(height: 10),
        _AttributionCard(
          title: l10n.legalAttributionsWordTimingTitle,
          body: l10n.legalAttributionsWordTimingBody,
        ),
      ],
    );
  }
}

class _AttributionCard extends StatelessWidget {
  const _AttributionCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          SelectableText(
            body,
            style: TextStyle(
              height: 1.35,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
