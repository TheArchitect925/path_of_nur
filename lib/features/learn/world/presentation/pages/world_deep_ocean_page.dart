import 'package:flutter/material.dart';

import '../../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../../../../../l10n/app_localizations.dart';

class WorldDeepOceanPage extends StatelessWidget {
  const WorldDeepOceanPage({super.key});

  @override
  Widget build(BuildContext context) {
    const zones = [
      (
        'Surface',
        'High light, active waves, and visible weather interaction.',
        Color(0xFF3B87C8),
      ),
      (
        'Sunlight Zone',
        'Most photosynthesis occurs here; biodiversity is high.',
        Color(0xFF2E6FA7),
      ),
      (
        'Twilight Zone',
        'Light drops rapidly and visual adaptation becomes critical.',
        Color(0xFF275887),
      ),
      (
        'Midnight Zone',
        'Near-total darkness with strong pressure and sparse food.',
        Color(0xFF1D3F63),
      ),
      (
        'Abyssal Zone',
        'Extreme pressure and cold demonstrate hidden complexity.',
        Color(0xFF132C47),
      ),
    ];

    return AppPageScaffold(
      title: AppLocalizations.of(context).worldDeepOceanTitle,
      subtitle: AppLocalizations.of(context).worldDeepOceanSubtitle,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Quran 24:40',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 8),
              Text(
                'This lesson uses the verse as a contemplative invitation toward humility before layered realities in creation.',
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        ...zones.map(
          (zone) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: zone.$3,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      zone.$1,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      zone.$2,
                      style: const TextStyle(color: Color(0xFFE3E8F2)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
