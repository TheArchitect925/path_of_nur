# ===== PHASE V23 PROMPT — COMPANION SURFACES RELEASE READINESS AUDIT =====

## PRIMARY OBJECTIVE === BUILDING COMPANION SURFACES RELEASE READINESS AUDIT

You are working in the existing Flutter codebase for Path of Nūr.

Goal:
Perform a release-readiness audit for the companion surfaces and their integrations.

Critical safety rule:
Do not make random destructive cleanup changes.
Audit first, fix clearly safe issues, and document what remains.

Task type:
Audit + targeted stabilization.

Implement:
1. Audit the full companion-surface chain:
   - routes
   - Learn integration
   - Journey handoffs
   - focused entry states
   - persistence/personalization
   - localization
   - accessibility/polish
2. Identify:
   - broken or weak handoffs
   - thin content areas
   - translation gaps
   - test coverage gaps
   - UI rough edges
   - any remaining learnLegacy dependency around these surfaces
3. Fix clearly safe issues discovered during the audit.
4. Do not redesign or overbuild.
5. Run analyzer and relevant tests.
6. Produce a concise release-readiness score and backlog.

Deliverables:
- audit findings before changes
- safe fixes made
- files changed
- tests run
- analyzer result
- release-readiness assessment
- recommended next roadmap beyond V23
