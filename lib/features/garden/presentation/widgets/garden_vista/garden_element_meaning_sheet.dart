import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/display/progress_bar.dart';
import '../../../data/garden_element_meanings.dart';
import '../../../domain/garden_scene_models.dart';
import 'garden_element_strings.dart';

/// Opens the calm detail sheet for one element of the vista: what it is,
/// why it stands in the garden, and which part of the user's practice grows
/// it. Read-only — nothing here is a reward to chase.
Future<void> showGardenElementMeaningSheet(
  BuildContext context, {
  required GardenSceneElementSpec element,
  required double dimensionScore,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => GardenElementMeaningSheet(
      element: element,
      dimensionScore: dimensionScore,
    ),
  );
}

class GardenElementMeaningSheet extends StatelessWidget {
  const GardenElementMeaningSheet({
    super.key,
    required this.element,
    required this.dimensionScore,
  });

  final GardenSceneElementSpec element;
  final double dimensionScore;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final appearance = theme.extension<AppAppearanceTheme>();
    final meaning = gardenElementMeaningFor(element.id);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final numberFormat = NumberFormat.decimalPattern(locale);
    final dimension = element.dimension;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              GardenElementStrings.title(l10n, element.id),
              style: theme.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            if (meaning != null) ...[
              const SizedBox(height: 8),
              _SourceChip(
                label: l10n.gardenElementSheetSourceLabel,
                // Ayah numerals follow the reader's locale.
                reference: meaning.ayahReference.splitMapJoin(
                  RegExp(r'\d+'),
                  onMatch: (match) =>
                      numberFormat.format(int.parse(match[0]!)),
                  onNonMatch: (text) => text,
                ),
              ),
            ],
            const SizedBox(height: 14),
            Text(
              GardenElementStrings.meaning(l10n, element.id),
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
            if (dimension != null) ...[
              const SizedBox(height: 20),
              Text(
                l10n.gardenElementSheetGrowsWithLabel,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.textTheme.bodySmall?.color,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                GardenElementStrings.dimensionTitle(l10n, dimension),
                style: theme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              ProgressBar(
                value: dimensionScore,
                color: appearance?.accent,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SourceChip extends StatelessWidget {
  const _SourceChip({required this.label, required this.reference});

  final String label;
  final String reference;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appearance = theme.extension<AppAppearanceTheme>();
    final tint = appearance?.accent ?? theme.colorScheme.primary;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tint.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Text(
          '$label $reference',
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: tint,
          ),
        ),
      ),
    );
  }
}
