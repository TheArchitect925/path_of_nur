import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/quran/data/quran_word_glossary.dart';
import 'package:quran/quran.dart' as q;

void main() {
  group('normalizeQuranWordForGlossary', () {
    test('strips harakat and folds hamza carriers', () {
      expect(normalizeQuranWordForGlossary('بِسْمِ'), 'بسم');
      expect(normalizeQuranWordForGlossary('ٱللَّهِ'), 'الله');
      expect(normalizeQuranWordForGlossary('ٱلرَّحْمَٰنِ'), 'الرحمن');
    });

    test('folds the Uthmani waw-dagger spelling to plain alef', () {
      // الصلوة in the mushaf is الصلاة in plain script.
      expect(normalizeQuranWordForGlossary('ٱلصَّلَوٰةَ'), 'الصلاة');
    });
  });

  group('buildWordGlosses', () {
    test('glosses known words from real Uthmani text and drops the rest', () {
      // Al-Fatihah 1:2 — every word here is either in the hand glossary or
      // absent; there must be no filler chips either way.
      final glosses = buildWordGlosses(q.getVerse(1, 2));
      expect(glosses, isNotEmpty);
      for (final gloss in glosses) {
        expect(gloss.gloss, isNot('Contextual Quranic word'));
        expect(gloss.gloss.trim(), isNotEmpty);
        // The transliteration must never be raw Arabic echoed back.
        expect(
          gloss.transliteration == gloss.arabic,
          isFalse,
          reason: '${gloss.arabic} echoed itself as transliteration',
        );
      }
    });

    test('keeps the mushaf spelling for display', () {
      final glossary = {
        'الحمد': const QuranWordGloss(
          arabic: 'الحمد',
          gloss: 'All praise',
          transliteration: 'Al-hamd',
        ),
      };
      final glosses = buildWordGlosses(
        'ٱلْحَمْدُ لِفُلَانٍ',
        glossary: glossary,
      );
      expect(glosses, hasLength(1));
      // Display keeps the word as written in the ayah, not the bare form.
      expect(glosses.single.arabic, 'ٱلْحَمْدُ');
      expect(glosses.single.gloss, 'All praise');
    });

    test('peels attached particles to find the stem', () {
      final glossary = {
        'الله': const QuranWordGloss(
          arabic: 'الله',
          gloss: 'God',
          transliteration: 'Allah',
        ),
      };
      expect(
        buildWordGlosses('وَٱللَّهُ', glossary: glossary).single.gloss,
        'God',
      );
      expect(
        buildWordGlosses('لِلَّهِ', glossary: glossary).single.gloss,
        'God',
      );
    });

    test('an unknown word yields no chip at all', () {
      expect(buildWordGlosses('قَسْوَرَةٍ', glossary: const {}), isEmpty);
    });

    test('covers a meaningful share of a long real surah', () {
      // The point of the repair: with the curated glossary attached, common
      // words across a whole surah actually resolve. Al-Baqarah has 286
      // ayat; demand a real hit count, not a lucky one-off.
      final curated = curatedGlossaryOverrides;
      var hits = 0;
      for (var ayah = 1; ayah <= 286; ayah++) {
        hits += buildWordGlosses(q.getVerse(2, ayah), glossary: curated).length;
      }
      expect(
        hits,
        greaterThan(200),
        reason: 'normalization no longer matches the Uthmani script',
      );
    });
  });
}
