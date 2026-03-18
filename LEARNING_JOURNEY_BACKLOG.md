# Learning Journey Backlog

Last updated: 2026-03-17

## Priority Queue

1. Redesign `/learn` into a journey-first entry with one primary next step, one continue card, and progressive disclosure for everything else.
2. Collapse overlapping learning systems (`learn/content`, `divine_life_lessons`, `life`, `world`, `hadith`, unified search) into one clearly owned information architecture.
3. Replace placeholder category links with explicit planned-state cards so users do not tap into dead-end or generic hub pages.
4. Split Qur'an reading, Qur'an study, and Qur'anic Arabic into clearer paths with less duplicated entry points.
5. Convert Prophets, Hadith, and Trivia into guided progression ladders with visible stage completion instead of broad menu-style browsing.
6. Audit all learning persistence models and unify continue-learning, saved, notes, and progress behavior across domains.
7. Remove or archive unused legacy Learn widgets/providers that are no longer referenced by the active router.
8. Add scholar/content verification metadata to more learning surfaces, especially where seeded or scaffold content still exists.
9. Finish the Dua dataset by separating verified live entries from scaffold-only stubs at the routing and UI level.
10. Define a kids-safe learning mode explicitly or remove kids-related hints from Learn summaries until a real mode exists.

## Secondary Improvements

- Add a domain-by-domain content completeness dashboard.
- Add a single shared "learning path" model for Prophets, Hadith, Trivia, Qur'anic Arabic, and Salah learning.
- Add stronger test coverage for trivia state, prophets state, and unified learn search/progress.
- Review large landing pages for widget density, rebuild scope, and scroll fatigue.
- Map learning actions into Journey XP, badges, and missions more intentionally instead of relying mostly on Ocean drops.

## Journey Node Follow-Up

- Add full translated lesson-copy coverage for the newly strengthened Arabic, Salah, Wudu, Hadith, Trivia, and Ramadan journey stages so non-English locales stop falling back to English lesson bodies.
- Add full translated lesson-copy coverage for the newly strengthened Qur’an, Al-Fatihah, short-surah, and completion-stage lessons so the unified Qur’an experience works cleanly outside English.
- Add precise secondary Qur’an tool entry points for `Topics`, `Top Words`, and `Word Review` inside the journey lessons once those routes are finalized as explicit support surfaces.
- Add completion-stage coverage for Daily Dhikr and Duas for Daily Life so the full worship cluster has the same closure pattern now used by Qur’an, Arabic, Salah, and Wudu journeys.
- Add route-aware deep links from the new lesson wrappers into more precise Salah detail, Arabic listen-only, and trivia-session destinations once those surfaces expose stable route contracts.
- Add focused widget tests for the newly expanded Reading Basics and Ramadan Foundations stage counts so future registry edits do not silently shrink the journeys again.
- Design a real Journey rings detail screen to replace the removed `journey-rings` placeholder concept.
- Design a real Journey streak detail screen to replace the removed `journey-streak` placeholder concept.
- Design a real Journey milestones detail screen to replace the removed `journey-milestones` placeholder concept.
- Design a real Journey unlocks detail screen to replace the removed `journey-unlocks` placeholder concept.
- Decide whether Ocean remains a Journey node that deep-links into the existing `oceanDrops` destination or becomes a sub-surface inside Journey.
- Split `Legacy Learning Material` into final island ownership gradually, mapping each existing Learn section to either a Journey island, Qur'an, Settings support flow, or archive bucket before deleting the legacy route.
- Fill the new Learning Journey stage shells in this order: Seerah, Daily Dhikr, Foundations of Faith, Fiqh Basics, Timeline of Islam, then Tajweed Basics.
- Add richer stage-to-stage completion state once the first real journey infill lands, instead of treating the current registry as static.
- Decide whether the Learn tab should later land on `/learn/journey-home`, `/learn/browse`, or remain a legacy-first entry until more stages are real.
- Expand the Seerah journey with a visual timeline, map moments, and event-by-event continuity between Makkah and Madinah.
- Add audio recitation and memorization support for the new Daily Dhikr and Dua lesson stages.
- Promote more verified duas from the scaffold dataset into complete entries so the journey lessons and Dua Hub share more of the same live source set.
- Add light persistence for completed Journey lesson stages so the progress shell reflects actual reading instead of mocked completion.
- Build the next high-impact real lesson sets: Fiqh Basics, Timeline of Islam, Tajweed Basics, and short-surah meaning lessons.
- Replace the current lightweight Learning Journey streak with a richer grace-day / recovery model only if users engage consistently enough to justify it.
- Persist per-stage dwell time and partial progress so Continue Journey can resume inside longer lessons, not only at the stage level.
- Expand Today’s Light routing so Hadith, Prophets, and Trivia open more precise item-specific destinations instead of safe fallback entry points when needed.
- Add smarter journey recommendations based on completed islands, stage depth, and complementary worship/knowledge balance.
- Add test coverage for Learning Journey progress persistence, stage completion rewards, and Today’s Light daily rotation.
- Add full translated lesson-copy coverage for the new Aqeedah, Fiqh, Timeline, and Stories lesson bodies so non-English locales stop falling back to English in the strengthened domains.
- Add a small trusted-source content review checklist for new lesson passes, including Qur'an reference verification and route-level content ownership.
- Add focused widget tests for the new completion-stage journey cards so next-step suggestions remain visible and localized across islands.
- Add a small animated completion ribbon or inline success state for finished stages so feedback stays calm without relying only on snackbars.
- Add route-aware next-stage deep links for placeholder stages too, so completed interim lessons can advance directly when a later stage is available.
- Add translation coverage for the new micro-polish CTA keys and streak/completion copy across supported locales.
- Add a lightweight path selector in Settings so users can change their learning level after onboarding without resetting learning progress.
- Add focused widget tests for the new `Your Path` section, including onboarding-to-path mapping and phase-progress rendering on Journey Home.
- Add profile-scoped persistence coverage for `learn.path.state.v1` so shared-device profile switching cannot leak path selection between profiles.
- Add translated locale coverage for the new learning-path UI keys and the new `Islam Foundations` / `Daily Routines` lesson bodies so localized users stop falling back to English.
- Add phase-completion feedback on Journey Home when a path phase is fully completed, with a calm unlock message for the next phase.
- Scope `learn.path.state.v1` to the active profile namespace so adaptive path choice and secondary explorations never leak across shared-device profiles.
- Add focused tests for adaptive recommendation ranking, path-switch preservation, and personalized Today’s Light bias selection.
- Add more precise inactivity handling so adaptive guidance can distinguish a short pause from actual path abandonment without introducing heavy analytics.
- Add localized translations for the new adaptive path keys in the supported non-English locales so the path intelligence UI stops falling back to English.
- Add a dedicated lightweight path settings surface if the current home-section switcher becomes too hidden for regular users.
- Add focused tests for sanitized progress reload when a journey or stage ID is removed from the registry, so content evolution stays safe over time.
- Add profile-scoped namespacing for learning progress and path state if the current shared-device behavior begins to show cross-profile leakage in manual QA.
- Add localized translations for the new offline/unavailable-stage, no-path, and exhausted-state fallback copy across supported locales.
- Add a small review-mode entry on completed journeys so users can intentionally revisit key takeaways without reopening the last stage manually.
- Add a deterministic Today’s Light fallback test to guarantee the daily surface never resolves to an empty or unroutable item.
- Add authored kids/teens lesson variants for the highest-traffic stages in Prophets, Salah, Duas, Dhikr, Character, and Stories so the current lightweight shortening layer can evolve into richer age-specific teaching.
- Add localized translations for the new age-group onboarding, hint, and lesson-variant keys across supported locales so age adaptation does not fall back to English.
- Add family-mode refinement so kids guidance can optionally bias toward family-friendly journeys and reduce independent switching friction on shared devices.
- Add focused tests for age-aware recommendation ranking and age-aware lesson trimming so kids/teens prominence does not regress silently.
- Add optional teen-specific reinforcement paths around identity, purpose, and discipline once more of that content is explicitly authored.
## Parent-Child Shared Learning Enhancements

- Apply each child profile's `preferredLanguage` automatically on profile switch and keep it in sync with the child's saved locale snapshot.
- Add parent-controlled daily goals and lightweight completion badges to the child progress cards.
- Add a child-safe filtered island detail/browse tools mapping instead of today’s coarse visibility buckets.
- Add a dedicated child-profile summary card to the shared-device profile picker so guardians can jump directly into guided learning.
- Add focused widget/provider tests for:
  - child profile creation
  - guardian-child switching
  - child visibility filtering
  - per-profile learning progress separation
  - family progress summary parsing from stored profile snapshots

## Kids UI Theme Enhancements

- Apply stronger Kids UI card variants to shared learning widgets so the larger touch targets are consistent beyond the learning module.
- Add guardian preview support to the child editor so parents can preview the exact child learning home before switching profiles.
- Expand Kids UI behavior to more non-learning surfaces already affected by `specialModeProvider.isKids`.
- Add focused tests for:
  - age-range auto resolution
  - manual Kids UI override precedence
  - child-profile Kids UI persistence across profile switching
  - learning home simplification when Kids UI is active

## Learn Together Enhancements

- Add stage-specific Learn Together prompts for the highest-traffic Prophet, Seerah, Character, Dua, Dhikr, and Stories lessons so guidance feels less generic while still staying lightweight.
- Add profile-scoped tests for Learn Together session persistence, guardian-to-child launch flow, and `learned together` state restoration after app restart.
- Add a calm shared-completion banner on child progress surfaces so guardians can immediately see which lessons were reviewed together most recently.
- Add translated locale coverage for the new Learn Together labels, prompts, and guidance text across supported non-English locales.
- Add a lightweight "continue together" shortcut on the family management page that resumes the latest unfinished shared session directly.

## Community Learning Layer Enhancements

- Add focused provider tests for learning-to-ocean contribution dedup across stage, journey, phase, Today’s Light, and Learn Together completions.
- Add a small Ocean detail deep link from the new learning-community summary card once the preferred Ocean route contract is confirmed.
- Add a family-scoped learning contribution summary so guardians can optionally view combined child learning drops without mixing profile-local progress state.
- Add translated locale coverage for the new community-learning summary and completion-feedback keys across supported non-English locales.
- Add a calmer inline completion ribbon option to lesson pages so Ocean contribution feedback does not rely only on snackbars.
