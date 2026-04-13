import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/learn/hadith/data/seeded_hadith_foundation_data.dart';
import 'package:path_of_nur/features/learn/hadith/domain/hadith_foundation_models.dart';
import 'package:path_of_nur/features/learn/hadith/presentation/hadith_reader_metadata.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';

void main() {
  group('Hadith reader metadata formatting', () {
    test('formats chapter labels from normalized source metadata', () async {
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      final entry = seededHadithEntries.firstWhere(
        (item) => item.sourceReference == 'Book 47, Hadith 8',
      );

      expect(
        formatHadithSourceChapterForDisplay(l10n, entry),
        'Chapter 47 • Book 47',
      );
    });

    test(
      'formats provenance and pipeline values for reader metadata',
      () async {
        final l10n = await AppLocalizations.delegate.load(const Locale('en'));
        final baseEntry = seededHadithEntries.first;

        final seeded = baseEntry;
        final editorial = baseEntry.copyWith(
          sourceProvenance: HadithSourceProvenance.editorialOverride,
          sourceImportSource: 'review_queue_v2',
        );
        final imported = baseEntry.copyWith(
          sourceProvenance: HadithSourceProvenance.imported,
          sourceImportSource: 'trusted_manual_ingest',
        );
        final unknown = baseEntry.copyWith(
          sourceProvenance: HadithSourceProvenance.unknown,
          sourceImportSource: '',
        );

        expect(
          formatHadithSourceProvenanceForDisplay(l10n, seeded),
          'Curated foundation record',
        );
        expect(
          formatHadithImportSourceForDisplay(l10n, seeded),
          'Pipeline: Seeded Hadith Foundation Data',
        );
        expect(
          formatHadithSourceProvenanceForDisplay(l10n, editorial),
          'Editorially reviewed record',
        );
        expect(
          formatHadithImportSourceForDisplay(l10n, editorial),
          'Pipeline: Review Queue V2',
        );
        expect(
          formatHadithSourceProvenanceForDisplay(l10n, imported),
          'Imported trusted-source record',
        );
        expect(
          formatHadithImportSourceForDisplay(l10n, imported),
          'Pipeline: Trusted Manual Ingest',
        );
        expect(
          formatHadithSourceProvenanceForDisplay(l10n, unknown),
          'Source pipeline metadata pending',
        );
        expect(formatHadithImportSourceForDisplay(l10n, unknown), isNull);
      },
    );

    test('formats chapter position context for the reader metadata', () async {
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));

      expect(
        formatHadithChapterPositionForDisplay(
          l10n,
          current: 3,
          total: 18,
        ),
        'Hadith 3 of 18 in this chapter',
      );
      expect(
        formatHadithChapterPositionForDisplay(
          l10n,
          current: 0,
          total: 18,
        ),
        isNull,
      );
    });
  });
}
