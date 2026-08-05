import 'package:flutter_test/flutter_test.dart';

import '../../tool/localization_masked_translation.dart';

void main() {
  test('masked export replaces ICU placeholders with stable tokens', () {
    final english = <String, dynamic>{
      'quranCompanionProgressLabel': '{completed} of {total} stops completed',
      '@quranCompanionProgressLabel': <String, dynamic>{
        'placeholders': <String, dynamic>{
          'completed': <String, dynamic>{},
          'total': <String, dynamic>{},
        },
      },
    };

    final payload = buildMaskedExport(
      englishData: english,
      localeData: const <String, dynamic>{},
      keys: const <String>['quranCompanionProgressLabel'],
    );

    expect(
      payload['quranCompanionProgressLabel']['maskedEnglish'],
      '__PH_0__ of __PH_1__ stops completed',
    );
  });

  test('masked import restores placeholders after translation', () {
    final english = <String, dynamic>{
      'hadithSearchResultsCount': '{count} results',
      '@hadithSearchResultsCount': <String, dynamic>{
        'placeholders': <String, dynamic>{'count': <String, dynamic>{}},
      },
    };

    final result = applyMaskedImport(
      englishData: english,
      localeData: const <String, dynamic>{},
      translatedMaskedData: <String, dynamic>{
        'hadithSearchResultsCount': '__PH_0__ resultados',
      },
    );

    expect(result.failures, isEmpty);
    expect(
      result.updatedLocaleData['hadithSearchResultsCount'],
      '{count} resultados',
    );
  });

  test('masked import fails if a placeholder token is dropped', () {
    final english = <String, dynamic>{
      'quranCompanionResumePathTitle': 'Continue {path}',
      '@quranCompanionResumePathTitle': <String, dynamic>{
        'placeholders': <String, dynamic>{'path': <String, dynamic>{}},
      },
    };

    final result = applyMaskedImport(
      englishData: english,
      localeData: const <String, dynamic>{},
      translatedMaskedData: <String, dynamic>{
        'quranCompanionResumePathTitle': 'Continuar camino',
      },
    );

    expect(result.updatedKeys, isEmpty);
    expect(result.failures, hasLength(1));
    expect(result.failures.single, contains('__PH_0__'));
  });
}
