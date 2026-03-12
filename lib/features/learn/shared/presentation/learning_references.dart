import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';

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
              label: Text(expanded ? 'Show less' : 'Show all references'),
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

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: item.onTap ?? () => _openQuranAnchor(context),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.accentGoldSoft.withValues(alpha: 0.28),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titleSegments.join(' • '),
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              if (item.label != null && item.label!.trim().isNotEmpty) ...[
                const SizedBox(height: 3),
                Text(item.label!),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _openQuranAnchor(BuildContext context) {
    final surahNumber = item.sourceNumber;
    if (surahNumber == null || surahNumber <= 0) return;
    final (startAyah, endAyah) = _parseAyahRange(item.rangeOrSection);
    final queryParameters = <String, String>{};
    if (startAyah != null && startAyah > 0) {
      queryParameters['ayah'] = '$startAyah';
    }
    if (endAyah != null && endAyah > 0 && endAyah >= (startAyah ?? endAyah)) {
      queryParameters['endAyah'] = '$endAyah';
    }
    context.pushNamed(
      'quranReader',
      pathParameters: {'surahNumber': '$surahNumber'},
      queryParameters: queryParameters,
    );
  }

  (int?, int?) _parseAyahRange(String? range) {
    final value = (range ?? '')
        .replaceAll('–', '-')
        .replaceAll('—', '-')
        .trim();
    if (value.isEmpty) return (null, null);
    final firstChunk = value.split(',').first.trim();
    if (firstChunk.isEmpty) return (null, null);
    if (firstChunk.contains(':')) {
      final ayahPart = firstChunk.split(':').last.trim();
      return _parseAyahRange(ayahPart);
    }
    if (!firstChunk.contains('-')) {
      final single = int.tryParse(firstChunk);
      return (single, single);
    }
    final parts = firstChunk.split('-');
    final start = int.tryParse(parts.first.trim());
    final end = parts.length > 1 ? int.tryParse(parts[1].trim()) : null;
    return (start, end ?? start);
  }
}
