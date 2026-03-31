# PHASE 8 PROMPT — QURAN REFLECTION CAPTURE + SAVED INSIGHTS SYSTEM

PRIMARY OBJECTIVE === BUILDING QURAN REFLECTION CAPTURE + SAVED INSIGHTS SYSTEM

You are working inside the existing Flutter codebase for Path of Nūr.

This is a production-ready product architecture + personal reflection pass.
Do not build placeholders.
Do not break existing Qur’an flows, main Qur’an landing page, Quran Summary, Surah Summary Detail, Browse by Topic, Qur’an Pathways, personalized Qur’an companion recommendations, reader integration, playback, localization, accessibility, routing, or current local persistence systems.

IMPORTANT SAFETY + EXECUTION RULES
- Audit first before editing anything.
- Do not remove, delete, or overwrite working records, seeded content, routes, providers, widgets, or current Qur’an systems unless they are clearly and safely replaced.
- Do not go haywire and remove/delete records for no reason.
- Preserve route integrity, current feature behavior, shared theme reuse, localization structure, current reader entrypoints, and current recommendation logic.
- Reuse the shared Qur’an design system and existing repositories/providers instead of building parallel systems.
- This feature must feel calm, private, and reflective, not social or noisy.
- At the very end, run a full audit and provide one clean implementation summary.

PHASE CONTEXT
Previous phases introduced:
- Quran Summary and Surah Summary Detail
- reader integration
- reusable Qur’an design system
- surah enrichment
- thematic discovery
- Qur’an Pathways
- personalized Qur’an companion recommendations

Now Phase 8 should let users capture and revisit meaningful reflections.

GOAL OF THIS PHASE
Build a Qur’an Reflection Capture + Saved Insights system that allows users to:
- save personal reflections
- save notes linked to surahs, themes, pathways, or ayah references
- revisit saved insights later in one calm dedicated space
- optionally mark items as private favorites / reflection highlights

This should feel like a spiritual journal companion, not a productivity note dump.

CORE USER JOURNEYS TO ENABLE
1. User is viewing:
   - Surah Summary Detail
   - Theme Detail
   - Pathway stop / pathway detail
   - reader-linked reflection surface
2. User taps “Reflect” / “Save Reflection” / “Add Insight”
3. User writes a short reflection or note
4. Reflection is saved locally and tied to its source context
5. User can later open a dedicated “Saved Insights” / “Reflections” area
6. User can browse/search/filter saved reflections by:
   - surah
   - theme
   - pathway
   - recent date
   - favorites / highlights

A. AUDIT FIRST
Before making changes, audit and identify:
- whether there is already any notes, journal, or reflection system in the app
- whether there is already a generic saved-items/favorites/bookmark pattern that should be reused
- what current Qur’an surfaces exist where reflection entry points should be added:
  - Surah Summary Detail
  - Theme Detail
  - Pathway Detail / pathway stop
  - Reader or reader-adjacent surfaces if appropriate
- what current local persistence/storage system should be used
- whether there is an existing personal notes area elsewhere in the app that should align with this feature
- what shared cards/section wrappers/theme components from previous phases should be reused
- how privacy expectations should be preserved in the UI language and layout
- whether there is existing export/backup support that reflections should fit into structurally

Before coding, identify:
- target files to modify
- new files/models/repositories/providers/pages/widgets to add
- whether existing note models can be extended rather than duplicated
- likely localization keys needed
- what source contexts must be supported in the first version

B. DEFINE THE QURAN REFLECTION / SAVED INSIGHT CONCEPT
Create a clean product concept for reflection capture.

Possible naming directions:
- Reflections
- Saved Insights
- Qur’an Reflections
- My Reflections
- Insight Journal

Recommended product behavior:
- quick capture from multiple Qur’an surfaces
- calm and simple writing experience
- source-aware saved entries
- dedicated private library page for revisiting reflections
- optional favorite/highlight support
- optional tags only if they remain lightweight

This must NOT feel like:
- social posting
- comments
- public sharing
- a cluttered note-taking app
- a heavy document editor

C. CREATE A TYPED REFLECTION DATA MODEL
Build a production-ready typed data model.

Suggested reflection model fields:
- id
- createdAt
- updatedAt
- text
- title optional
- sourceType
- sourceId
- sourceLabel
- optional surahNumber
- optional ayahReference
- optional themeId
- optional pathwayId
- optional pathwayStopId
- optional reflectionPromptId or prompt label
- optional tags
- isFavorite / isHighlighted
- optional mood/category if the app already uses something similar and it fits
- optional deletedAt if soft delete is preferred
- optional order metadata if needed later

Possible source types:
- surah_detail
- theme_detail
- pathway
- pathway_stop
- ayah_reflection
- quran_companion_prompt
- reader_context

Keep this typed and maintainable.
Do not use loose unstructured maps.

D. CREATE A REFLECTION REPOSITORY + PERSISTENCE LAYER
Implement a typed repository for saving and retrieving reflections.

Requirements:
- use the app’s existing local persistence/storage approach
- robust create/update/delete behavior
- support listing by:
  - all reflections
  - favorites
  - surah
  - theme
  - pathway
  - recent
  - search term
- support lightweight counts if useful
- preserve compatibility with backup/export structures if the app already has them

Possible architecture:
- QuranReflectionRepository
- QuranReflectionLocalStore
- QuranReflectionService / manager
- provider/controller layer for UI state

Do not bury persistence logic inside widget trees.

E. ADD REFLECTION ENTRY POINTS TO KEY QURAN SURFACES
Add production-ready reflection entry points in the right places.

Recommended surfaces:
1. Surah Summary Detail
   - Add “Reflect” or “Save Reflection”
2. Theme Detail
   - Add “Reflect on this Theme” or similar
3. Pathway Detail / pathway stop
   - Add “Save Reflection”
4. Personalized Companion suggestion cards if applicable
   - only if there is a very natural reflection prompt moment
5. Reader-adjacent surfaces
   - only if a safe and natural place already exists; do not clutter the core reader UI

Behavior:
- opening reflection entry should pre-bind the correct source context
- optionally prefill a small prompt or helper line based on the context
- saving should return the user cleanly

Avoid cluttering every surface with too many buttons.
Be selective and elegant.

F. BUILD A REFLECTION CAPTURE EXPERIENCE
Create the reflection capture UI.

Options:
- modal sheet
- dedicated page
- compact inline composer
Choose the one that best fits current architecture and scaling needs.

Requirements:
- calm, minimal, readable
- optional title field only if it truly adds value
- main text area for reflection
- source context visible but subtle
- optional favorite toggle
- save action
- cancel/back behavior that feels safe
- draft protection if practical and clean

Possible helper text examples:
- What stood out to you?
- What guidance are you taking from this?
- What do you want to remember from this moment?
- How does this connect to your life right now?

Do not over-instruct.
Keep the tone gentle.

G. BUILD A DEDICATED “SAVED INSIGHTS / REFLECTIONS” PAGE
Create a dedicated private page where users can revisit saved reflections.

Recommended page content:
1. Hero/header
2. Search bar
3. Filter controls
4. Favorites/highlights section if useful
5. Recent reflections list
6. All reflections grouped or sorted cleanly
7. Empty state for users with no saved reflections

Possible grouping/filtering options:
- All
- Favorites
- Surahs
- Themes
- Pathways
- Recent

Each saved reflection card should show:
- short preview
- date
- source label
- source type badge if useful
- favorite/highlight state
- tap to open full reflection
- quick actions if appropriate

The page must feel:
- private
- peaceful
- uncluttered
- easy to scan

H. BUILD REFLECTION DETAIL / EDIT EXPERIENCE
Users should be able to open a saved reflection and:
- read it fully
- edit it
- toggle favorite
- delete it safely
- navigate back to its source if possible

The source link behavior should be production-safe:
- if linked source still exists, allow “Open Source”
- if source is unavailable, do not crash; just show the saved reflection

Keep editing simple and reliable.

I. ADD LIGHT SOURCE CONTEXT + BACK-LINKING
Every reflection should preserve where it came from.

Examples:
- Surah Yusuf
- Theme: Patience
- Pathway: Mercy and Hope
- Ayah reflection: 94:5–6
- Companion prompt: Evening Reflection

This context should appear:
- during capture
- on reflection cards
- in reflection detail
- optionally in filters/search metadata

This will make the system feel coherent and meaningful over time.

J. ADD FAVORITES / HIGHLIGHTS
Support a lightweight “favorite” or “highlight” mechanism.

Requirements:
- user can mark a reflection as important
- favorites can be filtered
- favorites should be visually distinct but still calm
- do not over-gamify or clutter with too many status types

This can be a simple heart/star/bookmark style state depending on app design language.

K. SEARCH + FILTER BEHAVIOR
Implement search and filtering for saved reflections.

Search should support:
- reflection text
- source label
- surah number/name if stored
- theme name if resolvable
- pathway title if resolvable

Filters should support:
- all
- favorites
- surahs
- themes
- pathways
- recent

Keep the first version intuitive.
Do not build an overly complex database UI.

L. PRIVACY + TONE REQUIREMENTS
This system must feel private and respectful.

Requirements:
- no public sharing defaults
- no social language
- no intrusive reminders in this phase
- use calm wording
- avoid language that makes saved reflections feel like tasks

Examples of good tone:
- Save Reflection
- Your reflection
- Saved insight
- Revisit this later
- Reflect on this moment

Avoid:
- Post
- Comment
- Broadcast
- Share now
- achievement-heavy note language

M. PREPARE FOR FUTURE EXPANSION
Without overbuilding, structure the system so future phases can support:
- ayah-linked reflection capture directly from reader
- export/import of reflections
- backup/sync inclusion
- reflection streaks or gentle revisiting prompts
- voice note reflection support
- richer journaling templates
- relationship to companion recommendations
- relationship to dhikr/prayer journals
- lock screen or watch quick reflection entry

Do not build all of this now.
Just keep the architecture open.

N. UI / DESIGN REQUIREMENTS
Use the reusable Qur’an design system and current app theme patterns.

Potential reusable/new widgets:
- reflection entry button
- reflection composer sheet/page
- reflection card
- reflection detail page
- favorite toggle
- source context row
- empty state for no reflections
- filter chips or segmented controls

Design tone:
- elegant
- intimate
- calm
- readable
- non-cluttered
- spiritually grounded

Ensure:
- strong light/dark behavior
- accessibility-friendly contrast
- text scaling resilience
- reduced motion friendliness

O. LOCALIZATION
All new user-facing text must be localization-ready.

Likely new localization keys may include:
- Save Reflection
- Reflect
- Your Reflections
- Saved Insights
- Add Insight
- What stood out to you?
- What guidance are you taking from this?
- What do you want to remember from this moment?
- Save
- Cancel
- Edit Reflection
- Delete Reflection
- Open Source
- Favorites
- Recent
- Surahs
- Themes
- Pathways
- No reflections yet
- Start saving meaningful insights from your Qur’an journey
- Mark as favorite
- Remove favorite
- Reflection saved
- Update reflection
- Search reflections

At the end, report:
- new localization keys added
- locale resources updated

P. ACCESSIBILITY / EDGE CASES
Handle safely:
- empty reflection text submission
- editing deleted/missing item
- source no longer available
- invalid source link
- no reflections yet
- search with no matches
- narrow layouts
- text scaling
- reduced motion
- light/dark theme variations

No crashes.
No broken blank screens.

Q. TESTING / VALIDATION
After implementation:
- run analyzer on changed files
- verify main Qur’an page still works
- verify Surah Detail / Theme Detail / Pathways still work
- verify reflection entry points open correctly
- verify save/edit/delete flow works
- verify source context is preserved correctly
- verify favorites filter works
- verify search/filter works
- verify no route regressions
- verify light/dark/accessibility presentation remains coherent

R. DELIVERABLE REPORT
At the end provide one clean implementation summary:
1. Audit findings
2. Reflection model introduced
3. Repository/persistence layer introduced
4. Entry points added
5. Saved Insights / Reflections page added
6. Search/filter/favorites behavior
7. Source linking/back-linking behavior
8. Files changed
9. Localization keys added
10. Analyzer/test results
11. Follow-up recommendations for Phase 9

PHASE 8 PRODUCT INTENT
By the end of this phase, users should be able to:
- discover the Qur’an by surah
- browse it by theme
- follow guided pathways
- receive calm contextual suggestions
- capture and revisit meaningful personal reflections

This should make Path of Nūr feel more intimate and spiritually supportive over time.

The result should feel like:
- a calm private reflection companion
- deeply integrated with the existing Qur’an experience
- respectful of personal spiritual moments
- easy to return to later

IMPORTANT
Build this as a real production-ready reflection system.
Do not create social/comment behavior.
Do not break current surah/theme/pathway/reader flows.
Do not overbuild a full journaling platform yet.
Keep it elegant, source-aware, scalable, and private.

At the very end, run a final audit and provide one complete implementation summary.
