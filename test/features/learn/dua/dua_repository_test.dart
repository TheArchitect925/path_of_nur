import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:path_of_nur/features/learn/dua/application/dua_repository.dart';
import 'package:path_of_nur/features/learn/dua/domain/dua_models.dart';

void main() {
  test('embedded dua dataset matches expected scaffold counts', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final dataset = await container.read(duaDatasetProvider.future);

    expect(dataset.totalItems, 182);
    expect(dataset.completeItems, 182);
    expect(dataset.stubItems, 0);
    expect(dataset.items, hasLength(182));
    expect(dataset.verifiedItems, hasLength(dataset.completeItems));
    expect(
      dataset.items.where(
        (item) => item.completionStatus == DuaCompletionStatus.stub,
      ),
      hasLength(dataset.stubItems),
    );
  });

  test('embedded dua dataset exposes stable core entries', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final dataset = await container.read(duaDatasetProvider.future);
    final item = dataset.items.firstWhere(
      (entry) => entry.id == 'quran_020_114_increase_knowledge',
    );

    expect(item.title, 'Increase Me in Knowledge');
    expect(item.isCore, isTrue);
    expect(item.isQuran, isTrue);
    expect(item.completionStatus, DuaCompletionStatus.complete);
  });
}
