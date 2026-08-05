import 'package:flutter/material.dart';

import '../../features/learn/quran/domain/quran_content_refs.dart';
import '../widgets/quran_quote_block.dart';
import 'contextual_quran_quotes.dart';

const List<QuranQuote> _messengerGuidanceQuotePool = <QuranQuote>[
  QuranQuote(ref: QuranQuoteRef(surah: 4, ayah: 80)),
  QuranQuote(ref: QuranQuoteRef(surah: 59, ayah: 7)),
  QuranQuote(ref: QuranQuoteRef(surah: 33, ayah: 21)),
  QuranQuote(ref: QuranQuoteRef(surah: 53, ayah: 3, ayahEnd: 4)),
  QuranQuote(ref: QuranQuoteRef(surah: 16, ayah: 44)),
];

int _messengerGuidanceQuoteCursor = -1;

QuranQuote buildLearningCompactQuote() {
  return buildContextualQuranQuote(ContextualQuranQuoteKey.learnGeneral);
}

QuranQuote buildMessengerGuidanceQuoteForAccess() {
  _messengerGuidanceQuoteCursor =
      (_messengerGuidanceQuoteCursor + 1) % _messengerGuidanceQuotePool.length;
  return _messengerGuidanceQuotePool[_messengerGuidanceQuoteCursor];
}

QuranQuote buildProphetStoriesQuote() {
  return buildContextualQuranQuote(ContextualQuranQuoteKey.prophetStories);
}

QuranQuote buildGrowthReflectionQuote() {
  return buildContextualQuranQuote(ContextualQuranQuoteKey.growthReflection);
}

class LearningHubRabbiZidniIlmaHeader extends StatelessWidget {
  const LearningHubRabbiZidniIlmaHeader({super.key, this.center = true});

  static const _sourceRef = QuranQuoteRef(surah: 20, ayah: 114);
  static const _fallbackPhrase = 'Rabbi zidni ilma';
  static const _fallbackTranslation = 'My Lord, increase me in knowledge.';
  final bool center;

  @override
  Widget build(BuildContext context) {
    return QuranQuoteBlock(
      quote: QuranQuote(ref: _sourceRef),
      compact: true,
      center: center,
      showReference: false,
      arabicTransform: _extractArabicPhrase,
      transliterationTransform: _extractPhrase,
      translationTransform: _extractTranslationPhrase,
    );
  }

  // The "Rabbi zidni ilma" phrase is the final three words of 20:114; slice
  // it positionally so no Quran Arabic is hardcoded in this file.
  static String _extractArabicPhrase(String arabic) {
    final words = arabic
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList(growable: false);
    if (words.length < 3) {
      return arabic.trim();
    }
    return words.sublist(words.length - 3).join(' ');
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
