import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/application/app_summary_providers.dart';
import '../../learn/quran/application/quran_providers.dart';
import '../../learn/quran/domain/quran_surah.dart';
import '../data/tvos_content_parity_manifest.dart';
import '../domain/tvos_parity_payload_models.dart';

TVOSHomeParityPayload buildTVOSHomeParityPayload({
  required WorshipSummary worshipSummary,
  required QuranContinueReadingSummary continueReading,
  required TVOSDailyVerseParityPayload dailyVerse,
}) {
  return TVOSHomeParityPayload(
    routePath: '/home',
    prayerSummary: TVOSPrayerSummaryParityPayload.fromWorshipSummary(
      worshipSummary,
    ),
    continueReading: TVOSContinueReadingParityPayload.fromSummary(
      continueReading,
    ),
    dailyVerse: dailyVerse,
    mirroredSections: const <TVOSMirroredSectionId>[
      TVOSMirroredSectionId.homePrayerSummary,
      TVOSMirroredSectionId.homeContinueReading,
      TVOSMirroredSectionId.homeDailyVerse,
    ],
  );
}

TVOSQuranParityPayload buildTVOSQuranParityPayload({
  required QuranContinueReadingSummary continueReading,
  required TVOSDailyVerseParityPayload dailyVerse,
  required List<QuranSurah> availableSurahs,
  required QuranRecitationSession? recitationSession,
  required bool audioEnabled,
}) {
  final byNumber = <int, QuranSurah>{
    for (final surah in availableSurahs) surah.number: surah,
  };
  final curatedBrowse = tvosCuratedQuranBrowseSurahNumbers
      .map((number) => byNumber[number])
      .whereType<QuranSurah>()
      .map(TVOSBrowseSurahParityPayload.fromSurah)
      .toList(growable: false);

  final playbackSurahNumber =
      recitationSession?.surahNumber ?? continueReading.surahNumber;
  final playbackSurahName =
      byNumber[playbackSurahNumber]?.transliteratedName ??
      continueReading.surahName;

  return TVOSQuranParityPayload(
    routePath: '/quran',
    continueReading: TVOSContinueReadingParityPayload.fromSummary(
      continueReading,
    ),
    dailyVerse: dailyVerse,
    browseSurahs: curatedBrowse,
    playback: TVOSPlaybackParityPayload(
      audioEnabled: audioEnabled,
      hasActiveSession: recitationSession != null,
      resumeSurahNumber: playbackSurahNumber,
      resumeAyahNumber:
          recitationSession?.ayahNumber ?? continueReading.ayahNumber,
      resumeSurahName: playbackSurahName,
      positionSeconds: recitationSession?.positionSeconds ?? 0,
    ),
    mirroredSections: const <TVOSMirroredSectionId>[
      TVOSMirroredSectionId.quranContinueReading,
      TVOSMirroredSectionId.quranDailyVerse,
      TVOSMirroredSectionId.quranBrowse,
      TVOSMirroredSectionId.quranPlayback,
    ],
  );
}

final tvosDailyVerseParityPayloadProvider =
    Provider<TVOSDailyVerseParityPayload>((ref) {
      final dailyVerse = ref.watch(quranDailyVerseProvider);
      return TVOSDailyVerseParityPayload.fromDailyVerse(dailyVerse);
    });

final tvosHomeParityPayloadProvider = Provider<TVOSHomeParityPayload>((ref) {
  final worshipSummary = ref.watch(worshipSummaryProvider);
  final continueReading = ref.watch(quranContinueReadingSummaryProvider);
  final dailyVerse = ref.watch(tvosDailyVerseParityPayloadProvider);
  return buildTVOSHomeParityPayload(
    worshipSummary: worshipSummary,
    continueReading: continueReading,
    dailyVerse: dailyVerse,
  );
});

final tvosQuranParityPayloadProvider = Provider<TVOSQuranParityPayload>((ref) {
  final continueReading = ref.watch(quranContinueReadingSummaryProvider);
  final dailyVerse = ref.watch(tvosDailyVerseParityPayloadProvider);
  final availableSurahs = ref.watch(quranSurahListProvider);
  final recitationSession = ref.watch(quranRecitationSessionProvider);
  final audioEnabled = ref.watch(quranAudioFunctionEnabledProvider);
  return buildTVOSQuranParityPayload(
    continueReading: continueReading,
    dailyVerse: dailyVerse,
    availableSurahs: availableSurahs,
    recitationSession: recitationSession,
    audioEnabled: audioEnabled,
  );
});

final tvosParityPayloadBundleProvider = Provider<TVOSParityPayloadBundle>((
  ref,
) {
  final now = DateTime.now().toUtc().toIso8601String();
  final home = ref.watch(tvosHomeParityPayloadProvider);
  final quran = ref.watch(tvosQuranParityPayloadProvider);
  return TVOSParityPayloadBundle(generatedAtIso: now, home: home, quran: quran);
});
