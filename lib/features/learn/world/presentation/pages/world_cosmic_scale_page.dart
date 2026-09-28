import 'package:flutter/material.dart';

import '../../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../../../../../l10n/app_localizations.dart';

class WorldCosmicScalePage extends StatelessWidget {
  const WorldCosmicScalePage({super.key});

  @override
  Widget build(BuildContext context) {
    const steps = [
      ('Cell', 'Microscopic life systems remind us of hidden precision.'),
      ('Human', 'The human body is complex yet dependent and fragile.'),
      ('Tree', 'Living growth scales beyond immediate perception over time.'),
      ('Mountain', 'Large landforms anchor landscapes and perspective.'),
      ('Earth', 'Our shared home is one small world in vast creation.'),
      ('Moon', 'Regular lunar cycles shape time awareness.'),
      ('Sun', 'The sun sustains life and marks rhythm and direction.'),
      ('Solar System', 'Planetary motion reveals ordered dynamics.'),
      ('Galaxy', 'Billions of stars enlarge the sense of scale.'),
      ('Observable Universe', 'Immensity invites humility and gratitude.'),
    ];

    return AppPageScaffold(
      title: AppLocalizations.of(context).worldCosmicScaleTitle,
      subtitle: AppLocalizations.of(context).worldCosmicScaleSubtitle,
      children: [
        ...steps.asMap().entries.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: PremiumCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      color: const Color(0xFFF1E4CC),
                    ),
                    child: Text('${entry.key + 1}'),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.value.$1,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Text(entry.value.$2),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
