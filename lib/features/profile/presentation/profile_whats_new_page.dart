import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/display/expandable_tile.dart';
import '../../../shared/widgets/section_title.dart';

class ProfileWhatsNewPage extends StatefulWidget {
  const ProfileWhatsNewPage({super.key});

  @override
  State<ProfileWhatsNewPage> createState() => _ProfileWhatsNewPageState();
}

class _ProfileWhatsNewPageState extends State<ProfileWhatsNewPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final entries = _buildEntries(l10n);
    return AppPageScaffold(
      title: l10n.settingsWhatsNewTitle,
      subtitle: l10n.settingsWhatsNewSubtitle,
      children: [
        SectionTitle(
          title: l10n.profileWhatsNewChangelogTitle,
          subtitle: l10n.profileWhatsNewChangelogSubtitle,
        ),
        ...List.generate(
          entries.length,
          (index) => Padding(
            padding: EdgeInsets.only(
              bottom: index == entries.length - 1 ? 0 : 14,
            ),
            child: _WhatsNewEntryCard(
              entry: entries[index],
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
    // Was a Material ExpansionTile wrapped in a dividerColor override to stop
    // it drawing its own lines over the glass card.
    return ExpandableTile(
      initiallyExpanded: initiallyExpanded,
      title: Text(
        entry.title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Text('${entry.version} • ${entry.dateLabel}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              entry.summary,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
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

List<_WhatsNewEntry> _buildEntries(AppLocalizations l10n) {
  return [
    _WhatsNewEntry(
      version: '1.1.3',
      dateLabel: l10n.profileWhatsNewDateMarch2026,
      title: l10n.profileWhatsNewEntry113Title,
      summary: l10n.profileWhatsNewEntry113Summary,
      items: [
        l10n.profileWhatsNewEntry113Item1,
        l10n.profileWhatsNewEntry113Item2,
        l10n.profileWhatsNewEntry113Item3,
        l10n.profileWhatsNewEntry113Item4,
        l10n.profileWhatsNewEntry113Item5,
      ],
    ),
    _WhatsNewEntry(
      version: '1.1.2',
      dateLabel: l10n.profileWhatsNewDateMarch2026,
      title: l10n.profileWhatsNewEntry112Title,
      summary: l10n.profileWhatsNewEntry112Summary,
      items: [
        l10n.profileWhatsNewEntry112Item1,
        l10n.profileWhatsNewEntry112Item2,
        l10n.profileWhatsNewEntry112Item3,
      ],
    ),
    _WhatsNewEntry(
      version: '1.1.1',
      dateLabel: l10n.profileWhatsNewDateMarch2026,
      title: l10n.profileWhatsNewEntry111Title,
      summary: l10n.profileWhatsNewEntry111Summary,
      items: [
        l10n.profileWhatsNewEntry111Item1,
        l10n.profileWhatsNewEntry111Item2,
        l10n.profileWhatsNewEntry111Item3,
      ],
    ),
    _WhatsNewEntry(
      version: '1.1.0',
      dateLabel: l10n.profileWhatsNewDateFebruary2026,
      title: l10n.profileWhatsNewEntry110Title,
      summary: l10n.profileWhatsNewEntry110Summary,
      items: [
        l10n.profileWhatsNewEntry110Item1,
        l10n.profileWhatsNewEntry110Item2,
        l10n.profileWhatsNewEntry110Item3,
      ],
    ),
  ];
}
