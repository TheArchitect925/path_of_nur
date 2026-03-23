## Phase 24 Prompt

===== PHASE 24 PROMPT — FULL APP PRODUCTION READINESS AUDIT AND CURRENT STATE REVIEW =====

PRIMARY OBJECTIVE === RUN A FULL APP-WIDE AUDIT TO ASSESS CURRENT PRODUCTION READINESS, IDENTIFY WHAT IS COMPLETE, WHAT IS WEAK, WHAT IS BROKEN, WHAT IS REUSABLE, AND WHAT SHOULD BE BUILT NEXT

You are working in the existing Flutter codebase for Path of Nūr.

This phase is AUDIT-FIRST. Do not jump into a broad rebuild. First inspect the current app state thoroughly and produce a clear, honest, production-focused assessment of where the project stands now after the recent waves of work.

This is a whole-app audit and current-state review.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Prefer evidence over assumptions
- Preserve all user data, progress, routes, notes, bookmarks, XP, drops, streaks, garden state, learning completion, prayer logs, dhikr logs, and settings
- Do not delete or rewrite production data
- Do not perform a broad refactor during the audit
- Tiny safe fixes are only allowed if absolutely necessary to complete the audit clearly, and must be documented
- Distinguish clearly between:
  - production ready
  - mostly ready but needs polish
  - functional but structurally weak
  - incomplete / placeholder-backed
  - broken / wrongly routed / misleading
- At the end, provide one prioritized roadmap of what should happen next

--------------------------------------------------
AUDIT OBJECTIVES
--------------------------------------------------

1. Run a full audit of the current app state

2. Identify what is now production-ready and what is not

3. Identify route issues, placeholder exposure, structural weaknesses, localization debt, and fragmented systems

4. Review all major product areas, including recent work, to see where the project truly stands now

5. Recommend the smartest next implementation phases based on the current real state of the codebase

--------------------------------------------------
A. AUDIT SCOPE
--------------------------------------------------

Audit all major app surfaces and systems, including but not limited to:

CORE APP
- Home
- navigation shell / top-level routing
- global shared UI/page scaffolding
- settings/profile
- search surfaces

LEARN
- Learning Hub
- Learn category pages
- Ibadah & Practice
- Qur’an Learning
- Hadith / Life / World / Prophets / FAQ / Notes
- Learn placeholder containment status
- legacy / contained routes
- route safety across Learn

KIDS
- Kids Learning landing page
- all Kids Learning islands
- island routing correctness
- Kids Prophet Stories
- Kids Hadith Stories
- Qur’an for Kids
- Hadith for Kids
- Arabic / letters / tracing
- kids games / quizzes if present
- kids browse-all / discovery pages

QUR’AN
- Qur’an home
- Qur’an reader
- Qur’an search
- Qur’an notes/reflections
- Qur’an learning hub
- reader transport/follow/completion state if already changed
- production-readiness of reader and learning pages

WORSHIP / PRACTICE
- Worship page
- Salah-related learning/training surfaces
- Wudu-related learning/training surfaces
- Wudu Trainer
- Wudu Trainer routing, completion, resume, rewards
- other Ibadah & Practice destinations

GROWTH
- Growth home
- Today / Paths / Habits / Journey / Reflection / Spiritual / Browse All
- Statistics page
- Garden routing
- Ocean dashboard
- journey stats
- growth page consistency and data rendering

NOTES / REFLECTION / JOURNAL
- Notes and Reflection page
- learning hub notes entry
- Browse All Notes
- note categories/default note metadata
- contextual note creation
- fragmentation across note/reflection/journal flows

DATA / SYSTEMS
- XP / drops / Ocean Drop integration
- completion tracking
- reward deduplication
- resume/restart patterns
- localization readiness
- empty/loading/error states
- tests around critical flows

--------------------------------------------------
B. AUDIT QUESTIONS
--------------------------------------------------

Answer these clearly and specifically:

1. What major app areas are now truly production ready?
2. What areas are mostly ready but need polish?
3. What areas are functional but structurally weak?
4. What areas are still incomplete, placeholder-backed, or misleading?
5. What major routing issues still remain?
6. What recent work is strong and should not be rebuilt?
7. Which systems are fragmented and need unification later?
8. What user-facing strings/localization gaps are still visible?
9. What critical missing tests still leave high regression risk?
10. What is the smartest next build order from here?

--------------------------------------------------
C. PAGE / FEATURE INVENTORY
--------------------------------------------------

For every major page/surface/system reviewed, classify it as one of:
- Production ready
- Mostly ready but needs polish
- Functional but structurally weak
- Incomplete / placeholder-backed
- Broken / misleading / wrongly routed

For each item include:
- name
- file/location or route family
- classification
- short reason

--------------------------------------------------
D. ROUTING AUDIT
--------------------------------------------------

Run a serious routing review across the app.

Look for:
- islands/cards routing to wrong destinations
- routes that loop back to parents incorrectly
- generic pages being reused where specific child destinations should open
- contained routes still surfaced accidentally
- kids routes landing in adult/general pages
- duplicated access paths causing confusion
- incomplete pages reachable from main discovery surfaces

Be explicit about:
- what is correct now
- what is still wrong
- what needs fixing next

--------------------------------------------------
E. CONTENT / PLACEHOLDER AUDIT
--------------------------------------------------

Audit which visible surfaces still expose:
- placeholder content
- weak stub content
- planning-heavy copy
- unfinished shells
- overly future-facing wording
- incomplete lesson/content catalogs

Focus especially on:
- Learn
- Kids
- Salah-related learning
- any remaining contained-but-still-visible surfaces
- any broad content areas that look bigger than they really are

--------------------------------------------------
F. PRODUCTION READINESS OF RECENT BUILDS
--------------------------------------------------

Specifically audit the recent major additions and improvements:

1. Learn placeholder containment
2. Kids Learning island coverage and routing
3. Kids content surfacing
4. Wudu assets and Wudu Trainer
5. Growth cleanup and statistics
6. Notes routing / categories / Browse All Notes
7. Qur’an improvements
8. app-wide island arrow cleanup

For each one, say:
- what is done well
- what is still weak
- whether it is production-ready now
- what follow-up it still needs

--------------------------------------------------
G. SYSTEM FRAGMENTATION AUDIT
--------------------------------------------------

Audit cross-cutting systems that may still be fragmented, such as:
- notes vs reflections vs journal
- learning progress vs trainer completion
- kids content ownership vs general learn ownership
- reward logic across trainers/learning
- route definitions across related sections
- localization coverage
- empty/loading/error state patterns

Call out the fragmentation that matters most for production readiness.

--------------------------------------------------
H. LOCALIZATION / STRING AUDIT
--------------------------------------------------

Audit visible user-facing surfaces for:
- hardcoded strings
- inconsistent naming
- placeholder/future-state copy
- untranslated or translation-ready-only values
- areas where localization debt is especially visible in core flows

Prioritize:
- Home
- Learn
- Kids
- Qur’an
- Growth
- Wudu Trainer
- Settings

--------------------------------------------------
I. TEST / REGRESSION AUDIT
--------------------------------------------------

Audit the current testing posture of the most important features and routes.

Identify:
- what critical flows are already protected
- what critical flows still lack regression tests
- where routing bugs or reward duplication bugs are still likely
- what the highest-risk untested areas are

Focus on:
- Kids Learning routing
- Learn containment / discovery
- Wudu Trainer flow and rewards
- Qur’an reader/search if recently changed
- Growth routing/statistics
- notes routing and category defaults

--------------------------------------------------
J. TINY SAFE FIXES ONLY IF ABSOLUTELY NECESSARY
--------------------------------------------------

If you discover a tiny, obvious, safe issue that directly blocks understanding the audit, you may fix it, but only if:
- it is very small
- it is low-risk
- it helps complete the audit clearly

Document every such fix explicitly.

Do not convert this audit into a giant implementation phase.

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

At the end provide:

1. FILES / AREAS REVIEWED
List the major files, routes, pages, and systems reviewed

2. FULL PAGE / FEATURE INVENTORY
For each major page/surface/system:
- name
- classification
- short reason

3. TOP FINDINGS BY PRIORITY
Use:
- P0 = production blockers
- P1 = strongly recommended before public beta
- P2 = valuable polish
- P3 = later enhancement

4. ROUTING AUDIT SUMMARY
Include:
- what routes are now correct
- what routes are still wrong
- what still loops/misroutes
- what needs the next routing pass

5. CONTENT / PLACEHOLDER SUMMARY
Include:
- what still feels unfinished
- what is safely contained
- what should be hidden/fixed next
- what strong content should remain as-is

6. SYSTEM FRAGMENTATION SUMMARY
Include:
- which systems are still fragmented
- which matter most for production readiness
- what should be unified later

7. RECENT BUILDS SCORECARD
For each recent major feature/pass:
- status
- confidence
- follow-up needed

8. DATA SAFETY SUMMARY
Confirm whether any user data, progress, routes, notes, rewards, or settings were changed

9. VALIDATION
If any analyzer/tests were run, report results clearly

10. FINAL PRODUCTION READINESS ASSESSMENT
Give a practical assessment such as:
- production ready for internal beta
- strong internal beta, needs these items for public beta
- public beta viable after P0/P1 fixes
- etc.

11. RECOMMENDED NEXT PHASES
Give the next implementation phases in the best order, based on the actual current state

12. FINAL AUDIT BLOCK
Include:
- what was found
- what is strongest and should not be rebuilt
- what is weakest and must be addressed
- what should be built next
- what technical debt can wait

--------------------------------------------------
SUCCESS CRITERIA
--------------------------------------------------

This phase is successful if:
- the current whole-app state is clearly understood
- production-ready vs weak areas are honestly classified
- routing/content/fragmentation issues are clearly identified
- recent work is evaluated realistically
- a smart next-phase roadmap is produced
- unnecessary rebuilding is avoided

--------------------------------------------------
DO NOT DO IN THIS PHASE
--------------------------------------------------

Do not:
- rebuild major systems
- hide weak findings behind vague language
- delete content or routes
- invent missing content
- turn this into a giant implementation pass

Be specific, practical, and honest.

--------------------------------------------------

“And say, ‘My Lord, increase me in knowledge.’” — Qur’an 20:114

===== END PHASE 24 PROMPT =====
