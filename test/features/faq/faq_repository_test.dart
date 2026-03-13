import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/faq/repository/faq_repository.dart';

void main() {
  test('embedded FAQ dataset loads with expected structure', () async {
    final repository = FaqRepository();
    final dataset = await repository.load();

    expect(dataset.version, '0.1');
    expect(dataset.app, 'Path of Nur');
    expect(dataset.datasetName, 'Islam FAQ Learning Page Dataset');
    expect(dataset.items, hasLength(46));
    expect(dataset.categoryLabels, hasLength(10));
    expect(dataset.fields, hasLength(11));
  });

  test(
    'embedded FAQ dataset exposes stable featured items and search',
    () async {
      final repository = FaqRepository();

      final item = await repository.byId('foundations_001');
      expect(item, isNotNull);
      expect(item!.question, 'What does Islam mean?');
      expect(item.isFeatured, isTrue);

      final results = await repository.search(query: 'jihad');
      expect(results.any((entry) => entry.id == 'misconceptions_003'), isTrue);
    },
  );
}
