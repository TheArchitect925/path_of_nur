===== PHASE 2 PROMPT — QURAN AUDIO PLAYER AUDIT OF REMAINING RUNTIME =====

PRIMARY OBJECTIVE === BUILDING QURAN AUDIO PLAYER

You are working inside the existing Flutter codebase for Path of Nūr.

Important context:
A prior pass intentionally removed the visible Qur’an audio/player surface from the app UI, but did NOT remove the underlying Qur’an playback/runtime files and did NOT remove shared audio packages.

That means:
- the visible reader/player controls are currently disabled/hidden
- the shell mini-player is hidden
- continue listening shortcuts are removed
- ayah tap-to-play is disabled
- legacy runtime/player code may still exist underneath

This phase is NOT the rebuild yet.
This phase is the deep audit of everything Qur’an-audio-related still remaining in the codebase so we can rebuild cleanly from facts.

MANDATORY RULES
1. Audit first. Do not start rebuilding blindly.
2. Do not delete records, saved preferences, downloads, bookmarks, resume points, or stored user state unless explicitly replaced safely.
3. Do not remove remaining runtime files during this audit pass unless they are provably dead and completely unreferenced.
4. Do not damage non-Qur’an audio systems such as adhan or any shared audio infra that may still be needed.
5. Build toward production-ready architecture, not placeholder code.
6. At the end, provide one complete audit summary and a precise rebuild plan.

==================================================
A. AUDIT OBJECTIVE
==================================================

Audit all remaining Qur’an audio runtime, infrastructure, providers, controllers, services, models, widgets, storage keys, routes, and tests.

We need a factual map of:
- what still exists
- what is still referenced
- what is dead
- what is reusable
- what should become the canonical rebuild base
- what should be removed only after rebuild

==================================================
B. AUDIT SCOPE
==================================================

Inspect all remaining Qur’an audio-related code, including but not limited to:

1. Qur’an feature files
- application providers
- controllers
- services
- runtime localizations if relevant
- domain models
- infrastructure/audio adapters
- reader page integration hooks
- widgets previously used for audio
- reciter selection logic
- download/remove-download logic
- resume/continue-recitation logic
- per-ayah playback logic
- playback speed / repeat / loop logic
- sample preview logic

2. Shared app audio layers
- just_audio integration
- audio_service integration
- just_audio_background usage
- shared playback interfaces
- media session ownership
- notification/lock-screen control plumbing if any

3. Persistence and storage
- LocalStore / SharedPreferences keys
- download metadata storage
- playback state persistence
- last reciter
- last surah
- last ayah / resume point
- continue listening contracts

4. Routing and entry points
- old route hooks
- reader launch hooks
- mini-player references
- shortcut references
- hidden but still reachable surfaces

5. Tests
- playback tests
- widget tests
- harness tests
- sync/timing tests
- any stale test suite that still reveals expected architecture

==================================================
C. REQUIRED AUDIT OUTPUT
==================================================

Produce a structured audit that clearly answers:

1. REMAINING FILE INVENTORY
For every relevant file/module found:
- file path
- purpose
- whether still referenced
- whether canonical, duplicate, partial, or dead
- whether safe to reuse, refactor, or retire

2. CURRENT ARCHITECTURE SNAPSHOT
Explain:
- where playback state currently lives
- where engine ownership currently lives
- where UI ownership used to be
- where persistence lives
- where reciter logic lives
- where downloads live
- where ayah playback logic lives
- where background playback is wired

3. SHARED DEPENDENCY MAP
Identify exactly how Qur’an audio currently depends on:
- just_audio
- audio_service
- just_audio_background
- any shared app scaffolding
- any global providers or controllers

4. DEAD / FRAGILE / HIGH-RISK AREAS
Flag:
- dead code
- duplicate state ownership
- page-bound logic
- unsafe subscriptions
- improper disposal
- broken persistence assumptions
- stale route references
- code that was only hidden, not actually disconnected
- anything that could conflict with a rebuild

5. REUSABLE ASSETS
Identify parts worth preserving, such as:
- reciter models
- source URL builders
- download contract models
- state classes
- resume logic
- ayah timing contracts
- test harnesses
- localization-ready labels
- shared widgets that can be repurposed

6. SAFE RETIREMENT CANDIDATES
List files/modules that are safe to archive/remove later AFTER the rebuild.

==================================================
D. REQUIRED IMPLEMENTATION ACTIONS IN THIS PHASE
==================================================

This is primarily an audit phase, but you may make small safe improvements only if they help the audit and do not alter product behavior.

Allowed:
- add comments/doc notes where needed
- add temporary architecture mapping docs
- add a technical inventory doc
- fix obviously broken references that block analysis
- add TODO markers for rebuild phases
- create a clear backlog doc for rebuild steps

Not allowed in this phase:
- full rebuild
- large refactor
- deleting the remaining runtime broadly
- changing app behavior materially
- breaking non-Qur’an audio

==================================================
E. DELIVERABLE DOCUMENTS
==================================================

Create a concise but complete audit artifact in the repo that includes:

1. Executive summary
2. Remaining runtime inventory
3. Current dependency/ownership map
4. Reusable components list
5. Dead/legacy components list
6. Risks and constraints
7. Recommended target architecture for rebuild
8. Proposed phased rebuild plan
9. Post-rebuild cleanup candidates

Also create or update a rebuild backlog doc with phases such as:
- foundation playback engine
- player state controller
- reciter system
- surah playback UI
- ayah sync phase
- downloads/offline phase
- resume/continue listening restoration
- cleanup/archive phase
- final audit

==================================================
F. REBUILD RECOMMENDATION SECTION
==================================================

At the end of the audit, provide a recommended approach for the rebuild:

1. What should be reused as-is
2. What should be wrapped/refactored
3. What should be replaced entirely
4. What should be postponed to later phases
5. Which exact file(s) should become the canonical starting point for the new player foundation

Be opinionated and concrete.

==================================================
G. VALIDATION
==================================================

Run targeted validation for changed audit/docs/indexing files and any touched code.
At minimum:
- flutter analyze on any touched Dart files
- confirm no new broken imports/references
- confirm current app behavior remains unchanged in terms of audio being hidden from the Qur’an UI surface

==================================================
H. FINAL CODEX AUDIT SUMMARY
==================================================

End with a complete summary in this format:

1. Audit Findings
2. Remaining Runtime Files
3. Canonical Reuse Candidates
4. Dead / Legacy Candidates
5. Risks Before Rebuild
6. Recommended Rebuild Starting Point
7. Suggested Next Prompt

Important:
Do not do the rebuild yet.
This phase is about truthfully mapping what remains so the rebuild can be done once, correctly, and production-ready.
