===== PHASE 8 PROMPT — FULL APP PAGE AUDIT AND PRODUCTION-READINESS SWEEP =====

PRIMARY OBJECTIVE === BUILDING A FULL PAGE-BY-PAGE AUDIT AND PRODUCTION-READINESS SWEEP FOR PATH OF NŪR

You are working in the existing Flutter codebase for Path of Nūr.

This is a production-readiness audit and targeted improvement sweep across the app. DO NOT rebuild the app. DO NOT delete working user data, records, settings, progress, notes, stats, journeys, drops, garden state, prayers, adhkar, bookmarks, or learning progress. Build safely on top of the current implementation.

This phase is audit-first, then targeted production hardening. The goal is to identify every major app page/surface, evaluate its current production readiness, fix the highest-value issues, and leave behind a clear action map for the remaining work.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Do not do blind mass rewrites
- Preserve working logic and user data
- Do not remove features unless they are clearly broken, duplicated, placeholder-only, or harmful to UX consistency
- Reuse and improve existing pages instead of replacing them casually
- Keep offline-first behavior intact
- Preserve current routing, persistence, progress tracking, notes, XP, drops, garden, journeys, and learning systems unless improving them safely
- No destructive migrations
- No random UI churn without purpose
- Every improvement must move the app closer to production readiness
- At the end, provide one complete audit summary with prioritized findings and fixes completed

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Run a full audit of all major app pages and page-like surfaces

2. Identify what is needed to make the app production ready, including:
   - UX consistency
   - visual consistency
   - routing correctness
   - page structure quality
   - placeholder/incomplete states
   - broken navigation
   - duplicated content
   - missing empty/loading/error states
   - settings consistency
   - note/add-entry consistency
   - accessibility basics
   - localization gaps
   - persistence/state safety
   - performance red flags
   - offline readiness
   - test coverage gaps for critical surfaces

3. Implement a high-value targeted sweep for the most important production issues found

4. Leave behind a prioritized backlog for the remaining work

--------------------------------------------------
A. AUDIT INVENTORY (MANDATORY FIRST STEP)
--------------------------------------------------

First, build a page inventory of the app.

Audit and list all major app pages/surfaces, including but not limited to:
- Home page
- Prayer-related pages
- Qur’an home
- Qur’an reader/player
- Qur’an learning pages
- Hadith pages
- Learning Hub and its category pages
- Growth page and its destination pages
- Garden page
- Journey pages
- Statistics pages
- Notes pages and add/edit note flows
- Dhikr pages/counters
- Kids pages
- Explore / Browse All pages
- Reflection pages
- Spiritual pages
- Settings pages
- Profile-like pages if present
- Search pages
- Any modal/sheet-driven page-like surfaces that matter to core usage
- watch/tv companion pages only if they share Flutter page ownership in this codebase; otherwise exclude from this phase unless clearly connected

For each page/surface, classify:
- Production ready
- Mostly ready but needs polish
- Functional but structurally weak
- Incomplete / placeholder-heavy
- Wrongly routed / duplicated / confusing
- Needs redesign later but not now

Do not guess. Inspect the real code and routing.

--------------------------------------------------
B. PAGE-BY-PAGE AUDIT FRAMEWORK
--------------------------------------------------

For each major page, audit the following:

1. PURPOSE
- Is the page’s purpose clear?
- Does it match the navigation label?

2. INFORMATION ARCHITECTURE
- Is content grouped logically?
- Is there clutter, duplication, or mixed responsibilities?
- Are reading, learning, growth, and tools separated properly?

3. ROUTING
- Does the page open the correct destination pages?
- Are multiple cards incorrectly pointing to the same generic page?
- Are deep links and return flows sane?

4. VISUAL CONSISTENCY
- background treatment
- header/title treatment
- island/card styling
- spacing/padding
- section hierarchy
- typography consistency
- chip/button style consistency
- sheet/modal style consistency

5. FUNCTIONAL READINESS
- Does the page fully function?
- Are key actions obvious?
- Are there broken or placeholder interactions?

6. STATE/PERSISTENCE
- Does page state restore safely?
- Are progress and settings retained?
- Any fragile widget-lifecycle owned logic that should live elsewhere?

7. EMPTY / LOADING / ERROR STATES
- Are missing-data states graceful?
- Are loading states coherent?
- Are errors surfaced clearly and safely?

8. PRODUCTION POLISH
- inconsistent wording
- debug-like copy
- placeholder cards
- temporary labels
- unfinished toggles
- dead buttons
- non-performant sections
- obvious code smells affecting UX

9. ACCESSIBILITY BASICS
- tap target sanity
- readable contrast within existing theme
- semantic labeling where reasonable
- text overflow/large text resilience where practical

10. LOCALIZATION / STRING READINESS
- hardcoded strings
- missing localization hooks
- inconsistent naming across pages

11. TEST COVERAGE RISK
- is this a critical page with weak regression protection?

--------------------------------------------------
C. PRIORITIZE BY USER IMPACT
--------------------------------------------------

After the inventory, prioritize findings into:

P0 — Must fix for production
Examples:
- broken navigation
- destructive or risky state handling
- major user confusion
- missing critical page entry
- broken persistence
- obviously incomplete main surface
- wrong routing to unrelated page
- severe layout/overflow on core pages

P1 — Strongly recommended before production
Examples:
- inconsistent page architecture
- missing empty/loading states on key pages
- major notes/settings inconsistency
- poor search usability
- confusing duplicated resume cards
- high-friction flows

P2 — Valuable polish
Examples:
- wording cleanup
- minor layout improvements
- better grouping
- secondary page consistency
- non-critical localization gaps

P3 — Later enhancement
Examples:
- nice-to-have redesigns
- advanced customization
- deeper analytics/expansion

Use real judgment. Focus on release readiness, not perfectionism.

--------------------------------------------------
D. IMPLEMENT A HIGH-VALUE FIX SWEEP
--------------------------------------------------

After the audit, implement a targeted production hardening sweep for the most important issues you find.

Focus especially on:
- wrong or confusing routing
- page structure confusion
- duplicate/competing cards or sections
- obvious placeholders or incomplete page shells on main flows
- missing loading/empty/error states on major pages
- styling/scaffolding inconsistencies across core pages
- broken or inconsistent add-note flows
- core-page overflow/layout issues
- hardcoded production-facing strings in key surfaces
- fragile page-owned state that causes user-facing instability

Do not attempt to solve every single issue in one destructive rewrite.
Fix the most important production blockers and meaningful polish gaps safely.

--------------------------------------------------
E. CORE PAGE CONSISTENCY SWEEP
--------------------------------------------------

Run a consistency sweep across all major core pages.

Align where appropriate:
- page header format
- page background usage
- top spacing and safe area handling
- island/card component usage
- section heading hierarchy
- CTA/button placement
- summary vs detail content pattern
- search entry treatment where relevant
- bottom spacing and scroll completion
- empty/loading/error patterns
- note/add-entry affordances where relevant

Keep enough flexibility so pages still retain their own identity.

--------------------------------------------------
F. ROUTING AND DESTINATION CORRECTNESS SWEEP
--------------------------------------------------

Audit and fix major route issues.

Look for:
- cards routing to the wrong screen
- multiple top-level islands routing to one generic placeholder
- “Browse all” pages that do not actually browse anything meaningful
- pages that should link to detail pages but stop at shells
- broken back navigation or page-stack weirdness
- inconsistent route construction for the same destination

Preserve working route names/patterns where possible, but improve correctness.

--------------------------------------------------
G. NOTES / ADD ENTRY / CONTEXTUAL CREATION CONSISTENCY
--------------------------------------------------

Run a cross-app audit of contextual creation flows, especially:
- add note
- reflection creation
- note from ayah/hadith/content
- bookmark-adjacent note creation
- any contextual save/add sheet

Standardize behavior where high value:
- preserve source context
- sensible defaults
- consistent save UX
- no duplicate records
- consistent category/tag/source behavior
- editable but intelligently prefilled metadata

Do not overbuild a giant universal composer if that would be risky.

--------------------------------------------------
H. EMPTY, LOADING, ERROR, AND PLACEHOLDER SWEEP
--------------------------------------------------

Audit all core pages for production-grade states.

Fix cases where pages currently:
- show nothing with no explanation
- show placeholder text/cards
- use debug/developer wording
- have loading spinners without context
- fail silently
- have unfinished “coming soon” areas on key flows without graceful handling

Where a feature is truly not complete yet:
- handle it cleanly and honestly in the UI
- do not leave broken taps or dead buttons

--------------------------------------------------
I. PERFORMANCE / STATE SAFETY SWEEP
--------------------------------------------------

Audit page-level issues that hurt production readiness, such as:
- oversized build methods
- page-owned business logic that should live in state/controller layer
- duplicated listeners
- unnecessary rebuilds in major pages
- risky async lifecycle usage
- fragile restore-on-open behavior
- scroll/performance issues on big pages
- expensive search/filter logic on each keystroke without control

Fix the highest-risk items that visibly affect page reliability.

Do not do endless speculative optimization.

--------------------------------------------------
J. LOCALIZATION / STRING CLEANUP SWEEP
--------------------------------------------------

Audit user-facing strings across major pages.

Fix high-value issues:
- hardcoded core labels that should be localized
- inconsistent naming for the same concept
- awkward or temporary wording
- mixed terminology across pages
- labels that no longer match page purpose

Do not try to fully localize every last string in the whole app if that becomes too broad.
Prioritize core production surfaces.

--------------------------------------------------
K. ACCESSIBILITY / RESPONSIVENESS BASICS
--------------------------------------------------

Run a practical basics sweep across core pages:
- overflow issues
- cramped controls
- unreadable sections
- poor tap target size on key buttons
- obvious large-text clipping where practical to address
- semantic labels/testability hooks where useful

This is not a full accessibility overhaul, but obvious blockers should be fixed.

--------------------------------------------------
L. TESTING / REGRESSION PROTECTION
--------------------------------------------------

Add or update meaningful tests for the most critical production-ready surfaces and issues changed in this phase.

Prioritize test coverage for:
- page routing correctness
- core page presence/order where relevant
- empty/loading/error state rendering for important pages
- note/contextual creation safety
- search/reader/growth/high-priority page regressions caused by this phase
- any critical bug fixed during the audit sweep

Do not add fake tests. Add regression protection that actually matters.

Run analyzer/tests for changed areas and report clearly.

--------------------------------------------------
M. DELIVERABLE FORMAT
--------------------------------------------------

At the end provide one full structured production audit.

Include:

1. PAGE INVENTORY
For every major page/surface:
- name
- status classification
- short reason

2. TOP FINDINGS BY PRIORITY
- P0
- P1
- P2
- P3

3. FIXES COMPLETED IN THIS PHASE
- exactly what was changed
- which pages were improved
- what production blockers were resolved

4. FILES CHANGED
List all files created/updated/deleted

5. ROUTING AUDIT SUMMARY
- wrong routes found
- routes fixed
- any remaining ambiguous destinations

6. CONSISTENCY SWEEP SUMMARY
- visual/page scaffolding changes
- note/add-entry consistency changes
- empty/loading/error improvements
- string/localization cleanups

7. STATE / DATA SAFETY SUMMARY
- confirm no user data/progress was lost
- any migrations or model changes
- any backwards compatibility notes

8. VALIDATION
- analyzer/tests run
- results
- major warnings still remaining

9. FINAL PRODUCTION READINESS SCORECARD
Give a practical assessment such as:
- Core release blockers remaining
- Strong but still needs polish
- Production ready for internal beta
- Production ready for public beta after listed P0/P1 items
- etc.

10. FINAL AUDIT BLOCK
- what was completed
- what remains
- regressions found/fixed
- technical debt intentionally left for later
- recommended next phases in order

--------------------------------------------------
SUCCESS CRITERIA
--------------------------------------------------

This phase is successful if:
- the app now has a real page-by-page production-readiness audit
- major blockers across core pages are identified clearly
- highest-value production issues are fixed safely
- page routing and structure are materially cleaner
- placeholder/incomplete core page issues are reduced
- consistency across major pages is stronger
- no user data/progress is lost
- the project is left with a practical prioritized roadmap to full production readiness

--------------------------------------------------
DO NOT DO IN THIS PHASE
--------------------------------------------------

Do not:
- rebuild the entire app
- do a blind design-system rewrite
- remove large features just because they are imperfect
- reset progress/state
- create fake data to make dashboards look complete
- introduce breaking model changes without migration
- spend the whole phase on tiny polish while ignoring major blockers
- collapse distinct product areas into one generic page

Stay focused on full audit, production blockers, high-value fixes, and a clean roadmap.

--------------------------------------------------

“Allah does not burden a soul beyond that it can bear.” — Qur’an 2:286

===== END PHASE 8 PROMPT =====
