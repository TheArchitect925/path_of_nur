import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:quran/quran.dart' as q;

import '../domain/quran_content_refs.dart';
import '../domain/quran_audio_resilience_models.dart';
import '../domain/quran_audio_source_metadata.dart';

class QuranReciter {
  const QuranReciter({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.baseUrl,
  });

  final String id;
  final String name;
  final String arabicName;
  final String baseUrl;
}

class QuranAudioRepository {
  QuranAudioRepository({HttpClient? client}) : _client = client ?? HttpClient();

  final HttpClient _client;
  static const String defaultReciterId = 'alafasy';

  static const List<QuranReciter> reciters = [
    QuranReciter(
      id: 'husary',
      name: 'Mahmoud Khalil Al-Husary',
      arabicName: 'محمود خليل الحصري',
      baseUrl: 'https://everyayah.com/data/Husary_128kbps',
    ),
    QuranReciter(
      id: 'alafasy',
      name: 'Mishary Rashid Alafasy',
      arabicName: 'مشاري راشد العفاسي',
      baseUrl: 'https://everyayah.com/data/Alafasy_128kbps',
    ),
    QuranReciter(
      id: 'abdulbasit',
      name: 'Abdul Basit Murattal',
      arabicName: 'عبد الباسط عبد الصمد',
      baseUrl: 'https://everyayah.com/data/Abdul_Basit_Murattal_192kbps',
    ),
  ];

  QuranReciter reciterById(String id) {
    return reciters.firstWhere(
      (item) => item.id == id,
      orElse: () => reciters.first,
    );
  }

  QuranAudioCollectionMetadata collectionMetadata(String reciterId) {
    return QuranAudioCollectionMetadata(
      sourceId: QuranAudioSourceId('everyayah.$reciterId'),
      reciterId: QuranReciterId(reciterId),
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
      notes:
          'Mobile Qur’an playback currently uses EveryAyah ayah-level MP3s. '
          'The repo can prove Fatihah 1:1 is reused as the canonical Bismillah '
          'pre-roll source, but it does not yet prove whether non-Fatihah '
          'surah-start files already embed Bismillah or whether Surah 9 is '
          'handled specially in upstream source audio.',
      confidence: QuranAudioMetadataConfidence.unknownNeedsManualReview,
      manualReviewNeeded: true,
    );
  }

  Uri sampleUri(String reciterId) {
    final reciter = reciterById(reciterId);
    return Uri.parse('${reciter.baseUrl}/001001.mp3');
  }

  Uri verseUri({
    required String reciterId,
    required int surahNumber,
    required int ayahNumber,
  }) {
    final reciter = reciterById(reciterId);
    final code =
        '${surahNumber.toString().padLeft(3, '0')}${ayahNumber.toString().padLeft(3, '0')}';
    return Uri.parse('${reciter.baseUrl}/$code.mp3');
  }

  Future<String?> localAyahPath({
    required String reciterId,
    required int surahNumber,
    required int ayahNumber,
  }) async {
    final file = await _audioFile(
      reciterId: reciterId,
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
    );
    if (!file.existsSync()) return null;
    try {
      if (file.lengthSync() <= 0) {
        await file.delete();
        return null;
      }
    } catch (_) {
      return null;
    }
    return file.path;
  }

  /// The app ships Husary recitation for Al-Fatihah and the short surahs
  /// (105–114) inside the bundle — the salah trainer's clips, in everyayah's
  /// naming — so a brand-new reader can follow their first surahs offline
  /// before anything is downloaded.
  static const Set<int> bundledHusarySurahs = {
    1,
    105,
    106,
    107,
    108,
    109,
    110,
    111,
    112,
    113,
    114,
  };

  static const String _bundledHusaryReciterId = 'husary';

  String? bundledAssetUriForAyah({
    required String reciterId,
    required int surahNumber,
    required int ayahNumber,
  }) {
    if (reciterId != _bundledHusaryReciterId) return null;
    if (!bundledHusarySurahs.contains(surahNumber)) return null;
    final code =
        '${surahNumber.toString().padLeft(3, '0')}${ayahNumber.toString().padLeft(3, '0')}';
    return 'asset:///assets/audio/salah/husary/$code.mp3';
  }

  Future<String> resolveAyahSource({
    required String reciterId,
    required int surahNumber,
    required int ayahNumber,
  }) async {
    final local = await localAyahPath(
      reciterId: reciterId,
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
    );
    if (local != null) return local;
    final bundled = bundledAssetUriForAyah(
      reciterId: reciterId,
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
    );
    if (bundled != null) return bundled;
    return verseUri(
      reciterId: reciterId,
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
    ).toString();
  }

  Future<QuranAudioSourceMetadata> resolveAyahSourceMetadata({
    required String reciterId,
    required int surahNumber,
    required int ayahNumber,
    QuranPlaybackSourceType? preferredSourceType,
  }) async {
    final collection = collectionMetadata(reciterId);
    final downloadedSource = await localAyahPath(
      reciterId: reciterId,
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
    );
    // A bundled asset is on-device audio just like a download, so it rides
    // the localDownload tier for resilience purposes.
    final localSource =
        downloadedSource ??
        bundledAssetUriForAyah(
          reciterId: reciterId,
          surahNumber: surahNumber,
          ayahNumber: ayahNumber,
        );
    final remoteSource = verseUri(
      reciterId: reciterId,
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
    ).toString();
    final primarySourceType = _resolvePrimarySourceType(
      preferredSourceType: preferredSourceType,
      hasLocalSource: localSource != null,
    );
    final primarySource =
        primarySourceType == QuranPlaybackSourceType.localDownload
        ? localSource!
        : remoteSource;
    final fallbackSourceType =
        primarySourceType == QuranPlaybackSourceType.localDownload
        ? QuranPlaybackSourceType.remoteStream
        : (localSource == null ? null : QuranPlaybackSourceType.localDownload);
    final fallbackSource =
        fallbackSourceType == QuranPlaybackSourceType.remoteStream
        ? remoteSource
        : localSource;
    return QuranAudioSourceMetadata(
      surahNumber: surahNumber,
      ayahNumber: ayahNumber,
      reciterId: reciterId,
      source: primarySource,
      sourceType: primarySourceType,
      sourceContainsBismillahAtStart: surahNumber == 1 && ayahNumber == 1,
      sourceId: collection.sourceId,
      isAyahGranular: collection.isAyahGranular,
      includesBismillahInFatiha: collection.includesBismillahInFatiha,
      includesBismillahAtSurahStarts: collection.includesBismillahAtSurahStarts,
      hasStandaloneBismillahClip: collection.hasStandaloneBismillahClip,
      standaloneBismillahRef: collection.standaloneBismillahRef,
      surah9HasNoBismillahIntroInSource:
          collection.surah9HasNoBismillahIntroInSource,
      notes: collection.notes,
      confidence: collection.confidence,
      manualReviewNeeded: collection.manualReviewNeeded,
      fallbackSource: fallbackSource == primarySource ? null : fallbackSource,
      fallbackSourceType: fallbackSource == primarySource
          ? null
          : fallbackSourceType,
    );
  }

  Future<QuranAudioSourceMetadata> resolveCanonicalBismillahMetadata({
    required String reciterId,
    QuranPlaybackSourceType? preferredSourceType,
  }) async {
    final metadata = await resolveAyahSourceMetadata(
      reciterId: reciterId,
      surahNumber: 1,
      ayahNumber: 1,
      preferredSourceType: preferredSourceType,
    );
    return metadata.copyWith(
      sourceContainsBismillahAtStart: true,
      standaloneBismillahRef: QuranAudioRef(
        surah: 1,
        ayah: 1,
        reciterId: reciterId,
      ),
      notes:
          'Current canonical pre-roll reuses Fatihah 1:1 as the Bismillah '
          'source because no dedicated standalone Bismillah clip is modelled '
          'in the repo yet.',
      isStandaloneBismillah: true,
    );
  }

  Future<void> downloadSurah({
    required String reciterId,
    required int surahNumber,
    required void Function(int downloaded, int total) onProgress,
  }) async {
    final total = q.getVerseCount(surahNumber);
    var downloaded = 0;
    onProgress(downloaded, total);
    for (var ayah = 1; ayah <= total; ayah += 1) {
      final existing = await localAyahPath(
        reciterId: reciterId,
        surahNumber: surahNumber,
        ayahNumber: ayah,
      );
      if (existing != null) {
        downloaded += 1;
        onProgress(downloaded, total);
        continue;
      }
      final target = await _audioFile(
        reciterId: reciterId,
        surahNumber: surahNumber,
        ayahNumber: ayah,
      );
      await target.parent.create(recursive: true);
      final source = verseUri(
        reciterId: reciterId,
        surahNumber: surahNumber,
        ayahNumber: ayah,
      );
      final request = await _client.getUrl(source);
      final response = await request.close();
      if (response.statusCode != HttpStatus.ok) {
        throw HttpException(
          'Failed to download $source (${response.statusCode})',
          uri: source,
        );
      }
      final sink = target.openWrite();
      await response.pipe(sink);
      downloaded += 1;
      onProgress(downloaded, total);
    }
  }

  Future<void> clearSurahDownloads({
    required String reciterId,
    required int surahNumber,
  }) async {
    final total = q.getVerseCount(surahNumber);
    for (var ayah = 1; ayah <= total; ayah += 1) {
      final file = await _audioFile(
        reciterId: reciterId,
        surahNumber: surahNumber,
        ayahNumber: ayah,
      );
      if (file.existsSync()) {
        await file.delete();
      }
    }
  }

  Future<bool> isSurahDownloaded({
    required String reciterId,
    required int surahNumber,
  }) async {
    final total = q.getVerseCount(surahNumber);
    for (var ayah = 1; ayah <= total; ayah += 1) {
      final file = await _audioFile(
        reciterId: reciterId,
        surahNumber: surahNumber,
        ayahNumber: ayah,
      );
      if (!file.existsSync()) return false;
    }
    return true;
  }

  Future<File> _audioFile({
    required String reciterId,
    required int surahNumber,
    required int ayahNumber,
  }) async {
    final base = await getApplicationSupportDirectory();
    final folder = Directory(
      '${base.path}/quran_audio/$reciterId/$surahNumber',
    );
    final name =
        '${surahNumber.toString().padLeft(3, '0')}${ayahNumber.toString().padLeft(3, '0')}.mp3';
    return File('${folder.path}/$name');
  }

  QuranPlaybackSourceType _resolvePrimarySourceType({
    required QuranPlaybackSourceType? preferredSourceType,
    required bool hasLocalSource,
  }) {
    if (preferredSourceType == QuranPlaybackSourceType.localDownload &&
        hasLocalSource) {
      return QuranPlaybackSourceType.localDownload;
    }
    if (preferredSourceType == QuranPlaybackSourceType.remoteStream) {
      return QuranPlaybackSourceType.remoteStream;
    }
    if (hasLocalSource) {
      return QuranPlaybackSourceType.localDownload;
    }
    return QuranPlaybackSourceType.remoteStream;
  }
}
