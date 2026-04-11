import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:path_of_nur/features/editorial_dashboard/application/editorial_content_versions_provider.dart';
import 'package:path_of_nur/features/learn/hadith/data/generated_hadith_foundation_data.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('generated Hadith dataset has stable trusted runtime metadata', () {
    final ids = generatedHadithEntries.map((entry) => entry.id).toList();
    final uniqueIds = ids.toSet();
    final sourceCollections = generatedHadithEntries
        .map((entry) => entry.displaySourceCollectionTitle)
        .toSet();

    expect(ids, isNotEmpty);
    expect(generatedHadithEntries.length, greaterThan(900));
    expect(uniqueIds.length, ids.length);
    expect(
      generatedHadithEntries.every(
        (entry) => entry.sourceImportSource == 'hadith_master_dataset',
      ),
      isTrue,
    );
    expect(
      generatedHadithEntries.every((entry) => entry.isLaunchReady),
      isTrue,
    );
    expect(sourceCollections, contains('40 Hadith an-Nawawi'));
    expect(sourceCollections, contains('Riyad as-Salihin'));
  });

  test(
    'editorial Hadith provider uses generated dataset as its runtime base',
    () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final preferences = await SharedPreferences.getInstance();
      final container = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
      );
      addTearDown(container.dispose);

      final entries = container.read(editorialHadithEntriesProvider);

      expect(entries.length, generatedHadithEntries.length);
      expect(entries.first.sourceImportSource, 'hadith_master_dataset');
      expect(entries.first.id, generatedHadithEntries.first.id);
    },
  );
}
