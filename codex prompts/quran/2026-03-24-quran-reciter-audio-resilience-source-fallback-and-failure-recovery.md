===== PHASE 6 PROMPT — RECITER / AUDIO RESILIENCE, SOURCE FALLBACK & FAILURE RECOVERY =====

PRIMARY OBJECTIVE === BUILDING RECITER / AUDIO RESILIENCE, SOURCE FALLBACK & FAILURE RECOVERY

You are working in the existing Flutter codebase for Path of Nūr.

This phase builds directly on top of the completed Qur’an playback stabilization, playback-state extraction, word-highlight coordinator, presentation mapping, follow-mode coordination, and playback surface / transport polish passes.

Current known state after the latest phases:
- active ayah playback identity is normalized through shared playback state/controller layers
- pause/play drift and active ayah highlight drift were fixed
- reciter switching during active playback is now safe enough for production use
- word-highlight lifecycle is owned by a dedicated coordinator
- now-playing copy is presentation-owned
- follow-mode/auto-scroll lifecycle is more normalized
- playback surfaces and transport controls are being hardened

Main remaining product gaps:
- reciter switching needs deeper resilience under network, buffering, unavailable source, and fallback conditions
- audio-source failure recovery needs to be more explicit and trustworthy
- download/source fallback logic needs to be safer and more visible
- playback should recover more gracefully when one source path fails
- the user should better understand what happened when playback cannot continue

Your task in this phase is to:
1. harden reciter switching and active playback source transitions
2. add safer source selection and fallback behavior between downloaded/local and remote audio
3. improve buffering, unavailable-source, and retry/failure handling
4. preserve all working playback, highlight, reciter, session, memorization, notes, bookmarks, download, follow-mode, and mini-player behavior
5. keep the architecture production-ready and additive

IMPORTANT:
This is not a rewrite.
This is not a redesign of the whole Qur’an reader.
This is a targeted audio resilience and failure-recovery phase.

CRITICAL SAFETY RULES
- Audit first before changing anything.
- Do not rebuild the Qur’an player from scratch.
- Do not remove/delete working logic for no reason.
- Preserve the existing playback/highlight/reciter/session fixes.
- Preserve the current controller/coordinator ownership model.
- Do not introduce a second competing source of truth for playback or source state.
- Keep changes additive, maintainable, and production-ready.
- At the very end, provide one consolidated audit summary.

==================================================
STEP 1 — AUDIT FIRST
==================================================

Before editing code, audit and summarize the current reciter/audio/source behavior:

- how reciter switching currently works in active playback
- how reciter switching works when paused
- how reciter switching works when idle but a stored session exists
- how audio source selection currently works
- whether local downloaded audio is preferred or only optionally used
- how remote streaming sources are resolved
- how failures currently surface to the user
- what happens when:
  - a reciter audio source is missing
  - network is unavailable
  - a downloaded file is incomplete/corrupt
  - a reciter switch happens mid-buffer
  - playback is restored from session and the source is no longer valid
  - adjacent ayah/surah transport reaches an unavailable source
- what buffering/loading states already exist
- whether retry logic already exists
- whether source fallback logic already exists
- whether current error handling can leave playback/session/highlight state inconsistent
- where the safest ownership boundary is for source resolution and failure recovery

Then identify the safest additive implementation path.

Do not overbuild.
Do not redesign unrelated UI or app architecture.

==================================================
STEP 2 — DEFINE THE AUDIO SOURCE / FAILURE STATE MODEL
==================================================

Create or refine a production-ready source and failure state model.

Suggested support:
- active source type:
  - local_download
  - remote_stream
  - unavailable
- source resolution state:
  - resolving
  - ready
  - buffering
  - failed
  - fallback_applied
- playback failure type:
  - network_unavailable
  - source_missing
  - source_corrupt
  - reciter_unavailable
  - buffering_timeout
  - session_restore_failed
  - unknown
- retry availability
- fallback availability
- whether playback can resume from current ayah/session
- whether user action is required

If some of this already exists, normalize it.
Do not leave failure interpretation as scattered page logic.

==================================================
STEP 3 — HARDEN SOURCE RESOLUTION OWNERSHIP
==================================================

Audit and improve where source resolution lives.

The system should have one reliable ownership path for:
- deciding whether to use local downloaded audio
- deciding whether to use remote stream
- deciding when to fall back from one to the other
- deciding when playback should fail explicitly
- surfacing normalized source/failure state to UI

Requirements:
- source selection should not be split across too many layers
- playback/session/highlight state must remain consistent when source resolution changes
- if a fallback occurs, the user-facing playback state should remain trustworthy
- no silent drift between actual source and displayed reciter/session state

==================================================
STEP 4 — HARDEN RECITER SWITCHING UNDER FAILURE CONDITIONS
==================================================

Improve reciter switching under real-world failure conditions.

Requirements:
- switching reciter during active playback should preserve session intent safely
- switching reciter while paused should keep the correct ayah/session context
- switching to an unavailable reciter/source must fail honestly
- switching should not leave stale highlight or false “now playing” state
- switching should not destroy the last valid playback session unless the new state is confirmed
- if fallback is possible, apply it safely
- if fallback is not possible, preserve user trust with clear failure state

Potential safe behaviors:
- rebuild playback for the same ayah under the new reciter if source resolves
- preserve paused state where sensible
- revert to last-good state if the new reciter source cannot prepare
- show localized failure feedback when reciter change fails

Do not fake a successful switch.

==================================================
STEP 5 — IMPLEMENT LOCAL / REMOTE SOURCE FALLBACK
==================================================

Harden local-download vs remote-stream fallback behavior.

Requirements:
- if local downloaded audio exists and is valid, prefer it where product logic says it should be preferred
- if local source is missing/corrupt, fall back to remote if available
- if remote fails but valid local exists, fall back to local
- if neither is available, fail honestly
- session/highlight/transport state must stay consistent during fallback
- fallback behavior should be deterministic, not random

Also evaluate:
- whether user settings influence source preference
- whether current-surah-only download support changes fallback boundaries
- how fallback should behave during adjacent ayah and surah transport

Do not silently play from an unexpected source without normalized state reflecting it.

==================================================
STEP 6 — HARDEN BUFFERING / LOADING / TIMEOUT STATES
==================================================

Improve buffering and loading resilience.

Requirements:
- buffering state should surface clearly in shared playback state
- long unresolved loading should transition to a real recoverable failure state when appropriate
- repeated buffering loops should not trap the player forever
- user-facing controls should reflect when retry is possible
- buffering should not falsely appear as “playing”
- highlight/follow state should behave sensibly during buffering

If timeout logic is appropriate, implement it conservatively.
Do not create premature false failures on normal slow loads.

==================================================
STEP 7 — ADD RETRY / RECOVERY FLOWS
==================================================

Implement safe retry/recovery paths.

Possible recovery actions:
- retry current ayah
- retry source resolution
- retry with fallback source
- retry after reciter switch failure
- reopen current session from last-known-good ayah/session
- gracefully stop and preserve session state when recovery is not possible

Requirements:
- retry must not create duplicate competing playback state
- retry must not corrupt session persistence
- retry must not lose the active ayah context if recovery succeeds
- retry should be surfaced where it materially helps the user

==================================================
STEP 8 — IMPROVE USER-FACING FAILURE STATES
==================================================

Audit and improve the user-facing error/recovery experience.

The user should better understand:
- why playback did not continue
- whether the issue was the reciter/source/network/local file
- whether retry is possible
- whether fallback was used
- whether their place in recitation was preserved

Possible safe surfaces:
- localized snackbars/toasts for transient failures
- inline state in mini-player or reader controls for persistent failure states
- retry action where appropriate
- calm and concise copy

Do not make the UI noisy or alarming.
Do not use vague failure messaging if the cause is known.

==================================================
STEP 9 — HARDEN SESSION RESTORE UNDER SOURCE FAILURES
==================================================

Audit and improve session restoration when audio sources are no longer available.

Requirements:
- restore should preserve last-known recitation context
- if the original source is unavailable, attempt safe fallback if appropriate
- if restore cannot prepare audio, session context should still remain visible/available
- do not fake active playback after failed restore
- continue recitation surfaces should remain trustworthy
- highlight state should not falsely appear active until playback truly resumes

==================================================
STEP 10 — ADD REAL TEST COVERAGE
==================================================

Add or update tests for the resilience behavior.

At minimum cover:
- reciter switch success during active playback
- reciter switch failure preserves last-good state
- local-to-remote fallback
- remote-to-local fallback
- missing both sources produces honest failure state
- buffering state transitions correctly
- timeout/failure path behaves safely if implemented
- retry restores playback when source becomes available
- session restore with unavailable source does not fake active playback
- no-regression coverage for pause/play/highlight/session correctness

Prefer behavior-focused tests and route/surface-aware harnesses where practical.

==================================================
STEP 11 — REVIEW UX POLISH OPPORTUNITIES
==================================================

Audit whether small safe UX improvements are needed, such as:
- compact source indicator if helpful
- clearer buffering wording
- stronger retry affordance
- better distinction between paused vs loading vs failed
- graceful reader/mini-player state when a fallback was applied

Do not redesign the app.
Only make small safe improvements that materially improve trust and usability.

==================================================
STEP 12 — REVIEW WATCH / TVOS / CROSS-SURFACE CONTRACT
==================================================

Perform a targeted review of watch/tvOS and other playback consumers against the normalized source/failure contract.

Requirements:
- identify whether any surface assumes old source ownership
- identify any parity risks
- document safe follow-up work
- make only small shared-contract improvements if clearly beneficial in this phase

Do not begin a platform rewrite.
This is a contract-alignment and parity review only.

==================================================
STEP 13 — ANALYZER / CLEANUP
==================================================

After implementation:
- run analyzer on all touched files
- fix warnings/errors where reasonable
- remove only truly obsolete duplicate source/failure handling logic
- keep playback/controller/coordinator ownership boundaries clear
- keep route/surface state consistent
- do not regress working features

==================================================
STEP 14 — FINAL DELIVERABLE
==================================================

At the end, provide:

1. Audit summary before changes
2. What source/failure behavior existed before this pass
3. How reciter switching is now hardened
4. How local/remote fallback now works
5. How buffering/failure/retry behavior now works
6. What tests were added/updated
7. Files changed
8. What still remains partial or risky
9. Recommended next phase

==================================================
FINAL AUDIT AT THE VERY END
==================================================

At the very end, provide one consolidated audit summary of:
- what audio resilience behavior now exists
- whether reciter switching is now production-safe under failure conditions
- what fallback logic is truly supported
- what failure/retry UX is real vs still partial
- what still remains risky
- what should be built next as Phase 7 for the Qur’an player

Do not go haywire.
Do not delete or remove working logic for no reason.
Preserve the stabilized playback/highlight fixes.
Harden audio resilience carefully and keep source/failure state normalized.

===== END PROMPT =====
