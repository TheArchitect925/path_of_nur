import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_surfaces.dart';
import '../../../../shared/widgets/premium_card.dart';

class LearnActionCard extends StatelessWidget {
  const LearnActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
    this.showChevron = false,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final iconStyle = AppSurfaceTheme.resolve(
      context,
      variant: AppSurfaceVariant.panel,
      tintColor: AppColors.accentGold,
    );
    return PremiumCard(
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: iconStyle.decoration(
                  radius: 12,
                  includeShadow: false,
                ),
                child: Icon(icon, color: AppColors.onSurface),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.onSurfaceSubtle,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              if (showChevron)
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.onSurfaceSubtle,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class LearnTopicGrid extends StatelessWidget {
  const LearnTopicGrid({super.key, required this.topics, this.onTopicTap});

  final List<String> topics;
  final ValueChanged<String>? onTopicTap;

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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: onTopicTap == null ? null : () => onTopicTap!(topic),
                    child: Row(
                      children: [
                        const Icon(Icons.auto_stories_outlined, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            topic,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
