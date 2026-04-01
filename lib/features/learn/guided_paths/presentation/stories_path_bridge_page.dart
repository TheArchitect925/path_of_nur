import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';

class StoriesPathBridgePage extends StatelessWidget {
  const StoriesPathBridgePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return LearnHubPageScaffold(
      headerIcon: Icons.auto_stories_rounded,
      title: l10n.learnStoriesPathBridgeTitle,
      subtitle: l10n.learnStoriesPathBridgeSubtitle,
      showDefaultQuote: false,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.learnStoriesPathBridgeIntroTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(l10n.learnStoriesPathBridgeIntroBody),
              const SizedBox(height: 14),
              _HintRow(
                icon: Icons.route_rounded,
                text: l10n.learnStoriesPathBridgeHintNarrative,
              ),
              const SizedBox(height: 10),
              _HintRow(
                icon: Icons.favorite_border_rounded,
                text: l10n.learnStoriesPathBridgeHintMeaning,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => context.pushNamed(
                  'learnJourneyStage',
                  pathParameters: const <String, String>{
                    'journeyId': 'prophets-journey',
                    'stageId': 'prophets-overview',
                  },
                ),
                icon: const Icon(Icons.arrow_forward_rounded),
                label: Text(l10n.learnStoriesPathBridgeBeginAction),
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
