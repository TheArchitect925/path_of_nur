import '../domain/quran_content_refs.dart';
import 'quran_audio_repository.dart';
import 'quran_repository.dart';
import 'quran_transliteration_repository.dart';

abstract class QuranContentRepository {
  Future<QuranQuoteContent> loadQuoteContent({
    required QuranQuoteRef ref,
    required String translationCode,
  });

  Future<String> resolveAudioSource(QuranAudioRef ref);

  QuranReciter reciterById(String reciterId);

  Uri sampleAudioUri(String reciterId);
}

class DefaultQuranContentRepository implements QuranContentRepository {
  DefaultQuranContentRepository({
    required QuranRepository quranRepository,
    required QuranAudioRepository audioRepository,
    required QuranTransliterationRepository transliterationRepository,
  }) : _quranRepository = quranRepository,
       _audioRepository = audioRepository,
       _transliterationRepository = transliterationRepository;

  final QuranRepository _quranRepository;
  final QuranAudioRepository _audioRepository;
  final QuranTransliterationRepository _transliterationRepository;

  @override
  Future<QuranQuoteContent> loadQuoteContent({
    required QuranQuoteRef ref,
    required String translationCode,
  }) async {
    final ayahs = _quranRepository.getAyahsForSurah(
      ref.surah,
      translationCode: translationCode,
    );
    final transliterationRows = await _transliterationRepository
        .getSurahTransliteration(ref.surah);
    final endAyah = ref.ayahEnd ?? ref.ayah;
    final selected = ayahs
        .where(
          (ayah) => ayah.ayahNumber >= ref.ayah && ayah.ayahNumber <= endAyah,
        )
        .toList(growable: false);
    if (selected.isEmpty) {
      throw StateError('No Qur’an content found for ${ref.locationLabel}.');
    }
    final arabic = selected.map((item) => item.arabic.trim()).join(' ').trim();
    final translation = selected
        .map((item) => item.translation.trim())
        .join(' ')
        .trim();
    final transliteration = selected
        .map((item) {
          final index = item.ayahNumber - 1;
          if (index < 0 || index >= transliterationRows.length) {
            return '';
          }
          return transliterationRows[index].trim();
        })
        .where((item) => item.isNotEmpty)
        .join(' ')
        .trim();
    return QuranQuoteContent(
      ref: ref,
      arabic: arabic,
      transliteration: transliteration,
      translation: translation,
    );
  }

  @override
  Future<String> resolveAudioSource(QuranAudioRef ref) {
    return _audioRepository.resolveAyahSource(
      reciterId: ref.reciterId,
      surahNumber: ref.surah,
      ayahNumber: ref.ayah,
    );
  }

  @override
  QuranReciter reciterById(String reciterId) {
    return _audioRepository.reciterById(reciterId);
  }

  @override
  Uri sampleAudioUri(String reciterId) {
    return _audioRepository.sampleUri(reciterId);
  }
}
