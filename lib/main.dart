import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'core/diagnostics/app_telemetry.dart';
import 'shared/persistence/app_database.dart';
import 'shared/persistence/local_store.dart';
import 'shared/persistence/sqlite_opener.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  AppTelemetry.bootstrap(prefs);
  // Lock-screen controls are a phone feature; on the web just_audio plays on
  // its own.
  if (!kIsWeb) {
    try {
      await JustAudioBackground.init(
        androidNotificationChannelId: 'com.shahab.path_of_nur.quran_audio',
        androidNotificationChannelName: 'Quran Audio Playback',
        androidNotificationOngoing: true,
      );
    } catch (error, stackTrace) {
      AppTelemetry.logError(
        'audio_background_init_failed',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  await prepareSqlite();
  AppDatabase appDatabase;
  try {
    // The web build's file lives in IndexedDB, under the root of its own VFS.
    final directory = kIsWeb
        ? ''
        : (await getApplicationDocumentsDirectory()).path;
    appDatabase = AppDatabase.openFile('$directory/path_of_nur.sqlite3');
  } catch (error, stackTrace) {
    AppTelemetry.logError(
      'app_database_open_failed',
      error: error,
      stackTrace: stackTrace,
    );
    appDatabase = AppDatabase.inMemory();
  }

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        appDatabaseProvider.overrideWithValue(appDatabase),
      ],
      child: const PathOfNurApp(),
    ),
  );
}
