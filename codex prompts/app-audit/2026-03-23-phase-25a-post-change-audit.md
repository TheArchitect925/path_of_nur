# Phase 25A Prompt — Post-Change Audit + Action Plan Input

PRIMARY OBJECTIVE === BUILDING A FRESH POST-CHANGE AUDIT FOR PATH OF NŪR AFTER RECENT MANUAL/CODEX CHANGES

You are working in the existing Path of Nūr codebase.

This is an AUDIT-FIRST phase.
Do not start broad implementation.
Do not delete, merge, or rewire anything unless explicitly asked later.

The purpose of this phase is:
1. audit the app again after recent changes
2. identify what improved
3. identify what regressed
4. identify what is still broken
5. identify what is now the highest-priority next work
6. prepare a clean action plan foundation for the next phase

========================================================
CORE INSTRUCTION
========================================================

A previous audit exists, but it is now potentially stale because recent changes were made.

You must perform a fresh current-state audit based on the live code as it exists now.

Do NOT assume previous findings are still true.
Re-verify everything from code and tests.

========================================================
AUDIT SCOPE
========================================================

Audit these areas carefully:

A. ROUTING / NAVIGATION
- app shell
- top-level tabs
- canonical ownership
- alias usage
- broken routes
- discovery surfaces
- deep links
- back navigation behavior
- route regressions

B. QUR’AN AREA
- main Qur’an hub
- island structure
- Continue / Read Qur’an behavior
- reflections route
- learning grouping
- search scope
- quote visibility
- Learn-owned Qur’an aliases vs `/quran*`

C. LEARN AREA
- `/learn` hub
- category discovery truthfulness
- journey-related Learn surfaces
- kids entry behavior
- placeholder containment
- overlap vs canonical routes

D. KIDS AREA
- kids landing/discovery
- back-stack behavior
- category ownership
- Qur’an/Hadith/Arabic/Dua/story routes

E. JOURNEY / GROWTH / GARDEN
- home
- browse all / paths behavior
- tracking dashboard
- garden onward navigation
- alias families

F. WORSHIP / WUDU
- prayer/dhikr deeplinks
- salah hub
- wudu trainer / quiz / guide flow
- regression status

G. WRITING / RETENTION SYSTEM
- notes
- reflections
- journal
- fragmentation status
- whether anything improved or got worse

H. LOCALIZATION / COPY
- visible hardcoded English on live surfaces
- runtime localization shim reliance
- misleading or future-facing copy
- truthfulness of labels and empty states

========================================================
MANDATORY AUDIT-FIRST TASKS
========================================================

Before writing conclusions, verify:

1. current analyzer status
2. current focused regression status
3. which previously failing tests are now fixed
4. which new regressions appeared
5. which previous audit findings are now obsolete
6. which routes/pages changed materially
7. whether recent changes improved or worsened canonical ownership clarity

Do not guess.
Use current code and test evidence.

========================================================
REQUIRED OUTPUT FORMAT
========================================================

Return exactly:

1. Executive Summary
2. Current Health Snapshot
3. What Changed Since The Last Audit
4. Routing / Navigation Audit
5. Qur’an Audit
6. Learn Audit
7. Kids Audit
8. Journey / Growth / Garden Audit
9. Worship / Wudu Audit
10. Writing System Audit
11. Localization / Copy Audit
12. Regression / Test Status
13. Top Current Risks
14. Recommended Action Plan
15. Safe Next Phases
16. Files Reviewed
17. Final Audit Block

========================================================
ACTION PLAN REQUIREMENTS
========================================================

The “Recommended Action Plan” section must be concrete and prioritized.

For each action item include:
- priority: P0 / P1 / P2 / P3
- area
- problem
- recommended fix direction
- why it matters now
- whether it is safe to do immediately
- whether it depends on product approval

Group the action plan into:
- Fix now
- Approve first
- Later cleanup

========================================================
SAFE AUDIT RULES
========================================================

Do NOT:
- modify app code unless explicitly requested in a later phase
- delete records/routes/pages for no reason
- overstate progress
- understate regressions
- assume old audits are still correct

This is a current-state audit only.

========================================================
FINAL AUDIT SUMMARY FORMAT
========================================================

At the end provide:

- analyzer_passing: yes/no
- focused_regression_slice_passing: yes/no
- quran_status: strong / mixed / weak
- learn_status: strong / mixed / weak
- kids_status: strong / mixed / weak
- journey_status: strong / mixed / weak
- worship_status: strong / mixed / weak
- writing_system_status: strong / mixed / weak
- localization_status: strong / mixed / weak
- biggest_improvement_since_last_audit: <text>
- biggest_current_blocker: <text>
- safest_next_phase: <text>

===== END =====
