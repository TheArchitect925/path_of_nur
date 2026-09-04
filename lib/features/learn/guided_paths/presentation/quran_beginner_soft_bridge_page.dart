import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../analytics/application/learn_analytics_service.dart';
import '../../analytics/domain/learn_analytics_models.dart';
import '../../presentation/widgets/learn_hub_page_scaffold.dart';

class QuranBeginnerSoftBridgePage extends StatelessWidget {
  const QuranBeginnerSoftBridgePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    const analytics = LearnAnalyticsService();
    return LearnHubPageScaffold(
      title: l10n.learnQuranBeginnerSoftBridgeTitle,
      subtitle: l10n.learnQuranBeginnerSoftBridgeSubtitle,
      showDefaultQuote: false,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.learnQuranBeginnerSoftBridgeIntroTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(l10n.learnQuranBeginnerSoftBridgeIntroBody),
              const SizedBox(height: 14),
              _HintRow(
                icon: Icons.spa_outlined,
                text: l10n.learnQuranBeginnerSoftBridgeHintStartSmall,
              ),
              const SizedBox(height: 10),
              _HintRow(
                icon: Icons.headphones_outlined,
                text: l10n.learnQuranBeginnerSoftBridgeHintPace,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () {
                  analytics.logPrimaryCardOpened(
                    cardId: 'quran_beginner_bridge_handoff',
                    sourceSurface: 'quran_beginner_soft_bridge',
                    domain: 'quran',
                    audience: LearnAnalyticsAudience.beginner,
                  );
                  context.pushNamed('quranDailyCompanion');
                },
                icon: const Icon(Icons.arrow_forward_rounded),
                label: Text(l10n.learnQuranBeginnerSoftBridgeBeginAction),
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
