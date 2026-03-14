import 'package:flutter/material.dart';

import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/section_title.dart';
import '../../../shared/theme/islamic_icons.dart';

class ProfileComingSoonPage extends StatelessWidget {
  const ProfileComingSoonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      headerIcon: Icons.upcoming_outlined,
      title: 'Coming soon',
      subtitle: 'A calm look at the next improvements planned for Path of Nūr.',
      children: const [
        SectionTitle(
          title: 'On the roadmap',
          subtitle: 'These are the next areas being shaped for future updates.',
        ),
        _ComingSoonCard(
          icon: IslamicIcons.quran,
          title: 'Deeper Qur’anic Arabic guidance',
          description:
              'More verified source-linked examples, stronger review support, and clearer lesson progression are planned next.',
        ),
        SizedBox(height: 14),
        _ComingSoonCard(
          icon: Icons.quiz_outlined,
          title: 'Broader trivia journeys',
          description:
              'More curated knowledge paths, stronger category coverage, and better content diagnostics are planned.',
        ),
        SizedBox(height: 14),
        _ComingSoonCard(
          icon: IslamicIcons.prayer,
          title: 'Refined prayer widgets',
          description:
              'Further lock screen and Dynamic Island polish, with tighter presentation and more stable display options.',
        ),
        SizedBox(height: 14),
        _ComingSoonCard(
          icon: Icons.auto_awesome_outlined,
          title: 'Gentler personalization',
          description:
              'More optional onboarding and profile controls are planned so the app can adapt without feeling heavy.',
        ),
      ],
    );
  }
}

class _ComingSoonCard extends StatelessWidget {
  const _ComingSoonCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PremiumCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFF3EBE1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
