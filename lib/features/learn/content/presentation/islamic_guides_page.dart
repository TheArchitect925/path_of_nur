import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/app_page_scaffold.dart';
import '../../../../shared/widgets/premium_card.dart';

class IslamicGuidesPage extends StatelessWidget {
  const IslamicGuidesPage({super.key});

  static const _guides = <({String title, String subtitle, String topicId})>[
    (
      title: 'Companion App Disclaimer',
      subtitle: 'Why community and mosque connection remain essential.',
      topicId: 'disclaimer-community-first',
    ),
    (
      title: 'New Muslim Path',
      subtitle: 'Foundational guidance for beginning Islam.',
      topicId: 'new-muslim-path',
    ),
    (
      title: 'Revert Muslim Support',
      subtitle: 'Gentle consistency, forgiveness, and practical growth.',
      topicId: 'revert-support-growth',
    ),
    (
      title: 'Salah Learning Track',
      subtitle: 'Structured prayer learning from intention to consistency.',
      topicId: 'salah-learning-track',
    ),
    (
      title: 'Hajj Full Journey',
      subtitle: 'From preparation and booking to returning home.',
      topicId: 'hajj-full-journey',
    ),
    (
      title: 'Umrah Full Journey',
      subtitle: 'Step-by-step preparation, rites, and after-care.',
      topicId: 'umrah-full-journey',
    ),
    (
      title: 'I\'tikaf Basics',
      subtitle: 'Purpose, etiquette, and practical retreat structure.',
      topicId: 'itikaaf-basics',
    ),
    (
      title: 'I\'tikaf Do\'s & Don\'ts',
      subtitle: 'Keep focus and avoid common distractions.',
      topicId: 'itikaaf-dos-donts',
    ),
    (
      title: 'Islamic Do\'s & Don\'ts',
      subtitle: 'Daily moral guardrails for worship and conduct.',
      topicId: 'islamic-dos-donts',
    ),
    (
      title: 'Honor and Roles of Women',
      subtitle: 'Respect, dignity, rights, and contribution.',
      topicId: 'women-honor-roles',
    ),
    (
      title: 'What Brothers Should Know',
      subtitle: 'Respectful conduct and responsibility toward sisters.',
      topicId: 'brothers-respect-sisters',
    ),
    (
      title: 'Sisters Guidance',
      subtitle: 'Cycle-aware worship guidance and supportive topics.',
      topicId: 'sisters-guidance',
    ),
    (
      title: 'Stay Away from Jealousy',
      subtitle: 'Heart purification from envy and harmful comparison.',
      topicId: 'jealousy-heart-purification',
    ),
    (
      title: 'Avoid Gossip and Idle Talk',
      subtitle: 'Speech ethics from Quran source lessons.',
      topicId: 'gossip-idle-talk-ethics',
    ),
    (
      title: 'Conflict Resolution with Justice',
      subtitle: 'Resolve disputes with fairness and process.',
      topicId: 'conflict-resolution-adab',
    ),
    (
      title: 'Networking for Benefit',
      subtitle: 'Build healthier circles and community support.',
      topicId: 'networking-community-benefit',
    ),
    (
      title: 'Workplace Ethics and Safety',
      subtitle: 'Dignity, boundaries, and anti-harassment guidance.',
      topicId: 'workplace-ethics-safety',
    ),
    (
      title: 'Health as a Trust',
      subtitle: 'Physical and mental wellness as amanah.',
      topicId: 'health-body-mind-trust',
    ),
    (
      title: 'Be Mindful of Time',
      subtitle: 'Treat time as sacred and purposeful.',
      topicId: 'time-mindful-use',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      headerIcon: Icons.menu_book_rounded,
      title: 'Islamic Guidance Hub',
      subtitle: 'Structured practical guides for family, worship, and growth.',
      children: [
        PremiumCard(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Quran Source Mapping (50 Lessons)'),
            subtitle: const Text(
              'See which lessons are covered, partially covered, or still need expansion.',
            ),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.pushNamed('quranLessonsMapping'),
          ),
        ),
        const SizedBox(height: 10),
        ..._guides.map(
          (guide) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: PremiumCard(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(guide.title),
                subtitle: Text(guide.subtitle),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.pushNamed(
                  'learnContentDetail',
                  pathParameters: {
                    'category': 'life',
                    'topicId': guide.topicId,
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
