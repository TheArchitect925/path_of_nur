===== PHASE 5 PROMPT — THEMATIC QURAN DISCOVERY + BROWSE BY TOPIC SYSTEM =====

PRIMARY OBJECTIVE === BUILDING THEMATIC QURAN DISCOVERY + BROWSE BY TOPIC SYSTEM

You are working inside the existing Flutter codebase for Path of Nūr.

This is a production-ready product architecture + discovery UX pass.
Do not build placeholders.
Do not break existing Qur’an flows, main Qur’an landing page, Quran Summary Island, Quran Summary page, Surah Summary Detail page, reader integration, playback, localization, accessibility, routing, or the reusable Qur’an design system introduced in earlier phases.

IMPORTANT SAFETY + EXECUTION RULES
- Audit first before editing anything.
- Do not remove, delete, or overwrite working records, seeded content, routes, providers, widgets, or current Qur’an systems unless they are clearly and safely replaced.
- Do not go haywire and remove/delete records for no reason.
- Preserve route integrity, current feature behavior, shared theme reuse, localization structure, and current reader entrypoints.
- Reuse the Qur’an theme/header/components introduced in earlier phases instead of rebuilding parallel UI.
- At the very end, run a full audit and provide one clean implementation summary.

PHASE CONTEXT
Previous phases introduced:
- Quran Summary Island on the main Qur’an page
- Quran Summary page with 114-surah summaries
- Surah Summary Detail experience
- reader integration
- reusable Qur’an theme/token system
- reusable Qur’an header system
- surah enrichment structure with themes, notable ayat, prophets/events, virtues, and reflection prompts

Now Phase 5 should unlock discovery.

GOAL OF THIS PHASE
Allow users to explore the Qur’an not only by surah, but also by theme/topic.

Examples:
- Mercy
- Tawhid
- Patience
- Repentance
- Prophets
- Judgment
- Paradise and Hell
- Signs of Creation
- Family
- Justice
- Charity
- Hypocrisy
- Guidance
- Worship
- Gratitude

The feature should feel like a natural extension of Path of Nūr’s learning and Qur’an experience, not a disconnected encyclopedia.

CORE USER JOURNEYS TO ENABLE
1. User opens the main Qur’an page
2. Sees a new thematic discovery entry point / island
3. Opens a “Browse by Topic” Qur’an discovery page
4. Explores theme cards/chips/categories
5. Taps a theme
6. Sees:
   - theme overview
   - related surahs
   - key ayah references (short references only unless safe existing translation support exists)
   - related prophets/events if relevant
   - action to open the surah detail or reader

A. AUDIT FIRST
Before making changes, audit and identify:
- where the current main Qur’an landing page is
- where the Quran Summary Island currently lives
- where a new thematic discovery entry point best fits in the current information architecture
- what theme/tag data already exists from Phase 4
- whether current surah enrichment data already includes enough normalized keyThemes to drive discovery
- whether a canonical “open surah detail” route/helper already exists
- whether a canonical “open in reader” route/helper already exists
- what reusable Qur’an components from Phase 3 should be reused
- whether there are existing topic/tag browsing patterns elsewhere in the app that should be reused or aligned with
- whether search/discovery widgets already exist that could help here

Before coding, identify:
- target files to modify
- new files/models/repositories/pages/widgets to add
- whether current theme tags need normalization or cleanup
- which routes need to be added
- likely localization keys needed

B. DESIGN THE THEMATIC DISCOVERY INFORMATION ARCHITECTURE
Implement a clean IA for thematic Qur’an discovery.

Recommended structure:
1. Main Qur’an page
   - existing Quran Summary Island remains
   - add new “Browse by Topic” / “Themes in the Qur’an” island

2. Thematic Discovery landing page
   - hero/header
   - search/filter
   - featured themes
   - all themes grid/list
   - optional grouped sections such as:
     - Belief
     - Worship
     - Character
     - Stories and Prophets
     - Akhirah
     - Society and Ethics
     - Signs and Reflection

3. Theme Detail page
   - theme overview
   - related surahs
   - key ayah references
   - related prophets/events
   - reflection angle
   - actions into surah detail / reader

Keep this scalable and calm.
Do not overwhelm users with giant taxonomy overload.

C. CREATE A NORMALIZED THEME REGISTRY
Build a production-ready normalized theme registry.

Create a typed model for theme/topic definitions, such as:
- id
- localized display name
- optional Arabic label if appropriate
- short subtitle/description
- category/group
- icon or visual motif identifier if appropriate
- sort order
- related keywords/search aliases
- optional color/style token hook
- optional reflection prompt seed
- optional featured flag

Important:
- do not rely only on free-text theme labels scattered across surah content
- normalize the theme system so “Patience” always maps to the same internal id, display name, and metadata
- ensure the surah enrichment content can reference theme ids cleanly

Suggested initial theme families:
Belief / Core:
- tawhid
- revelation
- guidance
- prophethood
- resurrection
- divine_mercy
- divine_justice

Worship / Spiritual Life:
- salah
- dua
- remembrance
- repentance
- gratitude
- trust_in_allah
- sincerity

Character / Inner Life:
- patience
- humility
- truthfulness
- generosity
- self_purification
- steadfastness

Stories / Historical Lessons:
- prophets
- moses
- ibrahim
- yusuf
- maryam_isa
- people_of_the_cave
- pharaoh

Akhirah / Accountability:
- day_of_judgment
- paradise
- hellfire
- accountability

Society / Ethics:
- family
- justice
- charity
- community
- hypocrisy
- modesty
- contracts_and_rights

Signs / Reflection:
- signs_of_creation
- heavens_and_earth
- life_and_death
- history_and_ruins

Keep the first version controlled and clean.
Do not create 100 tiny tags in this pass.

D. LINK SURAH ENRICHMENT TO THEME IDS
Update the surah enrichment data so key themes reference normalized theme ids rather than loose inconsistent labels where appropriate.

Requirements:
- preserve any current display behavior
- add a mapping layer if needed
- do not create migration chaos
- ensure multiple surahs can belong to multiple themes
- ensure a theme can resolve back to its related surahs cleanly

This relationship should power:
- theme landing page counts
- theme detail page lists
- future search/filter by theme
- future recommendations such as “More on patience”

E. ADD A NEW MAIN QURAN ENTRY POINT / ISLAND
Add a new island/card on the main Qur’an page.

Suggested directions:
- Title: Browse by Topic
- Subtitle: Explore the Qur’an through themes like mercy, patience, prophets, guidance, and the hereafter

Requirements:
- visually belongs with existing Qur’an landing page sections
- reuse current card language and Qur’an theme system
- no clutter
- strong but calm entry point
- localized text

The page should open the new thematic discovery landing page.

F. BUILD THE THEMATIC DISCOVERY LANDING PAGE
Create a dedicated thematic Qur’an discovery landing page.

Recommended content:
1. Reusable Qur’an hero/header
2. Search bar
3. Featured themes section
4. Browse by category section
5. All themes grid/list
6. Optional quick prompts like:
   - Need patience?
   - Looking for stories of prophets?
   - Want verses about gratitude?
   - Exploring the signs of creation?

Search behavior:
- search theme names
- search aliases/keywords
- optionally search by prophet/event labels if that fits the data cleanly

Filter behavior:
- by category/group if helpful
- keep the first version simple and intuitive

UI requirements:
- premium, calm, Path of Nūr-consistent
- reuse shared Qur’an components from earlier phases
- no overwhelming dashboard clutter

G. BUILD THE THEME DETAIL PAGE
Create a theme detail page.

Each theme detail page should include:
1. Header / Hero
   - theme name
   - optional Arabic helper label if appropriate
   - short overview
   - category label
   - count of related surahs if useful

2. Theme overview
   - short editorial/thematic introduction
   - concise, reverent, readable
   - not overly long

3. Related surahs
   - list/grid of surahs connected to this theme
   - each item should support navigation to Surah Summary Detail
   - optional compact metadata like Makki/Madani or verse count if it helps

4. Key ayah references
   - short references only
   - optional short descriptor
   - no long copied verse blocks unless safely supported by the app’s approved translation structure

5. Related prophets/events
   - compact chips/rows where relevant

6. Reflection prompt or gentle “ponder this theme” section
   - calm and concise

7. Actions
   - Open surah detail
   - Open in Reader
   - possibly “Browse more themes”

Gracefully omit sections with no data.

H. BUILD A THEME-TO-SURAH DISCOVERY REPOSITORY / QUERY LAYER
Implement the actual retrieval layer that powers theme browsing.

Possible architecture:
- theme registry repository
- surah enrichment repository
- theme discovery service / query layer

This should support queries like:
- get all themes
- get featured themes
- get themes by category
- search themes by term
- get surahs for theme X
- get ayah references for theme X
- get prophets/events for theme X
- get related themes for theme X (optional if useful)

Keep this typed and maintainable.
Do not hardwire everything inside widgets.

I. MAKE DISCOVERY FEEL CURATED, NOT RAW
This phase should not feel like dumping tags on the screen.

Do:
- use a curated list of themes
- provide short elegant descriptions
- highlight a few featured themes
- guide users toward meaningful exploration paths

Avoid:
- showing internal ids
- showing messy duplicate labels
- giant unfiltered chip clouds
- confusing search experiences

J. PREPARE FOR FUTURE “RECOMMENDED NEXT” FLOWS
Without fully building recommendations yet, structure the data and pages so future features can do things like:
- More on Mercy
- Related themes: Repentance, Gratitude, Trust in Allah
- Surahs connected to Musa
- Themes connected to patience and hardship
- Recommended next topic after reading a theme

Do not overbuild recommendation logic now.
Just lay the groundwork cleanly.

K. UI / DESIGN REQUIREMENTS
Use the reusable Qur’an design system from earlier phases:
- shared Qur’an hero/header
- shared cards
- shared section layouts
- shared chips/badges
- shared empty states
- shared search styling
- shared metadata rows where appropriate

Design tone:
- elegant
- scholarly
- calm
- navigable
- spiritually reflective
- not overloaded

Keep light/dark/accessibility behavior coherent.

L. LOCALIZATION
All new user-facing text must be localization-ready.

Likely new localization keys may include:
- Browse by Topic
- Themes in the Qur’an
- Featured Themes
- All Themes
- Browse by Category
- Related Surahs
- Key Ayah References
- Related Prophets
- Related Events
- Explore Theme
- Search Topics
- No themes found
- More themes
- Reflection
- Belief
- Worship
- Character
- Stories and Prophets
- Akhirah
- Society and Ethics
- Signs and Reflection

At the end, report:
- new localization keys added
- locale resources updated

M. ACCESSIBILITY / EDGE CASES
Handle safely:
- theme with no related surahs
- theme with only a few items
- search with no matches
- route opened directly with invalid theme id
- missing optional overview text
- narrow mobile layouts
- text scaling
- reduced motion
- light/dark theme adaptations

No crashes.
No blank broken pages.

N. TESTING / VALIDATION
After implementation:
- run analyzer on changed files
- verify main Qur’an page still works
- verify Quran Summary Island still works
- verify new Browse by Topic island opens correctly
- verify thematic discovery page loads correctly
- verify theme search/filter works
- verify theme detail page opens correctly
- verify related surahs navigate correctly to Surah Summary Detail
- verify reader integration still works
- verify no route regressions
- verify light/dark/accessibility presentation remains coherent

O. DELIVERABLE REPORT
At the end provide one clean implementation summary:
1. Audit findings
2. Theme registry/model introduced
3. Discovery repository/query layer introduced
4. Routes/pages added
5. Main Qur’an page island added
6. How themes link to surahs
7. How theme detail data is rendered
8. Files changed
9. Localization keys added
10. Analyzer/test results
11. Follow-up recommendations for Phase 6

PHASE 5 PRODUCT INTENT
By the end of this phase, users should be able to experience the Qur’an in two complementary ways:
- by surah
- by topic/theme

This should make the Qur’an section feel deeper, more discoverable, and more educational without losing calmness or simplicity.

The feature should feel like:
- a beautiful guided thematic explorer
- fully integrated with Quran Summary and Surah Detail
- naturally connected to the actual reader

IMPORTANT
Build this as a real production-ready discovery layer.
Do not create tag chaos.
Do not break current reader or surah flows.
Do not overbuild a giant academic taxonomy.
Keep it curated, scalable, and elegant.

At the very end, run a final audit and provide one complete implementation summary.
===== END PHASE 5 PROMPT =====
