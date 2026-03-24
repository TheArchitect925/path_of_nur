===== PHASE 55 PROMPT — ARABIC LEARNING LAUNCH READINESS AUDIT AND HARDENING =====

PRIMARY OBJECTIVE === PERFORMING A FULL ARABIC LEARNING LAUNCH-READINESS AUDIT AND APPLYING TARGETED FIXES TO ENSURE THE SYSTEM IS STABLE, CONSISTENT, ACCESSIBLE, LOCALIZATION-READY, AND PRODUCTION-QUALITY

You are working in the existing Flutter codebase for Path of Nūr.

This is a comprehensive audit + targeted hardening phase built on top of:
- shared Arabic alphabet foundation
- shared positional-form foundation
- shared Arabic audio manifest
- shared words/phrases and themed packs
- Kids Arabic tracing / reading / review systems
- Adult Arabic learning and reading helpers
- continuity/resume layer
- review layer
- search/filter
- Qur’an readiness bridge and advanced progression
- offline-first Arabic bundle
- lesson-pack framework

DO NOT rebuild systems. DO NOT introduce new large features. Focus on auditing, fixing, and hardening what already exists.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Preserve all current functionality, routing, and progress
- Fix issues with minimal, targeted changes
- No destructive migrations
- No large redesigns in this phase
- Maintain Kids vs Adult UX separation
- Ensure consistency with shared foundations
- Run analyzer/tests and summarize results

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Perform a full audit of the Arabic learning system across:
   - Kids Arabic
   - Adult Arabic
   - shared foundations
   - Qur’an bridge
   - themed vocabulary packs
   - continuity/review/search/dashboard layers

2. Identify and fix issues related to:
   - UX consistency
   - navigation and routing
   - accessibility
   - localization readiness
   - offline reliability
   - performance
   - content discoverability

3. Ensure the system is production-ready and cohesive

--------------------------------------------------
A. FULL SYSTEM AUDIT
--------------------------------------------------

Audit all Arabic-related surfaces:

- Kids Arabic:
  - tracing
  - words
  - phrases
  - review/practice
  - parent overview

- Adult Arabic:
  - alphabet overview
  - letter detail
  - words/phrases
  - reading helpers
  - adult overview

- Shared layers:
  - alphabet foundation
  - positional forms
  - audio manifest
  - content authoring framework
  - lesson packs

- Discovery:
  - search/filter
  - continuity/resume
  - review layer

- Qur’an:
  - readiness bridge
  - short surah bridge
  - advanced bridge progression

Audit questions:
- Are all features discoverable from existing pages?
- Are there any broken or confusing routes?
- Are there duplicate or conflicting entry points?
- Are labels consistent?
- Are there empty or weak states?
- Are there inconsistent data sources?
- Are Kids and Adults clearly distinct but aligned?

--------------------------------------------------
B. UX CONSISTENCY FIXES
--------------------------------------------------

Fix:
- inconsistent layouts
- mismatched card styles
- uneven spacing
- inconsistent CTA wording
- duplicate or confusing navigation paths

Ensure:
- consistent island/card system
- no unnecessary arrows (per previous rule)
- clear hierarchy across all pages

--------------------------------------------------
C. NAVIGATION AND ROUTING CLEANUP
--------------------------------------------------

Fix:
- incorrect route targets
- duplicate routes
- indirect or multi-hop navigation
- orphan pages not reachable from main flows

Ensure:
- all Arabic content is reachable from:
  - Kids Arabic landing
  - Adult Arabic landing
  - Continue Arabic Learning
  - Review
  - Search/filter
  - Qur’an bridge

--------------------------------------------------
D. EMPTY / ERROR / EDGE STATE HANDLING
--------------------------------------------------

Ensure:
- no blank pages
- clear first-time states
- graceful offline fallback states
- safe handling of missing audio/content

Replace:
- placeholder text
- debug labels
- incomplete UI shells

--------------------------------------------------
E. LOCALIZATION READINESS
--------------------------------------------------

Audit:
- hardcoded strings
- missing localization keys
- inconsistent terminology

Fix:
- high-visibility strings
- core navigation labels
- main Arabic learning surfaces

Ensure:
- structure is ready for full translation later

--------------------------------------------------
F. ACCESSIBILITY BASICS
--------------------------------------------------

Check:
- tap target sizes
- readability
- contrast
- overflow handling
- large-text behavior

Fix:
- obvious usability blockers

Do NOT attempt full accessibility compliance overhaul—just fix critical issues.

--------------------------------------------------
G. OFFLINE RELIABILITY CHECK
--------------------------------------------------

Verify:
- letters load offline
- words/phrases load offline
- audio works (or degrades gracefully)
- search/filter works offline
- review/continue works offline

Fix:
- any fragile dependencies

--------------------------------------------------
H. PERFORMANCE PASS
--------------------------------------------------

Audit:
- large widget rebuilds
- unnecessary recomputation
- slow loading pages
- heavy layouts

Fix:
- most visible performance issues

Do not prematurely optimize everything.

--------------------------------------------------
I. CONTENT DISCOVERABILITY CLEANUP
--------------------------------------------------

Ensure:
- lesson packs are visible
- themed vocabulary packs are reachable
- Qur’an bridge is easy to find
- review/practice is accessible

Remove:
- hidden or buried features

--------------------------------------------------
J. TESTING AND REGRESSION COVERAGE
--------------------------------------------------

Add/update tests for:
- routing correctness
- major page rendering
- search/filter outputs
- review/continue logic
- offline-safe behavior
- key UI states

Run:
- analyzer
- targeted tests

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

1. Files changed
2. Full audit findings
3. Top issues identified (P0, P1, P2)
4. Fixes applied
5. Routing cleanup summary
6. UX consistency summary
7. Data safety summary
8. Validation results
9. FINAL AUDIT + readiness score

--------------------------------------------------
SUCCESS CRITERIA
--------------------------------------------------

- Arabic learning system is cohesive and consistent
- no major navigation issues remain
- no broken or placeholder surfaces
- offline usage is reliable
- key UX inconsistencies are resolved
- system is ready for real users (internal/public beta)

--------------------------------------------------

“And whoever does an atom’s weight of good will see it.” — Qur’an 99:7

===== END PHASE 55 PROMPT =====
