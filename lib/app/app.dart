import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_router.dart';
import '../core/localization/locale_provider.dart';
import '../core/reminders/prayer_live_activity_service.dart';
import '../core/reminders/reminder_scheduler.dart';
import '../core/theme/app_theme.dart';
import '../features/journey/application/journey_progression_provider.dart';
import '../features/ocean/application/ocean_drops_provider.dart';
import '../features/wallpaper/application/wallpaper_provider.dart';
import '../l10n/app_localizations.dart';

class PathOfNurApp extends ConsumerWidget {
  const PathOfNurApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(appLocaleProvider);
    ref.watch(reminderSchedulerBootstrapProvider);
    ref.watch(journeyProgressAutoSyncProvider);
    ref.watch(oceanDropsAutoSyncProvider);
    ref.watch(oceanDropsDerivedSyncProvider);
    ref.watch(wallpaperAutoUnlockProvider);
    ref.watch(prayerLiveActivityBootstrapProvider);
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
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
