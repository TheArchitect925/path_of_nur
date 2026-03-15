# Bundled Adhan assets

These files power the offline Adhan settings system.

Folders
- `assets/audio/adhan/regular/` for Dhuhr, Asr, Maghrib, and Isha
- `assets/audio/adhan/fajr/` for Fajr-only routing

Registry
- Register or swap options in `lib/core/reminders/adhan_options.dart`
- Keep filenames lowercase and underscore-separated
- Add matching notification resources for Android and iOS when you add a new option

Native notification resources
- Android: `android/app/src/main/res/raw/`
- iOS: `ios/Runner/`

Current status
- The app is wired for separate Fajr and regular Adhan selection
- The current bundled variants are temporary offline fallbacks derived from the existing bundled Adhan clip
- Replace them with curated Pixabay files when direct downloadable assets are available

Suggested replacement mapping
- `assets/audio/adhan/regular/makkah_default.oga`
- `assets/audio/adhan/regular/madinah_soft.oga`
- `assets/audio/adhan/regular/clear_masjid.oga`
- `assets/audio/adhan/fajr/fajr_default.oga`
- `assets/audio/adhan/fajr/fajr_soft.oga`
