import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:path_of_nur/app/routes/core_support_routes.dart';

void main() {
  test('all search routes remain intact', () {
    final coreRoutes = buildCoreSupportRoutes().whereType<GoRoute>();

    final allSearch = coreRoutes.firstWhere(
      (route) => route.name == 'allSearch',
    );
    final learnAlias = coreRoutes.firstWhere(
      (route) => route.path == '/learn/search',
    );

    expect(allSearch.path, '/search');
    expect(learnAlias.redirect, isNotNull);
  });
}
