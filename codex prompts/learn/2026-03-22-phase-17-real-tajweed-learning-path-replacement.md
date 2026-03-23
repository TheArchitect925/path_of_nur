===== PHASE 17 PROMPT — REAL TAJWEED LEARNING PATH REPLACEMENT =====

PRIMARY OBJECTIVE === BUILDING A REAL PRODUCTION-SAFE TAJWEED LEARNING PATH TO REPLACE THE CONTAINED PLACEHOLDER TAJWEED SURFACE

You are working in the existing Flutter codebase for Path of Nūr.

This is a targeted production-ready enhancement phase built on top of the existing Learn and Qur’an learning systems. DO NOT rebuild the whole Learn architecture. DO NOT remove working learning content, notes, bookmarks, progress, localization, routing, or release-gating infrastructure. Build safely on top of the current implementation.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Preserve existing Learn routing, progress, notes, bookmarks, and completion state
- Do not delete user learning data
- Reuse existing real Qur’an/Tajweed/Learn content where possible
- Replace placeholder Tajweed surfacing with a genuine production-safe learning path
- Do not expose planning/mapping pages as live learning content
- Do not create fake breadth or placeholder lesson trees
- Keep scope focused on building a real Tajweed path, not redesigning all Learn
- No unnecessary package churn
- At the end, provide a concise audit summary

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Replace the currently contained placeholder-backed `tajweed-basics` experience with a real production-safe Tajweed learning path

2. Create a clean Tajweed learning structure with real stages/modules and meaningful content

3. Wire Tajweed back into Learn discovery safely

4. Ensure the route feels like a real learning destination, not a planning shell

5. Preserve compatibility with existing Learn journey/progress infrastructure where safe

--------------------------------------------------
A. AUDIT (MANDATORY FIRST STEP)
--------------------------------------------------

Audit the current Tajweed/Learn implementation before editing.

Inspect:
- current `tajweed-basics` journey registration and route structure
- contained-state logic currently guarding that route
- any Qur’an learning pages that already contain Tajweed-related material
- any existing guides, mappings, seeds, lessons, or notes relevant to Tajweed
- learning journey models and stage structures
- progress/completion models for Learn journeys
- Learn discovery surfaces where Tajweed should appear
- any localization keys and copy already related to Tajweed

Audit these questions:
- What real Tajweed content already exists in the codebase?
- What content is currently planning-only and should not be surfaced as final lessons?
- What parts of the old `tajweed-basics` structure can be reused safely?
- What is the minimum real Tajweed path that is strong enough for production-safe Learn surfacing?
- Which routes should remain for compatibility, and which should now point to the real path?
- What progress/state model should the Tajweed path use so it fits the rest of Learn cleanly?

--------------------------------------------------
B. DEFINE THE REAL TAJWEED PATH STRUCTURE
--------------------------------------------------

Create a real Tajweed learning path with a clear and production-safe structure.

Prefer a focused path with a few strong modules rather than a large weak tree.

A recommended v1 structure may include only if supported cleanly:
- Introduction to Tajweed
- Why Tajweed Matters
- Arabic Letters and Articulation Basics
- Core Pronunciation / Recitation Rules
- Guided Practice / Review
- Continue Your Tajweed Journey

You may refine the module names based on real content already available, but the final structure must:
- feel like a real learning path
- have meaningful progression
- avoid placeholder stages
- avoid planning-only content being shown as live lessons

--------------------------------------------------
C. BUILD REAL TAJWEED CONTENT SURFACES
--------------------------------------------------

Create or upgrade the Tajweed path pages/stages so they are real production-safe learning surfaces.

Requirements:
- each surfaced stage/module should contain real instructional content
- pages should feel complete enough to learn from
- avoid raw planning/mapping text
- avoid “coming later” tone on live lesson pages
- keep the learning experience calm, clear, and aligned with Path of Nūr

If content is limited:
- build a smaller but real path
- do not pad with empty sections

Prefer reusing and adapting existing Learn/Qur’an instructional content where possible.

--------------------------------------------------
D. REPLACE THE CONTAINED PLACEHOLDER ROUTE SAFELY
--------------------------------------------------

Take the currently contained `tajweed-basics` route and replace its placeholder-backed behavior with the new real Tajweed learning path.

Requirements:
- preserve route compatibility where practical
- remove misleading contained state for Tajweed once the real path exists
- ensure direct route entry now lands in a real Tajweed experience
- keep back navigation and deep-link safety intact
- do not break existing progress records

If compatibility wrappers are needed, keep them lightweight and safe.

--------------------------------------------------
E. RE-SURFACE TAJWEED IN LEARN DISCOVERY
--------------------------------------------------

Once Tajweed is real and production-safe again, return it to the appropriate Learn discovery surfaces.

Requirements:
- surface Tajweed in the right Learn location(s)
- do not reintroduce it prematurely before the real path is ready
- keep Learn discovery trustworthy
- ensure the surfaced entry leads directly to the real Tajweed experience
- avoid duplicate Tajweed entry points unless intentionally useful

This may include:
- Learn journey discovery
- Browse All Learn
- Qur’an Learning related discovery
wherever it makes the most sense in the current architecture

--------------------------------------------------
F. KEEP TAJWEED DISTINCT FROM RAW GUIDES / MAPPINGS
--------------------------------------------------

Tajweed learning should not feel like a planning or internal guide surface.

Requirements:
- do not expose mapping/planning pages as the live Tajweed learning path
- if internal guides still exist, keep them non-production-facing
- make the Tajweed user experience clearly instructional and learner-friendly

--------------------------------------------------
G. PROGRESS / COMPLETION SAFETY
--------------------------------------------------

Ensure the real Tajweed path works safely with the existing Learn progress system.

Requirements:
- users should be able to enter, continue, and progress through Tajweed safely
- completion/progress should not break existing journey infrastructure
- historical or placeholder-era progress should not corrupt the new experience
- if some legacy progress state exists, handle it gracefully and explain in the final summary

Do not introduce risky migration logic unless absolutely necessary.

--------------------------------------------------
H. COPY / LOCALIZATION CLEANUP
--------------------------------------------------

Tajweed is a core learning area. Its visible copy should be production-safe.

Requirements:
- remove future-facing / placeholder wording from the live Tajweed path
- localize new user-facing strings
- keep terminology clear and consistent with the rest of Learn
- avoid overly technical labels unless they are explained well

--------------------------------------------------
I. EMPTY / ERROR / FALLBACK SAFETY
--------------------------------------------------

Ensure the Tajweed path behaves well in edge cases.

Requirements:
- no broken shell pages
- no raw placeholder cards
- graceful handling if a stage/module is unavailable
- safe fallback if legacy route state is encountered
- no dead taps

If a lesson is intentionally not yet included, do not surface it as a live lesson.

--------------------------------------------------
J. LIGHTWEIGHT LEARN CONSISTENCY SWEEP
--------------------------------------------------

After replacing Tajweed, do a lightweight consistency check on the affected Learn surfaces.

Check:
- Learn discovery wording
- route destinations
- Tajweed card/island placement
- page header/title consistency
- no disclosure arrows on islands/containers if that rule is already enforced app-wide
- no duplicate Tajweed surfacing in conflicting places

Do not broaden this into a full Learn redesign.

--------------------------------------------------
K. DATA SAFETY
--------------------------------------------------

Preserve:
- Learn progress
- notes/bookmarks tied to Learn content
- route compatibility where possible
- contained-state architecture for other still-incomplete Learn areas
- localization patterns already in place

Requirements:
- no destructive migrations
- no deletion of user data
- no breaking of other contained Learn routes
- no broad side effects outside Tajweed and directly related discovery surfaces

--------------------------------------------------
L. TESTING
--------------------------------------------------

Add or update meaningful tests for:

- `tajweed-basics` now opens a real Tajweed learning path
- Learn discovery surfaces Tajweed correctly again where intended
- contained-state behavior is removed only for the real Tajweed path and preserved for other still-contained Learn surfaces
- Tajweed route compatibility is preserved
- progress/completion state remains valid
- no broken routing or placeholder regressions are introduced

Do not add fake tests. Add regression protection that matters.

Run analyzer/tests for changed areas and report clearly.

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

1. Files changed

2. Audit findings
   - what real Tajweed content already existed
   - what was placeholder/planning-only
   - what structure was chosen for the real Tajweed path

3. Tajweed path summary
   - final modules/stages
   - where the content came from
   - how it is now production-safe

4. Routing summary
   - how `tajweed-basics` changed
   - how compatibility was preserved
   - where Tajweed is surfaced again in Learn

5. Progress/state summary
   - how progress/completion is handled
   - any legacy-state considerations

6. Localization/copy summary
   - what visible Tajweed strings were cleaned up or added

7. Data safety summary
   - confirmation that no user data/progress was lost

8. Validation
   - analyzer/tests run
   - results

9. FINAL AUDIT
   - what was completed
   - regressions found/fixed
   - remaining Learn follow-ups
   - technical debt intentionally left for later

--------------------------------------------------
SUCCESS CRITERIA
--------------------------------------------------

- `tajweed-basics` is no longer a contained placeholder experience
- Tajweed now exists as a real production-safe learning path
- Tajweed is surfaced correctly in Learn discovery again
- users can navigate the path and learn from real content
- no planning/mapping pages are exposed as live Tajweed lessons
- route compatibility is preserved where needed
- no learning progress/data is lost
- Learn becomes stronger, not just safer

--------------------------------------------------
DO NOT DO IN THIS PHASE
--------------------------------------------------

Do not:
- rebuild the entire Learn architecture
- create a giant advanced Tajweed academy beyond this phase
- expose planning/mapping pages as live lessons
- add fake placeholder stages to make the path look larger
- break contained-state behavior for other incomplete Learn areas
- broaden into full Learn localization cleanup outside Tajweed-related surfaces

Stay focused on replacing the contained Tajweed placeholder with a real Tajweed learning path and reintroducing it safely into Learn.

--------------------------------------------------

“Say, ‘My Lord, increase me in knowledge.’” — Qur’an 20:114

===== END PHASE 17 PROMPT =====
