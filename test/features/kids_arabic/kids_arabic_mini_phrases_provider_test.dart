import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_phrases_provider.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  test('mini phrases expose a small curated starter set', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);

    final phrases = container.read(kidsArabicMiniPhrasesProvider);
    expect(phrases, hasLength(6));
    expect(
      phrases.map((item) => item.id),
      orderedEquals(const [
        'bismillah',
        'alhamdulillah',
        'subhanallah',
        'allahu-akbar',
        'assalamu-alaikum',
        'inshaallah',
      ]),
    );
    for (final phrase in phrases) {
      expect(phrase.phraseAr, isNotEmpty);
      expect(phrase.transliteration, isNotEmpty);
    }
  });

  test('mini phrase progress persists heard and last-opened state', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);

    final notifier = container.read(
      kidsArabicMiniPhraseProgressProvider.notifier,
    );
    notifier.markPhraseOpened('alhamdulillah');
    notifier.markPhraseHeard('subhanallah');

    final state = container.read(kidsArabicMiniPhraseProgressProvider);
    expect(state.lastPhraseId, 'subhanallah');
    expect(state.heardPhraseIds, contains('subhanallah'));
    expect(
      container.read(kidsArabicMiniPhraseRecommendedProvider)?.id,
      'subhanallah',
    );
  });
}
