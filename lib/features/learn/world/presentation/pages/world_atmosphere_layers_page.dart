import 'package:flutter/material.dart';

import '../../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../../../../../l10n/app_localizations.dart';

class WorldAtmosphereLayersPage extends StatelessWidget {
  const WorldAtmosphereLayersPage({super.key});

  @override
  Widget build(BuildContext context) {
    const layers = [
      ('Troposphere', 'Weather systems, clouds, and most breathable air.'),
      ('Stratosphere', 'Includes ozone concentration and stable layering.'),
      ('Mesosphere', 'Cold region where many meteors burn up.'),
      (
        'Thermosphere',
        'Very thin air with auroral and high-energy interactions.',
      ),
      ('Exosphere', 'Transition zone toward space and orbital pathways.'),
    ];

    return AppPageScaffold(
      title: AppLocalizations.of(context).worldLandingAtmosphereLayersAction,
      subtitle: AppLocalizations.of(context).worldAtmosphereLayersSubtitle,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Quran 21:32',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 8),
              Text(
                'Presented with care: this is not a one-to-one technical claim, but a reflective bridge to atmospheric protection and layered structure.',
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        ...layers.asMap().entries.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: PremiumCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${entry.key + 1}. ${entry.value.$1}',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Text(entry.value.$2),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
