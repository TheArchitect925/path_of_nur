===== PHASE 2 PROMPT — QUR’AN READER PLAYER CONTROL AND ACTIVE AYAH HIGHLIGHT RESTORATION =====

PRIMARY OBJECTIVE === BUILDING / FIXING QUR’AN READER PLAYER CONTROL AND ACTIVE AYAH HIGHLIGHT RESTORATION

You are working inside the existing Path of Nūr codebase.

Your job is to RESTORE the expected Qur’an reader playback behavior so that the audio player works properly again and the currently recited ayah is visibly highlighted during playback, as it used to be before.

This is a targeted restoration and stabilization task. Do not rebuild the Qur’an reader from scratch. Do not remove working audio, ayah, or reader logic unnecessarily. Audit the regression, identify what broke, and repair it cleanly on top of the current implementation.

IMPORTANT SAFETY / EXECUTION RULES
- Do not delete working recitation logic, data models, repositories, or UI layers unless replacement is safe and necessary.
- Do not remove pause/play state logic just because it appears inconsistent; fix and normalize it.
- Do not hardcode fake highlighting behavior.
- Do not introduce placeholder timers if proper playback position / ayah tracking already exists or can be restored from the current architecture.
- Preserve existing resume, seek, reciter selection, surah loading, and page/ayah rendering behavior unless explicitly required for the fix.
- Scope this work to the Qur’an reader, its playback controls, ayah highlight synchronization, and any directly related providers/controllers/services.
- At the end, provide a concise implementation audit summarizing:
  1. root cause found,
  2. what was fixed,
  3. how pause/resume now behaves,
  4. how active ayah highlighting now works,
  5. any remaining risks or follow-up recommendations.

==================================================
PHASE GOAL
==================================================

Restore the Qur’an reader so that:

1. When the player starts, it can be paused again.
2. The ayah currently being recited is highlighted again in the reader UI like it used to be.

==================================================
REPORTED REGRESSIONS TO FIX
==================================================

1) PLAYER CAN NO LONGER BE PAUSED
Current problem:
- When the Qur’an player starts playing, pause no longer works properly.

Required behavior:
- User must be able to pause playback at any time after playback starts.
- Pause button must visibly and functionally switch player state correctly.
- Resume after pause must continue correctly from the proper playback state.
- UI state must stay in sync with actual audio state.
- If there is a global/shared audio controller involved, ensure the Qur’an reader is correctly subscribed to state changes.

Things to audit:
- play/pause button handler wiring
- audio controller state machine
- provider / notifier state propagation
- playback stream subscriptions
- whether play state is stuck in “playing” visually even when pause is requested
- whether pause is being swallowed due to async race conditions
- whether a recent refactor broke notifier updates or player command forwarding
- whether the audio package callback contract changed and the UI was not updated accordingly

2) ACTIVE AYAH HIGHLIGHT NO LONGER WORKS
Current problem:
- The ayah currently being recited is no longer highlighted like before.

Required behavior:
- As the Qur’an audio recites, the current ayah should visibly highlight in the reader.
- Highlight should update during playback as the recitation progresses.
- Only the correct active ayah should appear highlighted at the correct time.
- Highlight should clear or settle appropriately when playback is paused, stopped, completed, or when user changes surah/ayah context.
- If there was prior scrolling/focus behavior tied to the active ayah, preserve it if it already exists and still makes sense.
- Highlight styling should remain consistent with Path of Nūr design language and prior reader behavior.

Things to audit:
- active ayah state source
- timing/segment mapping between audio playback and ayah IDs
- whether ayah timing metadata is no longer being loaded
- whether the UI lost subscription to active ayah provider/notifier
- whether equality / ID matching between ayah model and playback segment model is failing
- whether the current recitation event callbacks no longer dispatch updates
- whether recent refactors broke the highlight widget state or conditional styling
- whether playback source changes are resetting active ayah incorrectly

==================================================
IMPLEMENTATION REQUIREMENTS
==================================================

A) AUDIT FIRST, THEN FIX
Before changing code, inspect the current Qur’an reader pipeline and identify:
- reader page/widget(s)
- playback controller / audio service / player service
- state providers / notifiers / view models
- ayah timing or ayah sync logic
- active ayah rendering/highlight condition
- play/pause control flow

Then implement the minimum safe production-ready fix.

B) RESTORE A RELIABLE PLAY/PAUSE STATE FLOW
Ensure the player state transitions are correct:
- idle -> loading -> playing
- playing -> paused
- paused -> playing
- playing -> completed / stopped
- switching surah/ayah should reset stale state safely

The play/pause button must:
- call the correct control method
- update UI based on real player state
- avoid stale optimistic UI state that gets stuck
- not require full page reload to recover

C) RESTORE ACTIVE AYAH TRACKING
The active ayah highlight must be driven by a real source of truth:
- current playback segment / ayah
- ayah timing metadata
- current ayah index from the synchronized playback engine
- or other existing valid reader sync architecture already in the codebase

Do not use a fake approximation unless no real sync exists at all.
If real sync data exists but is broken, restore it.

D) KEEP THE EXPERIENCE POLISHED
- Highlight must be visually clear but not messy.
- Reader should not flicker between ayahs.
- Pausing should not cause random ayah highlight jumps.
- Resuming should continue from the correct active ayah.
- Changing surah should clear stale highlight from prior surah.
- Stopping/completing playback should leave the UI in a clean final state.

==================================================
TECHNICAL GUIDANCE
==================================================

Audit likely areas such as:
- Qur’an reader presentation page
- reader item/ayah row widgets
- audio service / playback service
- playback state providers / Riverpod notifiers
- ayah synchronization / timing models
- recitation controller bindings
- stream subscriptions to playback position / state / sequence events

Potential regression causes to check:
- play/pause callbacks no longer wired after refactor
- paused state not emitted or not listened to
- reader UI condition tied to obsolete enum/state type
- active ayah provider no longer updated from playback tick
- mismatch between ayah number format and timing metadata format
- stale index mapping after changing data models
- position listener detached or throttled incorrectly
- player state stream subscription disposed too early
- current recitation session not resetting internal sync state correctly

If timing metadata is dependent on a specific reciter/source:
- preserve existing behavior
- fail gracefully if metadata is unavailable
- do not crash the reader
- do not show a wrong highlight if sync cannot be established

==================================================
UX / UI EXPECTATIONS
==================================================

- Pause button must work immediately during playback.
- Button icon/state must reflect the real playback state.
- Active ayah should be visibly distinguished from surrounding ayahs.
- Existing typography and layout should remain intact.
- Do not clutter the reader with debugging UI.
- If the reader previously auto-scrolled to the current ayah and that behavior still exists, preserve it as long as it remains smooth and not jumpy.

==================================================
ACCEPTANCE CRITERIA
==================================================

This phase is complete only if ALL of the following are true:

- Starting Qur’an playback works.
- While playback is active, tapping pause successfully pauses audio.
- After pausing, tapping play/resume resumes correctly.
- Player controls remain responsive after multiple play/pause cycles.
- The currently recited ayah is highlighted during playback.
- The highlight updates as recitation progresses.
- Highlight corresponds to the correct ayah, not a stale or offset ayah.
- Highlight state behaves cleanly when paused, resumed, stopped, completed, or when changing surahs.
- No new regressions are introduced to existing reader behavior.
- No fake/mock-only fix is used if proper synchronization already exists in the codebase.

==================================================
FILES / AREAS TO EXPECT TO TOUCH
==================================================

Touch only the files that are actually needed, likely in areas such as:
- Qur’an reader page/widgets
- reader playback controls
- audio player service/controller
- playback state provider/notifier
- ayah sync/timing provider or model
- reader highlight styling logic

Do not perform unrelated broad refactors.

==================================================
TESTING / VALIDATION EXPECTATIONS
==================================================

After implementation, validate at minimum:
1. Start playback from a surah in the Qur’an reader.
2. Pause during playback.
3. Resume playback.
4. Verify current ayah highlight appears.
5. Let playback continue through multiple ayahs and verify highlight changes accordingly.
6. Pause and resume again and verify highlight remains synchronized.
7. Switch surah or restart recitation and verify stale highlight does not persist.
8. Confirm no route/UI crash occurs.

==================================================
FINAL OUTPUT REQUIRED FROM CODEX
==================================================

When done, provide:
1. The root cause of the pause regression
2. The root cause of the ayah highlight regression
3. The exact files changed
4. What was restored in the play/pause flow
5. What now drives the active ayah highlight
6. Any remaining follow-up recommendations

END OF PROMPT
