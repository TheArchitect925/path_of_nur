import 'package:flutter/material.dart';

import '../../../../shared/widgets/premium_card.dart';
import '../../prophets/domain/prophets_tab.dart';
import '../../prophets/presentation/prophets_page.dart';
import '../data/learn_category_catalog.dart';
import '../data/learn_icon_registry.dart';
import '../widgets/learn_hub_page_scaffold.dart';
import '../widgets/learn_section_header.dart';

class LearnSectionPlaceholderPage extends StatelessWidget {
  const LearnSectionPlaceholderPage({
    super.key,
    required this.sectionId,
    this.initialProphetsTab,
    this.initialProphetId,
  });

  final String sectionId;
  final ProphetsTab? initialProphetsTab;
  final String? initialProphetId;

  @override
  Widget build(BuildContext context) {
    if (sectionId == 'prophets') {
      return ProphetsPage(
        initialTab: initialProphetsTab,
        initialProphetId: initialProphetId,
      );
    }

    final item = LearnCategoryCatalog.byId(sectionId);
    final title = item?.title ?? 'Learning Section';

    return LearnHubPageScaffold(
      headerIcon: LearnIconRegistry.iconFor(item?.iconKey ?? 'other'),
      title: title,
      subtitle:
          'This section is being prepared. Explore available resources meanwhile.',
      children: [
        LearnSectionHeader(
          title: 'Coming Soon',
          subtitle: 'Detailed modules for $title will appear here.',
        ),
        const SizedBox(height: 10),
        PremiumCard(
          child: Text(
            'This area uses the new hub structure and is ready to expand without layout refactors.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
