import 'package:go_router/go_router.dart';

import 'learn/learn_content_domain_routes.dart';
import 'learn/learn_core_routes.dart';
import 'learn/learn_hub_and_quiz_routes.dart';
import 'learn/learn_kids_routes.dart';

List<RouteBase> buildLearnRoutes() {
  return <RouteBase>[
    ...buildLearnCoreRoutes(),
    ...buildLearnKidsRoutes(),
    ...buildLearnHubAndQuizRoutes(),
    ...buildLearnContentDomainRoutes(),
  ];
}
