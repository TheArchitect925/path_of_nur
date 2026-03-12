import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/seeded_prophet_detail_content.dart';
import '../domain/prophet_detail_content.dart';
import '../domain/prophet_entry.dart';

abstract class ProphetDetailRepository {
  const ProphetDetailRepository();

  ProphetDetailContent forProphet(ProphetEntry prophet);
}

class SeededProphetDetailRepository extends ProphetDetailRepository {
  const SeededProphetDetailRepository();

  @override
  ProphetDetailContent forProphet(ProphetEntry prophet) {
    for (final item in seededProphetDetailContent) {
      if (item.prophetId == prophet.id) return item;
    }

    return ProphetDetailContent(
      prophetId: prophet.id,
      name: prophet.name,
      arabicName: prophet.arabicName,
      eraTitle: prophet.eraTitle,
      regionLabel: prophet.regionLabel,
      shortSummary: prophet.shortSummary,
      overview: prophet.overview,
      storySections: [
        ProphetStorySection(
          title: 'Story Summary',
          content: prophet.storySummary,
        ),
      ],
      keyLessons: prophet.keyLessons
          .map(
            (lesson) => ProphetLesson(
              title: _lessonTitleFromText(lesson),
              description: lesson,
            ),
          )
          .toList(),
      quranReferences: prophet.quranReferences.map(_parseReference).toList(),
      reflectionPrompts: [
        'Which quality from ${prophet.name} can you carry into this week?',
        'What one step can help your worship feel more sincere today?',
        'Where can you return gently to Allah with intention and gratitude?',
      ],
      relatedProphetIds: const [],
      relatedLifeLessonIds: const [],
      relatedGrowthHabitIds: const [],
      locationLabel: prophet.locationLabel,
      locationConfidence: prophet.locationConfidence,
    );
  }

  QuranReferenceItem _parseReference(String raw) {
    final normalized = raw.trim();
    final parts = normalized.split(':');
    final surahNumber = parts.isNotEmpty
        ? int.tryParse(parts.first.trim()) ?? 1
        : 1;
    final verseRange = parts.length > 1
        ? parts.sublist(1).join(':').trim()
        : '';
    final startAyah = int.tryParse(verseRange.split('-').first.trim());
    return QuranReferenceItem(
      surahName: _surahLabel(surahNumber),
      surahNumber: surahNumber,
      verseRange: verseRange.isEmpty ? '-' : verseRange,
      startAyah: startAyah,
    );
  }

  String _surahLabel(int surahNumber) {
    switch (surahNumber) {
      case 2:
        return 'Al-Baqarah';
      case 6:
        return 'Al-An\'am';
      case 7:
        return 'Al-A\'raf';
      case 10:
        return 'Yunus';
      case 11:
        return 'Hud';
      case 12:
        return 'Yusuf';
      case 14:
        return 'Ibrahim';
      case 19:
        return 'Maryam';
      case 20:
        return 'Ta-Ha';
      case 21:
        return 'Al-Anbiya';
      case 26:
        return 'Ash-Shu\'ara';
      case 28:
        return 'Al-Qasas';
      case 33:
        return 'Al-Ahzab';
      case 37:
        return 'As-Saffat';
      case 38:
        return 'Sad';
      case 40:
        return 'Ghafir';
      case 46:
        return 'Al-Ahqaf';
      case 48:
        return 'Al-Fath';
      case 54:
        return 'Al-Qamar';
      case 71:
        return 'Nuh';
      case 91:
        return 'Ash-Shams';
      default:
        return 'Surah $surahNumber';
    }
  }

  String _lessonTitleFromText(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return 'Lesson';
    final sentence = trimmed.split('.').first.trim();
    if (sentence.length <= 36) return sentence;
    final words = sentence.split(' ');
    if (words.length <= 4) return sentence;
    return words.take(4).join(' ');
  }
}

final prophetDetailRepositoryProvider = Provider<ProphetDetailRepository>((
  ref,
) {
  return const SeededProphetDetailRepository();
});
