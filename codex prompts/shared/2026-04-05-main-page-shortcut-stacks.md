===== PHASE X PROMPT — ADD PAGE-SPECIFIC VERTICAL SHORTCUT PILL STACKS TO ALL MAIN PAGES =====

PRIMARY OBJECTIVE === REPLICATE THE NEW SHORTCUT PILL PATTERN ACROSS ALL MAIN PAGES SO EACH MAIN PAGE HAS ITS OWN PAGE-SPECIFIC SHORTCUT STACK THAT NAVIGATES TO MAJOR DESTINATIONS WITHIN THAT SECTION

BUILDING === PAGE-SPECIFIC SHORTCUT NAVIGATION SYSTEM FOR MAIN PAGES

Context:
We now have the desired shortcut pill pattern:
- individual pills
- vertically stacked
- unique color per pill
- compact, premium, floating treatment

Now replicate this cleanly across the main top-level pages.
Each main page should have its own shortcut cluster that links to the most important destinations within that page’s section.

This must be implemented as a real reusable production-ready system, not page-by-page copy-paste.

IMPORTANT CONSTRAINTS
- Do not redesign the app’s global layout.
- Do not change unrelated page content.
- Do not introduce duplicate navigation systems that conflict with existing cards/buttons.
- Do not break routing, deep links, localization, semantics, or responsiveness.
- Ensure the system is not going haywire and removing deleting records for no reason.
- Keep the implementation reusable, scalable, and production ready.

MAIN GOAL
Each major page should have its own shortcut pill stack that:
- matches the new visual pattern
- is context-aware
- contains relevant shortcut destinations for that page
- helps users jump to major areas within that section
- stays visually secondary to the page hero / main content
- feels consistent across the app while still being section-specific

TARGET PAGES
Apply this to all main pages / top-level areas as appropriate, including the canonical main destinations currently used in the app shell.

Expected likely targets include:
- Home
- Worship
- Learn
- Journey
- Quran
- Settings or Profile-equivalent top-level page if that still exists in current canonical architecture

Audit the actual router and main shell first and only implement on the real current main pages.

STEP 1 — AUDIT FIRST
Before making changes, audit the repo and identify:
- the current canonical main pages
- where the current shortcut pill implementation lives
- shared surface/theming widgets that should be reused
- routing owners and canonical route names
- any existing page action menus or quick-jump components that should be unified with this system instead of duplicated badly

Also identify any pages where shortcuts do not make UX sense and call that out explicitly.

STEP 2 — CREATE A REUSABLE SYSTEM
Build a reusable shortcut system instead of duplicating widget code across pages.

Recommended architecture direction:
- page shortcut data model
- reusable shortcut stack widget
- reusable shortcut pill widget
- per-section configuration/mapping
- optional helper for route navigation / tap handling
- optional palette/style assignment system

Preferred direction:
- one shared page shortcut component family
- each main page passes its own shortcut definitions
- style remains consistent while content varies per section

Suggested component structure:
- MainPageShortcutItem
- MainPageShortcutStyle
- MainPageShortcutStack
- MainPageShortcutPill
- page-specific shortcut config/provider/mapper

STEP 3 — PAGE-SPECIFIC SHORTCUT CONTENT
Each main page should have shortcuts relevant to that section only.

Examples of intent:
Home:
- jump to major home-linked destinations or high-value actions
- avoid overcrowding

Worship:
- Prayer
- Dhikr
- Duas
- Qibla
- Tracking / Worship sections that are actually canonical in the current app

Learn:
- Foundations
- Quran & Hadith
- Prophets / Stories
- Kids
- Quizzes
- Notes / Reflections
- only if these routes are truly canonical and present

Journey:
- Growth / Garden
- Ocean / Drops
- Streaks / Calendar
- Character / Progress sections
- only based on actual app structure

Quran:
- Read
- Listen
- Surah Summary
- Bookmarks / Notes / Memorization / Continue Reading
- only what actually exists canonically

Settings/Profile area:
- Accounts / Profiles
- Notifications / Adhan
- Appearance
- Sync / Backup
- Privacy / Preferences
- only if this page is still a main-page destination in current architecture

Important:
Do not guess routes.
Audit the canonical routes and use the real current destinations only.

STEP 4 — SHORTCUT CURATION RULES
Do not overload each page with too many pills.
Aim for a curated set of the most useful destinations per page.

Guidance:
- keep each stack compact
- likely around 3–6 shortcuts per main page unless a page truly needs more
- prioritize high-value destinations
- avoid redundant destinations already visually dominant immediately next to the stack
- avoid adding shortcuts to destinations that are already the current page itself unless there is a meaningful subsection jump reason

STEP 5 — VISUAL / UX CONSISTENCY
All page shortcut stacks must share the same system and feel like one family:
- same general floating/compact treatment
- same spacing rhythm
- same shape language
- same typography scale
- same shadow/border treatment
- same alignment strategy unless a page genuinely needs a small layout adjustment

But:
- each pill should still have its own unique color
- each page’s stack should feel tailored to that page’s purpose

Color behavior:
- keep unique per-pill coloring
- keep palette tasteful and harmonized
- do not make the stacks loud or toy-like
- reuse theme tokens where possible

STEP 6 — PLACEMENT RULES
Place the shortcut stack in a consistent, intentional location on each main page.
It should:
- feel discoverable
- not collide awkwardly with titles/cards/location/weather/prayer surfaces
- not dominate the top of the page
- not break responsive layout
- not overlap essential content in a messy way

Audit each page layout and use the same pattern where possible.
If one page needs a slight vertical offset or spacing adjustment, keep it minimal and justified.

STEP 7 — NAVIGATION SAFETY
Ensure each shortcut pill:
- navigates to the correct canonical route
- respects existing router ownership
- does not create conflicting duplicate navigation flows
- does not push to legacy/alias routes when canonical routes exist
- does not break back navigation

If aliases currently exist, route the shortcut to the canonical destination.

STEP 8 — LOCALIZATION / ACCESSIBILITY
Ensure:
- labels are localized if the app localizes page action text
- semantics labels remain clear
- focus and screen reader behavior still works
- tap target remains reasonable
- no overflow on smaller widths
- stack remains readable on mobile and tablet sizes

STEP 9 — CLEAN IMPLEMENTATION
Avoid:
- repeated hardcoded containers across multiple pages
- inline color logic repeated in every page file
- route strings scattered everywhere
- visual inconsistencies between stacks
- shortcuts implemented through hacks layered onto page bodies

Prefer:
- central configuration
- shared component ownership
- minimal page-level glue code
- easy future extensibility

STEP 10 — TESTING / VALIDATION
Verify:
- all main pages still render correctly
- each page shows its correct shortcut stack
- taps navigate to the intended destinations
- no broken routes
- no overflows on narrow layouts
- no weird stacking overlaps
- no regressions in existing cards/buttons/headers
- no new focus/render/semantics assertions

Add/update targeted tests where appropriate for:
- page shortcut config mapping
- rendering of stack on representative pages
- navigation target correctness for shortcut items
- absence of duplicate/invalid destinations

OUTPUT REQUIRED
At the end provide:
A. files changed
B. canonical main pages detected
C. shortcut destinations assigned per page
D. reusable architecture introduced
E. routing strategy used for shortcut navigation
F. any pages intentionally excluded and why
G. final audit summary confirming the system is reusable, page-specific, and production ready

FINAL AUDIT REQUIREMENT
At the very end, audit the result and provide one full summary and note any follow-up improvements worth doing later.
