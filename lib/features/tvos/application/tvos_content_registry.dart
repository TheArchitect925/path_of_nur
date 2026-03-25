import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/tvos_content_registry.dart';
import '../domain/tvos_content_registry_models.dart';
import '../domain/tvos_foundation_models.dart';
import 'tvos_feature_flags.dart';
import 'tvos_release_policy.dart';

List<TVOSContentModuleDefinition> buildOnboardedTVOSContentModules({
  required String routePath,
  required TVOSReleaseStage releaseStage,
}) {
  final routeEnabled = TVOSReleasePolicy.isSurfaceEnabled(routePath);
  if (!routeEnabled) return const <TVOSContentModuleDefinition>[];

  final sectionFlags = TVOSReleasePolicy.sectionFlagsForRoute(routePath);
  final enabledSectionKeys = sectionFlags
      .where((flag) => flag.availability == TVOSFeatureAvailability.enabled)
      .map((flag) => flag.sectionKey)
      .toSet();

  return tvosContentModulesForRoute(routePath)
      .where(
        (module) =>
            module.requiredReleaseStage.index <= releaseStage.index &&
            enabledSectionKeys.contains(module.sectionKey) &&
            module.dependsOnSectionKeys.every(enabledSectionKeys.contains),
      )
      .toList(growable: false);
}

final tvosContentModuleRegistryProvider =
    Provider<List<TVOSContentModuleDefinition>>((ref) {
      return tvosContentModuleRegistry;
    });

final tvosHomeOnboardedModulesProvider =
    Provider<List<TVOSContentModuleDefinition>>((ref) {
      final stage = ref.watch(tvosReleaseStageProvider);
      return buildOnboardedTVOSContentModules(
        routePath: '/home',
        releaseStage: stage,
      );
    });

final tvosQuranOnboardedModulesProvider =
    Provider<List<TVOSContentModuleDefinition>>((ref) {
      final stage = ref.watch(tvosReleaseStageProvider);
      return buildOnboardedTVOSContentModules(
        routePath: '/quran',
        releaseStage: stage,
      );
    });

final tvosFavoritesOnboardedModulesProvider =
    Provider<List<TVOSContentModuleDefinition>>((ref) {
      final stage = ref.watch(tvosReleaseStageProvider);
      return buildOnboardedTVOSContentModules(
        routePath: '/quran/bookmarks',
        releaseStage: stage,
      );
    });

final tvosSettingsOnboardedModulesProvider =
    Provider<List<TVOSContentModuleDefinition>>((ref) {
      final stage = ref.watch(tvosReleaseStageProvider);
      return buildOnboardedTVOSContentModules(
        routePath: '/settings',
        releaseStage: stage,
      );
    });

final tvosArabicOnboardedModulesProvider =
    Provider<List<TVOSContentModuleDefinition>>((ref) {
      final stage = ref.watch(tvosReleaseStageProvider);
      return buildOnboardedTVOSContentModules(
        routePath: '/quran/arabic',
        releaseStage: stage,
      );
    });

final tvosPrayerOnboardedModulesProvider =
    Provider<List<TVOSContentModuleDefinition>>((ref) {
      final stage = ref.watch(tvosReleaseStageProvider);
      return buildOnboardedTVOSContentModules(
        routePath: '/worship/prayer',
        releaseStage: stage,
      );
    });

final tvosDhikrOnboardedModulesProvider =
    Provider<List<TVOSContentModuleDefinition>>((ref) {
      final stage = ref.watch(tvosReleaseStageProvider);
      return buildOnboardedTVOSContentModules(
        routePath: '/worship/dhikr',
        releaseStage: stage,
      );
    });

final tvosLearnOnboardedModulesProvider =
    Provider<List<TVOSContentModuleDefinition>>((ref) {
      final stage = ref.watch(tvosReleaseStageProvider);
      return buildOnboardedTVOSContentModules(
        routePath: '/learn',
        releaseStage: stage,
      );
    });

final tvosGamesOnboardedModulesProvider =
    Provider<List<TVOSContentModuleDefinition>>((ref) {
      final stage = ref.watch(tvosReleaseStageProvider);
      return buildOnboardedTVOSContentModules(
        routePath: '/learn/games',
        releaseStage: stage,
      );
    });

final tvosProfilesOnboardedModulesProvider =
    Provider<List<TVOSContentModuleDefinition>>((ref) {
      final stage = ref.watch(tvosReleaseStageProvider);
      return buildOnboardedTVOSContentModules(
        routePath: '/accounts-sync/profiles',
        releaseStage: stage,
      );
    });

final tvosKidsOnboardedModulesProvider =
    Provider<List<TVOSContentModuleDefinition>>((ref) {
      final stage = ref.watch(tvosReleaseStageProvider);
      return buildOnboardedTVOSContentModules(
        routePath: '/learn/kids/fun-learning',
        releaseStage: stage,
      );
    });

final tvosOnboardedRouteBundlesProvider =
    Provider<List<TVOSRouteContentBundle>>((ref) {
      final homeModules = ref.watch(tvosHomeOnboardedModulesProvider);
      final quranModules = ref.watch(tvosQuranOnboardedModulesProvider);
      final favoritesModules = ref.watch(tvosFavoritesOnboardedModulesProvider);
      final settingsModules = ref.watch(tvosSettingsOnboardedModulesProvider);
      final arabicModules = ref.watch(tvosArabicOnboardedModulesProvider);
      final prayerModules = ref.watch(tvosPrayerOnboardedModulesProvider);
      final dhikrModules = ref.watch(tvosDhikrOnboardedModulesProvider);
      final kidsModules = ref.watch(tvosKidsOnboardedModulesProvider);
      final learnModules = ref.watch(tvosLearnOnboardedModulesProvider);
      final gamesModules = ref.watch(tvosGamesOnboardedModulesProvider);
      final profilesModules = ref.watch(tvosProfilesOnboardedModulesProvider);
      return <TVOSRouteContentBundle>[
        TVOSRouteContentBundle(
          routePath: '/home',
          surfaceId: TVOSSurfaceId.home,
          modules: homeModules,
        ),
        TVOSRouteContentBundle(
          routePath: '/accounts-sync/profiles',
          surfaceId: TVOSSurfaceId.profiles,
          modules: profilesModules,
        ),
        TVOSRouteContentBundle(
          routePath: '/quran',
          surfaceId: TVOSSurfaceId.quran,
          modules: quranModules,
        ),
        TVOSRouteContentBundle(
          routePath: '/quran/bookmarks',
          surfaceId: TVOSSurfaceId.favorites,
          modules: favoritesModules,
        ),
        TVOSRouteContentBundle(
          routePath: '/settings',
          surfaceId: TVOSSurfaceId.settings,
          modules: settingsModules,
        ),
        TVOSRouteContentBundle(
          routePath: '/quran/arabic',
          surfaceId: TVOSSurfaceId.arabic,
          modules: arabicModules,
        ),
        TVOSRouteContentBundle(
          routePath: '/worship/prayer',
          surfaceId: TVOSSurfaceId.prayer,
          modules: prayerModules,
        ),
        TVOSRouteContentBundle(
          routePath: '/worship/dhikr',
          surfaceId: TVOSSurfaceId.dhikr,
          modules: dhikrModules,
        ),
        TVOSRouteContentBundle(
          routePath: '/learn/kids/fun-learning',
          surfaceId: TVOSSurfaceId.kids,
          modules: kidsModules,
        ),
        TVOSRouteContentBundle(
          routePath: '/learn',
          surfaceId: TVOSSurfaceId.learn,
          modules: learnModules,
        ),
        TVOSRouteContentBundle(
          routePath: '/learn/games',
          surfaceId: TVOSSurfaceId.games,
          modules: gamesModules,
        ),
      ];
    });
