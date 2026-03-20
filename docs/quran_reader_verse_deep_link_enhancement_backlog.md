# Qur'an Reader Verse Deep Link Enhancement Backlog

1. Add a lightweight selected-ayah visual emphasis in `QuranReaderPage` when opened with `initialAyah`, so deep-linked verse targets stand out after scroll.
2. Audit the remaining direct `quranReader` route callers and migrate any other structured verse-reference surfaces onto `quran_navigation.dart` when they are true reference taps rather than generic reader shortcuts.
3. Add a small widget test around the canonical deep-link helper and the `quranReader` route query parsing for `ayah` / `endAyah`.
