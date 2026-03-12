import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/theme/islamic_icons.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../widgets/learn_hub_page_scaffold.dart';
import '../widgets/learn_section_header.dart';

class LearnSalahHubPage extends StatelessWidget {
  const LearnSalahHubPage({super.key});

  static const List<_SalahModule> _modules = [
    _SalahModule(
      title: 'Learn Wudu',
      subtitle: 'Step-by-step purification before prayer.',
      icon: IslamicIcons.wudhu,
      routeName: 'learnWuduGuide',
    ),
    _SalahModule(
      title: 'Learn Salah',
      subtitle: 'Prayer movements, structure, and practical guidance.',
      icon: IslamicIcons.prayer,
      routeName: 'learnSectionHub',
      pathParameters: {'sectionId': 'salah-prayer'},
    ),
    _SalahModule(
      title: 'Learn Translation',
      subtitle: 'Understand what is recited in each part of salah.',
      icon: Icons.translate_rounded,
      routeName: 'learnSectionHub',
      pathParameters: {'sectionId': 'salah-translation'},
    ),
    _SalahModule(
      title: 'Salah Times & Adhan',
      subtitle: 'View prayer windows, reminders, and daily schedule.',
      icon: Icons.schedule_rounded,
      routeName: 'salahTimes',
    ),
    _SalahModule(
      title: 'Khushu and Focus',
      subtitle: 'Build concentration and presence in prayer.',
      icon: Icons.self_improvement_rounded,
      routeName: 'khusuFocus',
    ),
    _SalahModule(
      title: 'Common Mistakes',
      subtitle: 'Review frequent errors and how to correct them.',
      icon: Icons.fact_check_rounded,
      routeName: 'learnSectionHub',
      pathParameters: {'sectionId': 'salah-common-mistakes'},
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LearnHubPageScaffold(
      headerIcon: IslamicIcons.prayer,
      title: 'Salah',
      subtitle: 'Build prayer from foundations to focused consistency.',
      children: [
        const LearnSectionHeader(
          title: 'Salah Learning',
          subtitle:
              'Start with wudu and prayer basics, then deepen understanding and focus.',
        ),
        const SizedBox(height: 10),
        ..._modules.map(
          (module) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: PremiumCard(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(module.icon, color: const Color(0xFF5C4A3B)),
                title: Text(module.title),
                subtitle: Text(module.subtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.pushNamed(
                  module.routeName,
                  pathParameters: module.pathParameters,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SalahModule {
  const _SalahModule({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.routeName,
    this.pathParameters = const {},
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String routeName;
  final Map<String, String> pathParameters;
}
