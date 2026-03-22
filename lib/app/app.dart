import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_navigation_bridge.dart';
import 'app_router.dart';
import 'app_quick_actions.dart';
import '../core/localization/locale_provider.dart';
import '../core/reminders/prayer_live_activity_service.dart';
import '../core/reminders/reminder_scheduler.dart';
import '../core/theme/app_theme.dart';
import '../features/journey/application/growth_reminder_scheduler.dart';
import '../features/journey/application/growth_providers.dart';
import '../features/journey/application/growth_widget_support.dart';
import '../features/journey/application/journey_progression_provider.dart';
import '../features/learn/prophets/application/daily_learning_surfaces.dart';
import '../features/wallpaper/application/wallpaper_provider.dart';
import '../features/accounts_sync/application/accounts_sync_controller.dart';
import '../features/profile/application/profile_settings_provider.dart';
import '../features/watch_companion/application/apple_watch_runtime_bridge.dart';
import '../l10n/app_localizations.dart';

class PathOfNurApp extends ConsumerWidget {
  const PathOfNurApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(appLocaleProvider);
    final profileSettings = ref.watch(profileSettingsProvider);
    final scopeVersion = ref.watch(profileScopeVersionProvider);
    ref.watch(reminderSchedulerBootstrapProvider);
    ref.watch(growthReminderBootstrapProvider);
    ref.watch(growthWidgetBootstrapProvider);
    ref.watch(growthUnlocksAutoSyncProvider);
    ref.watch(prophetDailySurfacesBootstrapProvider);
    ref.watch(appQuickActionsBootstrapProvider);
    ref.watch(appNavigationBridgeBootstrapProvider);
    ref.watch(appleWatchRuntimeBridgeBootstrapProvider);
    ref.watch(journeyProgressAutoSyncProvider);
    ref.watch(wallpaperAutoUnlockProvider);
    ref.watch(prayerLiveActivityBootstrapProvider);
    final theme = AppTheme.themeFor(
      mode: profileSettings.appThemeMode,
      disableGlassTransparency: profileSettings.disableGlassTransparency,
      disableColoredGlass: profileSettings.disableColoredGlass,
      disableBackground: profileSettings.disableBackground,
      highContrastText: profileSettings.highContrastText,
      glassSurfaceAlpha: profileSettings.glassSurfaceAlpha,
    );
    final localeTag = locale?.toLanguageTag() ?? 'en';
    return MaterialApp.router(
      key: ValueKey<String>('app-$scopeVersion-$localeTag'),
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: theme,
      routerConfig: ref.read(appRouterProvider),
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
