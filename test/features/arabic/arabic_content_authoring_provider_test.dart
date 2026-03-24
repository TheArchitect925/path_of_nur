import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/arabic/application/arabic_content_authoring_provider.dart';
import 'package:path_of_nur/features/arabic/domain/arabic_content_authoring_models.dart';
import 'package:path_of_nur/features/arabic/domain/arabic_learning_continuity_models.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  test('kids content authoring units cover letters words phrases and bridge items', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);

    final units = container.read(
      arabicContentUnitsProvider(ArabicLearningAudience.kids),
    );

    expect(
      units.any(
        (unit) =>
            unit.id == arabicWordContentUnitId('bab') &&
            unit.type == ArabicContentUnitType.word &&
            unit.target.routeName == 'kidsArabicWordLesson',
      ),
      isTrue,
    );
    expect(
      units.any(
        (unit) =>
            unit.id == arabicPhraseContentUnitId('bismillah') &&
            unit.type == ArabicContentUnitType.phrase,
      ),
      isTrue,
    );
    expect(
      units.any(
        (unit) =>
            unit.id == arabicBridgeContentUnitId('bismillah_bridge') &&
            unit.type == ArabicContentUnitType.quranBridgeSnippet,
      ),
      isTrue,
    );
    expect(
      units.any(
        (unit) =>
            unit.id == arabicShortSurahContentUnitId(112) &&
            unit.type == ArabicContentUnitType.quranShortSurah,
      ),
      isTrue,
    );
  });

  test('adult content authoring units include shared modules and short surahs', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);

    final units = container.read(
      arabicContentUnitsProvider(ArabicLearningAudience.adult),
    );

    expect(
      units.any(
        (unit) =>
            unit.id == arabicModuleContentUnitId('foundations') &&
            unit.type == ArabicContentUnitType.module &&
            unit.target.moduleId == 'foundations',
      ),
      isTrue,
    );
    expect(
      units.any(
        (unit) =>
            unit.id == arabicShortSurahContentUnitId(112) &&
            unit.target.routeName == 'quranArabicShortSurahs',
      ),
      isTrue,
    );
  });

  test('pack compositions resolve to valid unit ids for both audiences', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);

    for (final audience in ArabicLearningAudience.values) {
      final units = container.read(arabicContentUnitsProvider(audience));
      final unitIds = units.map((unit) => unit.id).toSet();
      final compositions = container.read(
        arabicContentPackCompositionsProvider(audience),
      );

      for (final composition in compositions) {
        expect(
          composition.contentUnitIds.every(unitIds.contains),
          isTrue,
          reason: 'Missing unit for ${composition.id}',
        );
      }
    }
  });
}
