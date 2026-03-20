import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

class HelpGuideEntry {
  const HelpGuideEntry({
    required this.id,
    required this.title,
    required this.description,
    required this.steps,
    required this.icon,
    required this.color,
    required this.accentColor,
  });

  final String id;
  final String title;
  final String description;
  final List<String> steps;
  final IconData icon;
  final Color color;
  final Color accentColor;

  bool matchesQuery(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return true;
    return <String>[
      title,
      description,
      ...steps,
    ].join(' ').toLowerCase().contains(normalized);
  }
}

List<HelpGuideEntry> buildHelpGuideEntries(AppLocalizations l10n) {
  return <HelpGuideEntry>[
    HelpGuideEntry(
      id: 'getting-started',
      title: l10n.helpGuideGettingStartedTitle,
      description: l10n.helpGuideGettingStartedDescription,
      steps: <String>[
        l10n.helpGuideGettingStartedStep1,
        l10n.helpGuideGettingStartedStep2,
        l10n.helpGuideGettingStartedStep3,
      ],
      icon: Icons.play_circle_outline_rounded,
      color: const Color(0xFFE8ECE2),
      accentColor: const Color(0xFF5F7147),
    ),
    HelpGuideEntry(
      id: 'salah-reminders',
      title: l10n.helpGuideSalahRemindersTitle,
      description: l10n.helpGuideSalahRemindersDescription,
      steps: <String>[
        l10n.helpGuideSalahRemindersStep1,
        l10n.helpGuideSalahRemindersStep2,
        l10n.helpGuideSalahRemindersStep3,
      ],
      icon: Icons.notifications_active_outlined,
      color: const Color(0xFFF0E4D8),
      accentColor: const Color(0xFF835E42),
    ),
    HelpGuideEntry(
      id: 'quran',
      title: l10n.helpGuideQuranTitle,
      description: l10n.helpGuideQuranDescription,
      steps: <String>[
        l10n.helpGuideQuranStep1,
        l10n.helpGuideQuranStep2,
        l10n.helpGuideQuranStep3,
      ],
      icon: Icons.menu_book_outlined,
      color: const Color(0xFFE4EBF3),
      accentColor: const Color(0xFF496582),
    ),
    HelpGuideEntry(
      id: 'learning',
      title: l10n.helpGuideLearningTitle,
      description: l10n.helpGuideLearningDescription,
      steps: <String>[
        l10n.helpGuideLearningStep1,
        l10n.helpGuideLearningStep2,
        l10n.helpGuideLearningStep3,
      ],
      icon: Icons.school_outlined,
      color: const Color(0xFFE9E0EB),
      accentColor: const Color(0xFF755C7C),
    ),
    HelpGuideEntry(
      id: 'dhikr-adhkar',
      title: l10n.helpGuideDhikrAdhkarTitle,
      description: l10n.helpGuideDhikrAdhkarDescription,
      steps: <String>[
        l10n.helpGuideDhikrAdhkarStep1,
        l10n.helpGuideDhikrAdhkarStep2,
        l10n.helpGuideDhikrAdhkarStep3,
      ],
      icon: Icons.spa_outlined,
      color: const Color(0xFFE5EFE9),
      accentColor: const Color(0xFF4F6B59),
    ),
    HelpGuideEntry(
      id: 'growth-progress',
      title: l10n.helpGuideGrowthProgressTitle,
      description: l10n.helpGuideGrowthProgressDescription,
      steps: <String>[
        l10n.helpGuideGrowthProgressStep1,
        l10n.helpGuideGrowthProgressStep2,
        l10n.helpGuideGrowthProgressStep3,
      ],
      icon: Icons.trending_up_rounded,
      color: const Color(0xFFE5E7F5),
      accentColor: const Color(0xFF4E5B8C),
    ),
    HelpGuideEntry(
      id: 'notifications-settings',
      title: l10n.helpGuideNotificationsSettingsTitle,
      description: l10n.helpGuideNotificationsSettingsDescription,
      steps: <String>[
        l10n.helpGuideNotificationsSettingsStep1,
        l10n.helpGuideNotificationsSettingsStep2,
        l10n.helpGuideNotificationsSettingsStep3,
      ],
      icon: Icons.tune_rounded,
      color: const Color(0xFFEFE7DE),
      accentColor: const Color(0xFF6D5740),
    ),
  ];
}

HelpGuideEntry? findHelpGuideEntry(AppLocalizations l10n, String id) {
  for (final entry in buildHelpGuideEntries(l10n)) {
    if (entry.id == id) return entry;
  }
  return null;
}
