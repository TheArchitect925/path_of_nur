import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../learn/journey/data/learning_journey_localized_metadata.dart';
import '../../learn/journey/data/learning_journey_registry.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/contextual_linking_models.dart';

class ContextualRelatedContentSection extends StatelessWidget {
  const ContextualRelatedContentSection({super.key, required this.items});

  final List<ContextualLinkResult> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        for (var index = 0; index < items.length; index++) ...[
          if (index > 0) const Divider(height: 1),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(_title(context, items[index])),
            subtitle: Text(_subtitle(context, items[index])),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.pushNamed(
              items[index].node.routeName,
              pathParameters: items[index].node.pathParameters,
              queryParameters: items[index].node.queryParameters,
            ),
          ),
        ],
      ],
    );
  }

  String _title(BuildContext context, ContextualLinkResult item) {
    final node = item.node;
    if (node.routeName == 'learnJourneyDetail') {
      final journeyId = node.pathParameters['journeyId'];
      final journey = journeyId == null
          ? null
          : LearningJourneyRegistry.journeyById(journeyId);
      if (journey != null) {
        return localizedJourneyTitle(context, journey);
      }
    }
    return node.title;
  }

  String _subtitle(BuildContext context, ContextualLinkResult item) {
    final l10n = AppLocalizations.of(context);
    final typeLabel = switch (item.node.type) {
      ContextualContentType.historicalEvent => l10n.contextualLinksTypeEvent,
      ContextualContentType.journey => l10n.contextualLinksTypeJourney,
      ContextualContentType.hadith => l10n.contextualLinksTypeHadith,
      ContextualContentType.learnContent => l10n.contextualLinksTypeLearn,
    };
    final supporting = _supportingText(context, item);
    if (supporting.isEmpty) return typeLabel;
    return '$typeLabel • $supporting';
  }

  String _supportingText(BuildContext context, ContextualLinkResult item) {
    final node = item.node;
    if (node.routeName == 'learnJourneyDetail') {
      final journeyId = node.pathParameters['journeyId'];
      final journey = journeyId == null
          ? null
          : LearningJourneyRegistry.journeyById(journeyId);
      if (journey != null) {
        final localizedSubtitle = localizedJourneySubtitle(
          context,
          journey,
        ).trim();
        if (localizedSubtitle.isNotEmpty) {
          return localizedSubtitle;
        }
      }
    }
    if (node.subtitle.trim().isNotEmpty) {
      return node.subtitle.trim();
    }
    return node.summary.trim();
  }
}
