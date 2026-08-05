# Path of Nur — Smoke Tests
<!-- mcsnow-import: product=path-of-nur; key=PON; mode=full -->

## Backlog

### Epics

| Epic ID | Title | Status |
| --- | --- | --- |
| PON-E-flutter-344-test-recovery | Flutter 3.44 test suite recovery | done |
| PON-E-quran-playback-integrity | Qur'an reader playback state integrity | done |
| PON-E-repo-reconnect | Repo history reconnect and hygiene | done |

### Stories

| Story ID | Epic ID | Title | Points | Status |
| --- | --- | --- | --- | --- |
| PON-S-home-tahajjud-plus-one-total | PON-E-flutter-344-test-recovery | Restore 5+1 prayer tracker total when Tahajjud is offered | 1 | done |
| PON-S-reader-settings-material | PON-E-flutter-344-test-recovery | Reader settings cards render on a Material surface (no debug crash) | 1 | done |
| PON-S-stale-now-playing-clear | PON-E-quran-playback-integrity | Clear stale now-playing indicator after playback fully stops | 2 | done |
| PON-S-single-ayah-highlight | PON-E-quran-playback-integrity | Active single-ayah session wins highlight over remembered ayah | 2 | done |
| PON-S-focus-exit-crash | PON-E-quran-playback-integrity | Exit focus recitation without provider lifecycle crash | 2 | done |
| PON-S-memorize-intent-path | PON-E-quran-playback-integrity | Memorize intent suggests a learning path even when not featured | 1 | done |
| PON-S-locale-parity-41-keys | PON-E-repo-reconnect | Translate 41 care-mode/legal-attribution keys across 14 locales | 3 | done |

## Smoke Tests

| ID | Title | Steps / expected | Result | Notes |
| --- | --- | --- | --- | --- |
| PON-T-001 | Home tracker shows 5+1 total when Tahajjud is offered | Open Home while today's schedule includes a Tahajjud offer window. Expected: the salah tracker fraction shows a total of "5+1" (localized digits), e.g. "0/5+1"; when no Tahajjud offer exists, the total shows plain "5". | ⬜ | epic:PON-E-flutter-344-test-recovery · story:PON-S-home-tahajjud-plus-one-total · sprint:2026-08-05 · Regression fix: the tracker total helper ignored the Tahajjud offer flag |
| PON-T-002 | Reader settings sheet opens cleanly | Open the Qur'an reader, open the reader settings sheet, scroll through all setting groups and flip a toggle. Expected: sheet renders normally with card backgrounds and ink ripples on tiles; no error screen (debug builds previously crashed with a ListTile paint assertion). | ⬜ | epic:PON-E-flutter-344-test-recovery · story:PON-S-reader-settings-material · sprint:2026-08-05 |
| PON-T-003 | Now-playing indicator clears after playback stops | Play an ayah in the reader, let it finish (or stop playback fully), keep the reader open. Expected: the "now playing" highlight/transport state clears once playback is fully stopped; no ayah stays marked as playing indefinitely. | ⬜ | epic:PON-E-quran-playback-integrity · story:PON-S-stale-now-playing-clear · sprint:2026-08-05 |
| PON-T-004 | Switching single-ayah playback moves the highlight | Play ayah A (single-ayah mode), then start playing a different ayah B in the same surah. Expected: the highlight/now-playing marker moves to B immediately; A is no longer marked. | ⬜ | epic:PON-E-quran-playback-integrity · story:PON-S-single-ayah-highlight · sprint:2026-08-05 |
| PON-T-005 | Exit focus recitation safely | Enter focus recitation mode, enable repeat-current-ayah and a sleep timer, then exit the mode. Expected: returns to the reader without error; repeat and sleep timer are cleared (re-entering shows them off). | ⬜ | epic:PON-E-quran-playback-integrity · story:PON-S-focus-exit-crash · sprint:2026-08-05 |
| PON-T-006 | Memorize intent suggests a path | In the Qur'an experience, set your focus/intent to "Memorize". Expected: a suggested learning path appears (e.g. a memorization-support path) instead of no suggestion. | ⬜ | epic:PON-E-quran-playback-integrity · story:PON-S-memorize-intent-path · sprint:2026-08-05 |
| PON-T-007 | New settings strings localized in dev locales | In a dev build with locale override (e.g. ar or ur), open Settings → Care & Life Moments and Legal → Attributions. Expected: all care-mode, cycle-days, and attribution strings render in the selected language (no English fallbacks). | ⬜ | epic:PON-E-repo-reconnect · story:PON-S-locale-parity-41-keys · sprint:2026-08-05 · Shipping locales remain en/de; verify via locale override |
