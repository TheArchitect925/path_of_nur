import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/learn/quran/application/quran_reflections_provider.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_content_refs.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_reflection_entry.dart';

import '../../../test_helpers/app_test_harness.dart';

void main() {
  test('saving and toggling a reflection adds then removes it', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);

    final notifier = container.read(quranReflectionsProvider.notifier);
    final ref = QuranQuoteRef(surah: 20, ayah: 14);

    final saved = notifier.toggleSaved(
      ref: ref,
      sourceType: QuranReflectionSourceType.dailyAyah,
      title: 'Establish prayer for My remembrance',
      summary: 'A daily return to prayer and remembrance.',
      sourceEnrichmentId: 'worship_salah_20_14',
    );

    expect(saved, isTrue);
    expect(container.read(quranReflectionsProvider), hasLength(1));

    final removed = notifier.toggleSaved(
      ref: ref,
      sourceType: QuranReflectionSourceType.dailyAyah,
      title: 'Establish prayer for My remembrance',
      summary: 'A daily return to prayer and remembrance.',
      sourceEnrichmentId: 'worship_salah_20_14',
    );

    expect(removed, isFalse);
    expect(container.read(quranReflectionsProvider), isEmpty);
  });

  test(
    'upsertNote reuses the same enrichment entry instead of duplicating it',
    () async {
      final container = await makeTestContainer();
      addTearDown(container.dispose);

      final notifier = container.read(quranReflectionsProvider.notifier);
      final ref = QuranQuoteRef(surah: 20, ayah: 14);

      notifier.save(
        ref: ref,
        sourceType: QuranReflectionSourceType.dailyAyah,
        title: 'Establish prayer for My remembrance',
        summary: 'A daily return to prayer and remembrance.',
        sourceEnrichmentId: 'worship_salah_20_14',
      );

      notifier.upsertNote(
        ref: ref,
        sourceType: QuranReflectionSourceType.pathItem,
        title: 'Establish prayer for My remembrance',
        summary: 'A daily return to prayer and remembrance.',
        sourceEnrichmentId: 'worship_salah_20_14',
        note: 'Come back to this ayah after Maghrib.',
      );

      final items = container.read(quranReflectionsProvider);
      expect(items, hasLength(1));
      expect(items.single.note, 'Come back to this ayah after Maghrib.');
      expect(items.single.sourceEnrichmentId, 'worship_salah_20_14');
    },
  );

  test('related ayah note creates a saved reflection when needed', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);

    final notifier = container.read(quranReflectionsProvider.notifier);
    final ref = QuranQuoteRef(surah: 3, ayah: 190, ayahEnd: 191);

    notifier.upsertNote(
      ref: ref,
      sourceType: QuranReflectionSourceType.relatedAyah,
      title: 'Qur’an 3:190-191',
      summary: 'A supporting insight on reflection and belief.',
      note: 'Pair this with the creation path later.',
    );

    final items = container.read(quranReflectionsProvider);
    expect(items, hasLength(1));
    expect(items.single.sourceType, QuranReflectionSourceType.relatedAyah);
    expect(items.single.note, 'Pair this with the creation path later.');
  });
}
