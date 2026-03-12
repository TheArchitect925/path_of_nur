import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'core/diagnostics/app_telemetry.dart';
import 'shared/persistence/local_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.shahab.path_of_nur.quran_audio',
    androidNotificationChannelName: 'Quran Audio Playback',
    androidNotificationOngoing: true,
  );
  final prefs = await SharedPreferences.getInstance();
  AppTelemetry.bootstrap(prefs);

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const PathOfNurApp(),
    ),
  );
}
