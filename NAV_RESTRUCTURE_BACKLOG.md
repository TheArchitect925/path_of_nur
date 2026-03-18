# Navigation Restructure Backlog

- Move `profileSummary`, `profileWhatsNew`, and `profileComingSoon` route paths under `/settings/*` after link migration is complete.
- Retire [profile_page.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/profile/presentation/profile_page.dart) once no remaining entry points depend on it.
- Add a dedicated Qur'an deep link target for `/quran` so external links land on the new top-level tab instead of Learn-owned routes.
- Review Learn search/index copy that still uses "Profile" as a keyword and decide whether to rename those entries to "Settings".
- Start Learn placeholder cleanup after confirming the new Qur'an tab IA and Journey-path entry points.
