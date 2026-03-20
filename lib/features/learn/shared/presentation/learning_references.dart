import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/quran_reference_link.dart';

class LearningReferenceItem {
  const LearningReferenceItem({
    required this.sourceTitle,
    this.sourceNumber,
    this.rangeOrSection,
    this.label,
    this.onTap,
  });

  final String sourceTitle;
  final int? sourceNumber;
  final String? rangeOrSection;
  final String? label;
  final VoidCallback? onTap;
}

class LearningReferences extends StatelessWidget {
  const LearningReferences({
    super.key,
    required this.items,
    this.expandable = false,
    this.expanded = false,
    this.onToggleExpanded,
  });

  final List<LearningReferenceItem> items;
  final bool expandable;
  final bool expanded;
  final VoidCallback? onToggleExpanded;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    final visibleItems = expandable && !expanded && items.length > 3
        ? items.take(3).toList(growable: false)
        : items;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...visibleItems.map((item) => _ReferenceTile(item: item)),
        if (expandable && items.length > 3)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: onToggleExpanded,
              icon: Icon(
                expanded
                    ? Icons.unfold_less_rounded
                    : Icons.unfold_more_rounded,
              ),
              label: Text(
                expanded
                    ? l10n.learningReferencesShowLess
                    : l10n.learningReferencesShowAll,
              ),
            ),
          ),
      ],
    );
  }
}

class _ReferenceTile extends StatelessWidget {
  const _ReferenceTile({required this.item});

  final LearningReferenceItem item;

  @override
  Widget build(BuildContext context) {
    final titleSegments = <String>[item.sourceTitle];
    if (item.sourceNumber != null) {
      titleSegments.add(item.sourceNumber.toString());
    }
    if (item.rangeOrSection != null && item.rangeOrSection!.trim().isNotEmpty) {
      titleSegments.add(item.rangeOrSection!);
    }

    return QuranReferenceLinkTile(
      referenceLabel: titleSegments.join(' • '),
      surahNumber: item.sourceNumber ?? 1,
      verseRange: item.rangeOrSection,
      subtitle: item.label,
      onTapOverride: item.onTap,
    );
  }
}
