# Quran Reader Search Follow-Ups

Date: 2026-04-10
Area: Qur'an reader in-reader search

## Safe enhancement options

- Add an optional scope toggle for `Current Surah` vs `Whole Qur'an` while keeping the current-surah mode as the default.
- Add lightweight match-field chips inside the reader sheet so users can narrow to `Translation`, `Transliteration`, or `Arabic`.
- Add scroll-synced highlighted excerpt pills for long result jumps when the active match is below the fold.
- Add explicit empty-state copy for `no matches in this surah` if product wants a clearer reader-search response.
- Add reader-side live result counting while typing in the sheet, if it can be done without making the sheet feel heavy.
- Add a tiny `return to current recitation ayah` hint inside the search pill when follow-playback is suspended by a search jump.

## Notes

- Current V1 intentionally stays reader-scoped to the current surah.
- Current implementation reuses the canonical normalization/search rules instead of creating a separate reader-only engine.
- A future whole-Qur'an-in-reader phase should reuse the canonical repository search provider rather than rebuilding search again inside the reader.
