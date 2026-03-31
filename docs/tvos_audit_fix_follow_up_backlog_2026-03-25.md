# tvOS Audit Fix Follow-Up Backlog

Date: 2026-03-25
Related task: audit-fix pass for analyzer recovery and empty-state hardening

## Recommended next enhancements

- Add targeted SwiftUI snapshot or UI-host tests for empty-state rendering on `TVDhikrScreen`, `TVGamesScreen`, and `TVQuranScreen` so sparse-data regressions are caught before manual QA.
- Add a small native seed-data toggle or preview fixture path for zero-content scenarios to make Apple TV QA faster and more repeatable.
- Extend empty-state hardening to any remaining support shelves that still assume seeded content, even when current data is non-empty.
- Add a warning-only audit check that flags tvOS screens with direct `ForEach` shelves but no obvious empty-state branch.

## QA focus for next device pass

- Validate focus restore when Qur'an has no browse collections or no ayahs and confirm fallback lands on playback.
- Validate Dhikr route behavior when no mode is selected and when guided steps are unavailable.
- Validate Games route rails when primary items or challenge cards are intentionally absent.
