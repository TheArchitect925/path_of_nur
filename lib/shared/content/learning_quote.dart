import 'package:flutter/material.dart';

import '../../features/learn/quran/domain/quran_content_refs.dart';
import '../widgets/quran_quote_block.dart';
import 'contextual_quran_quotes.dart';

QuranQuote buildLearningCompactQuote() {
  return buildContextualQuranQuote(ContextualQuranQuoteKey.learnGeneral);
}

QuranQuote buildProphetStoriesQuote() {
  return buildContextualQuranQuote(ContextualQuranQuoteKey.prophetStories);
}

QuranQuote buildGrowthReflectionQuote() {
  return buildContextualQuranQuote(ContextualQuranQuoteKey.growthReflection);
}

class LearningHubRabbiZidniIlmaHeader extends StatelessWidget {
  const LearningHubRabbiZidniIlmaHeader({super.key});

  static const _sourceRef = QuranQuoteRef(surah: 20, ayah: 114);
  static const _fallbackArabic = 'رَبِّ زِدْنِي عِلْمًا';
  static const _fallbackPhrase = 'Rabbi zidni ilma';
  static const _fallbackTranslation = 'My Lord, increase me in knowledge.';

  @override
  Widget build(BuildContext context) {
    return const QuranQuoteBlock(
      quote: QuranQuote(ref: _sourceRef),
      compact: true,
      showReference: false,
      arabicTransform: _extractArabicPhrase,
      transliterationTransform: _extractPhrase,
      translationTransform: _extractTranslationPhrase,
    );
  }

  static String _extractArabicPhrase(String arabic) {
    if (arabic.trim().isEmpty) {
      return _fallbackArabic;
    }
    final match = RegExp(r'رَبِّ\s+زِدْنِي\s+عِلْم').firstMatch(arabic);
    if (match == null) {
      return _fallbackArabic;
    }
    return arabic.substring(match.start, match.end).trim();
  }

  static String _extractPhrase(String transliteration) {
    if (transliteration.trim().isEmpty) {
      return _fallbackPhrase;
    }
    final normalized = transliteration.replaceAll(RegExp(r"[‘’']"), '');
    final match = RegExp(
      r'(rabbi\s+zidni\s+ilman?)',
      caseSensitive: false,
    ).firstMatch(normalized);
    if (match == null) {
      return _fallbackPhrase;
    }
    final phrase = normalized.substring(match.start, match.end).trim();
    return phrase
        .replaceFirst(RegExp(r'ilman$', caseSensitive: false), 'ilma')
        .replaceFirstMapped(
          RegExp(r'^[a-z]'),
          (value) => value.group(0)!.toUpperCase(),
        );
  }

  static String _extractTranslationPhrase(String translation) {
    if (translation.trim().isEmpty) {
      return _fallbackTranslation;
    }
    final match = RegExp(
      r'(my lord,\s+increase me in knowledge\.?)',
      caseSensitive: false,
    ).firstMatch(translation);
    if (match == null) {
      return _fallbackTranslation;
    }
    final phrase = translation.substring(match.start, match.end).trim();
    return phrase.replaceFirstMapped(
      RegExp(r'^[a-z]'),
      (value) => value.group(0)!.toUpperCase(),
    );
  }
}
