# Path of Nur — Smoke Tests
<!-- mcsnow-import: product=path-of-nur; key=PON; mode=full -->

## Backlog

### Epics

| Epic ID | Title | Status |
| --- | --- | --- |
| PON-E-flutter-344-test-recovery | Flutter 3.44 test suite recovery | done |
| PON-E-quran-playback-integrity | Qur'an reader playback state integrity | done |
| PON-E-repo-reconnect | Repo history reconnect and hygiene | done |
| PON-E-backup-privacy-hardening | Backup encryption and account privacy hardening | done |
| PON-E-platform-runtime-config | Platform permission and auth runtime configuration | done |

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
| PON-S-real-backup-encryption | PON-E-backup-privacy-hardening | Encrypt manual exports with passphrase-derived AES-256-GCM | 5 | done |
| PON-S-backup-diagnostics-scrub | PON-E-backup-privacy-hardening | Exclude device diagnostics logs from all backup payloads | 2 | done |
| PON-S-signout-pii-removal | PON-E-backup-privacy-hardening | Sign-out deletes stored account PII and revokes the Google OAuth grant | 3 | done |
| PON-S-android-runtime-permissions | PON-E-platform-runtime-config | Declare INTERNET and location permissions in the Android manifest | 1 | done |
| PON-S-auth-button-gating | PON-E-platform-runtime-config | Show sign-in buttons only when the platform auth config exists | 2 | done |
| PON-S-privacy-policy-accuracy | PON-E-platform-runtime-config | Privacy policy names actual services and data flows (16 locales) | 2 | done |
| PON-S-nominatim-coordinate-privacy | PON-E-platform-runtime-config | Send only city-level coordinates to Nominatim reverse lookup | 1 | done |

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
| PON-T-008 | Encrypted export asks for a passphrase and produces an unreadable file | Open Accounts & Sync → Export backup, keep "Encrypted export" ON, tap Export Now. Expected: a dialog asks for a passphrase (entered twice, min 8 chars; mismatch and too-short show inline errors); after export the file ends in .enc.json and opening it in a text editor shows an envelope (format "pon-backup-enc"), not readable profile data. | ⬜ | epic:PON-E-backup-privacy-hardening · story:PON-S-real-backup-encryption · sprint:2026-08-05 |
| PON-T-009 | Encrypted import prompts for passphrase; wrong entry fails cleanly | Export an encrypted backup, then open Import backup and choose that file. Expected: a passphrase prompt appears automatically (no encrypted/plain toggle); entering a wrong passphrase reopens the prompt with a clear localized error and no crash; the correct passphrase shows the normal import preview and restores. | ⬜ | epic:PON-E-backup-privacy-hardening · story:PON-S-real-backup-encryption · sprint:2026-08-05 |
| PON-T-010 | Old backup files still import | Import (a) a plain .json export and (b) a pre-update .enc.json file (base64-encoded) made with an earlier build. Expected: both validate and restore without any passphrase prompt. | ⬜ | epic:PON-E-backup-privacy-hardening · story:PON-S-real-backup-encryption · sprint:2026-08-05 · Legacy compat: old ".enc.json" files were base64, not encrypted |
| PON-T-011 | Backups contain no diagnostics logs | Trigger some app usage (so analytics/crash logs exist), export an unencrypted backup, open the .json file. Expected: no keys starting with "diagnostics." anywhere in the file; restoring the backup on another device leaves that device's own diagnostics untouched. | ⬜ | epic:PON-E-backup-privacy-hardening · story:PON-S-backup-diagnostics-scrub · sprint:2026-08-05 · Applies to manual exports and remote backups |
| PON-T-012 | Sign-out removes stored account identity | Sign in with Google, create/use a profile, then sign out. Expected: the accounts list no longer shows the Google account (email/name gone); the profile and its data remain usable as a local profile; signing in again later asks for Google consent anew (OAuth grant was revoked). | ⬜ | epic:PON-E-backup-privacy-hardening · story:PON-S-signout-pii-removal · sprint:2026-08-05 |
| PON-T-013 | Location features work on an Android release build | Install a release APK on an Android device, open Qibla finder and prayer times with automatic location. Expected: the app asks for location permission and both features work (previously the manifest declared no location or INTERNET permission, so they could not). | ⬜ | epic:PON-E-platform-runtime-config · story:PON-S-android-runtime-permissions · sprint:2026-08-05 |
| PON-T-014 | Sign-in buttons appear only where they can work | On iOS: Accounts & Sync shows "Continue with Apple"; the Google button is hidden (until the build passes PON_GOOGLE_AUTH_CONFIGURED=true). On Android: no Apple button. Email option remains visible everywhere. | ⬜ | epic:PON-E-platform-runtime-config · story:PON-S-auth-button-gating · sprint:2026-08-05 · Setup steps in docs/auth_provider_setup.md |
| PON-T-015 | Privacy policy describes real data flows | Open Profile → Legal → Privacy in en and de (plus any dev locale). Expected: the text names on-device storage, Apple/Google sign-in data with sign-out removal, passphrase-protected exports, Google Drive/iCloud backups, city-level coordinates to OpenStreetMap Nominatim, and EveryAyah/AlQuran.cloud/Quran.com audio-data sources; no claim that data is local-only. | ⬜ | epic:PON-E-platform-runtime-config · story:PON-S-privacy-policy-accuracy · sprint:2026-08-05 |
