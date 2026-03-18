import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_of_nur/core/localization/locale_provider.dart';

import 'package:path_of_nur/app/app_router.dart';
import 'package:path_of_nur/l10n/app_localizations.dart';
import 'package:path_of_nur/shared/persistence/app_database.dart';
import 'package:path_of_nur/shared/persistence/local_store.dart';

Future<ProviderContainer> makeTestContainer({
  Map<String, Object> seed = const <String, Object>{},
  AppDatabase? database,
  List<Override> overrides = const <Override>[],
}) async {
  SharedPreferences.setMockInitialValues(<String, Object>{
    'app.onboardingCompleted': true,
    ...seed,
  });
  final prefs = await SharedPreferences.getInstance();
  final appDatabase = database ?? AppDatabase.inMemory();
  final container = ProviderContainer(
    overrides: <Override>[
      sharedPreferencesProvider.overrideWithValue(prefs),
      appDatabaseProvider.overrideWithValue(appDatabase),
      ...overrides,
    ],
  );
  return container;
}

Widget buildRouterTestApp(ProviderContainer container) {
  return UncontrolledProviderScope(
    container: container,
    child: Consumer(
      builder: (_, ref, _) {
        final locale = ref.watch(appLocaleProvider);
        return MaterialApp.router(
          routerConfig: ref.read(appRouterProvider),
          locale: locale,
          localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
        );
      },
    ),
  );
}
