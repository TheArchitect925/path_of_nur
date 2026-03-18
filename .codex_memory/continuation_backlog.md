# Continuation Backlog

Last updated: 2026-03-17

## Top 10 immediate engineering continuation items

1. Localize `SettingsPage` end-to-end, including hardcoded section titles, action labels, helper copy, and snackbar/dialog text.
2. Localize `AccountsProfilesSyncPage` and the main accounts/sync subpages so settings-first navigation does not land on English-only surfaces.
3. Finalize the canonical Learn ownership decision between `/learn`, `/learn/legacy`, and `/learn/browse`, then remove one layer of overlap.
4. Replace the most visible residual Learning Journey placeholder-backed destinations with real lesson-backed or route-specific targets.
5. Add widget tests for `LearningJourneyHomePage` covering Continue Journey, Today’s Light, and profile-aware visibility.
6. Add tests for progress reload when journey/stage IDs are removed or changed in the registry.
7. Refresh the root `README.md` with real product/setup/release information.
8. Audit the settings-to-accounts-sync route flow so all new settings ownership paths are coherent and no Profile-tab assumptions remain.
9. Validate current iOS simulator/native changes and close the duplicate Flutter engine bootstrap investigation.
10. Add a small local Codex engine helper that opens the right memory files for task categories.

## Top 10 cleanup / consolidation items

1. Remove dependency on `LearnPage` as a long-term fallback for unsupported learn sections.
2. Reduce duplicate Qur'an ownership across `/quran*` and `/learn/quran*` by documenting canonical paths and trimming new alias use.
3. Audit `LearnCategoryCatalog` hidden/placeholder items and either archive them more explicitly or promote only the ones with real implementation owners.
4. Reduce legacy Learn tool links inside `LearningJourneyRegistry` where real route-specific destinations now exist.
5. Consolidate settings/profile/about route naming so `/settings/*` becomes the only canonical namespace.
6. Review remaining unused legacy learn widgets/providers and delete only after route ownership is confirmed.
7. Normalize docs so release/readiness/platform claims match code reality everywhere.
8. Tighten feature ownership around family learning versus general settings to avoid split configuration paths.
9. Expand `.codex_memory_graph` with explicit route-feature ownership edges.
10. Add structured telemetry append workflow so future engine state is less hand-maintained.

## Top 10 launch-readiness items

1. Run full release-readiness checklist: `flutter test`, `flutter analyze`, golden verification, and integration flow pass.
2. Validate iOS signed build packaging and confirm privacy/support/legal pages remain reachable.
3. Verify prayer reminder permissions and adhan audio behavior on real iPhone/iPad devices.
4. Validate iCloud sync on signed Apple builds across two devices.
5. Confirm backup/export/import works on the intended release platform path.
6. Finish localization of highest-traffic surfaces before public launch.
7. Review attributions/licensing posture for Qur'an text, translations, transliteration, and audio.
8. Confirm deep-link and alias behavior for Qur'an, growth, and shared-profile launch flows.
9. Run watch-contract regression pass even if watch is not launch-ready, to avoid phone-side regressions.
10. Update root README and support-facing docs so the release posture is accurate for contributors/testers.

## Top 10 risky areas that need verification or tests

1. Learning Journey home/profile visibility logic under guardian/child/kids-ui permutations.
2. Continue Journey and stage completion persistence after registry edits.
3. Settings localization integrity after ongoing profile/settings refactors.
4. Accounts sync shared-device launch guard and profile switching with protected profiles.
5. iCloud transport behavior under signed versus unsigned Apple builds.
6. Reminder scheduling behavior when prayer settings, cycle state, and profile settings change together.
7. Watch action deduplication and reward safety around reconnect and rollover.
8. Qur'an alias routes versus canonical routes so navigation changes do not break old deep links.
9. Creation Explorer camera/native bridge behavior on iOS simulator and device.
10. Any user-facing content path that still relies on scaffold-only or placeholder references in active flows.
