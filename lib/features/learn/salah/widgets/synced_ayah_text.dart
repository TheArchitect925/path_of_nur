import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/quran_presentation_style.dart';
import '../models/salah_trainer_models.dart';

/// How a segment sits relative to the playhead.
enum SyncedTextEmphasis { active, done, upcoming }

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
    this.emphasis = SyncedTextEmphasis.active,
    this.arabicSize = 30,
  });

  final String arabicText;
  final String transliteration;
  final String translation;
  final RecitationTimingModel timing;
  final int activeWordIndex;
  final bool showTransliteration;
  final bool showTranslation;
  final bool highlightEntireAyah;
  final SyncedTextEmphasis emphasis;
  final double arabicSize;

  @override
  Widget build(BuildContext context) {
    final words = RecitationTimingModel.splitWords(arabicText);
    final accent = context.palette.accent;
    final activeColor = accent.withValues(alpha: 0.28);
    final doneColor = accent.withValues(alpha: 0.14);
    final dim = switch (emphasis) {
      SyncedTextEmphasis.active => 1.0,
      SyncedTextEmphasis.done => 0.62,
      SyncedTextEmphasis.upcoming => 0.78,
    };

    TextStyle arabicStyle({Color background = Colors.transparent}) {
      final base = QuranPresentationStyle.translucentTextStyle(
        context,
        AppTextStyles.quranVerse(size: arabicSize),
      );
      return base.copyWith(
        color: base.color?.withValues(alpha: (base.color!.a * dim)),
        backgroundColor: background,
      );
    }

    InlineSpan arabicSpan;
    if (timing.wordTimings.isEmpty ||
        words.length != timing.wordTimings.length) {
      arabicSpan = TextSpan(
        text: arabicText,
        style: arabicStyle(
          background: highlightEntireAyah && activeWordIndex >= 0
              ? activeColor
              : Colors.transparent,
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
            style: arabicStyle(background: background),
          ),
        );
      }
      arabicSpan = TextSpan(children: spans);
    }

    final textTheme = Theme.of(context).textTheme;
    final captionBase = textTheme.bodyLarge ?? const TextStyle();
    final translationBase = textTheme.bodyMedium ?? const TextStyle();
    Color? faded(Color? color) => color?.withValues(alpha: color.a * dim);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          arabicSpan,
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
        ),
        if (showTransliteration && transliteration.trim().isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            transliteration,
            style: QuranPresentationStyle.translucentTextStyle(
              context,
              captionBase.copyWith(
                fontStyle: FontStyle.italic,
                color: faded(captionBase.color),
              ),
            ),
          ),
        ],
        if (showTranslation && translation.trim().isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            translation,
            style: QuranPresentationStyle.translucentTextStyle(
              context,
              translationBase.copyWith(color: faded(translationBase.color)),
            ),
          ),
        ],
      ],
    );
  }
}
