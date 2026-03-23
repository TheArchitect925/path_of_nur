===== PHASE 23 PROMPT — KIDS LEARNING ISLAND ROUTING FIX AND DESTINATION PAGE CORRECTION =====

PRIMARY OBJECTIVE === FIX KIDS LEARNING ISLAND ROUTING SO EACH ISLAND OPENS ITS CORRECT DESTINATION PAGE WITH THE ACTUAL BUILT CONTENT

You are working in the existing Flutter codebase for Path of Nūr.

This is a targeted production-ready bug-fix and routing-correction phase. DO NOT rebuild the Kids Learning system. DO NOT remove existing kids content, kids story content, routes, notes, bookmarks, or progress. Build safely on top of the current implementation.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Preserve all existing kids learning content, progress, routes, notes, and bookmarks
- Do not delete or rewrite existing story/lesson content unless a tiny safe routing correction requires it
- Do not rebuild Kids Learning from scratch
- Fix routing so each island opens its actual intended destination page
- Reuse existing destination pages/content already built where possible
- Keep the Kids Learning landing page intact except for routing corrections and any tiny related cleanup needed
- No unnecessary package churn
- At the end, provide a concise audit summary

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Audit all islands/cards on the Kids Learning page

2. Identify why tapping any Kids Learning island is routing back to the Kids Learning page instead of the correct content page

3. Fix each island so it routes to its proper built destination/content page

4. Ensure each destination page actually surfaces the correct kids content already built

5. Preserve route stability and back navigation

--------------------------------------------------
A. AUDIT (MANDATORY FIRST STEP)
--------------------------------------------------

Audit the current Kids Learning implementation before editing.

Inspect:
- Kids Learning landing page / hub
- all kids learning island/card definitions
- tap handlers / navigation callbacks for each island
- route names and route builders used by Kids Learning
- any shared island widget used by Kids Learning
- each existing kids destination page already built
- any Browse All Kids Learning page if present
- Prophet Stories for Kids pages
- Hadith Stories for Kids pages
- Qur’an for Kids pages
- Hadith for Kids pages
- Arabic / letters / tracing pages
- kids games/quizzes pages if present
- duas for kids / manners/adab for kids pages if present
- any other kids content already surfaced or intended to be surfaced

Audit these questions:
- Which islands currently exist on Kids Learning?
- What route or callback does each one currently use?
- Why are they landing back on the Kids Learning page?
- Is one shared route mistakenly reused for all islands?
- Are the real destination pages already built but not linked?
- Are any islands pointing to placeholder or generic parent routes instead of child content routes?
- Which destination pages are production-safe and ready to receive traffic?
- Which islands should intentionally still point to Browse All, if any?

--------------------------------------------------
B. BUILD A CANONICAL KIDS ISLAND → DESTINATION MAP
--------------------------------------------------

Create a clear audited map of:

Kids Learning island
-> correct destination page
-> expected content shown there

For every surfaced kids island currently on the page.

Examples may include only if they truly exist in the current codebase:
- Prophet Stories -> Kids Prophet Stories page
- Hadith Stories -> Kids Hadith Stories page
- Qur’an for Kids -> Kids Qur’an page
- Hadith for Kids -> Kids Hadith page
- Arabic / Trace Letters -> Kids Arabic / tracing page
- Kids Games / Quizzes -> kids games page
- Duas for Kids -> kids duas page
- Browse All -> Kids Browse All page

This map should drive the fixes.

--------------------------------------------------
C. FIX THE ROUTING FOR EACH ISLAND
--------------------------------------------------

Correct each Kids Learning island tap target so it opens the proper destination page.

Requirements:
- each island must open its actual content page
- no island should route back to the Kids Learning landing page unless that is explicitly the intended Browse All behavior
- preserve back navigation
- avoid duplicate multi-hop routing if a direct route is cleaner
- do not create unnecessary new routes if the correct pages already exist

If the issue comes from a shared island tap handler or shared route constant, fix it at the correct shared level rather than patching each island in an inconsistent way.

--------------------------------------------------
D. VERIFY DESTINATION PAGE CONTENT OWNERSHIP
--------------------------------------------------

After routing is fixed, verify that each destination page actually shows the right built content.

Requirements:
- Prophet Stories island opens Prophet Stories content
- Hadith Stories island opens Hadith Stories content
- Qur’an for Kids opens the kids-safe Qur’an experience
- Hadith for Kids opens the kids-safe Hadith experience
- other kids islands open their own real content pages, not generic parents or unrelated pages

If a destination page currently exists but is incorrectly scoped or empty, do the minimum safe fix required to ensure the user lands in the correct content experience.

Do not redesign the content system in this phase.

--------------------------------------------------
E. HANDLE BROWSE ALL CORRECTLY
--------------------------------------------------

If there is a Browse All Kids Learning island:
- it may legitimately open a broader Kids Learning explorer/index page

But:
- only that island should do so intentionally
- other islands should not collapse back into the same generic parent page

Make this distinction explicit and correct.

--------------------------------------------------
F. SHARED COMPONENT / NAVIGATION BUG FIX
--------------------------------------------------

If the root cause is shared infrastructure, fix it centrally.

Possible root causes may include:
- shared island widget defaulting to parent page route
- wrong callback wiring
- reused navigation helper with incorrect arguments
- copy-paste route constants
- parent slug/id reused for all children

Requirements:
- centralize the fix where appropriate
- avoid ad hoc per-island hacks if a shared bug is causing the issue
- keep future regression risk low

--------------------------------------------------
G. LIGHTWEIGHT KIDS LEARNING CONSISTENCY SWEEP
--------------------------------------------------

After the routing fix, do a lightweight consistency pass on the Kids Learning section.

Check:
- island labels match destination page purpose
- no duplicate confusing islands
- no dead taps
- no disclosure arrows on islands/containers if that rule is already enforced app-wide
- visual layout remains unchanged or cleaner
- destination page titles match the selected island

Do not do a broad Kids redesign in this phase.

--------------------------------------------------
H. DATA / ROUTE SAFETY
--------------------------------------------------

Preserve:
- existing kids content
- kids learning progress
- notes/bookmarks tied to kids content
- existing destination pages
- route stability where possible

Requirements:
- no destructive migrations
- no content deletion
- no broken back navigation
- no accidental rerouting into adult/general pages
- kids entries must stay kids-safe

--------------------------------------------------
I. TESTING
--------------------------------------------------

Add or update meaningful tests for:

- each Kids Learning island renders
- tapping each surfaced island opens the correct destination
- islands no longer route back to the Kids Learning landing page incorrectly
- Browse All, if present, still routes correctly
- destination pages surface the expected content scope
- existing kids routes still work

Do not add fake tests. Add regression protection that matters.

Run analyzer/tests for changed areas and report clearly.

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

1. Files changed

2. Audit findings
   - current Kids Learning islands found
   - current incorrect route behavior
   - root cause of the routing loop/back-to-parent issue

3. Canonical island routing map
   - each island
   - final destination page
   - expected content shown

4. Routing fix summary
   - what was rewired
   - any shared navigation bug fixed
   - any route constants/helpers corrected

5. Destination content summary
   - confirmation that each island now opens the right built content

6. Data safety summary
   - confirmation that no kids content/progress/routes were broken

7. Validation
   - analyzer/tests run
   - results

8. FINAL AUDIT
   - what was completed
   - regressions found/fixed
   - any remaining follow-up items
   - technical debt intentionally left for later

--------------------------------------------------
SUCCESS CRITERIA
--------------------------------------------------

- Kids Learning islands no longer route back to the Kids Learning page incorrectly
- each island opens its correct destination page
- each destination page shows the correct built content
- Browse All, if present, behaves intentionally and separately
- no kids content, progress, or routes are broken
- the Kids Learning area feels real and production-safe

--------------------------------------------------
DO NOT DO IN THIS PHASE
--------------------------------------------------

Do not:
- rebuild the Kids Learning architecture
- redesign all Kids pages
- delete existing kids content
- route kids islands into adult/general pages
- create unnecessary new pages when correct ones already exist

Stay focused on fixing Kids Learning island routing and ensuring each island opens the right existing content page.

--------------------------------------------------

“And We made them leaders guiding by Our command.” — Qur’an 21:73

===== END PHASE 23 PROMPT =====
