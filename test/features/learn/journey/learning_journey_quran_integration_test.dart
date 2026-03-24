import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/journey/data/learning_journey_quran_integration.dart';

void main() {
  test(
    'journey quran context derives a contextual reader entry for strong lesson stages',
    () {
      final entry = learningJourneyQuranContextForStage('seerah-hijrah');

      expect(entry, isNotNull);
      expect(entry!.journeyId, 'seerah-journey');
      expect(entry.surahNumber, 9);
      expect(entry.ayahNumber, 40);
      expect(entry.topicId, 'trust-in-allah');
      expect(entry.toReaderQueryParameters()['mode'], 'study');
      expect(entry.toReaderQueryParameters()['stageId'], 'seerah-hijrah');
    },
  );

  test('curated character journey stages map into quran themes safely', () {
    final entry = learningJourneyQuranContextForStage('character-shukr');

    expect(entry, isNotNull);
    expect(entry!.journeyId, 'beautiful-character');
    expect(entry.surahNumber, 14);
    expect(entry.ayahNumber, 7);
    expect(entry.topicId, 'gratitude');
    expect(entry.toReaderQueryParameters()['mode'], 'theme');
  });

  test('reverse journey quran links stay curated and high-signal', () {
    final links = learningJourneyQuranReverseLinksForVerse(13, 28);

    expect(links, isNotEmpty);
    expect(links.any((entry) => entry.stageId == 'dhikr-what-is'), isTrue);
    expect(links.any((entry) => entry.stageId == 'fatihah-read'), isFalse);
  });

  test('reverse links can hand patience verses back into the character journey', () {
    final links = learningJourneyQuranReverseLinksForVerse(2, 153);

    expect(links.any((entry) => entry.stageId == 'character-sabr'), isTrue);
    expect(
      links.firstWhere((entry) => entry.stageId == 'character-sabr').topicId,
      'patience',
    );
  });
}
