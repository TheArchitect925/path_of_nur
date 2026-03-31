# PHASE THEME 4 PROMPT — MIDNIGHT MANUSCRIPT QURAN MODE POLISH

PRIMARY OBJECTIVE === BUILDING MIDNIGHT MANUSCRIPT QURAN MODE POLISH

You are working inside the existing Flutter codebase for Path of Nūr.

This is a production-ready Qur’an-specific visual refinement pass.
Do not build placeholders.
Do not redesign the whole app.
Do not break existing theme selection, theme persistence, glass container behavior, routing, localization, accessibility, reader integration, or the shared theme/component architecture already in place.

IMPORTANT SAFETY + EXECUTION RULES
- Audit first before editing anything.
- Do not remove or break the current theme system or the existing theme options.
- Do not go haywire and remove/delete assets, theme files, settings, shared UI logic, or Qur’an feature structures for no reason.
- Preserve the current Path of Nūr glass container identity.
- Preserve the existing behavior of Quran Summary, Surah Summary Detail, Theme Detail, Pathways, Companion, and Reflections.
- This pass is visual and interaction polish for the Qur’an area under Midnight Manuscript, not a functional rewrite.
- At the very end, run a full audit and provide one clean implementation summary.

PHASE CONTEXT
Previous theme passes introduced:
- Midnight Manuscript as a selectable theme
- app-level palette/tokens
- theme previews
- theme-aware background behavior
- component-level polish for shared app controls

Now this pass should make the Qur’an section feel exceptional under Midnight Manuscript.

PRODUCT GOAL
When the user uses Midnight Manuscript and enters the Qur’an section, it should feel:
- deeper
- richer
- calmer
- more sacred/editorial
- premium and intentional
- still unmistakably Path of Nūr

This should be achieved WITHOUT:
- replacing the app’s glass container system
- creating a separate mini-app inside the Qur’an area
- making the UI overly ornate or cluttered
- reducing readability/accessibility

A. AUDIT FIRST
Before making any changes, audit the current Qur’an-related surfaces and identify:
- which Qur’an pages/components are active and user-facing now
- which of them already consume the shared Qur’an theme tokens correctly
- which of them still use hardcoded colors, fills, borders, or text styles that fight Midnight Manuscript
- where the current Qur’an-specific shared widgets/components live
- whether Quran Summary, Surah Detail, Theme Detail, Pathways, Companion, and Reflections already share common wrappers that should be reused
- which pages currently feel least aligned with Midnight Manuscript
- which high-impact visual areas would benefit most from refinement first

Before coding, identify:
- target files to modify
- shared Qur’an components to update
- whether any new Qur’an-only theme helpers/tokens are needed
- where to refine at the shared-widget level instead of per-page
- which pages must remain visually stable in non-Midnight-Manuscript themes

B. DEFINE THE QURAN MODE VISUAL INTENT UNDER MIDNIGHT MANUSCRIPT
Formalize the Qur’an-specific visual expression for this theme.

The intended feel is:
- deep ink manuscript
- warm gold emphasis
- luminous Arabic hierarchy
- calm scholarly presentation
- restrained sacred atmosphere
- soft jade/teal for Madani distinction where appropriate
- warm cream reading text
- subtle bronze support text
- elegant borders/dividers rather than heavy boxes

This should NOT become:
- gold overload
- antique scrapbook styling
- over-decorated Islamic art motifs
- low-contrast dark-on-dark muddiness
- page-specific custom chaos

C. POLISH QURAN SUMMARY PAGE
Refine the Quran Summary page specifically under Midnight Manuscript.

Focus on:
- page header/hero
- search surface
- filter chips
- surah summary cards
- expanded card state
- number badges
- Arabic name emphasis
- revelation badges
- metadata row
- footer/support text if applicable

Requirements:
- preserve current search/filter/expand behavior
- keep the layout intact
- increase visual hierarchy and elegance
- ensure selected/expanded states feel premium
- ensure cards still feel like Path of Nūr glass surfaces, not opaque web cards
- use Midnight Manuscript tokens instead of page-level hardcoded colors

The page should feel like the strongest expression of this theme.

D. POLISH SURAH SUMMARY DETAIL PAGE
Refine the Surah Summary Detail page specifically under Midnight Manuscript.

Focus on:
- hero/header
- Arabic title treatment
- transliterated/English title hierarchy
- meaning, verse count, revelation type
- overview section
- key themes
- notable ayat
- prophets/events/virtues/reflection sections
- action row/buttons (Open in Reader, Start Reading, Resume if present)

Requirements:
- preserve current data structure and behavior
- improve hierarchy, spacing, section separation, and emphasis
- make the header feel richer and more immersive
- ensure the page remains highly readable for longer content
- do not create visually noisy stacked cards if lighter sectional treatment is better

E. POLISH THEME DETAIL PAGES IN THE QURAN AREA
Refine Qur’an thematic discovery detail pages under Midnight Manuscript.

Focus on:
- theme hero/header
- category badges
- related surah cards
- key ayah reference cards/rows
- related prophets/events
- reflection block
- action surfaces

Requirements:
- visually connect these pages to Quran Summary and Surah Detail
- maintain their own identity, but keep a shared Qur’an design language
- use refined chip/badge treatment under Midnight Manuscript
- ensure browse-by-topic feels premium and coherent

F. POLISH QURAN PATHWAYS PAGES
Refine the Qur’an Pathways landing page and pathway detail pages under Midnight Manuscript.

Focus on:
- pathway cards
- pathway stop cards
- progress treatment
- continue/resume banners
- pathway headers
- supporting metadata
- reflection prompts and stop descriptions

Requirements:
- preserve pathway progression and resume logic
- keep the UI calm and reflective, not task-heavy
- progress states should feel soft and premium
- active/current stop state should be clear
- completion indicators should be elegant, not gamified

G. POLISH QURAN COMPANION CARDS
Refine personalized Qur’an companion surfaces under Midnight Manuscript.

Focus on:
- primary recommendation card
- compact secondary suggestion cards
- rationale badges/labels
- resume/progress surfaces
- related theme/pathway/surah suggestion cards

Requirements:
- keep the cards calm and intelligent
- ensure rationale labels remain readable
- make companion cards feel integrated with the Qur’an visual world
- avoid making them look like generic recommendation feed cards

H. POLISH REFLECTION / SAVED INSIGHTS SURFACES
Refine Qur’an reflections and saved insights under Midnight Manuscript.

Focus on:
- reflections page header
- reflection cards
- source context row
- date/metadata treatment
- favorite markers
- empty state
- reflection detail page
- save/edit reflection surface where applicable

Requirements:
- preserve privacy-oriented calm feel
- improve visual warmth and intimacy
- ensure text input/capture surfaces remain highly readable
- avoid clutter or productivity-tool appearance

I. REFINE QURAN-SPECIFIC BADGES / CHIPS / METADATA PILLS
Create a stronger and more consistent Qur’an-specific treatment for:
- Makki chip
- Madani chip
- verse count pill
- surah number badge
- category/theme chips
- notable ayah labels
- pathway status badges
- reflection source badges

Requirements:
- preserve semantic clarity
- maintain consistency across the Qur’an section
- selected/emphasized states should be stronger
- unselected/secondary states should remain readable and elegant
- avoid every badge looking identical

Suggested direction:
- Makki = warm gold family
- Madani = muted jade family
- neutral metadata = cream/bronze on dark glass
- selected = soft gold-led emphasis
- source/status = restrained tinted glass treatments

J. REFINE QURAN HERO / HEADER ATMOSPHERICS
Improve the hero/header presentation for Qur’an pages under Midnight Manuscript.

Eligible pages:
- Quran Summary
- Surah Detail
- Theme Detail
- Pathways
- Reflections
- possibly Companion sections embedded inside Qur’an landing surfaces

Direction:
- subtle deep ink gradients
- restrained warm radial lift
- elegant Arabic title contrast
- refined divider/ornament treatment if already supported
- strong but calm vertical spacing

Important:
- keep this subtle
- no cluttered ornamentation
- no performance-heavy effects
- no busy wallpaper overlays behind text

K. IMPROVE QURAN SECTION DIVIDERS / SECTION WRAPPERS
Refine section separation and grouping across Qur’an pages.

This may include:
- softer but more intentional dividers
- cleaner section wrappers
- refined heading/subheading spacing
- better transitions between content sections

Goal:
make the pages feel composed and editorial, not like stacked widget fragments.

L. CENTRALIZE QURAN-ONLY POLISH THROUGH SHARED WIDGETS / TOKENS
If certain Qur’an-specific surfaces need extra refinement under Midnight Manuscript, implement that through:
- shared Qur’an tokens
- shared Qur’an wrappers
- shared badges/chips/header widgets
- shared section components

Avoid:
- page-by-page one-off styling hacks
- duplicate special cases across multiple screens
- hardcoded visual tweaks only in one page unless absolutely necessary

M. DO NOT REGRESS OTHER THEMES
This is critical.

Any Qur’an shared widget changes must preserve:
- existing light/default themes
- other theme modes
- current readability/accessibility outside Midnight Manuscript
- current behavior and routing

Midnight Manuscript can have richer expression, but shared Qur’an components must remain theme-safe.

N. OPTIONAL SUBTLE ORNAMENTAL REFINEMENT
If the current shared Qur’an architecture supports it cleanly, allow very restrained enhancements such as:
- fine divider flourish
- subtle top-edge glow in hero sections
- elegant card edge treatment
- very faint manuscript warmth around headers

This must stay minimal and premium.
No decorative overload.
No performance-heavy effects.
No reduced readability.

O. LOCALIZATION
Only add localization keys if new user-facing labels are introduced as part of this polish.
Do not create unnecessary new strings.

At the end, report:
- new localization keys added
- locale resources updated

P. ACCESSIBILITY / EDGE CASES
Ensure Midnight Manuscript Qur’an mode remains highly usable.

Requirements:
- strong text contrast
- readable long-form body text
- clear selected/active states
- chips/buttons remain understandable
- support text does not become too dim
- text scaling remains safe
- reduced transparency remains coherent
- reduced motion remains respected if present
- empty states remain readable and calm

Do not let aesthetic refinement reduce usability.

Q. TESTING / VALIDATION
After implementation:
- run analyzer on changed files
- verify Midnight Manuscript still applies correctly
- verify Quran Summary page looks polished and works correctly
- verify Surah Detail still works and remains readable
- verify Theme Detail still works and remains coherent
- verify Pathways still work and progress/resume remain intact
- verify Companion cards still work and remain readable
- verify Reflections still work and remain calm/private
- verify other themes are not regressed
- verify no route or interaction regressions
- verify accessibility and text scaling remain coherent

R. DELIVERABLE REPORT
At the end provide one clean implementation summary:
1. Audit findings
2. Qur’an pages/components refined
3. Shared Qur’an widgets/tokens updated
4. Which hardcoded visual conflicts were cleaned up
5. How Quran Summary changed
6. How Surah Detail changed
7. How Theme Detail / Pathways / Companion / Reflections changed
8. Whether other themes were preserved safely
9. Localization keys added
10. Analyzer/test results
11. Follow-up recommendations

DESIGN SUMMARY
By the end of this pass, Midnight Manuscript in the Qur’an section should feel:
- premium
- coherent
- immersive
- calm
- editorial
- spiritually grounded
- deeply integrated with Path of Nūr

It should NOT feel like:
- a separate app skin
- a decorative experiment
- gold overload
- hardcoded one-off page styling

IMPORTANT
Build this as a real Qur’an-only refinement pass.
Do not break the current theme system.
Do not remove the Path of Nūr glass identity.
Do not create per-page hacks that bypass shared Qur’an architecture.
At the very end, run a final audit and provide one complete implementation summary.
