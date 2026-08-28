import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_personalization_provider.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_personalization_models.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const surface = QuranPersonalizationSurface.home;

  test('recording a presentation does not change the primary (no churn)', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);

    QuranRecommendationBundle bundle() => container.read(
      quranPersonalizedRecommendationBundleProvider((surface, false)),
    )!;
    final notifier = container.read(quranPersonalizationStateProvider.notifier);

    final first = bundle().primary.ayahKey;
    // The card records its presentation post-frame; before the pin existed
    // this applied a cooldown penalty to `first` and flipped the ranking.
    notifier.recordPresentationIfNeeded(surface: surface, ayahKey: first);
    for (var i = 0; i < 3; i++) {
      expect(
        bundle().primary.ayahKey,
        first,
        reason: 'primary churned after its own presentation was recorded',
      );
      notifier.recordPresentationIfNeeded(surface: surface, ayahKey: first);
    }
  });

  test('dismiss removes exactly the presented primary and never resurfaces it', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);

    QuranRecommendationBundle? bundle() => container.read(
      quranPersonalizedRecommendationBundleProvider((surface, false)),
    );
    final notifier = container.read(quranPersonalizationStateProvider.notifier);

    final seen = <String>[];
    for (var step = 0; step < 6; step++) {
      final current = bundle();
      if (current == null) break;
      final key = current.primary.ayahKey;
      notifier.recordPresentationIfNeeded(surface: surface, ayahKey: key);
      // Presentation recorded: the same primary must still be shown when the
      // user reaches for the dismiss button.
      expect(bundle()!.primary.ayahKey, key);
      seen.add(key);
      notifier.dismissForToday(surface: surface, ayahKey: key);
      expect(
        bundle()?.primary.ayahKey,
        isNot(key),
        reason: 'dismissed ayah still primary',
      );
    }
    expect(seen.length, greaterThanOrEqualTo(3));
    expect(
      seen.toSet().length,
      seen.length,
      reason: 'a dismissed ayah came back: $seen',
    );
  });
}
