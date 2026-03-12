import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../shared/widgets/premium_card.dart';

class RevelationGrowthLinkCard extends StatelessWidget {
  const RevelationGrowthLinkCard({super.key, required this.habitLabels});

  final List<String> habitLabels;

  @override
  Widget build(BuildContext context) {
    if (habitLabels.isEmpty) return const SizedBox.shrink();
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Practice This Era',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            'Bring today\'s learning into gentle action through small consistent habits.',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceSubtle),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: habitLabels.map((h) => _chip(h)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: AppColors.surface.withValues(alpha: 0.28),
        border: Border.all(
          color: AppColors.accentGoldSoft.withValues(alpha: 0.34),
        ),
      ),
      child: Text(label, style: const TextStyle(fontSize: 11.5)),
    );
  }
}
