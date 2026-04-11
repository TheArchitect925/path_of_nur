# iOS Simulator Build Unblock Enhancements

- Remove or wire the currently unused moon-phase helpers in [prayer_section.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/worship/presentation/widgets/prayer_section.dart) so the file stops carrying dead private UI paths.
- Audit the worship prayer widgets against the home prayer surface imports periodically; these two files drifted apart and caused the missing-symbol build break.
- Add a small CI or local preflight script that runs `flutter analyze` on the worship prayer widgets after refactors touching shared glass, localization, or moon-phase helpers.
- Consider moving shared prayer-card strings like post-salah dhikr labels from extension-only helpers into the main localization resource if these surfaces will keep being reused across multiple feature areas.
