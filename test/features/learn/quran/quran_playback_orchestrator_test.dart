import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_playback_orchestrator.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_playback_policy.dart';
import 'package:path_of_nur/features/learn/quran/data/quran_audio_repository.dart';
import 'package:path_of_nur/features/learn/quran/domain/bismillah_playback_mode.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_audio_resilience_models.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_audio_source_metadata.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_content_refs.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_playback_request.dart';

class _FakeQuranAudioRepository extends QuranAudioRepository {
  _FakeQuranAudioRepository() : super(client: HttpClient());

  int resolveAyahSourceMetadataCallCount = 0;

  @override
  Future<QuranAudioSourceMetadata> resolveAyahSourceMetadata({
    required String reciterId,
    required int surahNumber,
    required int ayahNumber,
    QuranPlaybackSourceType? preferredSourceType,
  }) async {
    resolveAyahSourceMetadataCallCount += 1;
    return QuranAudioSourceMetadata(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      reciterId: reciterId,
      source: 'https://example.test/$reciterId/$surahNumber/$ayahNumber.mp3',
      sourceType: QuranPlaybackSourceType.remoteStream,
      sourceContainsBismillahAtStart: surahNumber == 1 && ayahNumber == 1,
      sourceId: QuranAudioSourceId('example.$reciterId'),
      isAyahGranular: true,
      includesBismillahInFatiha: true,
      includesBismillahAtSurahStarts: false,
      hasStandaloneBismillahClip: false,
      standaloneBismillahRef: QuranAudioRef(
        surah: 1,
        ayah: 1,
        reciterId: reciterId,
      ),
      surah9HasNoBismillahIntroInSource: false,
      notes: 'Test fixture source metadata',
      confidence: QuranAudioMetadataConfidence.unknownNeedsManualReview,
      manualReviewNeeded: true,
    );
  }

  @override
  Future<QuranAudioSourceMetadata> resolveCanonicalBismillahMetadata({
    required String reciterId,
    QuranPlaybackSourceType? preferredSourceType,
  }) async {
    return QuranAudioSourceMetadata(
      surahNumber: 1,
      ayahNumber: 1,
      reciterId: reciterId,
      source: 'https://example.test/$reciterId/bismillah.mp3',
      sourceType: QuranPlaybackSourceType.remoteStream,
      sourceContainsBismillahAtStart: true,
      sourceId: QuranAudioSourceId('example.$reciterId'),
      isAyahGranular: true,
      includesBismillahInFatiha: true,
      includesBismillahAtSurahStarts: false,
      hasStandaloneBismillahClip: false,
      standaloneBismillahRef: QuranAudioRef(
        surah: 1,
        ayah: 1,
        reciterId: reciterId,
      ),
      surah9HasNoBismillahIntroInSource: false,
      notes: 'Test fixture canonical Bismillah source',
      confidence: QuranAudioMetadataConfidence.confirmedFromCode,
      manualReviewNeeded: true,
      isStandaloneBismillah: true,
    );
  }
}

void main() {
  final repository = _FakeQuranAudioRepository();
  final orchestrator = QuranPlaybackOrchestrator(
    audioRepository: repository,
    policy: const QuranPlaybackPolicy(),
  );

  Future<QuranPreparedPlayback> prepare(
    QuranPlaybackRequest request, {
    List<int>? ayahs,
    BismillahPlaybackMode mode = BismillahPlaybackMode.alwaysPrepend,
  }) {
    return orchestrator.preparePlayback(
      request: request,
      reciterId: 'husary',
      ayahNumbers: ayahs ?? <int>[request.ayahNumber ?? 1],
      mode: mode,
    );
  }

  test('fresh play of Fatihah prepends Bismillah', () async {
    final prepared = await prepare(
      const QuranPlaybackRequest(
        surahNumber: 1,
        ayahNumber: 1,
        playbackReason: QuranPlaybackReason.freshPlay,
      ),
      ayahs: const <int>[1, 2, 3, 4, 5, 6, 7],
    );

    expect(prepared.didPrependBismillah, isTrue);
    expect(prepared.preRollSource, isNotNull);
  });

  test(
    'resume of Fatihah after app background keeps the target without prepending Bismillah',
    () async {
      final prepared = await prepare(
        const QuranPlaybackRequest(
          surahNumber: 1,
          ayahNumber: 4,
          resumePosition: Duration(seconds: 12),
          playbackReason: QuranPlaybackReason.resume,
        ),
        ayahs: const <int>[1, 2, 3, 4, 5, 6, 7],
      );

      expect(prepared.didPrependBismillah, isFalse);
      expect(prepared.initialLogicalIndex, 3);
      expect(prepared.initialPosition, const Duration(seconds: 12));
    },
  );

  test(
    'jump within Fatihah keeps the target without prepending Bismillah',
    () async {
      final prepared = await prepare(
        const QuranPlaybackRequest(
          surahNumber: 1,
          ayahNumber: 6,
          playbackReason: QuranPlaybackReason.jump,
        ),
        ayahs: const <int>[1, 2, 3, 4, 5, 6, 7],
      );

      expect(prepared.didPrependBismillah, isFalse);
      expect(prepared.initialLogicalIndex, 5);
    },
  );

  test('fresh play of another surah prepends Bismillah', () async {
    final prepared = await prepare(
      const QuranPlaybackRequest(
        surahNumber: 2,
        ayahNumber: 1,
        playbackReason: QuranPlaybackReason.freshPlay,
      ),
      ayahs: const <int>[1, 2, 3],
    );

    expect(prepared.didPrependBismillah, isTrue);
  });

  test(
    'resume of another surah keeps the target without prepending Bismillah',
    () async {
      final prepared = await prepare(
        const QuranPlaybackRequest(
          surahNumber: 2,
          ayahNumber: 3,
          resumePosition: Duration(seconds: 8),
          playbackReason: QuranPlaybackReason.resume,
        ),
        ayahs: const <int>[1, 2, 3, 4],
      );

      expect(prepared.didPrependBismillah, isFalse);
      expect(prepared.initialLogicalIndex, 2);
    },
  );

  test(
    'jump within another surah keeps the target without prepending Bismillah',
    () async {
      final prepared = await prepare(
        const QuranPlaybackRequest(
          surahNumber: 36,
          ayahNumber: 12,
          playbackReason: QuranPlaybackReason.jump,
        ),
        ayahs: const <int>[1, 5, 12, 20],
      );

      expect(prepared.didPrependBismillah, isFalse);
      expect(prepared.initialLogicalIndex, 2);
    },
  );

  test(
    'bookmark deep link and restore requests mid-surah do not prepend Bismillah',
    () async {
      final bookmarkPrepared = await prepare(
        const QuranPlaybackRequest(
          surahNumber: 18,
          ayahNumber: 25,
          playbackReason: QuranPlaybackReason.bookmark,
        ),
        ayahs: const <int>[10, 20, 25, 30],
      );
      final deepLinkPrepared = await prepare(
        const QuranPlaybackRequest(
          surahNumber: 18,
          ayahNumber: 25,
          playbackReason: QuranPlaybackReason.deepLink,
        ),
        ayahs: const <int>[10, 20, 25, 30],
      );
      final restorePrepared = await prepare(
        const QuranPlaybackRequest(
          surahNumber: 18,
          ayahNumber: 25,
          playbackReason: QuranPlaybackReason.restore,
        ),
        ayahs: const <int>[10, 20, 25, 30],
      );

      expect(bookmarkPrepared.didPrependBismillah, isFalse);
      expect(deepLinkPrepared.didPrependBismillah, isFalse);
      expect(restorePrepared.didPrependBismillah, isFalse);
    },
  );

  test(
    'sourceAware mode avoids duplicate Bismillah when source already contains it',
    () async {
      final prepared = await prepare(
        const QuranPlaybackRequest(
          surahNumber: 1,
          ayahNumber: 1,
          playbackReason: QuranPlaybackReason.freshPlay,
        ),
        ayahs: const <int>[1, 2, 3],
        mode: BismillahPlaybackMode.sourceAware,
      );

      expect(prepared.didPrependBismillah, isFalse);
      expect(prepared.preRollSource, isNull);
    },
  );

  test(
    'intended target is preserved without pre-roll for mid-surah bookmarks',
    () async {
      final prepared = await prepare(
        const QuranPlaybackRequest(
          surahNumber: 18,
          ayahNumber: 25,
          resumePosition: Duration(seconds: 17),
          playbackReason: QuranPlaybackReason.bookmark,
        ),
        ayahs: const <int>[10, 20, 25, 30],
      );

      expect(prepared.didPrependBismillah, isFalse);
      expect(prepared.preRollMetadata, isNull);
      expect(prepared.request.surahNumber, 18);
      expect(prepared.request.ayahNumber, 25);
      expect(prepared.initialLogicalIndex, 2);
      expect(prepared.initialPosition, const Duration(seconds: 17));
    },
  );

  test(
    'mid-surah deep links keep the logical target metadata without pre-roll',
    () async {
      final prepared = await prepare(
        const QuranPlaybackRequest(
          surahNumber: 2,
          ayahNumber: 3,
          playbackReason: QuranPlaybackReason.deepLink,
        ),
        ayahs: const <int>[1, 2, 3, 4],
      );

      expect(prepared.preRollMetadata, isNull);
      expect(
        prepared.entries[prepared.initialLogicalIndex].metadata.surahNumber,
        2,
      );
      expect(
        prepared.entries[prepared.initialLogicalIndex].metadata.ayahNumber,
        3,
      );
    },
  );

  test('Surah At-Tawbah start does not prepend Bismillah', () async {
    final prepared = await prepare(
      const QuranPlaybackRequest(
        surahNumber: 9,
        ayahNumber: 1,
        playbackReason: QuranPlaybackReason.freshPlay,
        isSurahEntry: true,
      ),
      ayahs: const <int>[1, 2, 3],
    );

    expect(prepared.didPrependBismillah, isFalse);
    expect(prepared.preRollSource, isNull);
  });

  test(
    'reuses cached prepared playback for repeated identical queue requests',
    () async {
      repository.resolveAyahSourceMetadataCallCount = 0;

      await prepare(
        const QuranPlaybackRequest(
          surahNumber: 18,
          ayahNumber: 25,
          resumePosition: Duration(seconds: 5),
          playbackReason: QuranPlaybackReason.resume,
        ),
        ayahs: const <int>[20, 25, 30],
      );
      await prepare(
        const QuranPlaybackRequest(
          surahNumber: 18,
          ayahNumber: 25,
          resumePosition: Duration(seconds: 9),
          playbackReason: QuranPlaybackReason.resume,
        ),
        ayahs: const <int>[20, 25, 30],
      );

      expect(repository.resolveAyahSourceMetadataCallCount, 3);
    },
  );
}
