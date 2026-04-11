import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/arabic_text_utils.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../../domain/hadith_foundation_models.dart';
import '../hadith_reader_metadata.dart';

class HadithContentBlock extends StatelessWidget {
  const HadithContentBlock({
    super.key,
    required this.entry,
    this.compact = false,
    this.showUnavailablePlaceholders = false,
  });

  final HadithEntry entry;
  final bool compact;
  final bool showUnavailablePlaceholders;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final arabicText = (entry.arabicMatn ?? '').trim();
    final transliteration = (entry.transliteratedText ?? '').trim();
    final translation = entry.translation.trim();
    final narrator = (entry.normalizedNarratorName ?? '').trim();
    final formattedReference = formatHadithReferenceForDisplay(l10n, entry);
    final showArabicSection =
        arabicText.isNotEmpty || showUnavailablePlaceholders;
    final showTransliterationSection =
        entry.hasVerifiedTransliteration ||
        (showUnavailablePlaceholders && transliteration.isEmpty);

    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _metadataPanel(
            context,
            items: [
              _HadithMetadataItem(
                label: l10n.hadithSourceLabel,
                value: entry.displaySourceCollectionTitle,
              ),
              _HadithMetadataItem(
                label: l10n.hadithReferenceLabel,
                value: formattedReference,
              ),
              _HadithMetadataItem(
                label: l10n.hadithGradeShortLabel,
                value: entry.standardizedGrade.displayLabel,
              ),
              if (narrator.isNotEmpty)
                _HadithMetadataItem(
                  label: l10n.hadithNarratorLabel,
                  value: narrator,
                ),
            ],
          ),
          const SizedBox(height: 14),
          if (showArabicSection) ...[
            _sectionLabel(context, l10n.hadithArabicMatnLabel),
            const SizedBox(height: 6),
            if (arabicText.isNotEmpty)
              Text(
                arabicText,
                textAlign: textAlignForContent(arabicText),
                textDirection: textDirectionForContent(arabicText),
                style: AppTextStyles.quranVerse(
                  size: compact ? 27 : 31,
                ).copyWith(height: 1.7),
              )
            else
              Text(
                l10n.hadithArabicMatnUnavailable,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            const SizedBox(height: 12),
          ],
          if (showTransliterationSection) ...[
            _sectionLabel(context, l10n.hadithTransliterationLabel),
            const SizedBox(height: 6),
            if (entry.hasVerifiedTransliteration)
              Text(
                transliteration,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
              )
            else
              Text(
                l10n.hadithTransliterationUnavailable,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            const SizedBox(height: 12),
          ],
          _sectionLabel(context, l10n.hadithTranslationLabel),
          const SizedBox(height: 6),
          Text(translation),
        ],
      ),
    );
  }

  Widget _metadataPanel(
    BuildContext context, {
    required List<_HadithMetadataItem> items,
  }) {
    final visibleItems = items.where((item) => item.value.trim().isNotEmpty);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.onSurfaceSubtle.withValues(alpha: 0.16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: visibleItems
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _metadataRow(context, item),
              ),
            )
            .toList(growable: false),
      ),
    );
  }

  Widget _metadataRow(BuildContext context, _HadithMetadataItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.onSurfaceSubtle,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          item.value,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _sectionLabel(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}

class _HadithMetadataItem {
  const _HadithMetadataItem({required this.label, required this.value});

  final String label;
  final String value;
}
