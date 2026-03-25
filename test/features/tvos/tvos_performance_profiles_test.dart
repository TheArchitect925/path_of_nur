import 'package:flutter_test/flutter_test.dart';
import 'package:path_of_nur/features/tvos/application/tvos_performance_profiles.dart';
import 'package:path_of_nur/features/tvos/data/tvos_performance_profiles.dart';
import 'package:path_of_nur/features/tvos/domain/tvos_foundation_models.dart';
import 'package:path_of_nur/features/tvos/domain/tvos_performance_models.dart';

void main() {
  test('quran remains the critical tvOS performance surface', () {
    final quranProfile = tvosPerformanceSurfaceProfiles.firstWhere(
      (profile) => profile.surfaceId == TVOSSurfaceId.quran,
    );

    expect(quranProfile.priority, TVOSPerformancePriority.critical);
    expect(tvosQuranPerformanceProfileRequiresCaching(), isTrue);
  });

  test('large-surface tvOS routes prefer lazy rendering', () {
    expect(tvosLargeSurfaceProfilesPreferLazyRendering(), isTrue);
  });

  test('high-priority performance profiles include home, quran, and learn', () {
    final surfaceIds = highPriorityTVOSPerformanceProfiles()
        .map((profile) => profile.surfaceId)
        .toSet();

    expect(surfaceIds, contains(TVOSSurfaceId.home));
    expect(surfaceIds, contains(TVOSSurfaceId.quran));
    expect(surfaceIds, contains(TVOSSurfaceId.learn));
  });
}
