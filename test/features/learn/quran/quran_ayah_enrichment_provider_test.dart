import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_ayah_enrichment_provider.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_ayah_enrichment_models.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_content_refs.dart';

void main() {
  test('ayah enrichment aggregates multiple source domains for a verse', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final entries = container.read(
      quranAyahEnrichmentForVerseProvider((2, 153)),
    );

    expect(entries, isNotEmpty);
    expect(
      entries.any(
        (entry) => entry.domain == QuranAyahEnrichmentDomain.guidanceDailyLife,
      ),
      isTrue,
    );
    expect(
      entries.any(
        (entry) => entry.domain == QuranAyahEnrichmentDomain.guidanceDailyLife,
      ),
      isTrue,
    );
    expect(
      entries.any(
        (entry) => entry.linkStrength == QuranAyahLinkStrength.direct,
      ),
      isTrue,
    );
  });

  test('range query returns world creation enrichment for creation ayah', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final entries = container.read(
      quranAyahEnrichmentForRangeProvider(
        const QuranQuoteRef(surah: 21, ayah: 30),
      ),
    );

    expect(entries, isNotEmpty);
    expect(
      entries.any(
        (entry) => entry.domain == QuranAyahEnrichmentDomain.worldNature,
      ),
      isTrue,
    );
    expect(
      entries
          .where(
            (entry) => entry.domain == QuranAyahEnrichmentDomain.worldNature,
          )
          .first
          .cautionNote,
      isNotEmpty,
    );
  });

  test(
    'curated signs in creation pack covers multiple creation categories',
    () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final skyEntries = container.read(
        quranAyahEnrichmentForVerseProvider((51, 47)),
      );
      final celestialEntries = container.read(
        quranAyahEnrichmentForVerseProvider((10, 5)),
      );
      final animalEntries = container.read(
        quranAyahEnrichmentForVerseProvider((24, 45)),
      );
      final humanEntries = container.read(
        quranAyahEnrichmentForRangeProvider(
          const QuranQuoteRef(surah: 23, ayah: 12, ayahEnd: 14),
        ),
      );

      expect(
        skyEntries.any((entry) => entry.id == 'signs_heavens_51_47'),
        isTrue,
      );
      expect(
        celestialEntries.any((entry) => entry.id == 'signs_sun_moon_10_5'),
        isTrue,
      );
      expect(
        animalEntries.any((entry) => entry.id == 'signs_animals_24_45'),
        isTrue,
      );
      expect(
        humanEntries.any(
          (entry) =>
              entry.id == 'signs_human_creation_23_12_14' &&
              entry.cautionLevel == QuranAyahCautionLevel.scientificCare,
        ),
        isTrue,
      );
    },
  );

  test(
    'curated worship and remembrance pack covers practical worship areas',
    () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final salahEntries = container.read(
        quranAyahEnrichmentForVerseProvider((20, 14)),
      );
      final duaEntries = container.read(
        quranAyahEnrichmentForVerseProvider((2, 186)),
      );
      final ikhlasEntries = container.read(
        quranAyahEnrichmentForVerseProvider((98, 5)),
      );
      final tawakkulEntries = container.read(
        quranAyahEnrichmentForVerseProvider((33, 3)),
      );

      expect(
        salahEntries.any(
          (entry) =>
              entry.id == 'worship_salah_20_14' &&
              entry.domain == QuranAyahEnrichmentDomain.worshipRemembrance,
        ),
        isTrue,
      );
      expect(
        duaEntries.any((entry) => entry.id == 'worship_dua_2_186'),
        isTrue,
      );
      expect(
        ikhlasEntries.any(
          (entry) =>
              entry.id == 'worship_sincerity_98_5' &&
              entry.tags.contains(QuranAyahEnrichmentTag.sincerity),
        ),
        isTrue,
      );
      expect(
        tawakkulEntries.any(
          (entry) =>
              entry.id == 'worship_reliance_33_3' &&
              entry.tags.contains(QuranAyahEnrichmentTag.tawakkul),
        ),
        isTrue,
      );
    },
  );

  test('curated character and adab pack covers key conduct areas', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final justiceEntries = container.read(
      quranAyahEnrichmentForVerseProvider((5, 8)),
    );
    final honestyEntries = container.read(
      quranAyahEnrichmentForVerseProvider((9, 119)),
    );
    final parentEntries = container.read(
      quranAyahEnrichmentForRangeProvider(
        const QuranQuoteRef(surah: 17, ayah: 23, ayahEnd: 24),
      ),
    );
    final angerEntries = container.read(
      quranAyahEnrichmentForVerseProvider((3, 134)),
    );

    expect(
      justiceEntries.any(
        (entry) =>
            entry.id == 'character_justice_5_8' &&
            entry.domain == QuranAyahEnrichmentDomain.characterAdab &&
            entry.displayType == QuranAyahDisplayItemType.characterLesson,
      ),
      isTrue,
    );
    expect(
      honestyEntries.any(
        (entry) =>
            entry.id == 'character_truthfulness_9_119' &&
            entry.tags.contains(QuranAyahEnrichmentTag.sincerity),
      ),
      isTrue,
    );
    expect(
      parentEntries.any(
        (entry) =>
            entry.id == 'character_parents_17_23_24' &&
            entry.linkStrength == QuranAyahLinkStrength.direct,
      ),
      isTrue,
    );
    expect(
      angerEntries.any(
        (entry) =>
            entry.id == 'character_anger_control_3_134' &&
            entry.tags.contains(QuranAyahEnrichmentTag.sabr) &&
            entry.tags.contains(QuranAyahEnrichmentTag.mercy),
      ),
      isTrue,
    );
  });

  test('curated tawhid and belief pack covers foundational belief areas', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final tawhidEntries = container.read(
      quranAyahEnrichmentForRangeProvider(
        const QuranQuoteRef(surah: 112, ayah: 1, ayahEnd: 4),
      ),
    );
    final signsEntries = container.read(
      quranAyahEnrichmentForRangeProvider(
        const QuranQuoteRef(surah: 3, ayah: 190, ayahEnd: 191),
      ),
    );
    final shirkEntries = container.read(
      quranAyahEnrichmentForVerseProvider((31, 13)),
    );
    final attributesEntries = container.read(
      quranAyahEnrichmentForVerseProvider((57, 3)),
    );

    expect(
      tawhidEntries.any(
        (entry) =>
            entry.id == 'belief_tawhid_112_1_4' &&
            entry.domain == QuranAyahEnrichmentDomain.tawhidBelief,
      ),
      isTrue,
    );
    expect(
      signsEntries.any(
        (entry) =>
            entry.id == 'belief_signs_3_190_191' &&
            entry.tags.contains(QuranAyahEnrichmentTag.signs),
      ),
      isTrue,
    );
    expect(
      shirkEntries.any(
        (entry) =>
            entry.id == 'belief_reject_shirk_31_13' &&
            entry.linkStrength == QuranAyahLinkStrength.direct,
      ),
      isTrue,
    );
    expect(
      attributesEntries.any(
        (entry) =>
            entry.id == 'belief_attributes_57_3' &&
            entry.displayType == QuranAyahDisplayItemType.ayahInsight,
      ),
      isTrue,
    );
  });

  test('resolved ayah insight paths keep starter entries in path order', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final resolvedPaths = container.read(quranAyahInsightResolvedPathsProvider);
    final worshipPath = resolvedPaths.firstWhere(
      (path) => path.path.id == 'worship-remembrance-starter',
    );

    expect(worshipPath.entries, isNotEmpty);
    expect(worshipPath.entries.first.id, 'worship_salah_20_14');
    expect(
      worshipPath.entries.any((entry) => entry.id == 'worship_dua_2_186'),
      isTrue,
    );
  });

  test(
    'curated akhirah and accountability pack covers core hereafter areas',
    () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final judgmentEntries = container.read(
        quranAyahEnrichmentForRangeProvider(
          const QuranQuoteRef(surah: 99, ayah: 6, ayahEnd: 8),
        ),
      );
      final deedsEntries = container.read(
        quranAyahEnrichmentForRangeProvider(
          const QuranQuoteRef(surah: 17, ayah: 13, ayahEnd: 14),
        ),
      );
      final resurrectionEntries = container.read(
        quranAyahEnrichmentForRangeProvider(
          const QuranQuoteRef(surah: 22, ayah: 5, ayahEnd: 7),
        ),
      );
      final dunyaEntries = container.read(
        quranAyahEnrichmentForVerseProvider((57, 20)),
      );

      expect(
        judgmentEntries.any(
          (entry) =>
              entry.id == 'akhirah_judgment_99_6_8' &&
              entry.domain == QuranAyahEnrichmentDomain.akhirahAccountability,
        ),
        isTrue,
      );
      expect(
        deedsEntries.any(
          (entry) =>
              entry.id == 'akhirah_deeds_17_13_14' &&
              entry.linkStrength == QuranAyahLinkStrength.direct,
        ),
        isTrue,
      );
      expect(
        resurrectionEntries.any(
          (entry) =>
              entry.id == 'akhirah_resurrection_22_5_7' &&
              entry.tags.contains(QuranAyahEnrichmentTag.signs),
        ),
        isTrue,
      );
      expect(
        dunyaEntries.any(
          (entry) =>
              entry.id == 'akhirah_dunya_57_20' &&
              entry.displayType == QuranAyahDisplayItemType.ayahInsight,
        ),
        isTrue,
      );
    },
  );

  test('curated prophets lessons pack covers core example-driven lessons', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final relianceEntries = container.read(
      quranAyahEnrichmentForVerseProvider((26, 62)),
    );
    final submissionEntries = container.read(
      quranAyahEnrichmentForVerseProvider((2, 131)),
    );
    final trialEntries = container.read(
      quranAyahEnrichmentForRangeProvider(
        const QuranQuoteRef(surah: 21, ayah: 83, ayahEnd: 84),
      ),
    );
    final leadershipEntries = container.read(
      quranAyahEnrichmentForVerseProvider((38, 26)),
    );

    expect(
      relianceEntries.any(
        (entry) =>
            entry.id == 'prophets_reliance_26_62' &&
            entry.displayType == QuranAyahDisplayItemType.prophetConnection,
      ),
      isTrue,
    );
    expect(
      submissionEntries.any(
        (entry) =>
            entry.id == 'prophets_submission_2_131' &&
            entry.domain == QuranAyahEnrichmentDomain.prophetsLessons,
      ),
      isTrue,
    );
    expect(
      trialEntries.any(
        (entry) =>
            entry.id == 'prophets_trials_21_83_84' &&
            entry.tags.contains(QuranAyahEnrichmentTag.mercy) &&
            entry.tags.contains(QuranAyahEnrichmentTag.prophets),
      ),
      isTrue,
    );
    expect(
      leadershipEntries.any(
        (entry) =>
            entry.id == 'prophets_leadership_38_26' &&
            entry.tags.contains(QuranAyahEnrichmentTag.justice),
      ),
      isTrue,
    );
  });

  test('display items prioritize primary insights before prompts', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final items = container.read(
      quranAyahDisplayItemsForVerseProvider((2, 153)),
    );

    expect(items, isNotEmpty);
    expect(items.length, lessThanOrEqualTo(6));
    expect(items.first.type, isNot(QuranAyahDisplayItemType.reflectionPrompt));
    expect(
      items.any(
        (item) =>
            item.type == QuranAyahDisplayItemType.ayahInsight ||
            item.type == QuranAyahDisplayItemType.worshipLesson ||
            item.type == QuranAyahDisplayItemType.signsInCreation ||
            item.type == QuranAyahDisplayItemType.scientificReflection,
      ),
      isTrue,
    );
  });

  test('curated related ayahs expose typed high-confidence links', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final items = container.read(
      quranAyahDisplayItemsForRangeProvider(
        const QuranQuoteRef(surah: 112, ayah: 1, ayahEnd: 4),
      ),
    );

    final relatedAyahs = items
        .where((item) => item.type == QuranAyahDisplayItemType.relatedAyah)
        .toList(growable: false);

    expect(relatedAyahs, isNotEmpty);
    expect(
      relatedAyahs.any(
        (item) =>
            item.relatedRef?.surah == 39 &&
            item.relatedRef?.ayah == 11 &&
            item.relatedAyahType == QuranRelatedAyahLinkType.worshipConnection,
      ),
      isTrue,
    );
    expect(
      relatedAyahs.any(
        (item) =>
            item.relatedRef?.surah == 31 &&
            item.relatedRef?.ayah == 13 &&
            item.relatedAyahType == QuranRelatedAyahLinkType.contrast,
      ),
      isTrue,
    );
  });

  test('curated ayah insight paths expose the starter path set', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final paths = container.read(quranAyahInsightPathsProvider);

    expect(paths.length, 6);
    expect(paths.any((path) => path.id == 'signs-in-creation-starter'), isTrue);
    expect(
      paths.any((path) => path.id == 'worship-remembrance-starter'),
      isTrue,
    );
    expect(paths.every((path) => path.entryIds.length >= 5), isTrue);
  });

  test('resolved ayah insight path keeps curated entry order', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final path = container.read(
      quranAyahInsightPathProvider('tawhid-belief-starter'),
    );

    expect(path, isNotNull);
    expect(path!.entries.first.id, 'belief_tawhid_112_1_4');
    expect(path.entries[1].id, 'belief_signs_3_190_191');
    expect(path.entries.last.id, 'belief_taqwa_3_102');
  });

  test(
    'localized enrichment returns Arabic copy when a curated translation exists',
    () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final entries = container.read(
        quranAyahEnrichmentForRangeLocalizedProvider((
          const QuranQuoteRef(surah: 112, ayah: 1, ayahEnd: 4),
          'ar',
        )),
      );

      final entry = entries.firstWhere(
        (item) => item.id == 'belief_tawhid_112_1_4',
      );

      expect(entry.title, contains('الله'));
      expect(entry.summary, contains('الله'));
      expect(entry.reflectionPrompts.first, contains('كيف'));
    },
  );

  test(
    'localized enrichment falls back to English when no translated copy exists',
    () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final localizedEntries = container.read(
        quranAyahEnrichmentForVerseLocalizedProvider((2, 186, 'ar-CA')),
      );
      final baselineEntries = container.read(
        quranAyahEnrichmentForVerseProvider((2, 186)),
      );

      final localizedEntry = localizedEntries.firstWhere(
        (item) => item.id == 'worship_dua_2_186',
      );
      final baselineEntry = baselineEntries.firstWhere(
        (item) => item.id == 'worship_dua_2_186',
      );

      expect(localizedEntry.title, baselineEntry.title);
      expect(localizedEntry.summary, baselineEntry.summary);
      expect(localizedEntry.reflectionPrompts, baselineEntry.reflectionPrompts);
    },
  );
}
