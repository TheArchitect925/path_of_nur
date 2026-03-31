===== PHASE 2 PROMPT — QURAN SUMMARY DETAIL EXPERIENCE + READER INTEGRATION =====

PRIMARY OBJECTIVE === BUILDING QURAN SUMMARY DETAIL EXPERIENCE + READER INTEGRATION

You are working inside the existing Flutter codebase for Path of Nūr.

This is a production-ready feature pass.
Do not build placeholders.
Do not break or regress existing Qur’an page flows, reader flows, playback flows, memorization flows, navigation, route aliases, theme behavior, localization, or shared settings.

IMPORTANT SAFETY + EXECUTION RULES
- Audit first before editing.
- Do not remove or delete working data, records, routes, seeded content, providers, widgets, or systems unless clearly replaced safely.
- Do not go haywire and remove/delete records for no reason.
- Preserve app architecture, route integrity, shared theme systems, localization systems, and current Qur’an feature hierarchy.
- Reuse existing reader entrypoints and existing surah navigation behavior rather than inventing parallel systems.
- At the very end, run a final audit so I can review one clean implementation summary.

PHASE CONTEXT
Phase 1 introduced:
- Quran Summary Island on the main Qur’an page
- Quran Summary page with all 114 surahs
- search/filter
- expandable summary cards
- initial Quran Summary theme foundation

Now Phase 2 should deepen the experience.

GOAL OF THIS PHASE
When a user engages with a surah in Quran Summary, the experience should feel richer and more useful while still calm and lightweight.

Build a proper Surah Summary Detail experience that can open from the Quran Summary page and connect naturally to the existing Qur’an reader.

PHASE 2 SCOPE
Build the following:

1. Dedicated Surah Summary Detail page or bottom sheet experience
2. Reader integration via “Open in Reader”
3. Optional quick actions:
   - Start from beginning
   - Resume if supported by existing reader state
   - Jump to surah
4. Richer surah metadata presentation
5. Theme continuation using the Quran Summary theme foundation
6. Future-ready structure for virtues / tafsir / notes / bookmarks without fully overbuilding them now

A. AUDIT FIRST
Before making changes, audit the current implementation and identify:
- where Phase 1 Quran Summary page now lives
- how a user currently opens a surah in the main reader
- whether there is already a canonical route/helper/provider for opening a specific surah
- whether there are existing detail page patterns under the Qur’an / Learn section that should be reused
- whether there are reusable action buttons, stat rows, info sections, or page shells that should be reused
- whether “continue reading” or reader resume state already exists and how it should be surfaced safely
- whether current bookmarks/notes/favorites systems exist and how to avoid conflicting with them now

Before coding, identify:
- target files to modify
- new files to add
- routes/actions to reuse
- any providers/repositories/models that should be extended
- new localization keys needed

B. ADD SURAH SUMMARY DETAIL EXPERIENCE
Implement a proper Surah Summary Detail experience.

Preferred behavior:
- Tapping a surah card from the Quran Summary page opens a dedicated detail page
- If the app architecture strongly prefers sheets for this pattern, use that only if it remains scalable and polished
- The result must feel like a true Path of Nūr feature, not a popup mock

The detail experience should include:
- surah number
- Arabic name
- transliterated/English name
- meaning
- revelation type
- verse count
- short summary
- themed hero/header presentation
- action buttons

The detail page should feel more elevated than the list card, but still calm and readable.

C. READER INTEGRATION
Add a clear “Open in Reader” action.

Requirements:
- Reuse the existing canonical Qur’an reader route/navigation logic
- Open the correct surah directly in the current reader flow
- Do not create a duplicate reader or alternate routing stack
- Preserve all existing reader settings and behavior

Also support, where already possible:
- Resume if there is existing per-surah progress/state
- Start from beginning
- If there is already a “continue listening” / “continue reading” mechanism, integrate with it safely rather than re-implementing it

Do not guess at reader state architecture.
Audit and hook into the real existing entrypoint.

D. ENHANCE THE DATA MODEL SAFELY
Extend the surah summary model only as needed for this phase.

Allowed additions if useful:
- shortThemeLine
- keywords/tags
- optional notableTopics list
- optional related concepts list
- optional detail intro
- optional reader route metadata if required
- optional search aliases

Do not overcomplicate.
Do not split into too many models unless the architecture truly benefits.

Keep all data typed and maintainable.

E. DETAIL PAGE CONTENT STRUCTURE
Structure the detail page into elegant sections.

Recommended sections:
1. Header / Hero
   - Arabic name
   - English/transliterated name
   - surah number
   - meaning
   - revelation chip
   - verse count

2. Overview
   - the summary text from Phase 1
   - possible short supporting intro line if useful

3. Key Themes
   - derived from optional tags/keywords if implemented
   - keep concise and calm
   - no giant walls of text

4. Actions
   - Open in Reader
   - Start Reading
   - Resume Reading (only if grounded in real data/support)
   - optional “View in Qur’an” if naming fits existing IA better

5. Future placeholders ONLY if architecturally helpful and production-safe
   - do not show fake/coming soon clutter everywhere
   - if needed, add internal hooks but not noisy UI

F. DESIGN / THEME CONTINUATION
Continue the Quran Summary theme foundation created in Phase 1.

Requirements:
- reuse feature-level theme tokens or theme extensions from Phase 1
- do not scatter new hardcoded colors
- maintain harmony with the Path of Nūr app
- preserve calm premium sacred feel
- ensure the detail page feels slightly richer and more immersive than the list page

Visual direction:
- strong Arabic heading moment
- elegant gold accents
- restrained surface layering
- readable spacing
- beautiful metadata chips/rows
- rich but not overly ornate

If the app supports light/dark and accessibility variants:
- adapt the detail page properly
- do not assume only one theme mode exists

G. ADD SMART ACTION BEHAVIOR
Action behavior should be production-safe.

Examples:
- Open in Reader → sends user to the canonical reader page for the selected surah
- Start from Beginning → opens at ayah 1
- Resume → only show if the app already has real resume state for that surah or reader session
- If there is audio state integration, do not auto-play unless that is already normal app behavior

Avoid:
- fake buttons
- broken routes
- duplicate navigation patterns
- state assumptions not grounded in the codebase

H. OPTIONAL LIGHT ENRICHMENT
If cleanly supported without bloat, add one small extra content row such as:
- “Makki revelation”
- “114 verses”
- “Main themes: Guidance, patience, tawhid”
- “Open in Reader”

But do not turn this into a tafsir app yet.

I. EMPTY / EDGE / SAFETY CASES
Handle safely:
- surah detail data missing fields
- route argument issues
- user opens detail page directly by deep link
- resume data unavailable
- any mixed revelation classification edge cases

No crashes.
No broken layout.

J. LOCALIZATION
All new user-facing strings must be localization-ready and integrated with the app’s existing localization system.

Examples likely needing keys:
- Quran Summary
- Open in Reader
- Start Reading
- Resume Reading
- Key Themes
- Overview
- Makki
- Madani
- Verses
- Revelation
- Surah
- No reading progress yet
- Continue where you left off

At the end, report:
- new localization keys added
- locale files/resources updated

K. TESTING / VALIDATION
After implementation:
- run analyzer on changed files
- verify Quran Summary page still works
- verify tapping a surah now opens the detail experience
- verify Open in Reader opens the correct surah
- verify Start from Beginning works correctly
- verify Resume only appears when valid, if implemented
- verify back navigation behaves correctly
- verify no regressions in the main Qur’an landing page or reader entrypoints

L. DELIVERABLE REPORT
At the end provide one clean implementation summary:
1. Audit findings
2. Files changed
3. Routes added/updated
4. How the detail page is opened
5. How reader integration was implemented
6. Whether resume behavior was added and how it works
7. Data model changes
8. Theme/token updates
9. Localization keys added
10. Analyzer/test results
11. Follow-up recommendations for Phase 3

PHASE 2 PRODUCT INTENT
This should make Quran Summary feel like a real discovery and study layer inside Path of Nūr.

The user journey should now be:
Main Qur’an page
→ Quran Summary Island
→ Quran Summary page
→ Surah Summary Detail
→ Open in Reader

The experience should feel natural, elegant, and fully integrated.

IMPORTANT
Build this as a real feature, not a mock.
Do not break existing reader flows.
Do not create duplicate reader systems.
Do not introduce messy hardcoded logic.
Do not overbuild tafsir or notes in this pass.
Lay the right foundation for future growth.

At the very end, run a final audit and provide one complete implementation summary.
===== END PHASE 2 PROMPT =====
