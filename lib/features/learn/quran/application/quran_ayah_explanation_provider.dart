import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../editorial_dashboard/application/editorial_content_versions_provider.dart';
import '../data/quran_ayah_explanation_repository.dart';
import '../domain/quran_ayah_explanation_models.dart';
import '../domain/quran_reference_models.dart';

final quranAyahExplanationRepositoryProvider =
    Provider<QuranAyahExplanationRepository>((ref) {
      return SeededQuranAyahExplanationRepository(
        entries: ref.watch(editorialQuranAyahExplanationEntriesProvider),
      );
    });

final quranAyahExplanationEntryProvider =
    Provider.family<QuranAyahExplanationEntry?, (int surah, int ayah)>((
      ref,
      input,
    ) {
      return ref
          .watch(quranAyahExplanationRepositoryProvider)
          .getExplanation(surahNumber: input.$1, ayahNumber: input.$2);
    });

final quranAyahExplanationsForSurahProvider =
    Provider.family<List<QuranAyahExplanationEntry>, int>((ref, surahNumber) {
      return ref
          .watch(quranAyahExplanationRepositoryProvider)
          .getExplanationsForSurah(surahNumber);
    });

final quranResolvedAyahExplanationProvider =
    Provider.family<
      QuranAyahResolvedExplanation?,
      (
        int surah,
        int ayah,
        QuranExplanationDetailLevel detail,
        String languageCode,
      )
    >((ref, input) {
      return ref
          .watch(quranAyahExplanationEntryProvider((input.$1, input.$2)))
          ?.resolve(input.$3, languageCode: input.$4);
    });

final quranResolvedAyahExplanationsForSurahProvider =
    Provider.family<
      Map<int, QuranAyahResolvedExplanation>,
      (int surah, QuranExplanationDetailLevel detail, String languageCode)
    >((ref, input) {
      final entries = ref.watch(
        quranAyahExplanationsForSurahProvider(input.$1),
      );
      final resolved = <int, QuranAyahResolvedExplanation>{};
      for (final entry in entries) {
        final explanation = entry.resolve(input.$2, languageCode: input.$3);
        if (explanation != null) {
          resolved[entry.ayahNumber] = explanation;
        }
      }
      return Map<int, QuranAyahResolvedExplanation>.unmodifiable(resolved);
    });

final quranAyahExplanationCoverageBySurahProvider =
    Provider<Map<int, QuranAyahExplanationCoverageSummary>>((ref) {
      final entries = ref
          .watch(quranAyahExplanationRepositoryProvider)
          .getAll();
      final coverage = <int, QuranAyahExplanationCoverageSummary>{};
      for (final entry in entries) {
        final current =
            coverage[entry.surahNumber] ??
            QuranAyahExplanationCoverageSummary.empty(
              surahNumber: entry.surahNumber,
            );
        coverage[entry.surahNumber] = current.addEntry(entry);
      }
      return Map<int, QuranAyahExplanationCoverageSummary>.unmodifiable(
        coverage,
      );
    });

final quranAyahExplanationManifestProvider =
    Provider<List<QuranAyahExplanationManifestEntry>>((ref) {
      final entries = ref
          .watch(quranAyahExplanationRepositoryProvider)
          .getAll();
      return entries
          .map(
            (entry) => QuranAyahExplanationManifestEntry(
              surahNumber: entry.surahNumber,
              ayahNumber: entry.ayahNumber,
              hasSimple: entry.hasSimpleSummary,
              hasStandard: entry.hasStandardExplanation,
              hasDeep: entry.hasDeepExplanation,
              hasKids: entry.hasKidsExplanation,
              hasReflectionPrompt: entry.hasReflectionPrompt,
              hasKeyLessons: entry.hasKeyLessons,
              hasSourceRefs: entry.sourceRefs.isNotEmpty,
              rolloutPack: entry.rolloutPack,
              reviewStatus: entry.reviewStatus,
            ),
          )
          .toList(growable: false);
    });

final quranAyahExplanationPackDefinitionsProvider =
    Provider<List<QuranAyahExplanationPackDefinition>>((ref) {
      return const <QuranAyahExplanationPackDefinition>[
        QuranAyahExplanationPackDefinition(
          pack: QuranAyahExplanationRolloutPack.foundations,
          title: 'Foundations Pack',
          description:
              'Core ayahs every beginner is likely to meet early in prayer, dua, and belief.',
          expectedDetailLevels: <QuranExplanationDetailLevel>[
            QuranExplanationDetailLevel.simple,
            QuranExplanationDetailLevel.standard,
            QuranExplanationDetailLevel.kids,
          ],
        ),
        QuranAyahExplanationPackDefinition(
          pack: QuranAyahExplanationRolloutPack.commonSalahSurahs,
          title: 'Common Salah Surahs Pack',
          description:
              'Short surahs commonly memorized and recited in daily prayer.',
          expectedDetailLevels: <QuranExplanationDetailLevel>[
            QuranExplanationDetailLevel.simple,
            QuranExplanationDetailLevel.standard,
            QuranExplanationDetailLevel.kids,
          ],
        ),
        QuranAyahExplanationPackDefinition(
          pack: QuranAyahExplanationRolloutPack.beginnerCoreAyahs,
          title: 'Beginner Core Ayahs Pack',
          description:
              'Frequently encountered foundational ayahs outside the shortest surah cluster.',
          expectedDetailLevels: <QuranExplanationDetailLevel>[
            QuranExplanationDetailLevel.simple,
            QuranExplanationDetailLevel.standard,
            QuranExplanationDetailLevel.kids,
          ],
        ),
        QuranAyahExplanationPackDefinition(
          pack: QuranAyahExplanationRolloutPack.kidsStarter,
          title: 'Kids Starter Pack',
          description:
              'Ayahs that especially benefit from explicit child-friendly simplification and takeaways.',
          expectedDetailLevels: <QuranExplanationDetailLevel>[
            QuranExplanationDetailLevel.simple,
            QuranExplanationDetailLevel.kids,
          ],
        ),
        QuranAyahExplanationPackDefinition(
          pack: QuranAyahExplanationRolloutPack.reflectionComfort,
          title: 'Reflection Comfort Pack',
          description:
              'Ayahs and short surahs often used for reassurance, patience, and hopeful reflection.',
          expectedDetailLevels: <QuranExplanationDetailLevel>[
            QuranExplanationDetailLevel.simple,
            QuranExplanationDetailLevel.standard,
            QuranExplanationDetailLevel.kids,
          ],
        ),
      ];
    });

final quranAyahExplanationPackSummaryProvider =
    Provider<Map<QuranAyahExplanationRolloutPack, int>>((ref) {
      final manifest = ref.watch(quranAyahExplanationManifestProvider);
      final counts = <QuranAyahExplanationRolloutPack, int>{};
      for (final entry in manifest) {
        counts.update(
          entry.rolloutPack,
          (value) => value + 1,
          ifAbsent: () => 1,
        );
      }
      return Map<QuranAyahExplanationRolloutPack, int>.unmodifiable(counts);
    });
