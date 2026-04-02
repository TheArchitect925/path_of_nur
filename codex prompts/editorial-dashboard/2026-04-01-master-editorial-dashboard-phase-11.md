# Phase 11 — Master Editorial Dashboard

PRIMARY OBJECTIVE === BUILDING MASTER EDITORIAL DASHBOARD

You are working in the existing Flutter codebase for Path of Nūr.

Always ensure the system is not going haywire and removing deleting records for no reason.

Instead of only doing a v1 or placeholder let’s always build out everything into a production ready product.

At the very end, audit everything and provide one full summary.

TASK TYPE
Build a hidden internal master editorial dashboard for the full app, not only for Qur’an content.

GOAL
Create a single internal dashboard system that allows the app owner to inspect content coverage, quality, routing, status, and readiness across:
- Qur’an
- hadith
- stories
- duas
- dhikr
- learning paths
- kids content
- actions / Ocean Drops mappings
- recommendations / spiritual moments
- localization coverage

IMPORTANT PRODUCT DIRECTION
This is an internal-only dashboard.
It must not appear in normal user navigation.
It must feel like a calm, powerful content command center.

SECURITY / ACCESS RULES
1. The dashboard must be hidden from standard navigation.
2. Access must require a hidden unlock gesture.
3. After the unlock gesture, require a PIN entry screen.
4. Initial local PIN must be: 0786
5. Store the PIN locally in a way that supports later change/reset flow.
6. The dashboard must remain locked by default on app launch.
7. Add a session-based unlock state that resets on app restart.
8. Add a production-safe feature flag so the dashboard can be disabled by default in public builds.
9. Do not expose the dashboard route openly to standard users.

EXECUTION RULES
1. Audit first before editing.
2. Reuse existing content models/providers where practical.
3. Build the dashboard as a master system, not as one-off pages.
4. Keep ownership clean and modular.
5. Preserve localization.
6. Keep UI readable and scalable.
7. Run analyzer on changed files and summarize results.

AUDIT REQUIREMENTS
A. Find all current content owners and sources for:
- Qur’an explanations
- surah summaries
- hadith
- stories
- duas
- dhikr
- learning journeys/paths
- kids content
- action/Ocean Drops mappings
- recommendation/spiritual moment systems
- localization/ARB coverage if accessible

B. Identify what can be surfaced in a normalized dashboard model.

IMPLEMENTATION REQUIREMENTS

A. Build dashboard shell
Create a hidden internal dashboard route and shell page.

B. Build access control
Implement:
- hidden unlock gesture
- PIN gate
- initial PIN = 0786
- session unlock state
- public-build-safe feature flag

C. Build master overview page
Show high-level counts/status for all major app content domains.

D. Build domain pages/tabs/sections for:
- Qur’an
- hadith
- stories
- duas/dhikr
- learning paths
- kids content
- actions/Ocean Drops
- recommendations/spiritual moments
- localization

E. Build normalized dashboard cards/rows
Each item should be able to surface:
- title
- type
- id
- status
- coverage flags
- kids-safe status
- source/reference status
- route/link if available
- notes/metadata if available

F. Add filtering/search
Allow filtering by:
- domain
- missing content
- needs review
- kids missing
- localization missing
- draft/reviewed/verified

G. Keep initial version mostly read-only
Do not overbuild full inline editing unless already trivial and safe.
Focus on visibility, auditability, and navigation first.

H. Keep UI modular and scalable
This dashboard must be able to grow with the app.

VALIDATION
1. Confirm dashboard is hidden from standard users.
2. Confirm access requires hidden gesture + PIN.
3. Confirm initial PIN 0786 works.
4. Confirm dashboard session relocks on restart.
5. Confirm major domains appear in overview.
6. Confirm filtering/search works.
7. Confirm analyzer passes.

DELIVERABLES
- audit summary
- files changed
- dashboard architecture summary
- access control summary
- list of domains included
- overview metrics surfaced
- filter/search capabilities
- analyzer results
