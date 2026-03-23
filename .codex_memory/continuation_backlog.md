# Continuation Backlog

Last updated: 2026-03-23

Master consolidation reference:

- Use `docs/master_execution_roadmap_2026-03-22.md` as the current top-level execution view for recent kids-system, progression, Learn routing, worship/date, and regression-hardening work.
- Keep this backlog as the rolling engineering queue, but prefer the master roadmap when deciding phase order or explaining overall project state.

## Top 10 immediate engineering continuation items

1. Finish the remaining live-surface localization payoff by retiring the last Wudu reward-helper bridge method cleanly, and replace the newly propagated Wudu/Kids Arabic non-English ARB fallback text with real translations.
2. Localize `SettingsPage` end-to-end, including hardcoded section titles, action labels, helper copy, and snackbar/dialog text.
3. Localize `AccountsProfilesSyncPage` and the main accounts/sync subpages so settings-first navigation does not land on English-only surfaces.
4. Finalize the canonical Learn ownership decision between `/learn`, `/learn/legacy`, and `/learn/browse`, then remove one layer of overlap.
5. Finish the remaining Qur'an ownership cleanup by localizing and tightening the scoped `/quran/learning` surface, then audit older Learn-side wording that still implies `Qur’an Study` as a parallel owner.
6. Replace the contained Learn guide/mapping routes with real lesson-backed or route-specific production content, and localize the newly live Tajweed lesson bodies.
7. Add widget tests for `LearningJourneyHomePage` covering Continue Journey, Today’s Light, and profile-aware visibility.
8. Add tests for progress reload when journey/stage IDs are removed or changed in the registry.
9. Refresh the root `README.md` with real product/setup/release information.
10. Audit the settings-to-accounts-sync route flow so all new settings ownership paths are coherent and no Profile-tab assumptions remain.
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
33. Extend the new Kids Arabic mastery map with optional parent-facing summaries, review-aging cues, and mastery milestone badges if user testing shows the current child-facing progress view is not enough on its own.
34. Expand the new Kids Arabic beginner-words bridge with the next short-word pack, optional word-to-letter deep links, and final tuning of word-level audio/celebration polish once the first QA pass confirms the current three-word set lands well.
35. Expand the new Kids Arabic reading mode with the next calm word-card pack, optional autoplay preference, and a last-viewed-word resume hint if families want a faster repeat-listen loop without turning it into a quiz surface.
36. Decide whether the new Kids Arabic practice loop should later track explicit unfinished word sessions or keep relying on the current unlocked incomplete-word heuristic to avoid extra persistence complexity.
37. Decide whether the new Kids Arabic audio-learning layer should stay TTS-first or adopt bundled kid-safe pronunciation assets for letters and starter words while preserving the current autoplay/repeat UX as the shared fallback path.
38. Decide whether the new Kids Arabic achievements layer should surface a lightweight unseen-achievement chip on the home page or remain rewards-page-first so celebration stays visible without becoming noisy.
39. If families want more parent visibility, add a calm weekly achievements summary on the mastery/progress route using the derived milestone model instead of a separate reporting dashboard.
40. Decide whether Growth Statistics should gain a full report-detail route or stay share-first after QA reviews the new weekly/monthly report cards.
41. Revisit Growth Statistics once repo-wide localization generation drift is repaired so the new ARB keys can move off the local extension shim and the blocked focused widget tests can run cleanly.
42. Decide whether Kids Qur’an should gain its own kids-safe search and lightweight recitation controls or remain a simpler browse-first layer over the existing surah list.
43. Expand Kids Hadith Stories only with additional source-backed stories that pass child-scope review, rather than branching into a parallel unreviewed story corpus.
44. Revisit the FAQ detail/category pages once repo-wide localization drift is repaired and localize the remaining hardcoded FAQ labels and error copy safely.
45. Replace the last local Wudu reward-feedback localization helper with generated `AppLocalizations` formatting once the shared formatting pattern is settled, then keep the Wudu widget/router tests in the green slice.
46. Add a dedicated widget test for the live `QuranReflectionsPage` writing-surface onward actions so the new Learn Notes / Journal links remain intentional.
47. Decide whether Learn Notes browse should also surface Qur’an reflections as first-class items or stay intentionally limited to Qur’an notes plus journal entries.
48. Decide whether journal detail should eventually support delete/archive after product review, while preserving the new `/journal/entry/:entryId` drill-in route as canonical.
49. Replace the remaining English-fallback ARB values added for the writing-system pass with real non-English translations.
50. Decide whether `/learn/legacy` should become a redirect, a contained state, or a fully archived compatibility surface once the hidden `LearnCategoryCatalog` entries are either re-owned or retired.
51. Audit remaining `learnLegacy` references in `LearningJourneyRegistry` and lesson-content metadata so compatibility-only legacy routes stop appearing in any future surfaced journey/tool recommendations.

## Top 10 cleanup / consolidation items

1. Remove dependency on `LearnPage` as a long-term fallback for unsupported learn sections, then decide whether `/learn/legacy` should remain a compatibility route or become fully archived.
2. Reduce duplicate Qur'an ownership across `/quran*` and `/learn/quran*` by documenting canonical paths and trimming new alias use.
3. Audit `LearnCategoryCatalog` hidden/placeholder items and either archive them more explicitly or promote only the ones with real implementation owners.
4. Reduce remaining legacy Learn tool links inside `LearningJourneyRegistry` where real route-specific destinations now exist.
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
12. Add widget tests for the crossword puzzle screen, especially clue solve detection, reward dedupe, and completion-state rendering.
13. Decide whether child profiles should receive a kids-only daily crossword instead of the current adult-owned daily mode being hidden from child mode.
14. Expand crossword clue sourcing from history, glossary, and character/adab content if the engine becomes a long-term discovery surface.
15. Continue the RTL/layout audit beyond shared scaffolds by converting remaining LTR-only padding/alignment assumptions in lower-priority feature widgets to directional equivalents.
16. Run a dedicated multilingual visual QA sweep on Arabic, Urdu, German, and English for high-traffic screens, especially bottom navigation, settings rows, mixed-content cards, and Quran/search surfaces.
17. Decide whether Urdu should keep sharing `Noto Sans Arabic` or move to a dedicated Urdu UI font in a later controlled typography pass.
