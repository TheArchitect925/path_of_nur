import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:path_of_nur/app/routes/learn/learn_content_domain_routes.dart';
import 'package:path_of_nur/app/routes/learn/learn_hub_and_quiz_routes.dart';
import 'package:path_of_nur/app/routes/learn/learn_kids_routes.dart';

void main() {
  test('canonical hadith routes remain intact', () {
    final contentRoutes = buildLearnContentDomainRoutes().whereType<GoRoute>();
    final kidsRoutes = buildLearnKidsRoutes().whereType<GoRoute>();
    final hubRoutes = buildLearnHubAndQuizRoutes().whereType<GoRoute>();

    final hadithLanding = contentRoutes.firstWhere(
      (route) => route.name == 'learnHadithLanding',
    );
    final hadithSearch = contentRoutes.firstWhere(
      (route) => route.name == 'hadithSearch',
    );
    final hadithSourceBrowse = contentRoutes.firstWhere(
      (route) => route.name == 'hadithSourceBrowse',
    );
    final hadithSourceDetail = contentRoutes.firstWhere(
      (route) => route.name == 'hadithSourceDetail',
    );
    final hadithSourceChapterDetail = contentRoutes.firstWhere(
      (route) => route.name == 'hadithSourceChapterDetail',
    );
    final hadithDetail = contentRoutes.firstWhere(
      (route) => route.name == 'hadithLessonDetail',
    );
    final kidsHadith = kidsRoutes.firstWhere(
      (route) => route.name == 'learnKidsHadith',
    );
    final hadithReflection = hubRoutes.firstWhere(
      (route) => route.name == 'learnHadithReflectionHome',
    );

    expect(hadithLanding.path, '/learn/hadith');
    expect(hadithSearch.path, '/learn/hadith/search');
    expect(hadithSourceBrowse.path, '/learn/hadith/sources');
    expect(hadithSourceDetail.path, '/learn/hadith/source/:sourceId');
    expect(
      hadithSourceChapterDetail.path,
      '/learn/hadith/source/:sourceId/chapter/:chapterId',
    );
    expect(hadithDetail.path, '/learn/hadith/lesson/:lessonId');
    expect(kidsHadith.path, '/learn/kids/hadith');
    expect(hadithReflection.path, '/learn/quizzes/hadith-reflection');
  });
}
