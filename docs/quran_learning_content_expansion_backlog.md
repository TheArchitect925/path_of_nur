# Qur'an Learning Content Expansion Backlog

Date: 2026-03-22

## Next safe enhancements

1. Expand the shared ayah-enrichment layer with curated creation / universe / nature entries first.
   - Why: the repo already has strong World & Creation material with caution notes.

2. Add explicit `interpretationNote` and `sourceSummary` population for curated scientific-signs entries.
   - Why: keeps observational learning from turning into careless proof claims.

3. Add direct enrichment adapters for `quran_universe` verse links where the verse mapping is stable and useful.
   - Why: improves thematic exploration without duplicating lesson text.

4. Expand `seededQuranLearningVerses` or replace it with curated exports from the shared ayah-enrichment layer.
   - Why: the current six-verse study set is too shallow for the hub to feel complete.

5. Add category filters or chips for first-class ayah-learning tracks.
   - Suggested first tracks:
     - `signs_creation`
     - `worship`
     - `character`
     - `mercy_repentance`
     - `prophets_stories`
     - `akhirah`

6. Add a focused widget test for the reader `Learn More` section when enrichment entries exist.
   - Why: protects the new additive UI hook.

7. Add a focused widget test for `QuranReferenceViewer` enrichment rendering.
   - Why: protects the bottom-sheet knowledge handoff.

8. Audit hardcoded strings in `LearnQuranHubPage`, `QuranTopicExplorerPage`, `DivineLifeLessonDetailPage`, and World pages as a dedicated localization pass.
   - Why: Qur'an-adjacent educational surfaces still carry localization debt.

9. Decide whether Qur'an-enrichment entries should become first-class searchable knowledge items in the shared Learn index.
   - Why: the new model is now structured enough to index later without a rewrite.

10. Add curated related-ayah links for:
    - worship
    - character
    - mercy / repentance
    - creation / universe
    - prophets / stories

11. Add difficulty / age suitability metadata if Qur'an learning is going to branch more clearly for kids, teens, and adult reflective study.

12. Run a separate Islamic content review pass before expanding any scientific-signs track significantly.
    - Why: future content needs stronger source discipline and interpretation caution than a normal metadata pass.

13. Replace remaining source-based enrichment domain shortcuts with fully curated canonical domain assignment.
    - Why: the new contract is stricter than the current starter mapping and should eventually be authored, not inferred.

14. Add typed display items for hadith references, prophet connections, and related ayahs through the same shared ayah-detail contract.
    - Why: the mixed-item display model is now ready for more than just enrichment entries.

15. Add focused widget tests for mixed ayah-detail display ordering and caution-state rendering.
    - Why: protects the new display-priority contract from future UI drift.

16. Build a curated `tawhid_belief` pack with strong direct ayahs before expanding lighter thematic tracks.
    - Why: it is the clearest next canonical Qur'an-learning domain after creation, worship, and character.

17. Build a curated `akhirah_accountability` pack with resurrection, reckoning, and moral urgency ayahs.
    - Why: Ayah Insights will feel more balanced once accountability and return-to-Allah themes are first-class.

18. Build a curated `prophets_lessons` pack using only ayahs with clear, direct prophet-linked guidance rather than broad narrative overlap.
    - Why: it will let Ayah Insights connect belief and conduct to prophetic models without turning every story mention into a weak lesson link.

19. Add stronger related-ayah chains across Tawhid, worship, and character packs so Ayah Insights can suggest the next strongest verse connection, not only the primary entry.
    - Why: the canonical display contract is now rich enough for guided ayah-to-ayah learning without needing a separate browse system.

20. Add a balanced mercy-and-accountability related-ayah chain across Akhirah entries so warning-heavy verses can surface adjacent hope-oriented links where the connection is strong.
    - Why: Ayah Insights should preserve seriousness without drifting into one-tone fear-only sequencing.

21. Build a focused `mercy_repentance` pack that complements Tawhid, worship, and Akhirah with clearer return-to-Allah guidance.
    - Why: it is the clearest next pack for balancing accountability with hope using direct ayah-grounded content.

22. Add a focused prophets-related related-ayah chain so direct prophet lessons can suggest the next strongest connected ayah without retelling entire narratives.
    - Why: Ayah Insights should stay lesson-first even when it grows through Qur'anic stories.

23. Add a focused widget test that verifies `prophet_connection` items can coexist with other insight types without crowding out the stronger direct items.
    - Why: mixed-item ordering is now rich enough that prophet-linked display should be protected explicitly.

24. Add focused widget tests for grouped Ayah Insights rendering in the reader and reference viewer.
    - Why: the UI now depends on grouped domain sections, type labels, and subtle caution states instead of a flat list.

25. Consider adding an optional “show more” reveal per Ayah Insights section if future packs make the current per-section cap feel too tight.
    - Why: the grouped structure is intentionally calm in V1, but later packs may justify deeper browsing without flattening the whole section again.

26. Add focused widget tests for the new `/quran/insights` browse page and per-domain listing page.
    - Why: the new browse/discovery flow now owns real Qur'an learning navigation and should be protected against route or localization regressions.

27. Add lightweight domain chips or a calm secondary filter on the browse page only if the category list grows beyond the current six-to-seven domain range.
    - Why: V1 intentionally avoids heavy search, but the browse surface should stay scalable if more first-class insight domains are added.

28. Consider persisting the last-used Ayah Insights browse filters only if repeat browse testing shows clear value.
    - Why: the current filter flow is intentionally lightweight and session-local, but larger enrichment catalogs may benefit from a gentle return-to-context behavior later.

29. Expand related-ayah coverage only through curated pack-level links with explicit relationship reasons, not automatic similarity scoring.
    - Why: the new related-ayah system should stay high-confidence and educational rather than drifting into noisy verse recommendations.

30. Add focused widget tests for the new Ayah Insight paths browse/detail flow, especially the first-ayah start action and ordered step rendering.
    - Why: the new curated path layer now owns real guided-learning navigation and should be protected against route and localization regressions.

31. Expand surah-level insight coverage only where the current Ayah Insight density is already strong enough to form real clusters.
    - Why: the new surah pages should stay concise and educational instead of becoming thin pseudo-tafsir placeholders for every surah too early.

32. Add focused widget tests for `/quran/knowledge-search`, especially grouped results, no-result recovery, and drill-down taps into ayah, path, and surah destinations.
    - Why: the new global Qur'an knowledge search now owns real discovery behavior across multiple structured content types.

33. Consider a very small recent-search or suggested-query layer only if real usage shows the empty state needs more guidance.
    - Why: the V1 search is intentionally calm and local-first, but repeated Qur'an study flows may benefit from one additional lightweight discovery aid later.

34. Add focused widget tests for the new Qur'an personalization cards on `/quran`, `/quran/learning`, and `/quran/insights`.
    - Why: the continue-learning and suggestion surfaces now depend on derived recent-reading plus path/domain state and should be protected against quiet regression.

35. Consider tracking last-opened surah-insight pages only if real usage shows surah-level resume is a clear gap.
    - Why: the current personalization layer stays intentionally lean and path/domain-focused, but surah-insight resume may become useful once the surah catalog grows.
