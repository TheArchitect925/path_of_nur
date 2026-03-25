import '../domain/tvos_parity_payload_models.dart';

const List<TVOSMirroredSectionManifest> tvosMirroredSectionManifests =
    <TVOSMirroredSectionManifest>[
      TVOSMirroredSectionManifest(
        id: TVOSMirroredSectionId.homePrayerSummary,
        routePath: '/home',
        contentKey: 'home.prayerSummary',
        phaseSummary: 'Prayer-first mirrored summary for the tvOS home stage.',
      ),
      TVOSMirroredSectionManifest(
        id: TVOSMirroredSectionId.homeContinueReading,
        routePath: '/home',
        contentKey: 'home.continueReading',
        phaseSummary: 'Shared continue-reading entry surfaced from Home.',
      ),
      TVOSMirroredSectionManifest(
        id: TVOSMirroredSectionId.homeDailyVerse,
        routePath: '/home',
        contentKey: 'home.dailyVerse',
        phaseSummary: 'Daily Qur’an light preview shown from Home.',
      ),
      TVOSMirroredSectionManifest(
        id: TVOSMirroredSectionId.quranContinueReading,
        routePath: '/quran',
        contentKey: 'quran.continueReading',
        phaseSummary: 'Shared continue-reading card for the tvOS Qur’an route.',
      ),
      TVOSMirroredSectionManifest(
        id: TVOSMirroredSectionId.quranDailyVerse,
        routePath: '/quran',
        contentKey: 'quran.dailyVerse',
        phaseSummary: 'Shared daily verse card for the tvOS Qur’an route.',
      ),
      TVOSMirroredSectionManifest(
        id: TVOSMirroredSectionId.quranBrowse,
        routePath: '/quran',
        contentKey: 'quran.browse',
        phaseSummary:
            'Curated browse set built from shared Qur’an domain metadata.',
      ),
      TVOSMirroredSectionManifest(
        id: TVOSMirroredSectionId.quranPlayback,
        routePath: '/quran',
        contentKey: 'quran.playback',
        phaseSummary:
            'Playback resume/parity payload sourced from shared recitation state.',
      ),
    ];

const List<int> tvosCuratedQuranBrowseSurahNumbers = <int>[1, 94, 112, 113, 114];
