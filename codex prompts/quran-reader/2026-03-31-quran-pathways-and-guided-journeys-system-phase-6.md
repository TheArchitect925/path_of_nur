===== PHASE 6 PROMPT — QURAN PATHWAYS + GUIDED JOURNEYS SYSTEM =====

PRIMARY OBJECTIVE === BUILDING QURAN PATHWAYS + GUIDED JOURNEYS SYSTEM

You are working inside the existing Flutter codebase for Path of Nūr.

This is a production-ready product architecture + guided experience pass.
Do not build placeholders.
Do not break existing Qur’an flows, main Qur’an landing page, Quran Summary Island, Quran Summary page, Surah Summary Detail page, thematic discovery pages, reader integration, playback, localization, accessibility, routing, or the reusable Qur’an design system established in earlier phases.

IMPORTANT SAFETY + EXECUTION RULES
- Audit first before editing anything.
- Do not remove, delete, or overwrite working records, seeded content, routes, providers, widgets, or current Qur’an systems unless they are clearly and safely replaced.
- Do not go haywire and remove/delete records for no reason.
- Preserve route integrity, current feature behavior, shared theme reuse, localization structure, progress/state behavior, and current reader entrypoints.
- Reuse the shared Qur’an theme/header/components from earlier phases instead of rebuilding parallel UI.
- At the very end, run a full audit and provide one clean implementation summary.

PHASE CONTEXT
Previous phases introduced:
- Quran Summary Island on the main Qur’an page
- Quran Summary page with 114-surah summaries
- Surah Summary Detail experience
- reader integration
- reusable Qur’an theme/token system
- reusable Qur’an header system
- surah enrichment structure
- thematic Qur’an discovery and browse-by-topic system

Now Phase 6 should make the Qur’an section feel guided, personal, and journey-based.

GOAL OF THIS PHASE
Allow users to follow curated guided Qur’an journeys/pathways instead of only browsing by surah or theme.

Examples:
- Patience in the Qur’an
- Tawhid Foundations
- Stories of Musa
- Mercy and Hope
- Reflection on the Hereafter
- Verses for Hard Times
- Gratitude and Blessings
- Character and Adab
- Du'a and Reliance on Allah
- Signs of Creation

These pathways should feel like calm, structured learning/reflection journeys inside Path of Nūr.

CORE USER JOURNEYS TO ENABLE
1. User opens the main Qur’an page
2. Sees a new “Guided Journeys” / “Qur’an Pathways” entry point
3. Opens a pathways landing page
4. Sees curated pathways with descriptions and progression
5. Taps a pathway
6. Sees pathway overview, its stops/segments, and progress
7. Opens individual stops, which may link to:
   - Surah Summary Detail
   - Theme Detail
   - Reader
   - short pathway reflections / prompts
8. Can resume a pathway later

A. AUDIT FIRST
Before making changes, audit and identify:
- where the current main Qur’an landing page is
- where Quran Summary and Browse by Topic entry points currently live
- where a new Guided Journeys / Qur’an Pathways entry point best fits in the current information architecture
- what data now exists from previous phases:
  - surah enrichment
  - notable ayat references
  - theme registry
  - theme-to-surah relationships
- whether there is already a generic “journey”, “learning path”, or “series progress” pattern elsewhere in the app that can be reused
- whether there is already local progress/persistence infrastructure suitable for pathway completion state
- whether current note/reflection/bookmark systems can be integrated later without blocking this phase
- what reusable Qur’an components from Phase 3 should be reused here
- whether there are existing route helpers for Surah Detail, Theme Detail, and Reader that must be reused

Before coding, identify:
- target files to modify
- new files/models/repositories/pages/widgets to add
- whether an existing learning-path architecture can be extended rather than rebuilt
- which routes need to be added
- likely localization keys needed
- what progress model should be used for pathway completion/resume

B. DEFINE THE PATHWAY / JOURNEY CONCEPT
Create a clean product model for Qur’an Pathways.

A pathway is a curated series of stops focused on a theme, story, spiritual need, or guided reflection arc.

Examples of pathway types:
- Theme-based pathway
- Prophet/story-based pathway
- Reflection-based pathway
- Spiritual support pathway
- Foundations pathway
- Beginner-friendly pathway

Each pathway should feel:
- structured
- calm
- purposeful
- short enough to be approachable
- rich enough to be meaningful

Do NOT make these huge academic courses in this phase.
Aim for guided spiritual/learning journeys with manageable depth.

C. CREATE A TYPED PATHWAY REGISTRY / DATA MODEL
Build a production-ready typed model for pathways.

Suggested pathway model fields:
- id
- localized title
- optional Arabic helper line if appropriate
- subtitle / short description
- category / pathway type
- difficulty or depth level if useful (Beginner / Reflective / Study)
- estimated length or number of stops
- optional cover motif / icon identifier
- optional featured flag
- optional sort order
- optional tags/theme ids
- optional reflection tone
- list of pathway stops

Suggested pathway stop model fields:
- id
- title
- short description
- stop type
- linked surah number if applicable
- linked theme id if applicable
- linked ayah reference(s) if applicable
- reflection prompt(s) if applicable
- action type / destination type
- optional unlock order / sort index
- optional completion criteria metadata

Possible stop types:
- surah_summary
- theme_detail
- ayah_reflection
- guided_reflection
- reader_entry
- paired_comparison
- prophet_story_anchor

Keep the structure typed and maintainable.
Do not create tangled untyped JSON/map chaos.

D. CREATE AN INITIAL CURATED SET OF PATHWAYS
Seed a clean first set of production-ready pathways.

Recommended starter set:
1. Patience in the Qur’an
2. Tawhid Foundations
3. Mercy and Hope
4. Stories of Musa
5. Signs of Creation
6. Reflection on the Hereafter
7. Gratitude and Blessings
8. Character and Adab
9. Du'a and Reliance on Allah
10. Verses for Hard Times

Each pathway should include:
- concise overview
- 4–8 meaningful stops
- logically ordered progression
- short reflection-oriented descriptions
- clean links into existing Qur’an features

Important:
- keep the content modest and curated
- do not overfill each pathway with too many stops
- prefer quality and coherence over volume

E. ADD A NEW MAIN QURAN ENTRY POINT / ISLAND
Add a new island/card on the main Qur’an page.

Suggested directions:
- Title: Qur’an Pathways
- Subtitle: Follow guided journeys through themes, stories, reflection, and meaningful verses

Alternative naming if it fits the app better:
- Guided Journeys
- Guided Qur’an Journeys
- Pathways in the Qur’an

Requirements:
- visually belongs with existing Qur’an landing page sections
- reuse current card language and Qur’an theme system
- no clutter
- clearly distinct from Quran Summary and Browse by Topic
- localized text

This entry point should open the Pathways landing page.

F. BUILD THE PATHWAYS LANDING PAGE
Create a dedicated pathways landing page.

Recommended content:
1. Reusable Qur’an hero/header
2. Intro text explaining what pathways are
3. Featured pathways section
4. All pathways list/grid
5. Optional category/group filters
6. Optional “Continue your pathway” section if progress exists
7. Optional quick prompts such as:
   - Need comfort?
   - Want to study Tawhid?
   - Exploring stories of the Prophets?
   - Looking for verses to reflect on hardship?

Requirements:
- premium, calm, Path of Nūr-consistent
- use shared Qur’an components from earlier phases
- elegant cards, not dashboard overload
- scalable and uncluttered

G. BUILD THE PATHWAY DETAIL PAGE
Create a dedicated pathway detail page.

Each pathway detail page should include:
1. Header / Hero
   - title
   - subtitle
   - optional Arabic helper text
   - estimated length / number of stops
   - optional category / depth badge

2. Pathway overview
   - what this pathway helps the user explore
   - concise and spiritually grounded
   - not overly long

3. Stops / Journey segments
   - visually ordered list or cards
   - each stop has:
     - title
     - short description
     - optional linked surah/theme/ayah info
     - progress/completion state
     - tap to open

4. Actions
   - Start Pathway
   - Resume Pathway
   - Mark current stop complete if appropriate
   - Open linked destination

5. Optional end reflection / summary section
   - keep light and calm

The page should feel like a guided companion, not a course dashboard.

H. BUILD STOP DESTINATION BEHAVIOR
Each pathway stop should open the correct destination using canonical routing/helpers.

Requirements:
- If stop type is surah_summary → open Surah Summary Detail
- If stop type is theme_detail → open Theme Detail
- If stop type is reader_entry → open Reader at the correct surah/ayah if supported
- If stop type is ayah_reflection → open the best existing detail surface available, or a lightweight reflection surface if needed
- If stop type is guided_reflection → open a clean internal reflection detail page if needed

Important:
- reuse existing real routes and navigation logic
- do not create duplicate surah or reader systems
- avoid broken or fake action flows

If a new lightweight “Pathway Stop Detail” page is truly needed, build it cleanly and only where useful.

I. ADD PATHWAY PROGRESS + RESUME
Implement a clean local progress system for pathways.

Minimum viable production-safe progress:
- track started pathways
- track completed stops
- determine next uncompleted stop
- allow Resume Pathway behavior
- allow Continue section on the landing page if progress exists

Suggested progress model:
- pathway id
- startedAt
- lastOpenedStopId
- completedStopIds
- completedAt if fully completed
- optional lastAccessedAt

Requirements:
- use the app’s existing local persistence approach if available
- do not overbuild cloud sync now unless already naturally supported
- keep progress lightweight and robust

Behavior:
- Start Pathway → marks pathway started
- Opening a stop can update lastOpenedStopId
- Completing a stop updates progress
- Resume continues at next meaningful point
- Completing all stops can show a soft completion state, not a gamified explosion unless aligned with app patterns

J. DESIGN THE EXPERIENCE TO FEEL REFLECTIVE, NOT TASKY
This is important.

The pathways system should not feel like:
- school homework
- a rigid checklist app
- a noisy productivity dashboard

It should feel like:
- guided reflection
- calm spiritual exploration
- meaningful sequencing
- supportive learning

Design guidance:
- soft progress indicators
- elegant completion markers
- thoughtful descriptions
- gentle CTAs
- avoid overwhelming stats clutter

K. CREATE A QUERY / REPOSITORY LAYER FOR PATHWAYS
Implement a typed retrieval layer.

Possible architecture:
- pathway registry repository
- pathway progress repository
- pathway query/service layer

This should support:
- get all pathways
- get featured pathways
- get pathway by id
- get continue/resume pathways
- get next stop for pathway
- mark stop complete
- mark pathway started
- compute completion percentage
- optional related pathways lookup

Keep this clean and testable.
Do not put all logic inside widgets.

L. OPTIONAL LIGHT RECOMMENDATION LINKS
Without building a full recommendation engine, support a few light relationships such as:
- related pathways
- more on this theme
- continue with another pathway after completion

Examples:
- After “Mercy and Hope” → suggest “Repentance” or “Gratitude and Blessings”
- After “Stories of Musa” → suggest “Tawhid Foundations” or “Patience”

Keep this curated and simple.

M. CONTENT STYLE REQUIREMENTS
All pathway titles, descriptions, stop labels, and reflection prompts should be:
- concise
- calm
- reverent
- readable
- spiritually useful
- not preachy overload
- not academically dense
- consistent in tone

Do not use sensational or unsupported wording.
Keep the editorial style aligned with Path of Nūr.

N. UI / DESIGN REQUIREMENTS
Use the reusable Qur’an design system from earlier phases:
- shared Qur’an hero/header
- shared cards
- shared chips/badges
- shared metadata rows
- shared empty states
- shared section wrappers
- shared search/filter styling if search is added

Potential reusable widgets to add:
- pathway card
- pathway stop card
- progress strip / progress badge
- continue pathway banner
- pathway completion badge

Design tone:
- elegant
- calm
- structured
- spiritual
- navigable
- not cluttered

Ensure coherent light/dark/accessibility behavior.

O. LOCALIZATION
All new user-facing text must be localization-ready.

Likely new localization keys may include:
- Qur’an Pathways
- Guided Journeys
- Featured Pathways
- All Pathways
- Continue Your Pathway
- Start Pathway
- Resume Pathway
- Continue Journey
- Stops
- Completed
- In Progress
- Not Started
- Pathway Complete
- Explore Pathway
- Reflect
- Open Stop
- Estimated Length
- Beginner
- Reflective
- Study
- Need Comfort?
- Want to Explore Tawhid?
- Stories of the Prophets
- No pathways found

At the end, report:
- new localization keys added
- locale resources updated

P. ACCESSIBILITY / EDGE CASES
Handle safely:
- invalid pathway id route
- pathway with missing optional metadata
- pathway with no stops
- progress partially corrupted or missing
- resume requested for not-yet-started pathway
- stop linked to missing destination data
- narrow mobile layouts
- text scaling
- reduced motion
- light/dark theme adaptations

No crashes.
No blank broken pages.

Q. TESTING / VALIDATION
After implementation:
- run analyzer on changed files
- verify main Qur’an page still works
- verify Quran Summary and Browse by Topic still work
- verify new Qur’an Pathways island opens correctly
- verify pathways landing page loads correctly
- verify pathway detail page loads correctly
- verify stop navigation works correctly
- verify progress starts, resumes, and completes correctly
- verify continue/resume section behaves correctly
- verify reader integration still works
- verify no route regressions
- verify light/dark/accessibility presentation remains coherent

R. DELIVERABLE REPORT
At the end provide one clean implementation summary:
1. Audit findings
2. Pathway registry/model introduced
3. Pathway progress model/repository introduced
4. Routes/pages added
5. Main Qur’an page island added
6. Initial curated pathways added
7. How stop routing/destinations work
8. How progress/resume works
9. Files changed
10. Localization keys added
11. Analyzer/test results
12. Follow-up recommendations for Phase 7

PHASE 6 PRODUCT INTENT
By the end of this phase, users should be able to engage with the Qur’an in three complementary ways:
- by surah
- by theme
- by guided journey

This should make the Qur’an section feel deeply alive, supportive, and structured for real exploration.

The feature should feel like:
- a calm spiritual guide
- beautifully integrated with Quran Summary and Browse by Topic
- naturally connected to Surah Detail and Reader
- easy to resume and continue over time

IMPORTANT
Build this as a real production-ready guided journey system.
Do not create checklist chaos.
Do not break current surah/theme/reader flows.
Do not overbuild a giant course engine.
Keep it curated, elegant, scalable, and reflective.

At the very end, run a final audit and provide one complete implementation summary.
===== END PHASE 6 PROMPT =====
