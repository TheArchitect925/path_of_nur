# Continuation Backlog

Last updated: 2026-03-18

## Top 10 immediate engineering continuation items

1. Localize `SettingsPage` end-to-end, including hardcoded section titles, action labels, helper copy, and snackbar/dialog text.
2. Localize `AccountsProfilesSyncPage` and the main accounts/sync subpages so settings-first navigation does not land on English-only surfaces.
3. Finalize the canonical Learn ownership decision between `/learn`, `/learn/legacy`, and `/learn/browse`, then remove one layer of overlap.
4. Replace the most visible residual Learning Journey placeholder-backed destinations with real lesson-backed or route-specific targets.
5. Add widget tests for `LearningJourneyHomePage` covering Continue Journey, Today’s Light, and profile-aware visibility.
6. Add tests for progress reload when journey/stage IDs are removed or changed in the registry.
7. Refresh the root `README.md` with real product/setup/release information.
8. Audit the settings-to-accounts-sync route flow so all new settings ownership paths are coherent and no Profile-tab assumptions remain.
9. Run paired Apple Watch QA covering snapshot fetch, prayer action queue replay, dhikr completion sync, complication refresh, and offline recovery.
10. Validate Apple Watch prayer reminder actions on real hardware, including mark prayed, mark prayed late, snooze rescheduling, and prayer-row focus routing after open.
11. Confirm the new persisted prayer follow-up and snooze settings are surfaced in product UI if they should become user-configurable beyond watch sync truth.
12. Validate watch complication freshness at prayer boundaries and day rollover on device after the Phase 5 timeline scheduling changes.
13. Run real-device Apple Watch Auto Dhikr QA covering pace changes, pause/resume, background interruption recovery, and completion sync reconciliation.
14. Run real-device QA on the new Auto Dhikr complication entry points and confirm `pathofnurwatch://dhikr?mode=auto` opens the intended watch setup state from the watch face.
15. Validate current iOS simulator/native changes and close the duplicate Flutter engine bootstrap investigation.
16. Validate Phase 3 watch flows on device: post-prayer adhkar completion, complication rollover, URL/deep-link routing, and haptic feel tuning.
17. Run the next tvOS parity pass so Home prayer data flow and the Qur'an page keep tracking the current mobile implementation instead of drifting into a separate product path.
18. Migrate legacy formula-based XP consumers to the new `features/journey/xp` ledger so Home, Profile, wallpapers, and watch summaries stop carrying parallel XP truth.
19. Wire the remaining trustworthy XP hooks for Qur'an, learning completion, taraweeh, qiyam, congregation prayer, and Jumu‘ah where existing feature ownership already exposes reliable source references.
20. Localize the new 100 XP level titles in non-English locale ARB files so the XP card stops relying on English fallback outside `app_en.arb`.
21. Migrate remaining trustworthy direct Ocean award call sites to the canonical `features/journey/drops` ledger so Prayer/Learn/Qur'an/Garden/Ocean stop carrying mixed drop ownership.
22. Decide whether Home/watch/Ocean daily drop summaries should read canonical Drops directly or continue to mirror through the Ocean adapter.
23. Add edit flows for custom habit categories and custom habits in the new Growth Habit Settings page so the page is not create/delete-only.
24. Expand the new Growth Habit Calendar with filters, month jump controls, and category-specific review if the first QA pass shows the V1 grid is too shallow.
25. Replace remaining inert related-content chips in secondary learn surfaces once canonical destination mappings exist for every content type.
26. Clarify the incomplete source requirement note `Let the user be able ...` before implementing any behavior tied to it; no guess-based implementation should ship.
27. Replace the V1 Garden fallback artwork with the final curated milestone images under `assets/images/garden/` and validate the fullscreen viewer with real assets.
28. Decide whether the new dedicated `/journey/garden` page should later replace the remaining inline Garden entry cards with richer previews once the final art set is available.
29. Migrate remaining feature-level Qur’an catalogs and tvOS seed data onto `QuranQuoteRef` / `QuranContentRepository` ownership so no active quote/banner surface depends on raw embedded Qur’an Arabic.
30. Add a broader CI-safe Qur’an integrity scan once the remaining manual-review files in `docs/quran_text_audio_integrity_audit.md` are either migrated or explicitly exempted.
31. Finish consolidating Qur'an playback so tvOS can adopt the same Bismillah-first orchestrator path and the remaining reader-owned sample-preview / seek controls are either intentionally exempted or moved behind controller helpers.
32. Decide whether mobile Qur'an playback should auto-advance across surahs, and if yes, route that transition through the centralized Bismillah-first controller path instead of screen-level navigation.

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
11. Consolidate Qur’an quote rendering around `QuranContentRepository` so `quran_reader_page.dart` and any future verse-preview surfaces stop bypassing the higher-level content gateway.

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
11. Feature-owned Arabic verse catalogs outside the canonical Qur’an repository path, especially tvOS, celestial, creation explorer, and onboarding/manual-content surfaces.
