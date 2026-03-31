===== PHASE 3 PROMPT — QURAN SUMMARY THEME ROLLOUT + REUSABLE QURAN HEADER SYSTEM =====

PRIMARY OBJECTIVE === BUILDING QURAN SUMMARY THEME ROLLOUT + REUSABLE QURAN HEADER SYSTEM

You are working inside the existing Flutter codebase for Path of Nūr.

This is a production-ready feature/design system pass.
Do not create throwaway UI.
Do not break existing Qur’an flows, page shells, routing, playback, reader state, localization, accessibility settings, theme behavior, or shared widgets.

IMPORTANT SAFETY + EXECUTION RULES
- Audit first before editing.
- Do not remove or delete working records, seeded content, routes, providers, widgets, or shared theme systems unless clearly replaced safely.
- Do not go haywire and remove/delete records for no reason.
- Preserve current architecture and reuse shared patterns wherever possible.
- Extend the system cleanly so future Qur’an pages can adopt the same visual language.
- At the very end, run a final audit and provide one full implementation summary.

PHASE CONTEXT
Phase 1 introduced:
- Quran Summary Island on the main Qur’an page
- Quran Summary page
- search/filter
- 114-surah structured summary dataset
- initial Quran Summary theme foundation

Phase 2 introduced:
- Surah Summary Detail experience
- reader integration
- action surfaces like Open in Reader / Start Reading / Resume where grounded

Now Phase 3 should take the feature from “one well-designed page” to “a reusable Qur’an presentation system” that can be used across the app.

GOAL OF THIS PHASE
Turn the Quran Summary visual direction into a reusable, scalable Qur’an design layer for Path of Nūr.

This phase should:
1. formalize the Quran Summary theme into reusable tokens/components
2. introduce a reusable Qur’an header/hero system
3. refactor Phase 1 and Phase 2 pages to use the shared system
4. prepare the app for future Qur’an surfaces such as:
   - surah detail headers
   - tafsir cards
   - reflection pages
   - virtues/benefits sections
   - recitation/study pages
   - topic-based Qur’an discovery pages

A. AUDIT FIRST
Before making changes, audit and identify:
- what theme/token work was already introduced in Phase 1
- whether current colors, type styles, spacing, card surfaces, and chips are still hardcoded anywhere
- where Qur’an-specific UI is duplicated across:
  - main Qur’an page
  - Quran Summary page
  - Surah Summary Detail page
  - any related Qur’an landing/detail widgets already in the codebase
- whether there are existing theme extensions or app design tokens that should be extended rather than bypassed
- whether there are existing reusable page headers/cards/section wrappers that can be specialized rather than rebuilt
- what Qur’an surfaces would benefit most from reuse now

Before coding, identify:
- target files to modify
- new shared files/components to create
- places where hardcoded design values should be centralized
- any existing components that should be refactored to use the new shared system
- localization impact, if any

B. FORMALIZE THE QURAN SUMMARY THEME
Take the initial Quran Summary theme foundation and convert it into a proper reusable feature-level theme system.

Implement a clean, reusable design structure for Qur’an surfaces, such as:
- Qur’an background tones
- elevated card surfaces
- outline/border tones
- gold accent/highlight
- subdued support text
- Arabic emphasis styling
- Makki chip styling
- Madani chip styling
- metadata row styling
- hero/header spacing rules
- title/subtitle hierarchy rules

Use one of these approaches depending on project architecture:
- ThemeExtension
- feature-level palette/token classes
- theme helper tied into the app’s shared theme system

Do NOT:
- scatter hardcoded colors
- create a disconnected mini-theme that ignores the rest of the app
- override the full app theme just for this feature unless architecture already supports that cleanly

C. BUILD A REUSABLE QURAN HEADER / HERO SYSTEM
Create a reusable Qur’an header component that can support multiple Qur’an surfaces.

This shared component should be adaptable for:
- Quran Summary page header
- Surah Summary Detail header
- future surah/tafsir/reflection/detail pages

The reusable header system should support combinations of:
- Arabic title
- English/transliterated title
- overline / eyebrow text
- subtitle / helper text
- number badge
- revelation chip
- verse count
- decorative but restrained sacred/editorial styling
- optional gradient / glow / manuscript-inspired background treatment
- optional action row
- optional compact mode and expanded mode

Important:
- keep it elegant, calm, and premium
- do not make it overly ornate or visually noisy
- it must still feel like Path of Nūr

D. CREATE REUSABLE QURAN UI BUILDING BLOCKS
Extract reusable building blocks from the Quran Summary experience.

Good candidates include:
- Qur’an section container
- metadata chip row
- revelation badge/chip
- surah number badge
- themed search field wrapper for Qur’an pages
- themed empty state for Qur’an pages
- Qur’an content card surface
- compact stats row
- section title row for detail pages

Refactor Phase 1 and Phase 2 pages to use these shared pieces.

Goal:
Reduce duplicated UI logic and make future Qur’an pages faster and safer to build.

E. REFACTOR EXISTING QURAN SUMMARY SCREENS TO USE THE SHARED SYSTEM
Update the existing Quran Summary page and Surah Summary Detail page so they use:
- the reusable Qur’an theme tokens
- the reusable Qur’an header system
- extracted shared building blocks

Do this safely:
- preserve current behavior
- preserve routes
- preserve search/filter logic
- preserve reader integration
- preserve existing localization
- preserve accessibility

This refactor should improve consistency, not rewrite behavior unnecessarily.

F. DEFINE LIGHT + DARK + ACCESSIBILITY BEHAVIOR
Ensure the Qur’an theme system behaves properly across supported app modes.

Requirements:
- support existing light/dark theme behavior
- support reduced transparency if the app has that setting
- support reduced motion if the app has that setting
- preserve contrast/readability for Arabic and English text
- ensure accent gold and chip colors remain accessible

If the dramatic dark scholarly style is strongest in dark mode:
- still provide a refined adaptation for light mode
- do not let light mode feel like an afterthought

G. TYPOGRAPHY RULES
Formalize typography behavior for this Qur’an visual system.

Define reusable text style logic for:
- Arabic headline
- English/transliterated headline
- overline
- helper/subtitle
- metadata labels
- summary body text
- chip text

Respect the app’s existing font setup and avoid random font usage.
If the project already uses specific Arabic fonts or Qur’an-friendly fonts, reuse those.
Keep the typographic mood elegant and consistent.

H. OPTIONAL DECORATIVE LAYER — RESTRAINED
If it fits the current app style and can be done cleanly, add a restrained decorative layer such as:
- subtle radial glow
- faint manuscript/grid pattern
- gentle sacred geometry hint
- top divider ornament
- elegant footer divider

This must remain subtle.
No visual clutter.
No performance-heavy decorations.
No busy wallpaper effect that fights readability.

I. PREPARE FOR FUTURE QURAN SURFACES
Without overbuilding, structure the shared system so future pages can plug in easily:
- Surah virtues page
- Tafsir overview page
- Reflection page
- Qur’an topic explorer
- Memorization support pages
- “Signs in the Qur’an” or thematic learning pages
- “Open in Reader” companion panels

Do not build all of these now.
Just ensure the shared components are flexible enough.

J. CLEAN FILE ORGANIZATION
Organize the new shared Qur’an design system cleanly.

Suggested structure examples:
- shared/theme/quran_*.dart
- features/quran/presentation/widgets/quran_*.dart
- shared/widgets/quran/*.dart

Choose the structure that best matches the repo.
Keep names explicit and scalable.

Avoid:
- giant monolithic widget files
- dumping theme logic into page files
- mixing data model logic with presentation components

K. LOCALIZATION
If any new UI labels are introduced, they must be localization-ready and integrated with the app’s existing localization system.

Examples:
- Overview
- Key Themes
- Revelation
- Verses
- Search Surahs
- No Surahs Found
- Explore the Qur’an
- Quran Summary

At the end, report:
- which localization keys were added
- which locale resources were updated

L. TESTING / VALIDATION
After implementation:
- run analyzer on changed files
- verify Quran Summary page still works
- verify Surah Summary Detail page still works
- verify the reader integration still works
- verify reusable headers render correctly in all intended uses
- verify no layout regressions on narrow/mobile widths
- verify light/dark appearance remains coherent
- verify accessibility/readability remains strong
- verify no duplicated obsolete components remain in active use

M. DELIVERABLE REPORT
At the end provide one clean implementation summary:
1. Audit findings
2. Shared theme/token system introduced
3. Reusable header/hero components introduced
4. Shared Qur’an widgets/components introduced
5. Files changed
6. Which existing pages were refactored
7. Accessibility/theme behavior notes
8. Localization keys added
9. Analyzer/test results
10. Follow-up recommendations for Phase 4

PHASE 3 PRODUCT INTENT
By the end of this phase, Quran Summary should no longer feel like a one-off feature.
It should become the foundation of a broader Qur’an design language within Path of Nūr.

The user should feel:
- this belongs deeply inside the app
- the Qur’an section now has a premium, coherent identity
- future Qur’an study/discovery features can build on this cleanly

IMPORTANT
Build this as a real reusable system.
Do not over-engineer.
Do not break working behavior.
Do not create a parallel design language disconnected from Path of Nūr.
Do not leave hardcoded styles scattered across pages once the shared system exists.

At the very end, run a final audit and provide one complete implementation summary.
===== END PHASE 3 PROMPT =====
