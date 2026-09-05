import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/quran/data/quran_audio_repository.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_audio_resilience_models.dart';
import 'package:quran/quran.dart' as q;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late QuranAudioRepository repository;
  setUp(() {
    repository = QuranAudioRepository();
    final tempDir = Directory.systemTemp.createTempSync('husary-test');
    addTearDown(() => tempDir.deleteSync(recursive: true));
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          (call) async => tempDir.path,
        );
  });

  test('every bundled Husary surah resolves offline to an asset uri', () async {
    for (final surah in QuranAudioRepository.bundledHusarySurahs) {
      for (var ayah = 1; ayah <= q.getVerseCount(surah); ayah++) {
        final source = await repository.resolveAyahSource(
          reciterId: 'husary',
          surahNumber: surah,
          ayahNumber: ayah,
        );
        expect(
          source,
          startsWith('asset:///assets/audio/salah/husary/'),
          reason: '$surah:$ayah fell through to the network',
        );
      }
    }
  });

  test('every asset uri the resolver emits exists in the bundle', () async {
    for (final surah in QuranAudioRepository.bundledHusarySurahs) {
      for (var ayah = 1; ayah <= q.getVerseCount(surah); ayah++) {
        final source = repository.bundledAssetUriForAyah(
          reciterId: 'husary',
          surahNumber: surah,
          ayahNumber: ayah,
        )!;
        final assetPath = source.replaceFirst('asset:///', '');
        final data = await rootBundle.load(assetPath);
        expect(
          data.lengthInBytes,
          greaterThan(1000),
          reason: '$assetPath is missing or empty',
        );
      }
    }
  });

  test(
    'other reciters and unbundled surahs stay on their normal tiers',
    () async {
      expect(
        repository.bundledAssetUriForAyah(
          reciterId: 'alafasy',
          surahNumber: 1,
          ayahNumber: 1,
        ),
        isNull,
      );
      expect(
        repository.bundledAssetUriForAyah(
          reciterId: 'husary',
          surahNumber: 2,
          ayahNumber: 1,
        ),
        isNull,
      );
      final remote = await repository.resolveAyahSource(
        reciterId: 'husary',
        surahNumber: 2,
        ayahNumber: 1,
      );
      expect(remote, startsWith('https://'));
    },
  );

  test('the metadata resolver treats bundled audio as on-device', () async {
    final metadata = await repository.resolveAyahSourceMetadata(
      reciterId: 'husary',
      surahNumber: 112,
      ayahNumber: 1,
    );
    expect(metadata.sourceType, QuranPlaybackSourceType.localDownload);
    expect(metadata.source, startsWith('asset:///'));
    expect(metadata.fallbackSourceType, QuranPlaybackSourceType.remoteStream);
  });
}
