import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/arabic_text_utils.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../../application/hadith_narrator_repository.dart';
import '../../domain/hadith_foundation_models.dart';
import '../hadith_reader_metadata.dart';

class HadithContentBlock extends StatelessWidget {
  const HadithContentBlock({
    super.key,
    required this.entry,
    this.compact = false,
    this.showUnavailablePlaceholders = false,
    this.wrapInCard = true,
    this.showArabic = true,
    this.showTransliteration = true,
    this.showTranslation = true,
    this.onTapSource,
    this.onTapChapter,
    this.onTapGrade,
    this.onTapNarrator,
    this.onTapProvenance,
    this.chapterSupportingText,
  });

  final HadithEntry entry;
  final bool compact;
  final bool showUnavailablePlaceholders;
  final bool wrapInCard;
  final bool showArabic;
  final bool showTransliteration;
  final bool showTranslation;
  final VoidCallback? onTapSource;
  final VoidCallback? onTapChapter;
  final VoidCallback? onTapGrade;
  final VoidCallback? onTapNarrator;
  final VoidCallback? onTapProvenance;
  final String? chapterSupportingText;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final arabicText = (entry.arabicMatn ?? '').trim();
    final transliteration = (entry.transliteratedText ?? '').trim();
    final translation = entry.translation.trim();
    final narrator = (resolveHadithNarratorDisplayName(entry.narrator) ?? '')
        .trim();
    final formattedReference = formatHadithReferenceForDisplay(l10n, entry);
    final formattedChapter = formatHadithSourceChapterForDisplay(l10n, entry);
    final provenance = formatHadithSourceProvenanceForDisplay(l10n, entry);
    final importSource = formatHadithImportSourceForDisplay(l10n, entry);
    final showArabicSection =
        showArabic && (arabicText.isNotEmpty || showUnavailablePlaceholders);
    final showTransliterationSection =
        showTransliteration &&
        (entry.hasVerifiedTransliteration ||
            (showUnavailablePlaceholders && transliteration.isEmpty));
    final showTranslationSection = showTranslation;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        if (showTranslationSection) ...[
          _sectionLabel(context, l10n.hadithTranslationLabel),
          const SizedBox(height: 6),
          Text(translation),
          const SizedBox(height: 14),
        ],
        _metadataPanel(
          context,
          items: [
            _HadithMetadataItem(
              label: l10n.hadithSourceLabel,
              value: entry.displaySourceCollectionTitle,
              onTap: onTapSource,
            ),
            if (formattedChapter.isNotEmpty)
              _HadithMetadataItem(
                label: l10n.hadithSourceChapterLabel,
                value: formattedChapter,
                supportingText: chapterSupportingText,
                onTap: onTapChapter,
              ),
            _HadithMetadataItem(
              label: l10n.hadithReferenceLabel,
              value: formattedReference,
            ),
            _HadithMetadataItem(
              label: l10n.hadithGradeShortLabel,
              value: entry.standardizedGrade.displayLabel,
              onTap: onTapGrade,
            ),
            if (narrator.isNotEmpty)
              _HadithMetadataItem(
                label: l10n.hadithNarratorLabel,
                value: narrator,
                onTap: onTapNarrator,
              ),
            _HadithMetadataItem(
              label: l10n.hadithProvenanceLabel,
              value: provenance,
              supportingText: importSource,
              onTap: onTapProvenance,
            ),
          ],
        ),
      ],
    );
    if (!wrapInCard) return content;
    return PremiumCard(child: content);
  }

  Widget _metadataPanel(
    BuildContext context, {
    required List<_HadithMetadataItem> items,
  }) {
    final visibleItems = items
        .where((item) => item.value.trim().isNotEmpty)
        .toList(growable: false);
    return Column(
      children: [
        for (var index = 0; index < visibleItems.length; index++) ...[
          _metadataRow(context, visibleItems[index]),
          if (index != visibleItems.length - 1) const SizedBox(height: 10),
        ],
      ],
    );
  }

  Widget _metadataRow(BuildContext context, _HadithMetadataItem item) {
    final content = Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.onSurfaceSubtle.withValues(alpha: 0.16),
        ),
      ),
      child: Column(
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
          if ((item.supportingText ?? '').trim().isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              item.supportingText!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.onSurfaceSubtle,
              ),
            ),
          ],
        ],
      ),
    );
    if (item.onTap == null) return content;
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(18),
      child: content,
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
  const _HadithMetadataItem({
    required this.label,
    required this.value,
    this.supportingText,
    this.onTap,
  });

  final String label;
  final String value;
  final String? supportingText;
  final VoidCallback? onTap;
}
