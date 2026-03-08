import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/premium_card.dart';

class LearnActionCard extends StatelessWidget {
  const LearnActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.sectionId,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String? sectionId;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: InkWell(
        onTap: sectionId == null
            ? null
            : () => context.pushNamed(
                  'featureSection',
                  pathParameters: {'sectionId': sectionId!},
                ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.accentGold.withValues(alpha: 0.22),
              ),
              child: Icon(icon, color: AppColors.onSurface),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(color: AppColors.onSurfaceSubtle, height: 1.35),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.onSurfaceSubtle),
          ],
        ),
      ),
    );
  }
}

class LearnTopicGrid extends StatelessWidget {
  const LearnTopicGrid({
    super.key,
    required this.topics,
  });

  final List<String> topics;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: topics
          .map(
            (topic) => SizedBox(
              width: (MediaQuery.of(context).size.width - 16 * 2 - 10 - 2) / 2,
              child: PremiumCard(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                child: Row(
                  children: [
                    const Icon(Icons.auto_stories_outlined, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        topic,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

