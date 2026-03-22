import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'core/diagnostics/app_telemetry.dart';
import 'shared/persistence/app_database.dart';
import 'shared/persistence/local_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  AppTelemetry.bootstrap(prefs);
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

  AppDatabase appDatabase;
  try {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    appDatabase = AppDatabase.openFile(
      '${documentsDirectory.path}/path_of_nur.sqlite3',
    );
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
