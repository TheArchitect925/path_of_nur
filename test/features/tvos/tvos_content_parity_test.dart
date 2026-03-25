import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_providers.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_daily_verse.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_surah.dart';
import 'package:path_of_nur/features/tvos/application/tvos_content_parity.dart';
import 'package:path_of_nur/features/tvos/domain/tvos_parity_payload_models.dart';
import 'package:path_of_nur/shared/application/app_summary_providers.dart';
import 'package:path_of_nur/features/worship/domain/fasting_status.dart';

void main() {
  group('buildTVOSHomeParityPayload', () {
    test('maps shared worship, continue-reading, and daily-verse data', () {
      final payload = buildTVOSHomeParityPayload(
        worshipSummary: const WorshipSummary(
          prayerCompleted: 3,
          prayerTotal: 5,
          prayerProgress: 0.6,
          dhikrCount: 120,
          dhikrTarget: 500,
          dhikrProgress: 0.24,
          fastingStatus: FastingStatus.notFasting,
          khusuQuickReady: true,
        ),
        continueReading: const QuranContinueReadingSummary(
          surahNumber: 2,
          surahName: 'Al-Baqarah',
          ayahNumber: 255,
          locationLabel: 'Al-Baqarah 2:255',
        ),
        dailyVerse: const TVOSDailyVerseParityPayload(
          surahNumber: 39,
          ayahNumber: 53,
          arabic: 'قُلْ يَا عِبَادِيَ',
          translation: 'Say, O My servants.',
          transliteration: 'Qul ya ibadiya',
          locationLabel: 'Az-Zumar 39:53',
        ),
      );

      expect(payload.routePath, '/home');
      expect(payload.prayerSummary.completed, 3);
      expect(payload.continueReading.surahName, 'Al-Baqarah');
      expect(
        payload.mirroredSections,
        contains(TVOSMirroredSectionId.homePrayerSummary),
      );
      expect(payload.toJson()['routePath'], '/home');
    });
  });

  group('buildTVOSQuranParityPayload', () {
    test('maps curated browse and active playback session from shared data', () {
      final payload = buildTVOSQuranParityPayload(
        continueReading: const QuranContinueReadingSummary(
          surahNumber: 1,
          surahName: 'Al-Fatihah',
          ayahNumber: 5,
          locationLabel: 'Al-Fatihah 1:5',
        ),
        dailyVerse: const TVOSDailyVerseParityPayload(
          surahNumber: 2,
          ayahNumber: 45,
          arabic: 'وَاسْتَعِينُوا',
          translation: 'Seek help through patience and prayer.',
          transliteration: 'Wastaeenu',
          locationLabel: 'Al-Baqarah 2:45',
        ),
        availableSurahs: const <QuranSurah>[
          QuranSurah(
            number: 1,
            arabicName: 'الفاتحة',
            transliteratedName: 'Al-Fatihah',
            englishName: 'The Opening',
            verseCount: 7,
            revelationPlace: 'Makkah',
          ),
          QuranSurah(
            number: 94,
            arabicName: 'الشرح',
            transliteratedName: 'Ash-Sharh',
            englishName: 'The Expansion',
            verseCount: 8,
            revelationPlace: 'Makkah',
          ),
          QuranSurah(
            number: 112,
            arabicName: 'الإخلاص',
            transliteratedName: 'Al-Ikhlas',
            englishName: 'Sincerity',
            verseCount: 4,
            revelationPlace: 'Makkah',
          ),
          QuranSurah(
            number: 113,
            arabicName: 'الفلق',
            transliteratedName: 'Al-Falaq',
            englishName: 'Daybreak',
            verseCount: 5,
            revelationPlace: 'Makkah',
          ),
          QuranSurah(
            number: 114,
            arabicName: 'الناس',
            transliteratedName: 'An-Nas',
            englishName: 'Mankind',
            verseCount: 6,
            revelationPlace: 'Makkah',
          ),
        ],
        recitationSession: const QuranRecitationSession(
          surahNumber: 94,
          ayahNumber: 6,
          positionSeconds: 42,
          updatedAtIso: '2026-03-25T00:00:00.000Z',
        ),
        audioEnabled: true,
      );

      expect(payload.routePath, '/quran');
      expect(payload.playback.hasActiveSession, isTrue);
      expect(payload.playback.resumeSurahNumber, 94);
      expect(payload.playback.positionSeconds, 42);
      expect(payload.browseSurahs, hasLength(5));
      expect(
        payload.mirroredSections,
        contains(TVOSMirroredSectionId.quranPlayback),
      );
      expect(
        (payload.toJson()['browseSurahs'] as List<Object?>).length,
        5,
      );
    });

    test('falls back to continue-reading when playback session is absent', () {
      final payload = buildTVOSQuranParityPayload(
        continueReading: const QuranContinueReadingSummary(
          surahNumber: 112,
          surahName: 'Al-Ikhlas',
          ayahNumber: 2,
          locationLabel: 'Al-Ikhlas 112:2',
        ),
        dailyVerse: TVOSDailyVerseParityPayload.fromDailyVerse(
          const QuranDailyVerse(
            surahNumber: 112,
            ayahNumber: 1,
            arabic: 'قُلْ هُوَ اللَّهُ أَحَدٌ',
            translation: 'Say, He is Allah, the One.',
            transliteration: 'Qul huwa Allahu ahad',
            locationLabel: 'Al-Ikhlas 112:1',
          ),
        ),
        availableSurahs: const <QuranSurah>[
          QuranSurah(
            number: 112,
            arabicName: 'الإخلاص',
            transliteratedName: 'Al-Ikhlas',
            englishName: 'Sincerity',
            verseCount: 4,
            revelationPlace: 'Makkah',
          ),
        ],
        recitationSession: null,
        audioEnabled: false,
      );

      expect(payload.playback.audioEnabled, isFalse);
      expect(payload.playback.hasActiveSession, isFalse);
      expect(payload.playback.resumeSurahNumber, 112);
      expect(payload.playback.resumeAyahNumber, 2);
      expect(payload.playback.resumeSurahName, 'Al-Ikhlas');
    });
  });
}
