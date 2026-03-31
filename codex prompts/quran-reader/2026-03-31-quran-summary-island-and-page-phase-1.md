===== PHASE 1 PROMPT — QURAN SUMMARY ISLAND + QURAN SUMMARY PAGE =====

PRIMARY OBJECTIVE === BUILDING QURAN SUMMARY ISLAND + QURAN SUMMARY PAGE

You are working inside the existing Flutter codebase for Path of Nūr.

This phase is NOT a placeholder pass.
Build this as a production-ready feature using the app’s current architecture, route patterns, localization system, shared theme system, reusable widgets, and existing Qur’an section design language.

IMPORTANT SAFETY + EXECUTION RULES
- Audit first before editing anything.
- Do not remove, break, or regress existing Qur’an flows, reader flows, playback, memorization flows, or existing home/quran navigation.
- Do not delete existing records, seeded content, routes, providers, or shared systems unless clearly obsolete and replaced safely.
- Preserve localization and app stability.
- Reuse existing surfaces, page shells, cards, chips, search patterns, and route conventions where practical.
- Keep this pass readably structured and maintainable.
- At the very end, run an audit summary so I can review one clean implementation report.

CONTEXT / PRODUCT GOAL
We want to introduce a new “Quran Summary” feature into Path of Nūr.

Phase 1 scope:
1. Add a Quran Summary Island / entry point under the main Qur’an page.
2. Tapping it should open a dedicated Quran Summary page.
3. That page should display all 114 surahs with:
   - surah number
   - transliterated/English name
   - Arabic name
   - meaning
   - verse count
   - revelation type (Makki / Madani / if mixed, support gracefully)
   - short summary text
4. Page should support:
   - search by surah number, English/transliterated name, Arabic name, and meaning
   - filter chips/tabs for All / Makki / Madani
   - tap-to-expand card behavior for summary details
5. The final feature must feel like Path of Nūr, but we also want to begin extracting this reference into a reusable visual theme direction called “Quran Summary Theme”.

REFERENCE DIRECTION
The supplied reference code has a very strong tone:
- deep dark background
- warm gold typography
- elegant serif feel
- strong Arabic headline presence
- subtle sacred / manuscript mood
- restrained green for Madani tagging
- rich editorial card presentation

We LIKE that tone.
But do NOT clone it literally.
Instead:
- adapt it into Path of Nūr’s current visual system
- keep the app’s existing calm spiritual feel
- ensure consistency with current backgrounds, cards, typography, spacing, theming, and shared widgets
- if the app already supports light/dark or reduced-transparency settings, respect them

PHASE 1 DELIVERABLES
Build the following in this phase:

A. AUDIT FIRST
Audit the existing Qur’an section and determine:
- where the main Qur’an landing page currently lives
- where a new Quran Summary Island best fits in the current IA
- what existing shared widgets/components should be reused
- whether there is already any surah metadata/domain model that can be reused
- whether there is already a seeded content pattern for structured lesson/reference content
- whether theme extensions or feature-level palettes already exist that should be used instead of hardcoding colors

Before coding, identify:
- target files to modify
- target route to add
- reusable components to leverage
- any localization keys likely needed
- whether the summary content should be seeded directly in Dart for this phase or stored in a feature data file

B. ADD QURAN SUMMARY ISLAND ON THE MAIN QURAN PAGE
Implement a new Quran Summary Island / feature card on the main Qur’an page.

Requirements:
- It must visually belong with the current Qur’an page sections
- It should not feel bolted on
- It should include:
  - title
  - short subtitle/helper text
  - visual iconography or motif appropriate to Qur’an study / overview
- Tapping it opens the new Quran Summary page

Suggested copy direction:
- Title: Quran Summary
- Subtitle: Explore all 114 surahs with short overviews, revelation type, and key themes

Localize all user-facing strings.

C. ADD ROUTE + PAGE
Create a dedicated Quran Summary page under the Qur’an route family.

Requirements:
- Follow existing routing architecture and naming conventions
- Use the Qur’an section shell / app bar / page chrome patterns already established in the app
- Ensure navigation back behavior works properly
- Ensure deep linking stays clean if the app uses route aliases/redirects

D. CREATE A PROPER DATA MODEL
Create a production-ready feature data model for surah summaries.

Recommended structure per surah:
- surahNumber
- englishName / transliteratedName
- arabicName
- meaning
- verseCount
- revelationType
- summary
- optional tags or keywords for future extensibility
- optional sort index if helpful

Use a typed domain model, not a loose map list.

Data guidance:
- Seed all 114 surahs in a dedicated feature data file or structured repository source for this phase
- Keep the data easy to extend later for:
  - themes
  - tafsir snippets
  - virtues/fadha’il
  - reflection prompts
  - related surah links
  - audio/reading shortcuts

Do not bury the dataset inside the widget file.

E. BUILD SEARCH + FILTER
Implement search and filter behavior.

Search requirements:
- search by:
  - number
  - transliterated/English name
  - Arabic name
  - meaning
- search should be responsive and forgiving
- if the project already has a reusable search field widget, use it

Filter requirements:
- All
- Makki
- Madani

If a surah has mixed classification or edge-case metadata, handle it safely without breaking the UI.
If needed, keep Phase 1 visible filters to All / Makki / Madani and gracefully include mixed cases in All until a richer classification system is added later.

F. BUILD SURAH SUMMARY CARD UI
Each surah item should present:
- number badge
- transliterated/English name
- Arabic name
- meaning
- revelation badge/chip
- compact metadata row including verse count
- expandable summary area

Interaction:
- tap card to expand/collapse
- expanded state should feel smooth and polished
- only use simple animation if it already fits the app; do not over-animate

Design requirements:
- preserve Path of Nūr feel
- adapt the reference aesthetic into a themed layer:
  - deep night base
  - warm gold highlights
  - elegant text treatment
  - subtle contrast between Makki / Madani chips
- avoid making the screen look alien compared to the rest of the app

G. CREATE “QURAN SUMMARY THEME” FOUNDATION
We also want this pass to begin creating a reusable theme direction inspired by this feature.

Implement this safely:
- do NOT fork the entire app theme
- instead introduce a contained feature-level theme/palette/token set or theme extension that can support this page and future related Qur’an surfaces

Extract/design tokens such as:
- background tone(s)
- card surface tone(s)
- gold highlight/accent
- muted support text colors
- Makki badge color
- Madani badge color
- title/heading typography treatment rules
- Arabic text emphasis treatment

Goal:
Create a foundation so this “Quran Summary Theme” can later be reused for:
- surah detail headers
- tafsir cards
- Qur’an reflection pages
- Qur’an overview islands
- special study mode surfaces

Do not hardcode scattered colors throughout the widget tree if the app already uses theme extensions or token systems.

H. PRESERVE ACCESSIBILITY + SETTINGS
Respect existing app settings wherever possible, especially if already present:
- light/dark theme behavior
- reduced transparency
- reduced motion
- text scaling/accessibility
- high contrast if supported

If the exact reference aesthetic only works in dark mode, adapt it thoughtfully for the app’s supported theme modes rather than forcing a one-off dark-only implementation unless the existing Qur’an section already intentionally does that.

I. KEEP LOCALIZATION CLEAN
Any new:
- title
- subtitle
- button text
- placeholder
- filter label
- empty state
- helper text
must be localization-ready and integrated with the app’s existing localization system.

At the end, report:
- new localization keys added
- which locale files/resources were updated

J. EMPTY / NO RESULT / STATE POLISH
Implement polished empty/search states:
- no results found
- search + filter combo returns nothing
- initial load should feel immediate and clean for seeded data

Keep copy calm and concise.

K. FUTURE-READY HOOKS (WITHOUT OVERBUILDING)
Structure the implementation so future phases can add:
- “open surah reader” CTA from each summary card
- related tafsir
- virtues / recommended recitation times
- bookmarks/favorites
- memorization shortcuts
- “continue reading” integration
- study mode
- kids-friendly simplified summaries
- language toggle or summary translation variants

Do not build all of those now.
Just structure Phase 1 so we do not paint ourselves into a corner.

L. TESTING / VALIDATION
After implementation:
- run analyzer on changed files
- ensure no route regressions
- ensure no existing Qur’an page regressions
- verify search and filter behavior
- verify expand/collapse works
- verify summary island opens the right page
- verify page looks visually coherent in the current app

M. DELIVERABLE REPORT
At the end provide one clean summary with:
1. Audit findings
2. Files changed
3. Route added
4. Data model introduced
5. Where the 114 surah summary data is stored
6. How search/filter work
7. How the Quran Summary Theme foundation was implemented
8. Localization keys added
9. Analyzer/test results
10. Follow-up recommendations for Phase 2

PHASE 1 DESIGN GUIDANCE
Visual tone to aim for:
- reverent
- elegant
- calm
- editorial
- sacred without being ornate overload
- aligned with Path of Nūr rather than looking like a separate app

Try to preserve these good reference ideas:
- gold-accent hierarchy
- strong Arabic header moments
- clean revelation chips
- compact but readable cards
- rich dark scholarly feel

But adapt them into:
- Path of Nūr spacing
- Path of Nūr card language
- Path of Nūr route/page shell
- Path of Nūr theme architecture

IMPORTANT
Build this as a real production-ready feature.
Do not create throwaway mock widgets.
Do not leave placeholder summary data for only a few surahs.
Do not skip the theme-token extraction step.
Do not break existing Qur’an navigation or reader experiences.

At the very end, run a final audit and provide one complete implementation summary.
===== END PHASE 1 PROMPT =====
