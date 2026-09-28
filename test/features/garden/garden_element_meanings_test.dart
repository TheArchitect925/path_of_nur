import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/garden/data/garden_element_meanings.dart';
import 'package:path_of_nur/features/garden/data/garden_scene_catalog.dart';
import 'package:path_of_nur/features/garden/domain/garden_scene_models.dart';
import 'package:path_of_nur/features/garden/presentation/widgets/garden_vista/garden_element_strings.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';

void main() {
  test('every scene element has a meaning entry', () {
    for (final id in GardenSceneElementId.values) {
      expect(
        gardenElementMeaningFor(id),
        isNotNull,
        reason: '${id.name} is missing from gardenElementMeanings',
      );
    }
  });

  test('meanings cover the catalog and carry no duplicates', () {
    final ids = gardenElementMeanings.map((m) => m.elementId).toList();
    expect(ids.toSet().length, ids.length, reason: 'duplicate element entry');
    for (final rule in gardenSceneElementRules) {
      expect(
        gardenElementMeaningFor(rule.id),
        isNotNull,
        reason: 'catalog rule ${rule.id.name} has no meaning',
      );
    }
  });

  test('ayah references are surah:ayah or surah:from-to', () {
    final pattern = RegExp(r'^\d{1,3}:\d{1,3}(-\d{1,3})?$');
    for (final meaning in gardenElementMeanings) {
      expect(
        pattern.hasMatch(meaning.ayahReference),
        isTrue,
        reason:
            '${meaning.elementId.name} has a malformed reference '
            '"${meaning.ayahReference}"',
      );
      final surah = int.parse(meaning.ayahReference.split(':').first);
      expect(
        surah,
        inInclusiveRange(1, 114),
        reason: '${meaning.elementId.name} surah out of range',
      );
    }
  });

  testWidgets('every element resolves to non-empty localized strings', (
    tester,
  ) async {
    late AppLocalizations l10n;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            l10n = AppLocalizations.of(context);
            return const SizedBox();
          },
        ),
      ),
    );
    for (final id in GardenSceneElementId.values) {
      expect(
        GardenElementStrings.title(l10n, id),
        isNotEmpty,
        reason: '${id.name} title',
      );
      expect(
        GardenElementStrings.meaning(l10n, id),
        isNotEmpty,
        reason: '${id.name} meaning',
      );
      // A raw key leaking through would start with "gardenElement".
      expect(
        GardenElementStrings.title(l10n, id),
        isNot(startsWith('gardenElement')),
      );
    }
  });
}
