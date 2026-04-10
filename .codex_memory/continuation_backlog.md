# Continuation Backlog

Last updated: 2026-04-03

Master consolidation reference:

- Use `docs/master_execution_roadmap_2026-03-22.md` as the current top-level execution view for recent kids-system, progression, Learn routing, worship/date, and regression-hardening work.
- Keep this backlog as the rolling engineering queue, but prefer the master roadmap when deciding phase order or explaining overall project state.

## Top 10 immediate engineering continuation items

1. Finish the remaining live-surface localization payoff by retiring the last Wudu reward-helper bridge method cleanly, and replace the newly propagated Wudu/Kids Arabic non-English ARB fallback text with real translations.
2. Localize `SettingsPage` end-to-end, including hardcoded section titles, action labels, helper copy, and snackbar/dialog text.
3. Replace the newly added Accounts, Profiles & Sync non-English ARB fallback text with real translations and run multilingual QA on the account/backup/import flows.
4. Follow up the Windows audit in `docs/windows_store_readiness_audit_2026-04-03.md`: fix desktop device-kind mapping, decide honest Windows V1 scope, add MSIX/store packaging docs, and validate desktop-specific QA before any Microsoft Store submission claim.
5. Run real-device QA for Phase 2 remote backup transport on signed Apple and Google builds, including iCloud unavailable, revoked Google auth, remote metadata fetch, upload, download, and confirmed restore flows.
6. Run real-device QA for the new auto-backup engine on iOS and Android, especially launch/resume/background triggers, provider-unavailable states, and throttle behavior after repeated local changes.
7. Implement the backend-backed email remote backup transport behind the shared `BackupTransport` contract instead of adding a separate backup architecture.
8. Add widget tests for the remote restore preview page and the new auto-backup settings/status card, especially provider/account mismatch warnings, replace-only domain messaging, retry visibility, and failure-state rendering.
9. Decide whether future backup payloads should carry per-domain last-modified metadata so currently approximate snapshot domains can move out of `uncertain difference` status and payload-fingerprint dirty tracking can become more selective.
10. Run real-device QA for granular sync-scope controls on Apple and Google backup paths, especially partial backup upload, scope mismatch restore preview messaging, and excluded-domain preservation after partial restore.
11. Decide whether manual export should stay full-only or optionally support the same sync-scope controls without making the backup model harder to understand.
12. Finalize the canonical Learn ownership decision between `/learn`, `/learn/legacy`, and `/learn/browse`, then remove one layer of overlap.
13. Finish the remaining Qur'an ownership cleanup by localizing and tightening the scoped `/quran/learning` surface, then audit older Learn-side wording that still implies `Qur’an Study` as a parallel owner.
14. Run product and test QA on the new Learn three-card hub (`/learn`, `/learn/learning-path`, `/learn/self-learning`, `/learn/kids-preview`), especially onboarding-derived level defaults, kids preview safety, and the new settings handoff row.
15. Replace the contained Learn guide/mapping routes with real lesson-backed or route-specific production content, and localize the newly live Tajweed lesson bodies.
16. Add widget tests for `LearningJourneyHomePage` covering Continue Journey, Today’s Light, and profile-aware visibility.
17. Add tests for progress reload when journey/stage IDs are removed or changed in the registry.
18. Refresh the root `README.md` with real product/setup/release information.
19. Finish real-device QA for Apple/Google sign-in, export/share, file-based import, and safety-snapshot restore recovery on the intended release platforms.
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
26. Decide whether the new companion-surface saved state should later surface cross-entry suggestions on Home or stay intentionally local to `/learn/seerah`, `/learn/character`, and `/learn/daily-wisdom`.
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
52. Add explicit redirect query-forwarding tests for the main compatibility Learn aliases now that the route builders are split across `lib/app/routes/learn/`.

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
18. Audit hidden `learnLegacy` tool links in Learning Journey metadata and replace only the clearly safe ones with canonical feature-owned destinations.
19. Add focused redirect-integrity coverage for remaining Journey/Growth compatibility aliases beyond the Learn aliases covered in Phase V5.
20. Decide whether hidden `jummah`, `eid`, and `funeral` catalog items should gain specific canonical destinations or remain intentionally archived behind `learnLegacy`.
21. Decide whether `/learn/seerah` should next add deeper period-specific modules such as Hudaybiyyah, Conquest of Makkah, and Farewell Hajj, or stay intentionally compact for the first public beta.
22. Decide whether `/learn/character` should gain a lightweight “practice this today” layer or remain a curation-first companion without action tracking.
23. Decide whether `/learn/daily-wisdom` should surface on Home as a secondary handoff card now that the rotation and source-owner structure are stronger.
24. Decide whether companion-surface personalization should stay feature-scoped or later grow into shared “continue where you left off” learn-level discovery, without turning it into a recommendation system.
25. Decide whether companion-surface source chips should later become tappable owner filters on `/learn/seerah` and `/learn/character`, or remain visual guidance only.
26. Decide whether `/learn/seerah` should next add one more curated layer for Hudaybiyyah, Conquest of Makkah, and Farewell Hajj, or keep the current five-period guide intentionally compact.
27. Decide whether the Seerah -> Qur'an-linked study handoff should eventually use a narrower Seerah-specific Ayah Insights owner instead of the current `prophets-lessons` bridge.
28. Decide whether `/learn/character` should next deepen the new `work-study-pressure` lane with one more curated layer, or stay intentionally compact after the first scenario-depth pass.
29. Decide whether Character scenario owners should later deep-link into narrower Hadith theme or Ayah Insight starter states instead of the current route-level owner pages.
30. Decide whether `/learn/daily-wisdom` should eventually add a small owner-diversity rule to the actual daily rotation so nearby featured days avoid clustering too many entries from the same owner as the dataset grows.
31. Decide whether Daily Wisdom should later gain a small number of history-owned or season-aware entries, or stay intentionally focused on evergreen Qur'an, Hadith, Seerah, Character, and Divine Life reminders.
32. Expand curated Qur'an reference-graph coverage for more ayahs now that the reader's visible `Learn More` chips rely on graph-backed links instead of the retired keyword matcher.
33. Expand the new Qur'an thematic-map layer only through explicit high-signal theme seeds and representative ayah/surah mappings, not broad keyword/topic auto-matching.
34. Decide whether reader ayah chips should later show light source-category cues such as Hadith, Character, Signs, Prophets, and Paths, or remain title-only to keep the card quieter.
35. Broaden seeded surah-insight coverage beyond the current starter surahs if the new surah preview cues prove useful in the reader.
36. Add more explicit no-link and no-theme regression tests for Qur'an enrichment so broad prophet/path/theme fallbacks do not reappear through future graph edits.
37. Add more explicit curated `relationReason` text for the strongest Qur'an related-link routes so the new explanation sheet relies less on category-level fallback wording.
38. Decide whether Qur'an theme chips should later open a matching lightweight explanation sheet before the full thematic detail page, or remain direct-to-theme for speed.
39. Expand the new Surah Study Hub structure to additional high-value surahs only through explicit curated significance, reflection-prompt, related-theme, and related-learning mappings rather than generic auto-fill.
40. Refactor the remaining adult Qur'anic Arabic audio manifest and any residual Arabic-learning static mappings to derive from the shared `lib/features/arabic/` alphabet catalog now that Kids, adult seeds, and positional forms share canonical ids/order.
41. Build the next Arabic-learning phase on top of the new shared positional-form foundation, especially reusable word-shaping helpers for Kids phrase cards, adult beginner reading helpers, and joined-letter practice without duplicating per-word glyph strings again.
42. Decide whether the shared Arabic foundation should next add a very small pronunciation-contrast layer such as soft/heavy and throat-letter hints, but only if a real Kids or adult teaching surface needs it.
42. Expand Journey ↔ Qur'an contextual entry only through explicit lesson-stage mappings and real Qur'anic anchors, especially if future Yusuf, Al-Kahf, or companion-surface stages need surah-first study entry instead of verse-first entry.
43. Add richer explicit relation-reason copy for the new Qur'an → Journey lesson links so the reader detail sheet can name the exact lesson angle instead of relying on the generic learning-journey fallback reason.
44. Run on-device QA for the new Qur'an reader hierarchy on small screens, large text, and VoiceOver/TalkBack to confirm the grouped `Learn More` chips and reordered Journey/surah cards stay calm and readable.
45. Decide whether memorization review should later support surah-level saved sets or remain intentionally ayah-first until the lightweight `quran/review` flow proves clear in real use.
46. Consider one optional memorization-focused reader density preset only if real-world QA shows the new memorization review entry still feels visually busy during repetition sessions.
47. Decide whether adaptive reader mode choice should persist locally after manual switching, or remain entry-driven so Journey, memorization, and theme routes always control emphasis predictably.
48. Add a few explicit `mode=study` and `mode=theme` route handoffs from Surah Insights, Qur'an Topics, and future high-intent Journey lessons if those entry points prove more valuable than current mode inference alone.
49. Run dedicated UX QA for adaptive reader modes on small screens and large text to confirm the new focus card, mode menu, and per-mode density changes remain calm and accessible.
50. Decide whether the new memorization rhythm sections should eventually explain themselves more explicitly with a small helper line, or stay label-only to keep the review surface quieter.
51. Evaluate whether Qur'an hub or Journey should later surface a tiny non-intrusive “review today” cue when memorization items are due, but only after real use confirms it adds value.
52. If memorization lists grow materially, consider one lightweight sort/filter layer for the review surface rather than adding a more complex scheduler.
53. Decide whether the new `/quran/paths` owner should surface one lightweight `Continue your path` card on the main Qur'an hub after product QA confirms it adds value without clutter.
54. Expand the guided Qur'an learning path catalog only through explicit curated routes, especially one Surah Yusuf path, one Al-Kahf path, and one stronger memorization-support variant if current V1 paths prove useful.
55. Decide whether Qur'an paths should later participate in shared search/discovery metadata, or remain a browse-only guided owner until the catalog is larger.
56. Decide whether the new Qur'an credibility labels should later appear on thematic-map, surah-insight, and path-level related-learning cards, or remain detail-sheet-first to keep those surfaces calmer.
57. Expand explicit relation-reason copy for the strongest Hadith, Seerah, and Journey links so the credibility layer relies less on generic knowledge-type fallback wording.
58. Decide whether `/quran/daily` should later keep a tiny recent-days archive or remain intentionally today-only after product QA confirms how often users want to revisit yesterday's companion flow.
59. Evaluate whether the new Daily Qur'an Companion should surface one small due-review or continue-path cue on the main Qur'an hub only, without turning Home or Journey into a reminder surface.
60. Expand the new Journey ↔ Theme mapping layer only through explicitly anchored stages, especially `duas-daily-life`, `seerah-madinah-society`, and future Yusuf / Al-Kahf study journeys, rather than broad journey-tag matching.
61. Decide whether mapped theme detail pages should later surface one matching Qur'an learning path card when a Journey-stage mapping and a path both align cleanly, starting with gratitude and patience.
62. Add more stage-specific relation-reason copy for mapped Journey links so the reader detail sheet can explain the exact lesson angle instead of relying on the generic Journey fallback text.
63. Run on-device QA for the new Qur'an focus selector and intent-aware daily companion actions on small screens, large text, and screen readers to confirm the personalization layer stays calm and reversible.
64. Decide whether the saved Qur'an focus should later surface on `/quran/daily` and `/quran/paths` as a tiny change-focus control, or remain intentionally hub-owned to avoid spreading preference UI across too many surfaces.
65. Consider one minimal Learn-side Qur'an recommendation card keyed off the saved intent only after product QA confirms the main `/quran` focus card materially improves discovery without adding noise.
66. Decide whether the Home daily preview should later show one tiny Journey/theme cue from the unified daily loop summary, or remain intentionally preview-light until QA confirms the extra context is worth the density.
67. Expand Journey-aligned daily ayah selection only through explicitly mapped stages that already have strong Qur'anic anchors, especially `duas-daily-life`, `seerah-madinah-society`, and future Surah Yusuf / Al-Kahf study journeys.
68. Evaluate whether the unified daily loop should later rotate among a tiny curated set of alternate ayahs per mapped Journey stage so long-running active journeys do not repeatedly surface the same daily verse.
69. Decide whether the new `/quran` hub recommendation section should later allow one soft dismiss-for-today behavior for fallback cards, or remain fully passive if QA shows the current density is already calm enough.
70. Expand fallback hub recommendations only through explicit curated defaults, such as one or two more stable theme-study suggestions or one recent-theme continuation, rather than adding opaque scoring.
71. Run on-device QA for the new recommendation rows on small screens, large text, and screen readers to confirm the title/subtitle/reason stack stays readable and the hub still feels calm near the top.
72. Expand the new high-depth theme layer only through explicit curated themes such as humility, prayer, and akhirah after the current eight flagship topics are QA'd for coherence and real study value.
73. Add theme-detail widget coverage for the new study-framing card so future topic-map edits do not quietly remove `Why this theme matters`, `What to notice`, best-mode guidance, or the primary study CTA.
74. Decide whether the strongest flagship themes should later surface one compact “best next surah” card instead of only related-surah chips, starting with patience, gratitude, remembrance, and sincerity.
75. Expand Kids Arabic mini phrases only through another small curated pack after family QA confirms the first six phrases land well without turning the feature into a vocabulary treadmill.
76. Decide whether mini phrases should later gain one optional phrase-to-meaning matching card, or remain listen-and-repeat only to keep early reading confidence calmer.
77. Evaluate whether bundled child-safe phrase audio should replace or supplement TTS for the mini-phrase flow while preserving the current local fallback behavior.
78. Add widget-level coverage for the adult Arabic section overview and adult shared-letter lesson support card so future copy/layout changes do not silently remove the new shared-foundation visibility.
79. Decide whether adult Arabic should next gain a dedicated alphabet browser surface or remain section-first if the new overview card and next-step guidance prove sufficient in QA.
80. Consider one lightweight adult pronunciation-contrast helper for heavy/light and throat letters, but only if it can stay grounded in the shared alphabet foundation and avoid a grammar-heavy expansion.
81. Decide whether the new shared Arabic audio foundation should next absorb stable adult harakah/word/phrase audio metadata, or remain letter-only until broader coverage is consistent enough to avoid a half-shared manifest.
82. Add widget-level coverage for at least one Kids letter replay path and one adult letter-audio action so future playback refactors cannot silently bypass the shared letter-audio lookup layer.
83. Evaluate whether Kids Arabic should later add bundled child-safe letter audio on top of the current TTS path while preserving the shared manifest as the canonical lookup source and keeping the child UX calm.
84. Add widget-level tracing-pad coverage for a dot-family letter, a loop/curve-heavy letter, and a multi-stroke late-alphabet letter so the new full vector-tracing expansion cannot regress quietly.
85. Run on-device Kids tracing QA across small phones and tablets to confirm the newly promoted late-alphabet vector letters still feel smooth, forgiving, and visually consistent with the earlier tracing set.
86. If family QA identifies any “too hard” letters after the full tracing pass, tune thresholds per letter rather than branching the tracing engine or reintroducing a second scoring path.
87. Expand the new shared Arabic beginner-content catalog only through another small high-signal pack of words and phrases, and keep any additions grounded in safe letter decomposition and existing adult/Kids learning needs.
88. Decide whether shared beginner words/phrases should next move to localized gloss keys for adult Arabic instead of continuing to rely on English seed meanings in the shared/adult layer.
89. Add one shared joined-word display helper on top of the new catalog so future Kids reading cards and adult beginner reading helpers stop rebuilding word-shaping visuals in feature-local code.
90. Decide whether adult Qur'anic Arabic should next add a small shared mini-phrases surface beside the new beginner-words guide, or keep the adult flow intentionally word-first for now.
91. Add one optional adult letter-tap replay interaction inside the beginner-words helper only if it stays calm and does not turn the page into a quiz or grammar drill.
92. Run on-device QA for the new adult beginner-words page on small screens, large text, and VoiceOver/TalkBack to confirm the joined-letter cards and previous/next controls stay readable.
93. Run on-device QA for the new shared Arabic resume cards on Kids and adult entry surfaces, especially small screens, large text, and screen readers, to confirm the primary and secondary actions stay clear without crowding the cards.
94. Decide whether Kids Arabic should start persisting `last opened word` separately from `last completed word` so the shared continuity layer can resume unfinished reading-mode work more precisely.
95. Decide whether adult Qur'anic Arabic should later expose a tiny shared “resume from beginner words” handoff inside the daily review surface, or keep resume ownership confined to the main adult section page.
96. Run on-device QA for the new shared Arabic gentle review buttons on Kids and adult entry surfaces, especially large text and screen readers, to confirm the extra actions remain calm and readable.
97. Decide whether the gentle review layer should later surface a dedicated adult phrase-review suggestion once adult shared mini phrases exist, or stay lesson/word/review-only for now.
98. Decide whether Kids Arabic should later treat `heard but not repeated` mini phrases differently from fully revisited phrases, or keep the current single calm review suggestion model.
99. Replace the current shared Arabic TTS fallback for the strongest Kids mini phrases and adult shared beginner words with bundled pronunciation assets only where the asset quality is clearly better and coverage is stable enough to stay consistent.
100. Add a compact shared active-playback visual state to adult lesson and review audio buttons so adult playback feels as clearly “live” as the Kids pulse/highlight surfaces without adding louder UI.
101. Decide whether the shared Arabic playback controller should next absorb stable adult harakah and phrase-review audio packs, or stay limited to letters plus shared beginner words/phrases until broader audio coverage is normalized.
102. Run on-device QA for the new shared Arabic normal/slow playback toggle across Kids lessons, Kids reading/phrases, adult beginner words, and adult lessons, especially interruption handling, volume consistency, and large-text layouts.
103. Add one bundled recitation-quality snippet-audio pack for the Qur’an Readiness bridge so the bridge can prefer real recitation audio over phrase assets or TTS fallback while still staying lighter than the full reader.
104. Run on-device QA for the new Kids and adult Qur’an Readiness bridge surfaces on small screens, large text, and screen readers, especially the highlighted ayah context and the verse deep-link tile.
105. Decide whether the bridge should next add one tiny post-completion handoff into Surah Al-Fatihah or another curated short-surah surface, or remain intentionally self-contained until the first snippet set is validated in product QA.
106. Run on-device QA for the new shared Arabic search/filter sections on Kids Arabic home and adult Qur’anic Arabic, especially typing latency, large text, and screen-reader order once real device keyboards are involved.
107. Decide whether adult Qur’anic Arabic should next fold lesson/module titles into the shared Arabic discovery index so one search field can fully replace the remaining module-only search assumptions.
108. Decide whether Kids Arabic should later gain a lighter non-typing browse shortcut row for letters/words/phrases if family QA shows filters are used more than typed queries.
109. Add widget-level coverage for the new adult Arabic progress dashboard card so future layout and copy changes cannot quietly remove the recent-activity or next-step summary rows.
110. Decide whether adult Arabic progress should later distinguish `covered`, `opened`, and `completed` word states once the adult beginner-word flow tracks more than the current calm last-opened signal.
111. Run on-device QA for the new Kids and adult Arabic progress dashboard cards on small screens, large text, and screen readers, especially the chip row and two-button layout.
112. Decide whether Qur’an Readiness bridge coverage should later display as its own calm snippet count instead of being grouped under phrase coverage once the bridge set grows beyond the current starter pack.
113. Decide whether the shared Arabic offline bundle should next ship a guaranteed bundled starter audio pack for the highest-value letters, shared words, and mini phrases instead of continuing to rely primarily on graceful manifest-checked fallback.
114. Add one widget-level regression test for the adult Arabic landing page so future offline warmup changes cannot quietly break startup or route-owned section rendering.
115. Run airplane-mode QA for Kids Arabic home, adult Qur’anic Arabic, beginner words, mini phrases, and Qur’an Readiness on real devices to confirm first-play timing and fallback behavior outside the test harness.
116. Decide whether the shared Arabic offline warmup helper should later persist a per-launch warmed state if real-device profiling shows repeated landing-page prewarm work is measurable.
117. Add one widget-level level-switching test for the expanded Qur’an Readiness bridge so future UI changes cannot quietly break the three-stage progression chips.
118. Add one bundled recitation-quality snippet audio pack for the strongest Qur’an Readiness bridge entries so the expanded bridge can prefer real recitation over phrase-pack overlap or fallback behavior.
119. Decide whether the expanded Qur’an Readiness bridge should next hand off into one curated short-surah study surface after completion, or remain intentionally self-contained until the larger snippet pack is validated in product QA.
120. Add one beginner-safe bridge snippet that naturally carries `ghunnah` so the light Tajweed hint layer can connect to the existing `ghunnah_intro` lesson without inventing synthetic examples.
121. Add one beginner-safe bridge snippet that naturally carries `noon saakin` so the Tajweed hint layer can eventually cover all three existing adult Tajweed basics lessons.
122. Add widget-level route tests for linked bridge hints so adult hint taps prove they open the intended Qur’anic Arabic lesson and Kids hint taps prove they open the `tajweed-basics` journey stage.
123. Add one adult widget-level accessibility test for the new shared lesson-pack section so future section-page refactors cannot quietly strand grouped adult Arabic entry points.
124. Add one widget-level route/flow test for the shared Arabic mini-assessment page once the shared shell test harness is stable enough to exercise the full intro-question-completion sequence without brittle router/scaffold assumptions.
125. Decide whether the shared mini-assessment generator should later rotate practice seeds by day or persist the last-used seed so quick practice avoids repeating the same short set too often while still staying deterministic and offline-safe.
126. Decide whether an adult-only `match meaning` recognition question should join the shared mini-assessment layer later, or whether the current `see -> choose` and `hear -> choose` coverage should remain intentionally minimal.
127. Run on-device QA for the new Kids and adult quick-practice cards plus the shared assessment page on small screens, large text, screen readers, and offline mode to confirm tap targets, audio replay, and completion CTAs remain calm and readable.
128. Add one widget-level short-surah page playback/navigation test once there is a stable fake Qur'an player harness for bridge-owned playback surfaces.
129. Add one bundled recitation-quality offline starter pack for the short-surah readiness surface so the first complete-surah experience is less dependent on network Qur'an audio resolution.
130. Decide whether Al-Fatihah should later join the short-surah bridge as an optional “next full surah” step or stay outside the very-short-surah pack.
131. Run on-device QA for the new Kids and adult short-surah bridge surfaces on small screens, large text, and screen readers, especially the ayah cards, play button state, and reader handoff button.
124. Add one widget-level scroll/regression test for the refreshed Kids Arabic parent dashboard so future layout changes cannot quietly remove the weekly consistency or parent-guidance cards.
125. Decide whether the parent-friendly Kids Arabic overview should later expose one quiet deep link into the progress map, or stay intentionally CTA-light with only continue/review actions.
124. Decide whether the shared Arabic continuity layer should later recommend lesson packs directly in a few cases, or remain intentionally item-first with packs reserved for discovery and grouping only.
125. If Arabic content expansion accelerates, decide whether pack search should eventually show pack-result previews grouped by audience/type rather than staying in the same flat result list as item-level search hits.
126. Decide whether short-surah readiness should join the shared Arabic search index directly or stay bridge-entry-only until the current route-owned entry cards are validated on device.
127. Add a lightweight CI-safe validator that checks `ArabicContentPackComposition` unit ids against the shared authored content-unit layer so future pack additions cannot silently reference missing content.
128. Decide whether adult Qur'anic Arabic lesson-step and quiz-step detail should later normalize into the shared Arabic content-authoring layer, or stay intentionally owned by the richer teaching catalog.
129. Add one widget-level regression test for the adult Arabic landing page so future refactors cannot quietly remove the new calm overview card or its browse actions.
130. Decide whether the adult Arabic overview should later gain a dedicated detail page, or stay intentionally landing-page-first with the current calm summary card.
131. Run on-device QA for the adult Arabic overview on small screens, large text, and screen readers, especially the two-button action row and browse-links wrap.
132. Add a real iOS/Android home-screen widget owner for the shared Arabic quick-resume payload so the Phase 52 `home_widget` bridge renders a production widget instead of only syncing offline-ready data.
133. Add one widget-level route test for the shared Arabic quick-resume section on Kids and adult Arabic landings so future layout refactors cannot quietly break the primary or review actions.
134. Run on-device QA for Arabic app-icon shortcuts after progress changes, locale changes, and offline cold starts on both iOS and Android.
135. Add bundled recitation-quality offline audio for the guided Al-Fatihah passages so the advanced bridge depends less on network Qur'an audio resolution.
136. Decide whether the guided-passage bridge should next add one second single-surah passage family beyond Al-Fatihah, or stay intentionally focused until on-device QA validates the current step-up.
137. Add one widget-level route test from the short-surah bridge CTA into the guided-passage page once the bridge-shell test harness is stable enough to exercise cross-page navigation cleanly.
138. Decide whether guided passages should join the shared Arabic discovery index directly, or remain entry-card-first until the current bridge-owned discovery path is validated on device.
139. Expand the shared Arabic beginner-content catalog with one more small, curated theme-ready set of words only after QA confirms the new daily/prayer/Qur'an-linked packs still feel focused.
140. Add one widget-level adult Arabic landing regression test that proves the new themed vocabulary packs remain visible in the shared lesson-pack section after future layout refactors.
141. Decide whether the Qur'an-linked vocabulary theme card on the readiness bridge should later add one tiny “heard in this bridge” preview row, or stay title/subtitle-first to preserve the calm bridge presentation.
142. Decide whether shared Arabic search should later group lesson-pack results by theme/review/bridge type once the pack catalog becomes larger than the current starter set.
143. Add one widget-level regression test for the adult Arabic review page so future localization or filter changes cannot quietly break replay-audio handling, segmented filters, or completion copy.
144. Run launch-readiness device QA for Arabic learning on large text, VoiceOver/TalkBack, and airplane mode across Kids home, adult Arabic landing, review, Qur'an readiness, short surahs, and guided passages before treating the bridge stack as release-ready.
145. Extract the reader now-playing label and any remaining user-facing playback copy out of `quran_reader_playback_controller.dart` so the shared playback-state layer becomes fully presentation-agnostic and localization-owned.
146. Add a fuller fake-player widget harness around the real `quran_reader_page.dart` route so page-level playback, reciter switching, and highlight persistence are protected without relying only on the lightweight controls/ayah-card harness.
147. Move the word-timing lifecycle coordination out of `quran_reader_page.dart` into a dedicated reader word-sync coordinator once the shared playback-state boundary is proven stable on device.
148. Audit watch/tvOS Qur'an playback consumers against the new normalized playback-state contract before mirrored playback surfaces evolve further, so active-ayah/session drift does not reappear on companion targets.
253. Run real-device QA for the new Qur'an shell mini-player, especially background playback, route transitions, long-title truncation, and reader re-entry on small phones.
254. Add a real router-backed test for previous/next surah transitions from the reader so adjacent-surah navigation is protected beyond the current controller/global-state coverage.
255. Decide whether whole-surah repeat should become a first-class surfaced playback mode or remain limited to repeat-range plus loop-count configuration until device QA validates the simpler contract.
256. Review watch/tvOS Qur'an playback consumers against the newer global mini-player and normalized transport metadata contract so mirrored playback surfaces do not regress into shell-vs-reader drift.
257. Add a real route-backed retry harness that exercises a normalized source failure, visible retry action, and successful recovery on the full Qur'an reader route.
258. Run signed-device QA for corrupt local files, airplane-mode streaming failure, buffering timeout, mid-play reciter switching, and session restore with unavailable audio so the new resilience contract is validated outside the fake-player harness.
259. Decide whether to expose a user-facing downloaded-vs-streaming source preference after the current automatic fallback behavior is validated on device.
260. Cache recent bad-source outcomes per ayah/reciter so adjacent ayah and adjacent surah transport do not keep choosing the same known-bad source path in a tight failure loop.
261. Review watch/tvOS Qur'an playback consumers against the new source/failure/buffering/retry contract so mirrored playback surfaces do not assume playback is only idle, paused, or playing.
