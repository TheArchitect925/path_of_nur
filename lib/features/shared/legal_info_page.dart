import 'package:flutter/material.dart';

import '../../core/config/build_flavor.dart';
import '../../core/diagnostics/app_telemetry.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/app_page_scaffold.dart';
import '../../shared/widgets/premium_card.dart';

enum LegalInfoKind { privacy, terms, support }

class LegalInfoPage extends StatelessWidget {
  const LegalInfoPage({super.key, required this.kind});

  final LegalInfoKind kind;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final title = switch (kind) {
      LegalInfoKind.privacy => l10n.legalPrivacyTitle,
      LegalInfoKind.terms => l10n.legalTermsTitle,
      LegalInfoKind.support => l10n.legalSupportTitle,
    };

    final subtitle = switch (kind) {
      LegalInfoKind.privacy => l10n.legalPrivacySubtitle,
      LegalInfoKind.terms => l10n.legalTermsSubtitle,
      LegalInfoKind.support => l10n.legalSupportSubtitle,
    };

    final body = switch (kind) {
      LegalInfoKind.privacy => l10n.legalPrivacyBody,
      LegalInfoKind.terms => l10n.legalTermsBody,
      LegalInfoKind.support => l10n.legalSupportBody,
    };

    return AppPageScaffold(
      title: title,
      subtitle: subtitle,
      children: [
        PremiumCard(child: Text(body, style: const TextStyle(height: 1.4))),
        if (kind == LegalInfoKind.support) ...[
          const SizedBox(height: 12),
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.legalBuildInfoTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(l10n.legalBuildFlavorLabel(BuildFlavorConfig.label)),
                const SizedBox(height: 4),
                Text(
                  l10n.legalCrashLogCountLabel(
                    AppTelemetry.getCrashLog().length,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
