import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_text_styles.dart';
import '../../features/learn/quran/application/quran_providers.dart';
import '../../features/learn/quran/domain/quran_content_refs.dart';
import 'arabic_text_utils.dart';
import 'quran_presentation_style.dart';
import 'quran_text_span.dart';

@immutable
class QuranVerseSource {
  const QuranVerseSource({
    this.ref,
    this.referenceText,
    this.arabicText,
    this.transliteration,
    this.translation,
  }) : assert(ref != null || referenceText != null);

  final QuranQuoteRef? ref;
  final String? referenceText;
  final String? arabicText;
  final String? transliteration;
  final String? translation;

  String get displayReference =>
      (referenceText ?? ref?.locationLabel ?? 'Qur’an').trim();
}

QuranQuoteRef? tryParseQuranQuoteRef(String? raw) {
  if (raw == null) return null;
  final match = RegExp(r'(\d+):(\d+)(?:-(\d+))?').firstMatch(raw);
  if (match == null) return null;
  final surah = int.tryParse(match.group(1)!);
  final ayah = int.tryParse(match.group(2)!);
  final ayahEnd = int.tryParse(match.group(3) ?? '');
  if (surah == null || ayah == null || surah <= 0 || ayah <= 0) return null;
  if (ayahEnd != null && ayahEnd < ayah) return null;
  return QuranQuoteRef(surah: surah, ayah: ayah, ayahEnd: ayahEnd);
}

class QuranVerseContent extends ConsumerWidget {
  const QuranVerseContent({
    super.key,
    required this.source,
    this.center = true,
    this.dense = false,
    this.showReference = true,
    this.arabicBaseSize = 30,
    this.transliterationBaseSize = 13.5,
    this.translationBaseSize = 12.8,
    this.arabicTransform,
    this.transliterationTransform,
    this.translationTransform,
    this.transliterationColor,
    this.translationColor,
  });

  final QuranVerseSource source;
  final bool center;
  final bool dense;
  final bool showReference;
  final double arabicBaseSize;
  final double transliterationBaseSize;
  final double translationBaseSize;
  final String Function(String arabic)? arabicTransform;
  final String Function(String transliteration)? transliterationTransform;
  final String Function(String translation)? translationTransform;
  final Color? transliterationColor;
  final Color? translationColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(quranReaderSettingsProvider);
    final effectiveRef = source.ref ?? tryParseQuranQuoteRef(source.referenceText);
    final contentAsync = effectiveRef == null
        ? null
        : ref.watch(quranQuoteContentProvider(effectiveRef));
    final resolvedContent = contentAsync?.valueOrNull;

    final arabic = _resolveArabic(
      (resolvedContent?.arabic ?? source.arabicText ?? '').trim(),
    );
    final transliteration = _resolveTransliteration(
      (resolvedContent?.transliteration ?? source.transliteration ?? '').trim(),
    );
    final translation = _resolveTranslation(
      (resolvedContent?.translation ?? source.translation ?? '').trim(),
    );
    final reference = source.displayReference;

    final arabicScale = settings.arabicScalePercent / 100.0;
    final transliterationScale =
        settings.transliterationScalePercent / 100.0;
    final translationScale = settings.translationScalePercent / 100.0;
    final crossAxisAlignment = center
        ? CrossAxisAlignment.center
        : CrossAxisAlignment.start;
    final textAlign = center ? TextAlign.center : TextAlign.start;
    final referenceColor = QuranPresentationStyle.translucentHarakatColor(
      context,
    );

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        if (settings.showArabic && arabic.isNotEmpty)
          Builder(
            builder: (context) {
              final verseStyle = QuranPresentationStyle.translucentTextStyle(
                context,
                AppTextStyles.quranVerse(
                  size: arabicBaseSize * arabicScale,
                ).copyWith(
                  height: dense ? 1.75 : 1.85,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              );
              return Text.rich(
                buildQuranTextWithColoredHarakat(
                  arabic,
                  verseStyle,
                  harakatColor:
                      QuranPresentationStyle.translucentHarakatColor(context),
                ),
                textAlign: textAlignForContent(arabic),
                textDirection: textDirectionForContent(arabic),
                strutStyle: StrutStyle(
                  fontFamily: verseStyle.fontFamily,
                  fontSize: verseStyle.fontSize,
                  height: verseStyle.height,
                  forceStrutHeight: true,
                ),
              );
            },
          )
        else if (resolvedContent == null &&
            effectiveRef != null &&
            (contentAsync?.isLoading ?? false))
          SizedBox(
            height: dense ? 40 : 56,
            child: const Center(
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 1.8),
              ),
            ),
          ),
        if (settings.showTransliteration && transliteration.isNotEmpty) ...[
          SizedBox(height: dense ? 8 : 10),
          Text(
            transliteration,
            textAlign: textAlign,
            style: QuranPresentationStyle.quranSupportTextStyle(
              context,
              Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                    fontSize: transliterationBaseSize * transliterationScale,
                  ) ??
                  TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: transliterationBaseSize * transliterationScale,
                  ),
              italic: true,
              colorOverride: transliterationColor,
            ),
          ),
        ],
        if (settings.showTranslation && translation.isNotEmpty) ...[
          SizedBox(height: dense ? 6 : 8),
          Text(
            translation,
            textAlign: textAlign,
            style: QuranPresentationStyle.quranSupportTextStyle(
              context,
              Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: translationBaseSize * translationScale,
                    height: 1.35,
                  ) ??
                  TextStyle(
                    fontSize: translationBaseSize * translationScale,
                    height: 1.35,
                  ),
              colorOverride: translationColor,
            ),
          ),
        ],
        if (showReference && reference.isNotEmpty) ...[
          SizedBox(height: dense ? 8 : 10),
          Text(
            reference,
            textAlign: textAlign,
            style: TextStyle(
              color: referenceColor,
              fontSize: dense ? 11 : 11.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }

  String _resolveTransliteration(String value) {
    if (value.isEmpty || transliterationTransform == null) {
      return value;
    }
    return transliterationTransform!(value).trim();
  }

  String _resolveArabic(String value) {
    if (value.isEmpty || arabicTransform == null) {
      return value;
    }
    return arabicTransform!(value).trim();
  }

  String _resolveTranslation(String value) {
    if (value.isEmpty || translationTransform == null) {
      return value;
    }
    return translationTransform!(value).trim();
  }
}
