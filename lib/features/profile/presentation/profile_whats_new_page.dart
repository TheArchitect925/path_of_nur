import 'package:flutter/material.dart';

import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../../../shared/widgets/section_title.dart';

class ProfileWhatsNewPage extends StatefulWidget {
  const ProfileWhatsNewPage({super.key});

  @override
  State<ProfileWhatsNewPage> createState() => _ProfileWhatsNewPageState();
}

class _ProfileWhatsNewPageState extends State<ProfileWhatsNewPage> {
  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      headerIcon: Icons.new_releases_outlined,
      title: 'What’s new',
      subtitle: 'Recent changes to Path of Nūr, with the latest updates first.',
      children: [
        const SectionTitle(
          title: 'Changelog',
          subtitle:
              'The newest update opens first. Older updates stay collapsed until you expand them.',
        ),
        ...List.generate(
          _entries.length,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: index == _entries.length - 1 ? 0 : 14),
            child: _WhatsNewEntryCard(
              entry: _entries[index],
              initiallyExpanded: index == 0,
            ),
          ),
        ),
      ],
    );
  }
}

class _WhatsNewEntryCard extends StatelessWidget {
  const _WhatsNewEntryCard({
    required this.entry,
    required this.initiallyExpanded,
  });

  final _WhatsNewEntry entry;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PremiumCard(
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          childrenPadding: EdgeInsets.zero,
          initiallyExpanded: initiallyExpanded,
          title: Text(
            entry.title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          subtitle: Text('${entry.version} • ${entry.dateLabel}'),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  entry.summary,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
                ),
              ),
            ),
            ...entry.items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 7),
                      child: Icon(Icons.circle, size: 6),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item,
                        style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WhatsNewEntry {
  const _WhatsNewEntry({
    required this.version,
    required this.dateLabel,
    required this.title,
    required this.summary,
    required this.items,
  });

  final String version;
  final String dateLabel;
  final String title;
  final String summary;
  final List<String> items;
}

const List<_WhatsNewEntry> _entries = [
  _WhatsNewEntry(
    version: '1.1.3',
    dateLabel: 'March 2026',
    title: 'Refined onboarding, motion, and prayer widgets',
    summary:
        'This update tightened early app setup, smoothed page transitions, and made prayer widgets calmer and more controlled.',
    items: [
      'Merged name and Brother/Sister selection into one onboarding step and left the name blank by default.',
      'Made habit tracking optional at the start so users can opt in later at their own pace.',
      'Applied subtle page entrance animation across shared pages and onboarding, with full respect for Reduce Motion.',
      'Removed second-by-second prayer Live Activity countdowns and added separate stable controls for Dynamic Island and lock screen widgets.',
      'Simplified theme mode so the calm Path of Nūr look is the default theme.',
    ],
  ),
  _WhatsNewEntry(
    version: '1.1.2',
    dateLabel: 'March 2026',
    title: 'Trusted-source Qur’anic Arabic improvements',
    summary:
        'The Learn Qur’anic Arabic content now uses stricter source handling so visible Qur’anic examples are more traceable and consistent.',
    items: [
      'Audited letters, word examples, phrase lessons, and rule examples to use trusted Qur’anic references where appropriate.',
      'Added source references directly into the lesson flow so examples can be traced back clearly.',
      'Source-locked the seeded 100-word Qur’anic Arabic dataset so future additions require source metadata.',
    ],
  ),
  _WhatsNewEntry(
    version: '1.1.1',
    dateLabel: 'March 2026',
    title: 'Islamic Trivia and Knowledge Paths',
    summary:
        'Trivia expanded into a fuller learning feature with structured question packs and guided topic journeys.',
    items: [
      'Added Islamic Trivia with category-based questions, review flow, daily quiz behavior, stats, and rewards integration.',
      'Introduced Knowledge Paths for guided learning journeys with short learning cards and staged quizzes.',
      'Expanded curated trivia packs for Prophets, Qur’an Basics, Salah, Ramadan, Duʿā, Seerah, and Islamic History.',
    ],
  ),
  _WhatsNewEntry(
    version: '1.1.0',
    dateLabel: 'February 2026',
    title: 'Smarter Qur’anic Arabic practice',
    summary:
        'Qur’anic Arabic learning became more adaptive, with more meaningful review and guidance across the teaching flow.',
    items: [
      'Added a Smart Daily Review system with spaced review and adaptive weak-area targeting.',
      'Introduced memory-strength tracking, review history, and calmer progress visibility on the teaching dashboard.',
      'Moved Learn Qur’anic Arabic into its own dedicated Learn destination for easier discovery.',
    ],
  ),
];
