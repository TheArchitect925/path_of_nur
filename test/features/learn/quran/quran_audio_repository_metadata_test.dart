import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/quran/data/quran_audio_repository.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_audio_source_metadata.dart';

void main() {
  group('QuranAudioRepository metadata', () {
    final repository = QuranAudioRepository(client: HttpClient());

    test('exposes auditable collection metadata for mobile reciters', () {
      final metadata = repository.collectionMetadata('husary');

      expect(metadata.sourceId.value, 'everyayah.husary');
      expect(metadata.reciterId.value, 'husary');
      expect(metadata.isAyahGranular, isTrue);
      expect(metadata.includesBismillahInFatiha, isTrue);
      expect(metadata.hasStandaloneBismillahClip, isFalse);
      expect(
        metadata.confidence,
        QuranAudioMetadataConfidence.unknownNeedsManualReview,
      );
      expect(metadata.manualReviewNeeded, isTrue);
    });

    test('canonical Bismillah metadata points to Fatihah 1:1 ownership', () {
      final metadata = repository.collectionMetadata('husary');
      final verseUri = repository.verseUri(
        reciterId: 'husary',
        surahNumber: 1,
        ayahNumber: 1,
      );

      expect(metadata.hasStandaloneBismillahClip, isFalse);
      expect(metadata.standaloneBismillahRef?.surah, 1);
      expect(metadata.standaloneBismillahRef?.ayah, 1);
      expect(metadata.standaloneBismillahRef?.reciterId, 'husary');
      expect(verseUri.toString(), contains('001001.mp3'));
    });
  });
}
