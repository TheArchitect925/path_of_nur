import '../domain/quran_ayah_explanation_models.dart';

abstract class QuranAyahExplanationRepository {
  List<QuranAyahExplanationEntry> getAll();

  List<QuranAyahExplanationEntry> getExplanationsForSurah(int surahNumber);

  QuranAyahExplanationEntry? getExplanation({
    required int surahNumber,
    required int ayahNumber,
  });
}

class SeededQuranAyahExplanationRepository
    implements QuranAyahExplanationRepository {
  SeededQuranAyahExplanationRepository({
    required List<QuranAyahExplanationEntry> entries,
  }) : _entries = List<QuranAyahExplanationEntry>.unmodifiable(entries),
       _byAyahKey = Map<String, QuranAyahExplanationEntry>.unmodifiable({
         for (final entry in entries) entry.ayahKey: entry,
       }),
       _bySurahNumber = Map<int, List<QuranAyahExplanationEntry>>.unmodifiable({
         for (final surahNumber
             in entries.map((entry) => entry.surahNumber).toSet())
           surahNumber: List<QuranAyahExplanationEntry>.unmodifiable(
             entries
                 .where((entry) => entry.surahNumber == surahNumber)
                 .toList(growable: false)
               ..sort((a, b) => a.ayahNumber.compareTo(b.ayahNumber)),
           ),
       });

  final List<QuranAyahExplanationEntry> _entries;
  final Map<String, QuranAyahExplanationEntry> _byAyahKey;
  final Map<int, List<QuranAyahExplanationEntry>> _bySurahNumber;

  @override
  List<QuranAyahExplanationEntry> getAll() => _entries;

  @override
  List<QuranAyahExplanationEntry> getExplanationsForSurah(int surahNumber) {
    return _bySurahNumber[surahNumber] ?? const <QuranAyahExplanationEntry>[];
  }

  @override
  QuranAyahExplanationEntry? getExplanation({
    required int surahNumber,
    required int ayahNumber,
  }) {
    return _byAyahKey['$surahNumber:$ayahNumber'];
  }
}
