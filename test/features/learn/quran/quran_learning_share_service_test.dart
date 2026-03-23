import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_learning_share_service.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_content_refs.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_reflection_entry.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_surah.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_surah_insight_models.dart';

void main() {
  test('saved reflection share text excludes private note by default', () {
    const entry = QuranReflectionEntry(
      id: 'saved_1',
      ref: QuranQuoteRef(surah: 2, ayah: 152),
      sourceType: QuranReflectionSourceType.ayahInsight,
      title: 'Remember Allah',
      summary: 'Remember Allah and stay grateful.',
      note: 'This is a private note that should not be shared by default.',
      savedAtIso: '2026-03-22T00:00:00.000Z',
      updatedAtIso: '2026-03-22T00:00:00.000Z',
    );

    final text = QuranLearningShareService.buildSavedReflectionShareText(
      entry: entry,
      attribution: 'Shared from Path of Nur',
    );

    expect(text, contains('2:152'));
    expect(text, contains('Remember Allah'));
    expect(text.contains('private note that should not be shared'), isFalse);
  });

  test(
    'saved reflection share text includes only a short note excerpt when requested',
    () {
      const entry = QuranReflectionEntry(
        id: 'saved_2',
        ref: QuranQuoteRef(surah: 20, ayah: 14),
        sourceType: QuranReflectionSourceType.dailyAyah,
        title: 'Prayer helps us remember Allah',
        summary: 'Prayer keeps the heart connected to Allah.',
        note:
            'This note is intentionally long so the share output uses only a short excerpt and never dumps the full private reflection into the exported text. It keeps going with a few more thoughts about prayer, patience, and daily remembrance so the exported version must trim it carefully.',
        savedAtIso: '2026-03-22T00:00:00.000Z',
        updatedAtIso: '2026-03-22T00:00:00.000Z',
      );

      final text = QuranLearningShareService.buildSavedReflectionShareText(
        entry: entry,
        attribution: 'Shared from Path of Nur',
        noteLabel: 'Reflection note',
        includeNoteExcerpt: true,
      );

      expect(text, contains('Reflection note:'));
      expect(text, contains('...'));
      expect(text.length < 420, isTrue);
    },
  );

  test('surah insight share text includes concise summary labels', () {
    const insight = QuranResolvedSurahInsight(
      surah: QuranSurah(
        number: 1,
        transliteratedName: 'Al-Fatihah',
        arabicName: 'الفاتحة',
        englishName: 'The Opening',
        verseCount: 7,
        revelationPlace: 'Makkah',
      ),
      definition: QuranSurahInsightDefinition(
        surahNumber: 1,
        descriptionId: 'desc',
        themeIds: ['theme_a'],
        lessonIds: ['lesson_a'],
        clusters: [],
      ),
      clusters: [],
      suggestedPaths: [],
    );

    final text = QuranLearningShareService.buildSurahInsightShareText(
      insight: insight,
      description: 'A short overview of the surah.',
      themes: const ['Guidance', 'Worship'],
      lessons: const ['Turn to Allah'],
      attribution: 'Shared from Path of Nur',
      themesLabel: 'Themes',
      lessonsLabel: 'Lessons',
    );

    expect(text, contains('Al-Fatihah'));
    expect(text, contains('Themes: Guidance • Worship'));
    expect(text, contains('Lessons: Turn to Allah'));
  });
}
