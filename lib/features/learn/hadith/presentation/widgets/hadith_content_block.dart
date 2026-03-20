import 'package:flutter/material.dart';

import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../shared/widgets/arabic_text_utils.dart';
import '../../../../../shared/widgets/premium_card.dart';
import '../../domain/hadith_foundation_models.dart';

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
    final sectionSpacing = compact ? 8.0 : 12.0;
    final arabicText = (entry.arabicMatn ?? '').trim();
    final transliteration = (entry.transliteratedText ?? '').trim();
    final translation = entry.translation.trim();
    final showArabicSection =
        arabicText.isNotEmpty || showUnavailablePlaceholders;
    final showTransliterationSection =
        entry.hasVerifiedTransliteration ||
        (showUnavailablePlaceholders && transliteration.isEmpty);

    return PremiumCard(
      child: Column(
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
          _sectionLabel(context, l10n.hadithTranslationLabel),
          const SizedBox(height: 6),
          Text(translation),
          const SizedBox(height: 12),
          _sectionLabel(context, l10n.hadithReferenceLabel),
          const SizedBox(height: 6),
          Text(
            entry.sourceLabel,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          if (entry.grading.trim().isNotEmpty) ...[
            SizedBox(height: sectionSpacing),
            Text(entry.grading, style: Theme.of(context).textTheme.bodySmall),
          ],
        ],
      ),
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
