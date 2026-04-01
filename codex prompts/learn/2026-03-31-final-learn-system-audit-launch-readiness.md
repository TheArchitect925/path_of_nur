===== PHASE 11 PROMPT — FINAL LEARN SYSTEM AUDIT, CLEANUP & LAUNCH READINESS =====

PRIMARY OBJECTIVE === PERFORM A FULL, PRODUCTION-SAFE FINAL AUDIT OF THE ENTIRE LEARN SYSTEM, CLEAN UP REMAINING INCONSISTENCIES, VERIFY THAT ALL PRIOR PHASES WORK TOGETHER CORRECTLY, AND PREPARE THE LEARN EXPERIENCE FOR STABLE RELEASE WITHOUT BREAKING ROUTES, CANONICAL OWNERSHIP, PROGRESS, OR CURRICULUM STRUCTURE

You are working in the existing Flutter codebase for “Path of Nūr”.

This pass happens after:
- Learning Hub IA audit
- visible island consolidation
- naming/copy cleanup
- Guided Learning Paths V1
- safe Learn route / alias / canonical ownership consolidation
- deep UX polish & progression clarity
- personalization & path intelligence
- content gap audit & curriculum hardening
- Foundations Path hardening
- Daily Dhikr Path hardening
- Qur’an Beginner soft bridge
- Kids Starter Path hardening
- Stories Path creation
- Search, Discovery & Indexing upgrade
- Analytics, Optimization & Safe Retirement Planning
- Advanced Enrichment, Milestones & Long-Term Delight

This is the FINAL LEARN SYSTEM hardening pass before release readiness.
It is an audit + cleanup + validation pass.
It is NOT permission to do broad destructive rewrites.

Core safety rule:
Do not go haywire and remove/delete records, routes, pages, aliases, canonical owners, content, progress data, path ids, search mappings, analytics contracts, reward hooks, or kids/Qur’an systems for no reason.

==================================================
PRODUCT GOAL
==================================================

The Learn system should now feel:
- calm
- guided
- coherent
- beginner-safe
- discoverable
- stable
- polished
- ready for real users

This pass should answer:
- do all Learn surfaces now work together coherently?
- are there still duplicate visible entry points or mixed ownership signals?
- do guided paths, search, personalization, analytics, rewards, and route safety work together cleanly?
- are there any rough edges, dead ends, regressions, or inconsistencies left?
- what must still be fixed before calling the Learn system launch-ready?

==================================================
GUIDING PRINCIPLES
==================================================

- Audit first before changing
- Fix root causes, not symptoms
- Prefer small high-confidence cleanup
- Preserve compatibility
- Preserve canonical ownership
- Preserve beginner safety
- Preserve kids safety
- Preserve spiritual calm over feature sprawl
- Be honest about what is still not ready

==================================================
IMPORTANT NON-GOALS
==================================================

DO NOT:
- do a major IA rewrite again
- destroy legacy compatibility routes casually
- rewrite `/quran/*`
- rebuild kids systems
- create new large feature families
- invent placeholder fixes
- silently change stable identifiers without documentation
- over-polish by destabilizing the system

==================================================
FULL AUDIT SCOPE
==================================================

Audit the Learn system end-to-end, including where relevant:
- `/learn` landing
- main visible islands
- Explore / Browse surfaces
- guided paths and path overview screens
- path step routing and completion behavior
- Foundations Path
- Salah Path
- Qur’an Beginner Path
- Daily Dhikr Path
- Character Path
- Kids Starter Path
- Stories Path
- personalization / “Your Next Step”
- search / discovery / indexing
- related content
- analytics events
- milestones / completion moments
- legacy routes / aliases / redirects
- kids route family
- canonical `/quran/*` handoffs
- localization coverage
- performance-sensitive surfaces
- empty/loading/error states
- documentation consistency where applicable

==================================================
YOUR TASK
==================================================

1. PERFORM A FULL LEARN SYSTEM AUDIT
Audit the complete Learn flow from entry to discovery to progression to completion.

Review:
- visible user experience
- route safety
- content handoffs
- canonical ownership clarity
- beginner-friendliness
- kids-friendliness
- personalization quality
- search/discovery coherence
- analytics coverage
- milestone behavior
- localization completeness
- launch readiness

Identify:
- remaining mixed ownership signals
- rough UX edges
- inconsistent naming/copy still visible
- dead ends
- path steps that still feel too hub-like
- weak completion flows
- search results that still feel too broad
- personalization suggestions that feel weak or noisy
- analytics gaps
- milestone duplication or thinness
- regressions introduced by later phases
- places where multiple systems now overlap awkwardly

2. AUDIT PATH-BY-PATH LAUNCH READINESS
For each current guided path:
- Foundations
- Salah
- Qur’an Beginner
- Daily Dhikr
- Character
- Kids Starter
- Stories

Assess:
- clarity of first step
- progression quality
- handoff quality
- completion meaning
- discoverability
- resume behavior
- route safety
- beginner appropriateness
- whether each is launch-ready, nearly ready, or still weak

3. AUDIT MAIN LEARN SURFACES
Assess launch readiness for:
- Learn landing
- Explore
- search/discovery
- Your Next Step / Continue
- guided path entry
- kids discovery
- Qur’an entry handoff
- games visibility
- stories visibility
- secondary utilities placement

4. AUDIT CANONICAL OWNERSHIP CLARITY
Reconfirm and verify that:
- `/learn` is the main Learn front door
- `/quran/*` remains canonical Qur’an owner
- kids route family remains preserved as the kids owner
- guided paths are orchestration layers, not duplicate owners
- search/discovery respects ownership
- personalization respects ownership

Identify any remaining places where the UI or routes still imply conflicting ownership.

5. AUDIT LEGACY / ALIAS SAFETY
Verify that:
- compatibility routes still work
- redirects do not loop
- legacy routes do not compete too strongly in visible UX
- retirement candidates remain documented, not prematurely removed

Identify:
- aliases that are safe and useful
- aliases that are noisy but still needed
- aliases that are potential post-launch cleanup candidates

6. AUDIT SEARCH / PERSONALIZATION / MILESTONE INTEGRATION
Verify these systems work together coherently:
- search finds strong destinations
- personalized suggestions do not conflict with active paths
- milestones trigger at appropriate moments
- path completion enrichment feels consistent
- related content suggestions are helpful and not repetitive
- analytics can observe important flows cleanly

7. AUDIT LOCALIZATION / COPY / UX CONSISTENCY
Check:
- no newly added hardcoded user-facing strings slipped in
- visible naming remains consistent
- tone remains calm and spiritually aligned
- kids copy remains appropriate
- no odd leftovers from older naming models remain in primary UX

8. AUDIT PERFORMANCE / STABILITY / OFFLINE-FIRST
Check:
- no obvious rebuild storms
- search remains responsive
- recommendation calculations remain lightweight
- path progress loads safely
- milestone logic is efficient
- analytics does not block UI
- offline-first expectations remain intact

9. IMPLEMENT SMALL HIGH-CONFIDENCE FIXES
You may implement:
- small copy cleanups
- small route safety fixes
- small path sequencing fixes
- small empty/loading/error state improvements
- small search result grouping refinements
- small milestone/personalization smoothing
- small documentation corrections

But:
- do not start a new architecture phase
- do not broaden scope
- do not introduce risky rewrites during final cleanup

10. CREATE A FINAL LAUNCH READINESS REPORT
Create:
docs/final_learn_system_audit_launch_readiness_2026-03-31.md

It must include:
- executive summary
- overall readiness assessment
- launch-ready areas
- nearly-ready areas
- not-ready-yet areas
- path-by-path readiness table
- route/ownership verification
- search/discovery readiness
- personalization readiness
- analytics readiness
- milestone/enrichment readiness
- localization readiness
- performance/stability notes
- blockers before release
- recommended final fixes
- post-launch watch items

11. CREATE A FINAL FIXLIST / PUNCHLIST
Create:
docs/final_learn_punchlist_2026-03-31.md

Include:
- critical issues
- medium issues
- low polish issues
- owner/risk/dependency notes
- recommended order
- do-not-break notes
- post-launch candidates vs pre-launch blockers

12. OPTIONAL: CREATE A LAUNCH CHECKLIST
Create:
docs/final_learn_launch_checklist_2026-03-31.md

Include:
- route checks
- path checks
- kids checks
- Qur’an handoff checks
- search checks
- personalization checks
- analytics checks
- milestone checks
- localization checks
- performance/manual QA checks

13. TESTING / VALIDATION
Where practical, run or update focused validation for:
- route safety
- path start/resume/complete
- canonical Qur’an handoff
- kids route safety
- search result launch
- personalization next-step resolution
- milestone triggering
- analytics event emission where core logic changed

Do not overbuild, but ensure meaningful validation exists for the most important Learn flows.

14. LOCALIZATION
If any user-facing copy changes are made:
- preserve localization structure
- reuse keys where possible
- add minimal new keys only if necessary
- update relevant locale files

At the end, report:
- keys added
- keys reused
- locale files updated
- or confirm none changed

==================================================
READINESS RATING MODEL
==================================================

Use a simple readiness rating in the final report:
- Ready
- Ready with minor polish
- Needs targeted fixes
- Not ready yet

Be honest.
Do not claim everything is ready unless the audit supports it.

==================================================
VALIDATION
==================================================

Before finishing, confirm:

1. The full Learn system was audited end-to-end.
2. All main guided paths were reviewed for launch readiness.
3. `/learn` remains the front door.
4. `/quran/*` remains canonical and protected.
5. Kids route family remains safe and discoverable.
6. Search/discovery is coherent.
7. Personalization is coherent.
8. Analytics coverage is sufficient for launch monitoring.
9. Milestones/enrichment are calm and stable.
10. Legacy/alias routes remain safe.
11. Localization remains intact.
12. Performance/offline-first expectations remain intact.
13. Any implemented fixes were small, targeted, and safe.
14. Analyzer passes on changed files, or remaining issues are clearly explained.

==================================================
DELIVERABLES
==================================================

1. Perform the final Learn system audit.
2. Implement only small high-confidence fixes if needed.
3. Create the final launch readiness report.
4. Create the final punchlist.
5. Create the final launch checklist.
6. Return a concise but thorough summary including:
   - overall launch-readiness assessment
   - strongest launch-ready areas
   - biggest remaining blockers
   - files changed
   - files created
   - small fixes implemented
   - localization impact
   - test/validation impact
   - analyzer results
7. At the very end, audit your own final audit and provide one full summary so we can decide whether the Learn system is ready to ship.

===== END PHASE 11 PROMPT — FINAL LEARN SYSTEM AUDIT, CLEANUP & LAUNCH READINESS =====
