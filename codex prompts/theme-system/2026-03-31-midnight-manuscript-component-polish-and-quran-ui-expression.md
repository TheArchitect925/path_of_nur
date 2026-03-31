# PHASE THEME 3 PROMPT — MIDNIGHT MANUSCRIPT COMPONENT POLISH + QURAN UI EXPRESSION

PRIMARY OBJECTIVE === BUILDING MIDNIGHT MANUSCRIPT COMPONENT POLISH + QURAN UI EXPRESSION

You are working inside the existing Flutter codebase for Path of Nūr.

This is a production-ready theme refinement and component-polish pass.
Do not build placeholders.
Do not redesign the app from scratch.
Do not break existing theme selection, theme persistence, glass container behavior, navigation shell, localization, accessibility, or current shared component architecture.

IMPORTANT SAFETY + EXECUTION RULES
- Audit first before editing anything.
- Do not remove or break the current theme system or existing theme options.
- Do not go haywire and remove/delete settings, assets, shared UI logic, or component systems for no reason.
- Preserve the current Path of Nūr glass container identity.
- Preserve current structure, spacing philosophy, routing, and interaction patterns.
- This pass should refine component expression under Midnight Manuscript, not create a separate UI framework.
- At the very end, run a full audit and provide one clean implementation summary.

PHASE CONTEXT
Previous passes introduced:
- Midnight Manuscript as a selectable theme
- theme tokens/palette
- preserved glass container language
- theme previews in settings
- theme-aware background/wallpaper behavior

Now this pass should make Midnight Manuscript feel truly complete by refining the key shared interactive components and Qur’an-specific surfaces.

PRODUCT GOAL
When the user switches to Midnight Manuscript, the app should feel intentionally designed at the component level.

The theme should not only affect page backgrounds.
It should influence:
- navigation shell
- search and filter controls
- chips and segmented controls
- buttons
- badges
- headers
- metadata rows
- empty states
- key Qur’an UI surfaces

The experience should feel:
- elegant
- premium
- calm
- readable
- manuscript-inspired
- still unmistakably Path of Nūr

A. AUDIT FIRST
Before making changes, audit the current state and identify:
- which shared components are most visible across the app
- which shared components already consume theme tokens properly
- which components still use hardcoded colors or partial theme assumptions
- how the nav shell/bottom nav/top nav currently derives colors
- how search fields, chips, segmented controls, and buttons are currently themed
- whether there are existing shared component wrappers for:
  - chips
  - segmented controls
  - text fields/search fields
  - buttons
  - badges
  - section headers
  - hero headers
  - empty states
- which Qur’an-specific components/pages would benefit most from a Midnight Manuscript expression
- where component states might become unreadable or too low-contrast under the new theme

Before coding, identify:
- target files to modify
- new shared token/helper/component files to add
- what should be generalized centrally vs. refined only in Qur’an-specific components
- which components need cleanup for token compliance
- likely localization impact, if any

B. DEFINE THE MIDNIGHT MANUSCRIPT COMPONENT EXPRESSION
Create a clean design rule set for how shared components should look under Midnight Manuscript.

General direction:
- deep ink backing
- warm cream text
- gold accent for selected/emphasized states
- restrained bronze/brown border tones
- preserved glass/translucent fills
- subtle luminous hierarchy, not bright neon contrast
- refined selected states
- readable subdued unselected states

The result should feel like:
- a night manuscript aesthetic
- gold-lit interface details
- soft scholarly calm
- premium spiritual atmosphere

It should NOT feel like:
- generic gamer dark mode
- black-and-yellow harsh contrast
- flat matte redesign
- over-ornate antique UI

C. POLISH THE NAVIGATION SHELL / NAV BAR
Refine the main navigation shell under Midnight Manuscript.

Requirements:
- preserve current nav architecture and interaction behavior
- adapt background, icon, label, active state, divider, and glow treatments for Midnight Manuscript
- active tab should feel intentional and premium
- inactive tabs should remain clearly visible and readable
- the nav should still harmonize with the glass container system

Potential refinements:
- richer glass/nav surface tint
- subtle gold active indicator
- cream active labels
- subdued bronze inactive state
- gentle separator treatment

Do not reduce usability.
Do not make inactive tabs disappear into the background.

D. POLISH SEARCH FIELDS + INPUTS
Refine search fields and related input surfaces under Midnight Manuscript.

Requirements:
- preserve current input behavior and sizing
- ensure text fields/search bars feel elegant on dark glass surfaces
- placeholders remain readable
- borders/focus states are clear
- search icons/clear buttons remain visible
- selected/focused states should use gold or refined highlight behavior, not generic bright blue unless required by system constraints

Good direction:
- deep translucent fill
- soft manuscript border
- cream primary input text
- muted bronze placeholder/support text
- refined gold focus ring/border accent where appropriate

E. POLISH CHIPS + SEGMENTED CONTROLS
This is especially important for the Qur’an pages.

Refine:
- filter chips
- category chips
- segmented tabs/toggles
- selection controls
- Makki/Madani chips
- metadata pills

Requirements:
- selected states should feel premium and clear
- unselected states should remain readable
- outlines should feel soft but intentional
- selected gold should not be too loud
- Qur’an-specific chips may have slightly richer expression than general app chips

For Qur’an-specific chips:
- Makki can lean warm gold
- Madani can lean muted jade/teal
- neutral metadata chips should use cream/bronze hierarchy
- maintain consistent shape language with current app

F. POLISH BUTTONS + CTA STATES
Refine shared button styling for Midnight Manuscript.

Review:
- primary buttons
- secondary buttons
- tertiary/ghost buttons
- icon buttons
- small action buttons on cards

Requirements:
- preserve current interaction model and accessibility
- ensure primary CTAs feel clear but not loud
- ensure secondary buttons remain distinct
- ghost buttons remain readable on dark/glass surfaces
- disabled states remain visibly disabled without disappearing

Suggested expression:
- primary action may use gold-led emphasis where appropriate
- secondary actions can use dark glass + border treatment
- destructive/alert actions should still remain consistent with app semantics

Do not turn every button gold.
Preserve hierarchy.

G. POLISH BADGES + STATUS TOKENS
Refine badges and status indicators under Midnight Manuscript.

Includes:
- progress badges
- section badges
- metadata tags
- theme/pathway badges
- favorite/selected markers
- Qur’an badges such as revelation type or verse metadata

Requirements:
- clear hierarchy
- theme-consistent border/fill handling
- readable text
- no harsh color clashes
- preserve semantic distinction when needed

H. POLISH HERO HEADERS + SECTION HEADERS
Refine shared hero header and section header behavior under Midnight Manuscript.

Important surfaces:
- Qur’an page headers
- theme/pathway headers
- Settings/theme section headers if applicable
- major feature hero cards

Requirements:
- keep current reusable header architecture
- allow richer Midnight Manuscript presentation:
  - deeper ink gradient
  - subtle gold lift
  - stronger Arabic emphasis
  - warm cream support text
- preserve readability and not over-ornament

Section headers should feel:
- elevated
- elegant
- calm
- consistent across the app

I. QURAN-SPECIFIC COMPONENT POLISH
This pass should especially improve the Qur’an experience under Midnight Manuscript.

Focus on:
- Qur’an summary cards
- surah number badges
- Arabic title treatment
- metadata rows
- notable ayah pills
- theme chips
- pathway stop cards
- reflection and action cards
- Qur’an companion recommendation cards

Requirements:
- make these feel especially at home in Midnight Manuscript
- preserve shared component reuse
- avoid page-by-page bespoke styling unless truly necessary
- keep light and other themes safe

J. POLISH EMPTY STATES + SUPPORTING UI
Refine empty states and secondary supporting UI under Midnight Manuscript.

Includes:
- no results found
- no reflections yet
- no pathways found
- empty discovery states
- helper labels
- dividers
- subtitles
- metadata support text

Requirements:
- do not let muted text become too dim
- preserve clean hierarchy
- ensure empty states still feel hopeful and readable
- use the theme’s calm manuscript tone

K. CENTRALIZE COMPONENT TOKENS WHERE NEEDED
If the current theme system lacks component-level token granularity, extend it cleanly.

Possible additions:
- nav background / active indicator tokens
- search/input fill/border/focus tokens
- chip selected/unselected tokens
- button emphasis tokens
- badge tokens
- hero gradient tokens
- header ornament/divider tokens
- muted/secondary/tertiary text tokens
- Qur’an-specific emphasis tokens

Use ThemeExtension or the app’s existing token architecture.
Do not scatter Midnight Manuscript special cases throughout widget trees.

L. CLEAN UP HARDCODED STATE COLORS
Identify and safely refactor shared components or active pages that still use hardcoded state colors that conflict with Midnight Manuscript.

Prioritize:
- selection states
- active tab colors
- chip states
- search focus states
- outlined buttons
- icon button fills
- Qur’an metadata pills
- card borders

Do not start an unrelated mass refactor.
Only fix what is necessary for correct theme behavior.

M. PRESERVE OTHER THEMES
This is critical.

Any shared component cleanup or token extraction must not regress:
- default/light theme
- existing dark or other current themes
- current accessibility states
- current semantic color hierarchy

Midnight Manuscript should be an enhancement, not a breakage source.

N. OPTIONAL SUBTLE ORNAMENTAL DETAIL — VERY RESTRAINED
If the shared header/component architecture supports it cleanly, add very subtle manuscript-inspired polish such as:
- fine header divider treatment
- small gold accent separators
- elegant focus/selection shimmer or tint
- soft radial emphasis behind some Qur’an headers

This must remain minimal.
No clutter.
No busy decoration.
No performance-heavy effect stacks.

O. LOCALIZATION
If any new user-facing labels are added as part of component polish or settings previews, make them localization-ready.

Only add keys where needed.
At the end, report:
- new localization keys added
- locale resources updated

P. ACCESSIBILITY / EDGE CASES
Ensure the polished components remain accessible.

Requirements:
- strong contrast for interactive controls
- visible focus/selected states
- text scaling resilience
- readable placeholder/support text
- chips/buttons remain understandable at small sizes
- nav items remain clear
- reduced transparency handling stays coherent
- reduced motion settings remain respected if present

Do not let refinement reduce usability.

Q. TESTING / VALIDATION
After implementation:
- run analyzer on changed files
- verify Midnight Manuscript still appears in settings and persists
- verify nav shell looks correct and remains usable
- verify search fields/inputs/chips/buttons render correctly
- verify Qur’an pages especially benefit visually
- verify other app sections still look coherent
- verify light/default themes are not regressed
- verify no unreadable text or low-contrast states
- verify no route or interaction regressions
- verify accessibility and text scaling remain coherent

R. DELIVERABLE REPORT
At the end provide one clean implementation summary:
1. Audit findings
2. Shared components polished
3. Component-level token changes introduced
4. Qur’an-specific components refined
5. Which hardcoded colors/states were cleaned up
6. Nav/search/chips/buttons/badges/header changes
7. Whether other themes were affected and how compatibility was preserved
8. Localization keys added
9. Analyzer/test results
10. Follow-up recommendations

DESIGN SUMMARY
This pass should make Midnight Manuscript feel:
- complete
- refined
- premium
- coherent at the interaction level
- especially strong in the Qur’an section
- still faithful to Path of Nūr’s glass identity

It should NOT feel like:
- a component redesign for the whole app
- harsh gold-on-black styling
- a page-only visual tweak
- a separate design system

IMPORTANT
Build this as a real component-level refinement pass.
Do not break the current theme system.
Do not remove the existing glass container identity.
Do not let hardcoded component states undermine Midnight Manuscript.
At the very end, run a final audit and provide one complete implementation summary.
