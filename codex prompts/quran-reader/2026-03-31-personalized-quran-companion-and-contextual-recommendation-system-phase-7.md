===== PHASE 7 PROMPT — PERSONALIZED QURAN COMPANION + CONTEXTUAL RECOMMENDATION SYSTEM =====

PRIMARY OBJECTIVE === BUILDING PERSONALIZED QURAN COMPANION + CONTEXTUAL RECOMMENDATION SYSTEM

You are working inside the existing Flutter codebase for Path of Nūr.

This is a production-ready product intelligence + UX integration pass.
Do not build placeholders.
Do not break existing Qur’an flows, main Qur’an landing page, Quran Summary, Surah Summary Detail, Browse by Topic, Qur’an Pathways, reader integration, playback, localization, theme behavior, accessibility, routing, or local progress systems.

IMPORTANT SAFETY + EXECUTION RULES
- Audit first before editing anything.
- Do not remove, delete, or overwrite working records, seeded content, routes, providers, widgets, or current Qur’an systems unless they are clearly and safely replaced.
- Do not go haywire and remove/delete records for no reason.
- Preserve route integrity, current feature behavior, shared theme reuse, localization structure, and current reader entrypoints.
- Reuse the shared Qur’an design system and existing repositories/providers instead of building parallel systems.
- Personalization must be explainable, calm, and lightweight.
- At the very end, run a full audit and provide one clean implementation summary.

PHASE CONTEXT
Previous phases introduced:
- Quran Summary Island and page
- Surah Summary Detail
- reader integration
- reusable Qur’an design system
- surah enrichment
- thematic discovery
- Qur’an Pathways with progress/resume

Now Phase 7 should make the Qur’an experience feel personal, timely, and supportive.

GOAL OF THIS PHASE
Build a Personalized Qur’an Companion layer that can gently recommend:
- surahs
- themes
- pathways
- reflections
based on the user’s current context and recent app activity.

The system should feel:
- calm
- spiritually supportive
- non-intrusive
- understandable
- aligned with Path of Nūr’s tone

This is NOT a manipulative feed.
This is a thoughtful companion layer.

CORE USER JOURNEYS TO ENABLE
1. User opens the main Qur’an page
2. Sees a “For You” / “Your Qur’an Companion” section
3. Receives a small set of contextual recommendations
4. Taps into:
   - a suggested surah
   - a suggested theme
   - a suggested pathway
   - a reflection prompt
5. Can continue where they left off, or explore something relevant to their current moment

Examples of contextual suggestions:
- after Fajr: reflective/light-start recommendations
- after Isha: calming or deeper reflection suggestions
- if user is on a consistency streak: gentle encouragement to continue
- if user recently explored hardship/patience content: suggest related mercy/hope pathway
- if user selected growth intentions during onboarding: weight suggestions toward those themes
- if user was in Musa-related content recently: suggest connected surahs/themes/pathways
- if user has unfinished pathway progress: offer resume
- if Friday: softly surface Al-Kahf or a Friday-relevant journey only if supported by current content model

A. AUDIT FIRST
Before making changes, audit and identify:
- what existing user context signals are already available in the app, such as:
  - onboarding interests / growth intentions
  - recent Qur’an activity
  - last opened surah/theme/pathway
  - reading progress
  - pathway progress
  - favorites/bookmarks if they exist
  - prayer timing context if available
  - streaks or daily engagement systems if available
- what persistence/storage layer already exists for lightweight personalized state
- whether there is already a recommendation-style section elsewhere in the app
- what reusable cards/components from previous phases can power a “For You” area
- what existing route helpers should be reused
- which signals are safe and stable enough to use now
- which signals should NOT be used yet because they are incomplete, noisy, or fragile

Before coding, identify:
- target files to modify
- new files/models/repositories/providers/services to add
- where the main companion entry point should appear
- which current data models need small extensions
- likely localization keys needed

B. DEFINE THE PERSONALIZED QURAN COMPANION CONCEPT
Create a clean product concept for a personalized companion layer.

Suggested entry labels:
- Your Qur’an Companion
- For You
- Continue Your Reflection
- Suggested for This Moment

The experience should:
- show a small, high-quality set of recommendations
- explain or imply why something is being suggested
- avoid overwhelming the user
- never feel like endless content feed behavior

Keep the recommendation count modest, for example:
- 1 primary recommendation
- 2–4 secondary suggestions

Possible recommendation types:
- Resume pathway
- Continue surah
- Explore a theme
- Suggested reflection prompt
- Time-of-day recommendation
- Related follow-up recommendation

C. CREATE A TYPED RECOMMENDATION MODEL
Build a production-ready typed model for personalized Qur’an recommendations.

Suggested fields:
- id
- type
- title
- subtitle
- description / helper line
- reason label / recommendation rationale
- priority score
- destination type
- destination id / route metadata
- optional surah number
- optional theme id
- optional pathway id
- optional ayah reference
- optional icon/motif key
- optional freshness timestamp
- optional dismissibility flag

Possible recommendation types:
- resume_pathway
- continue_surah
- theme_suggestion
- pathway_suggestion
- reflection_prompt
- time_of_day_pick
- friday_pick
- related_follow_up
- growth_intention_pick

Destination types may include:
- surah_detail
- theme_detail
- pathway_detail
- reader_entry
- reflection_surface

Keep this typed and maintainable.
Do not use unstructured ad-hoc maps.

D. BUILD A LIGHTWEIGHT RECOMMENDATION ENGINE / SCORING LAYER
Create a calm, rules-based recommendation engine.

Do NOT build a black-box AI system here.
Use understandable weighted rules.

Possible signal inputs:
1. Recent user activity
   - last opened surah
   - recent themes viewed
   - recent pathways viewed
   - recent reader activity
2. Resume state
   - incomplete pathway
   - unfinished surah/reading progress
3. User growth intentions / onboarding interests
4. Time of day
   - morning
   - afternoon
   - evening
   - night
5. Prayer context if real and already supported in app
   - before/after Fajr
   - before/after Maghrib
   - late evening reflection
6. Day context
   - Friday support if appropriate and grounded
7. Gentle diversity balancing
   - do not recommend the exact same thing repeatedly unless it is a resume item

Suggested scoring behavior:
- highest priority: resume meaningful in-progress content
- then contextual content relevant to current time or day
- then interest-aligned content
- then related follow-up content based on recent exploration
- then evergreen beginner-safe content

The engine should support:
- deduping
- priority sorting
- fallback recommendations when little user context exists
- explainable rationale strings like:
  - Continue where you left off
  - A gentle reflection for this morning
  - Based on your recent reading
  - Connected to your current pathway
  - A Friday reflection
  - Chosen from your growth focus

E. BUILD A PERSONALIZED COMPANION REPOSITORY / SERVICE LAYER
Implement a typed service/repository layer.

Possible architecture:
- QuranCompanionService
- QuranRecommendationEngine
- QuranRecommendationRepository
- lightweight user activity adapter/query layer

This layer should support:
- get recommendations for current user context
- get primary recommendation
- get secondary recommendations
- get recommendation rationale
- track recommendation impressions/open events if helpful locally
- optionally dismiss or rotate recommendations
- fallback safely when no context is available

Do not stuff all logic into widgets.

F. ADD A “YOUR QURAN COMPANION” SECTION TO THE MAIN QURAN PAGE
Add a new section on the main Qur’an page.

Requirements:
- visually fit the existing Qur’an landing page
- not overpower Quran Summary / Browse by Topic / Pathways
- feel premium, calm, and useful
- use shared Qur’an design system
- localized text

Suggested structure:
1. Section header
2. Primary recommendation card
3. Small row/list of secondary recommendations

Possible UI examples:
- Primary large recommendation:
  - “Continue Mercy and Hope”
  - “A reflection for this evening”
  - “Resume Patience in the Qur’an”
- Secondary cards:
  - Surah suggestion
  - Theme suggestion
  - Pathway suggestion

G. BUILD RECOMMENDATION CARD UI
Create reusable recommendation cards/widgets.

Possible card variants:
- primary companion card
- compact suggestion card
- reflection prompt card
- resume progress card

Each card should support:
- title
- subtitle/helper
- rationale/reason
- icon/motif
- optional progress indicator
- tap behavior
- optional badge like Resume / For this moment / Based on your journey

Design tone:
- warm
- calm
- gently intelligent
- not flashy
- not feed-like

H. SUPPORT CONTEXTUAL RECOMMENDATION CATEGORIES
Implement the first set of recommendation categories.

Recommended initial categories:
1. Resume recommendation
   - pathway in progress
   - recently opened surah
   - current reading thread
2. Time-of-day reflection
   - morning reflection
   - evening reflection
   - quieter late-night reflection
3. Growth intention recommendation
   - tied to onboarding interests or selected goals if available
4. Related follow-up
   - based on recent surah/theme/pathway engagement
5. Friday recommendation
   - only if grounded and content exists
6. Evergreen fallback
   - useful when there is very little personal activity data

Do not overbuild too many categories.
Start with a clean, meaningful set.

I. ADD A LIGHTWEIGHT USER ACTIVITY / CONTEXT SNAPSHOT MODEL
If needed, create a typed snapshot model that gathers the current user context in one place.

Suggested fields:
- recentSurahNumbers
- recentThemeIds
- recentPathwayIds
- activePathwayId
- lastOpenedDestination
- currentReadingProgress
- selectedGrowthIntentions
- currentTimeSegment
- currentPrayerContext if available
- isFriday
- streak info if already available
- favorite topics if already available

This should help keep the recommendation engine clean and testable.

J. PERSONALIZATION MUST REMAIN EXPLAINABLE
Every recommendation shown to the user should have either:
- a visible rationale label
or
- a clearly inferable reason

Good examples:
- Continue where you left off
- For your morning reflection
- Connected to your recent reading
- Based on your current journey
- Chosen from your growth focus

Avoid:
- mysterious recommendations with no context
- overly personal/casual phrasing
- manipulative “we noticed you…” type tone
- excessive behavioral tracking feel

K. HANDLE LOW-DATA / NEW-USER EXPERIENCE WELL
The system must work even when the user has little activity history.

For new or low-data users:
- show beginner-friendly evergreen recommendations
- optionally use onboarding growth intentions if available
- suggest a small starter pathway
- suggest a foundational surah/theme

Examples:
- Al-Fatiha overview
- Tawhid Foundations pathway
- Guidance theme
- Mercy and Hope pathway

Do not leave the companion area blank unless the design intentionally supports that gracefully.

L. OPTIONAL LIGHT DISMISS / REFRESH BEHAVIOR
If it fits cleanly, support lightweight interaction such as:
- dismiss one secondary recommendation
- refresh or rotate secondary suggestions
- persist a simple dismissed state briefly if needed

Do not overbuild feed controls.
This is optional and should remain simple.

M. PREPARE FOR FUTURE PERSONALIZATION EXPANSION
Without overbuilding, structure the system so future phases could support:
- recommendations tied to prayer completion
- recommendations tied to emotional check-ins
- recommendations tied to Dhikr/du’a habits
- recommendations tied to notes/reflections the user saves
- lock screen / widget companion suggestions
- watch companion suggestions

Do not build all that now.
Just keep the architecture open.

N. CONTENT / EDITORIAL REQUIREMENTS
All recommendation titles, subtitles, helper lines, and rationale labels should be:
- concise
- calm
- spiritually grounded
- readable
- not preachy
- not algorithm-sounding
- aligned with Path of Nūr tone

Examples:
- Continue Mercy and Hope
- A gentle reflection for this evening
- Revisit patience and trust
- Based on your recent reading
- Continue your pathway
- Start with guidance

O. UI / DESIGN REQUIREMENTS
Use the reusable Qur’an design system from earlier phases:
- shared section wrappers
- shared cards
- shared chips/badges
- shared headers
- shared empty/loading states where needed

Potential widgets to add:
- companion section
- companion primary card
- companion compact suggestion card
- rationale badge
- small progress row for resume items

Ensure:
- strong light/dark behavior
- accessibility-friendly contrast
- text scaling resilience
- calm motion only
- no clutter

P. LOCALIZATION
All new user-facing text must be localization-ready.

Likely new localization keys may include:
- Your Qur’an Companion
- For You
- Continue Your Reflection
- Suggested for This Moment
- Continue Where You Left Off
- Based on Your Recent Reading
- Based on Your Growth Focus
- For This Morning
- For This Evening
- Friday Reflection
- Resume Pathway
- Continue Surah
- Explore Theme
- Start Here
- Refresh Suggestions
- No suggestions right now
- Chosen for you
- Connected to your journey

At the end, report:
- new localization keys added
- locale resources updated

Q. ACCESSIBILITY / EDGE CASES
Handle safely:
- no activity history
- invalid linked destination
- pathway/surah/theme removed or missing
- duplicate recommendations from overlapping rules
- missing onboarding interests
- missing prayer context
- empty recent history
- text scaling
- reduced motion
- narrow layouts
- light/dark theme variations

No crashes.
No broken blank cards.

R. TESTING / VALIDATION
After implementation:
- run analyzer on changed files
- verify main Qur’an page still works
- verify Quran Summary / Browse by Topic / Pathways still work
- verify companion section renders correctly
- verify primary and secondary recommendation taps navigate correctly
- verify resume recommendations behave correctly
- verify fallback recommendations appear for low-data users
- verify deduping works
- verify rationale labels display correctly
- verify no route regressions
- verify light/dark/accessibility presentation remains coherent

S. DELIVERABLE REPORT
At the end provide one clean implementation summary:
1. Audit findings
2. Recommendation model introduced
3. Recommendation engine/service introduced
4. User activity/context snapshot model introduced
5. Main Qur’an page companion section added
6. Recommendation categories implemented
7. How scoring/prioritization works
8. Fallback behavior for low-data users
9. Files changed
10. Localization keys added
11. Analyzer/test results
12. Follow-up recommendations for Phase 8

PHASE 7 PRODUCT INTENT
By the end of this phase, the Qur’an section should support four complementary ways to engage:
- by surah
- by theme
- by guided journey
- by personal companion suggestion

This should make Path of Nūr feel more alive and supportive without becoming noisy or overly algorithmic.

The result should feel like:
- a calm intelligent companion
- deeply integrated with existing Qur’an systems
- helpful in the moment
- easy to continue over time
- respectful of the spiritual tone of the app

IMPORTANT
Build this as a real production-ready personalized layer.
Do not create a noisy content feed.
Do not break current surah/theme/pathway/reader flows.
Do not use opaque recommendation logic.
Keep it explainable, elegant, scalable, and calm.

At the very end, run a final audit and provide one complete implementation summary.
===== END PHASE 7 PROMPT =====
