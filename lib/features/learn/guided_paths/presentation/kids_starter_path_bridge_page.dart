import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../analytics/application/learn_analytics_service.dart';
import '../../analytics/domain/learn_analytics_models.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';

class KidsStarterPathBridgePage extends StatelessWidget {
  const KidsStarterPathBridgePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    const analytics = LearnAnalyticsService();
    return LearnHubPageScaffold(
      headerIcon: Icons.child_friendly_rounded,
      title: l10n.learnKidsStarterBridgeTitle,
      subtitle: l10n.learnKidsStarterBridgeSubtitle,
      showDefaultQuote: false,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.learnKidsStarterBridgeIntroTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(l10n.learnKidsStarterBridgeIntroBody),
              const SizedBox(height: 14),
              _HintRow(
                icon: Icons.text_fields_rounded,
                text: l10n.learnKidsStarterBridgeArabicHint,
              ),
              const SizedBox(height: 10),
              _HintRow(
                icon: Icons.auto_stories_rounded,
                text: l10n.learnKidsStarterBridgeStoryHint,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () {
                  analytics.logPrimaryCardOpened(
                    cardId: 'kids_starter_begin',
                    sourceSurface: 'kids_starter_bridge',
                    domain: 'kids',
                    audience: LearnAnalyticsAudience.kids,
                  );
                  context.pushNamed(
                    'kidsArabicLesson',
                    pathParameters: const <String, String>{'letterId': 'alif'},
                  );
                },
                icon: const Icon(Icons.arrow_forward_rounded),
                label: Text(l10n.learnKidsStarterBridgeBeginAction),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HintRow extends StatelessWidget {
  const _HintRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
