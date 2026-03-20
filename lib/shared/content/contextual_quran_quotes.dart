import '../../features/learn/quran/domain/quran_content_refs.dart';
import '../widgets/quran_quote_block.dart';

enum ContextualQuranQuoteKey {
  learnGeneral,
  prophetStories,
  growthReflection,
  quranGuidance,
  foundationsTawheed,
  worshipPrayer,
  worshipDhikr,
  worshipFasting,
  worshipTracking,
  worshipReminders,
}

QuranQuote buildContextualQuranQuote(ContextualQuranQuoteKey key) {
  switch (key) {
    case ContextualQuranQuoteKey.learnGeneral:
      return const QuranQuote(ref: QuranQuoteRef(surah: 38, ayah: 29));
    case ContextualQuranQuoteKey.prophetStories:
      return const QuranQuote(ref: QuranQuoteRef(surah: 12, ayah: 111));
    case ContextualQuranQuoteKey.growthReflection:
      return const QuranQuote(ref: QuranQuoteRef(surah: 13, ayah: 11));
    case ContextualQuranQuoteKey.quranGuidance:
      return const QuranQuote(ref: QuranQuoteRef(surah: 17, ayah: 9));
    case ContextualQuranQuoteKey.foundationsTawheed:
      return const QuranQuote(ref: QuranQuoteRef(surah: 2, ayah: 255));
    case ContextualQuranQuoteKey.worshipPrayer:
      return const QuranQuote(ref: QuranQuoteRef(surah: 20, ayah: 14));
    case ContextualQuranQuoteKey.worshipDhikr:
      return const QuranQuote(ref: QuranQuoteRef(surah: 13, ayah: 28));
    case ContextualQuranQuoteKey.worshipFasting:
      return const QuranQuote(ref: QuranQuoteRef(surah: 2, ayah: 183));
    case ContextualQuranQuoteKey.worshipTracking:
      return const QuranQuote(ref: QuranQuoteRef(surah: 2, ayah: 148));
    case ContextualQuranQuoteKey.worshipReminders:
      return const QuranQuote(ref: QuranQuoteRef(surah: 2, ayah: 152));
  }
}

const List<QuranQuote> homeContextualQuotePool = <QuranQuote>[
  QuranQuote(ref: QuranQuoteRef(surah: 2, ayah: 45)),
  QuranQuote(ref: QuranQuoteRef(surah: 2, ayah: 152)),
  QuranQuote(ref: QuranQuoteRef(surah: 20, ayah: 14)),
  QuranQuote(ref: QuranQuoteRef(surah: 39, ayah: 53)),
  QuranQuote(ref: QuranQuoteRef(surah: 2, ayah: 186)),
  QuranQuote(ref: QuranQuoteRef(surah: 9, ayah: 51)),
  QuranQuote(ref: QuranQuoteRef(surah: 94, ayah: 5)),
];
