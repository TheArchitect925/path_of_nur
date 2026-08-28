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
import '../core/theme/occasion_theme.dart';
import '../features/journey/application/growth_reminder_scheduler.dart';
import '../features/journey/application/growth_providers.dart';
import '../features/journey/application/growth_widget_support.dart';
import '../features/journey/application/journey_progression_provider.dart';
import '../features/arabic/application/arabic_learning_quick_resume_widget_bridge.dart';
import '../features/learn/prophets/application/daily_learning_surfaces.dart';
import '../features/wallpaper/application/wallpaper_provider.dart';
import '../features/accounts_sync/application/accounts_sync_controller.dart';
import '../features/accounts_sync/application/auto_backup_engine.dart';
import '../features/ios_widgets/application/iphone_home_widget_sync_service.dart';
import '../features/profile/application/profile_settings_provider.dart';
import '../features/watch_companion/application/apple_watch_runtime_bridge.dart';
import '../shared/application/daily_clock_provider.dart';
import '../shared/application/special_mode_provider.dart';
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
    ref.watch(arabicLearningQuickResumeWidgetBootstrapProvider);
    ref.watch(autoBackupBootstrapProvider);
    ref.watch(appNavigationBridgeBootstrapProvider);
    ref.watch(iPhoneHomeWidgetBootstrapProvider);
    ref.watch(appleWatchRuntimeBridgeBootstrapProvider);
    ref.watch(journeyProgressAutoSyncProvider);
    ref.watch(wallpaperAutoUnlockProvider);
    ref.watch(prayerLiveActivityBootstrapProvider);
    final occasionNow = ref.watch(dailyNowProvider).value ?? DateTime.now();
    final specialMode = ref.watch(specialModeProvider);
    final effectiveThemeMode = resolveOccasionThemeMode(
      baseMode: profileSettings.appThemeMode,
      dressUpFridays: profileSettings.dressUpFridays,
      dressUpRamadan: profileSettings.dressUpRamadan,
      isRamadan: specialMode.isRamadan || specialMode.ramadanDateWindowActive,
      now: occasionNow,
    );
    final manualTheme = AppTheme.themeFor(
      mode: effectiveThemeMode,
      pageTransitionStyle: profileSettings.pageTransitionStyle,
      reduceMotion: profileSettings.reduceMotion,
      disableGlassTransparency: profileSettings.disableGlassTransparency,
      disableColoredGlass: profileSettings.disableColoredGlass,
      disableBackground: profileSettings.disableBackground,
      highContrastText: profileSettings.highContrastText,
      glassSurfaceAlpha: profileSettings.glassSurfaceAlpha,
      locale: locale,
    );
    final useSystemTheme =
        profileSettings.themePreference == ProfileThemePreference.system;
    final lightMode = _lightThemeModeFor(effectiveThemeMode);
    final darkMode = _darkThemeModeFor(effectiveThemeMode);
    final lightTheme = AppTheme.themeFor(
      mode: lightMode,
      pageTransitionStyle: profileSettings.pageTransitionStyle,
      reduceMotion: profileSettings.reduceMotion,
      disableGlassTransparency: profileSettings.disableGlassTransparency,
      disableColoredGlass: profileSettings.disableColoredGlass,
      disableBackground: profileSettings.disableBackground,
      highContrastText: profileSettings.highContrastText,
      glassSurfaceAlpha: profileSettings.glassSurfaceAlpha,
      locale: locale,
    );
    final darkTheme = AppTheme.themeFor(
      mode: darkMode,
      pageTransitionStyle: profileSettings.pageTransitionStyle,
      reduceMotion: profileSettings.reduceMotion,
      disableGlassTransparency: profileSettings.disableGlassTransparency,
      disableColoredGlass: profileSettings.disableColoredGlass,
      disableBackground: profileSettings.disableBackground,
      highContrastText: profileSettings.highContrastText,
      glassSurfaceAlpha: profileSettings.glassSurfaceAlpha,
      locale: locale,
    );
    final localeTag = locale?.toLanguageTag() ?? 'en';
    return MaterialApp.router(
      key: ValueKey<String>('app-$scopeVersion-$localeTag'),
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: useSystemTheme ? lightTheme : manualTheme,
      darkTheme: useSystemTheme ? darkTheme : manualTheme,
      themeMode: useSystemTheme ? ThemeMode.system : ThemeMode.light,
      routerConfig: ref.read(appRouterProvider),
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: releaseSupportedLocales,
    );
  }
}

AppThemeMode _lightThemeModeFor(AppThemeMode mode) {
  switch (mode) {
    case AppThemeMode.noorGlassDark:
      return AppThemeMode.noorGlass;
    case AppThemeMode.noGlassDark:
      return AppThemeMode.noGlass;
    // The night themes pair with Noor Glass when the OS switches to light.
    case AppThemeMode.midnight:
    case AppThemeMode.candlelight:
      return AppThemeMode.noorGlass;
    // The occasions hold day and night alike.
    case AppThemeMode.jummah:
      return AppThemeMode.jummah;
    case AppThemeMode.ramadan:
      return AppThemeMode.ramadan;
    default:
      return mode;
  }
}

AppThemeMode _darkThemeModeFor(AppThemeMode mode) {
  switch (mode) {
    // OS dark mode now lands on the starry Midnight theme.
    case AppThemeMode.noorGlass:
      return AppThemeMode.midnight;
    case AppThemeMode.noGlass:
      return AppThemeMode.noGlassDark;
    default:
      return mode;
  }
}
