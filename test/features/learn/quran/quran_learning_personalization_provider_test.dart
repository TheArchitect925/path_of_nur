import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_learning_personalization_provider.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_providers.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_ayah_enrichment_models.dart';

import '../../../test_helpers/app_test_harness.dart';

void main() {
  test(
    'personalization summary resumes last path and suggests the next ayah',
    () async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);

      container
          .read(quranReadingProgressProvider.notifier)
          .touchLocation(surahNumber: 20, ayahNumber: 14);
      container
          .read(quranLearningPersonalizationStateProvider.notifier)
          .markDomainOpened('worship-remembrance');
      container
          .read(quranLearningPersonalizationStateProvider.notifier)
          .markPathOpened(
            pathId: 'worship-remembrance-starter',
            entryId: 'worship_salah_20_14',
          );

      final summary = container.read(
        quranLearningPersonalizationSummaryProvider,
      );

      expect(summary.hasSignals, isTrue);
      expect(summary.continueAyah.surahNumber, 20);
      expect(summary.continueAyah.ayahNumber, 14);
      expect(summary.continueDomain?.id, 'worship-remembrance');
      expect(summary.continuePath?.path.id, 'worship-remembrance-starter');
      expect(summary.nextPathEntry?.id, 'worship_dhikr_2_152');
      expect(summary.suggestedDomain?.id, 'worship-remembrance');
      expect(summary.suggestedTag, QuranAyahEnrichmentTag.worship);
    },
  );

  test(
    'personalization summary falls back to calm starter suggestions',
    () async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);

      final summary = container.read(
        quranLearningPersonalizationSummaryProvider,
      );

      expect(summary.hasSignals, isFalse);
      expect(summary.suggestedPath?.path.id, 'worship-remembrance-starter');
      expect(summary.suggestedDomain?.id, 'worship-remembrance');
      expect(summary.suggestedTag, QuranAyahEnrichmentTag.worship);
    },
  );
}
