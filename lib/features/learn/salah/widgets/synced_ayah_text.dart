import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/quran_presentation_style.dart';
import '../models/salah_trainer_models.dart';

class SyncedAyahText extends StatelessWidget {
  const SyncedAyahText({
    super.key,
    required this.arabicText,
    required this.transliteration,
    required this.translation,
    required this.timing,
    required this.activeWordIndex,
    this.showTransliteration = true,
    this.showTranslation = true,
    this.highlightEntireAyah = false,
  });

  final String arabicText;
  final String transliteration;
  final String translation;
  final RecitationTimingModel timing;
  final int activeWordIndex;
  final bool showTransliteration;
  final bool showTranslation;
  final bool highlightEntireAyah;

  @override
  Widget build(BuildContext context) {
    final words = arabicText
        .trim()
        .split(RegExp(r'\s+'))
        .where((item) => item.isNotEmpty)
        .toList(growable: false);
    final activeColor = Theme.of(
      context,
    ).colorScheme.primary.withValues(alpha: 0.28);
    final doneColor = Theme.of(
      context,
    ).colorScheme.primary.withValues(alpha: 0.14);

    InlineSpan arabicSpan;
    if (timing.wordTimings.isEmpty ||
        words.length != timing.wordTimings.length) {
      arabicSpan = TextSpan(
        text: arabicText,
        style: QuranPresentationStyle.translucentTextStyle(
          context,
          AppTextStyles.quranVerse(size: 30).copyWith(
            backgroundColor: highlightEntireAyah && activeWordIndex >= 0
                ? activeColor
                : Colors.transparent,
          ),
        ),
      );
    } else {
      final spans = <InlineSpan>[];
      for (var i = 0; i < words.length; i += 1) {
        Color background = Colors.transparent;
        if (i == activeWordIndex) {
          background = activeColor;
        } else if (activeWordIndex > i) {
          background = doneColor;
        }
        spans.add(
          TextSpan(
            text: '${words[i]} ',
            style: QuranPresentationStyle.translucentTextStyle(
              context,
              AppTextStyles.quranVerse(
                size: 30,
              ).copyWith(backgroundColor: background),
            ),
          ),
        );
      }
      arabicSpan = TextSpan(children: spans);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(arabicSpan, textAlign: TextAlign.right),
        if (showTransliteration && transliteration.trim().isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(
            transliteration,
            style: QuranPresentationStyle.translucentTextStyle(
              context,
              Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontStyle: FontStyle.italic,
                  ) ??
                  const TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ],
        if (showTranslation && translation.trim().isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(
            translation,
            style: QuranPresentationStyle.translucentTextStyle(
              context,
              Theme.of(context).textTheme.bodyMedium ?? const TextStyle(),
            ),
          ),
        ],
      ],
    );
  }
}
