Last login: Fri Apr 10 04:57:11 on ttys004
shahabmansoor@mac path_of_nur % flutter emulators
flutter emulators --launch apple_ios_simulator
2 available emulators:

Id                    • Name                  • Manufacturer • Platform

apple_ios_simulator   • iOS Simulator         • Apple        • ios
Medium_Phone_API_36.1 • Medium Phone API 36.1 • Generic      • android

To run an emulator, run 'flutter emulators --launch <emulator id>'.
To create a new emulator, run 'flutter emulators --create [--name xyz]'.

You can find more information on managing emulators at the links below:
  https://developer.android.com/studio/run/managing-avds
  https://developer.android.com/studio/command-line/avdmanager
shahabmansoor@mac path_of_nur % flutter run
Resolving dependencies... 
Downloading packages... 
  async 2.13.0 (2.13.1 available)
  audio_session 0.2.2 (0.2.3 available)
  camera 0.11.4 (0.12.0+1 available)
  camera_android_camerax 0.6.30 (0.7.1+2 available)
  camera_avfoundation 0.9.23+2 (0.10.1 available)
  cupertino_icons 1.0.8 (1.0.9 available)
  file_selector_android 0.5.2+4 (0.5.2+5 available)
  flutter_local_notifications 17.2.4 (21.0.0 available)
  flutter_local_notifications_linux 4.0.1 (8.0.0 available)
  flutter_local_notifications_platform_interface 7.2.0 (11.0.0 available)
  flutter_plugin_android_lifecycle 2.0.33 (2.0.34 available)
  flutter_riverpod 2.6.1 (3.3.1 available)
  flutter_timezone 4.1.1 (5.0.2 available)
  geolocator_linux 0.2.3 (0.2.4 available)
  go_router 14.8.1 (17.2.0 available)
  google_sign_in 6.3.0 (7.2.0 available)
  google_sign_in_android 6.2.1 (7.2.10 available)
  google_sign_in_ios 5.9.0 (6.3.0 available)
  google_sign_in_platform_interface 2.5.0 (3.1.0 available)
  google_sign_in_web 0.12.4+4 (1.1.3 available)
  home_widget 0.7.0+1 (0.9.0 available)
  meta 1.17.0 (1.18.2 available)
  package_info_plus 8.3.1 (9.0.1 available)
  path_provider_android 2.2.22 (2.3.1 available)
! path_provider_foundation 2.4.1 (overridden) (2.6.0 available)
  permission_handler 11.4.0 (12.0.1 available)
  permission_handler_android 12.1.0 (13.0.1 available)
  quick_actions_android 1.0.27 (1.0.28 available)
  quick_actions_ios 1.2.3 (1.2.4 available)
  riverpod 2.6.1 (3.2.1 available)
  share_plus 10.1.4 (12.0.2 available)
  share_plus_platform_interface 5.0.2 (6.1.0 available)
  shared_preferences 2.5.4 (2.5.5 available)
  shared_preferences_android 2.4.21 (2.4.23 available)
  shared_preferences_platform_interface 2.4.1 (2.4.2 available)
  sign_in_with_apple 6.1.4 (7.0.1 available)
  sign_in_with_apple_platform_interface 1.1.0 (2.0.0 available)
  sign_in_with_apple_web 2.1.1 (3.0.0 available)
  sqlite3 2.9.4 (3.3.0 available)
  sqlite3_flutter_libs 0.5.42 (0.6.0+eol available)
  test_api 0.7.10 (0.7.11 available)
  timezone 0.9.4 (0.11.0 available)
  vector_graphics 1.1.20 (1.1.21 available)
  vector_math 2.2.0 (2.3.0 available)
  wakelock_plus 1.3.3 (1.5.1 available)
  win32 5.15.0 (6.0.0 available)
Got dependencies!
46 packages have newer versions incompatible with dependency constraints.
Try `flutter pub outdated` for more information.
Launching lib/main.dart on iPhone 16e in debug mode...
Running Xcode build...                                                  
Xcode build done.                                            6.3s
Failed to build iOS app
Error output from Xcode build:
↳
    ** BUILD FAILED **


Xcode's output:
↳
    Writing result bundle at path:
    	/var/folders/5j/m4hz6n291g5fql2sp3vg_flc0000gn/T/flutter_tools.CKH41X/flutt
    	er_ios_build_temp_dirhmpIb9/temporary_xcresult_bundle

    lib/features/worship/presentation/widgets/prayer_section.dart:1168:9: Error:
    Type 'MoonPhaseVisualData' not found.
      final MoonPhaseVisualData moon;
            ^^^^^^^^^^^^^^^^^^^
    lib/features/worship/presentation/widgets/prayer_section.dart:1168:9: Error:
    'MoonPhaseVisualData' isn't a type.
      final MoonPhaseVisualData moon;
            ^^^^^^^^^^^^^^^^^^^
    lib/features/worship/presentation/widgets/prayer_section.dart:1220:54:
    Error: The method 'pushNamed' isn't defined for the type 'BuildContext'.
     - 'BuildContext' is from 'package:flutter/src/widgets/framework.dart'
     ('/opt/homebrew/share/flutter/packages/flutter/lib/src/widgets/framework.da
     rt').
    Try correcting the name to the name of an existing method, or defining a
    method named 'pushNamed'.
                          onPrayerTimeTap: () =>
                          context.pushNamed('salahTimes'),
                                                         ^^^^^^^^^
    lib/features/worship/presentation/widgets/prayer_section.dart:1224:32:
    Error: The method 'MoonPhaseVisual' isn't defined for the type
    '_MoonPhaseCard'.
     - '_MoonPhaseCard' is from
     'package:path_of_nur/features/worship/presentation/widgets/prayer_section.d
     art' ('lib/features/worship/presentation/widgets/prayer_section.dart').
    Try correcting the name to the name of an existing method, or defining a
    method named 'MoonPhaseVisual'.
                        children: [MoonPhaseVisual(moon: moon)],
                                   ^^^^^^^^^^^^^^^
    lib/features/worship/presentation/widgets/salah_timings_tracker_card.dart:98
    6:44: Error: Member not found: 'rtl'.
                  textDirection: TextDirection.rtl,
                                               ^^^
    lib/features/worship/presentation/widgets/salah_timings_tracker_card.dart:91
    4:13: Error: The getter 'NoorLiquidGlassMode' isn't defined for the type
    'PrayerTimingPill'.
     - 'PrayerTimingPill' is from
     'package:path_of_nur/features/worship/presentation/widgets/salah_timings_tr
     acker_card.dart'
     ('lib/features/worship/presentation/widgets/salah_timings_tracker_card.dart
     ').
    Try correcting the name to the name of an existing getter, or defining a
    getter or field named 'NoorLiquidGlassMode'.
          mode: NoorLiquidGlassMode.fake,
                ^^^^^^^^^^^^^^^^^^^
    lib/features/worship/presentation/widgets/salah_timings_tracker_card.dart:10
    16:22: Error: The getter 'homePrayerCompletedTapHintText' isn't defined for
    the type 'AppLocalizations'.
     - 'AppLocalizations' is from
     'package:path_of_nur/l10n/app_localizations.dart'
     ('lib/l10n/app_localizations.dart').
    Try correcting the name to the name of an existing getter, or defining a
    getter or field named 'homePrayerCompletedTapHintText'.
                    l10n.homePrayerCompletedTapHintText,
                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    lib/features/worship/presentation/widgets/salah_timings_tracker_card.dart:10
    41:34: Error: The getter 'homePrayerPostSalahDhikrLoggedText' isn't defined
    for the type 'AppLocalizations'.
     - 'AppLocalizations' is from
     'package:path_of_nur/l10n/app_localizations.dart'
     ('lib/l10n/app_localizations.dart').
    Try correcting the name to the name of an existing getter, or defining a
    getter or field named 'homePrayerPostSalahDhikrLoggedText'.
                              ? l10n.homePrayerPostSalahDhikrLoggedText
                                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    lib/features/worship/presentation/widgets/salah_timings_tracker_card.dart:10
    42:34: Error: The getter 'homePrayerPostSalahDhikrActionText' isn't defined
    for the type 'AppLocalizations'.
     - 'AppLocalizations' is from
     'package:path_of_nur/l10n/app_localizations.dart'
     ('lib/l10n/app_localizations.dart').
    Try correcting the name to the name of an existing getter, or defining a
    getter or field named 'homePrayerPostSalahDhikrActionText'.
                              : l10n.homePrayerPostSalahDhikrActionText,
                                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    Target kernel_snapshot_program failed: Exception
    Failed to package /Users/shahabmansoor/Developer/path_of_nur.
    Command PhaseScriptExecution failed with a nonzero exit code
    note: Run script build phase 'Thin Binary' will be run during every build
    because the option to run the script phase "Based on dependency analysis" is
    unchecked. (in target 'Runner' from project 'Runner')
    note: Run script build phase 'Run Script' will be run during every build
    because the option to run the script phase "Based on dependency analysis" is
    unchecked. (in target 'Runner' from project 'Runner')

Could not build the application for the simulator.
Error launching application on iPhone 16e.
shahabmansoor@mac path_of_nur % 
