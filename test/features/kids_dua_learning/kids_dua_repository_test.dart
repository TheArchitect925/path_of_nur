import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/kids_dua_learning/application/kids_dua_repository.dart';

import '../../test_helpers/app_test_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('repository returns duas by category and by slug', () async {
    final container = await makeTestContainer();
    addTearDown(container.dispose);

    final homeDaily = container.read(
      kidsDuaLessonsForCategoryProvider('home_daily'),
    );
    final rabbi = container.read(
      kidsDuaLessonBySlugProvider('rabbi-zidnee-ilma'),
    );

    expect(homeDaily, hasLength(3));
    expect(homeDaily.map((item) => item.slug), contains('leaving-home'));
    expect(rabbi?.title, 'Rabbi Zidnee Ilma');
    expect(rabbi?.sourceReference, 'Qur’an 20:114');
  });
}
