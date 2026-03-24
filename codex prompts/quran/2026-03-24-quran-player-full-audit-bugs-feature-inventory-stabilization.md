===== QURAN PLAYER FULL AUDIT PROMPT — BUGS, FEATURE INVENTORY & STABILIZATION =====

PRIMARY OBJECTIVE === AUDITING AND STABILIZING THE QURAN PLAYER

You are working in the existing Flutter codebase for Path of Nūr.

Your task is to run a full production-level audit of the existing Qur’an reader/player implementation, identify all currently implemented features, identify missing or partially wired features, find the causes of active bugs, and then fix the bugs safely without breaking working functionality.

IMPORTANT:
This is not a rewrite prompt.
This is not a “build from scratch” prompt.
This is an audit-first, stabilize-first, fix-the-real-bugs prompt.

The current known bug examples include:
- playback cannot be paused properly
- the currently playing ayah highlight is not showing reliably
- highlighting / active ayah sync may be broken or inconsistent

You must investigate the real implementation and report exact findings before making risky changes.

CRITICAL SAFETY RULES
- Audit first before changing anything.
- Do not rebuild the Qur’an player from scratch.
- Do not remove/delete records, files, state, or logic for no reason.
- Do not strip out features just because they are hard to understand.
- Preserve existing working features unless a fix absolutely requires refactoring.
- Prefer targeted extraction, stabilization, and bug fixes over broad rewrites.
- If a flow is partially implemented, identify whether it should be completed, repaired, or left alone for a later phase.
- Keep all changes production-ready and maintainable.
- At the very end, provide one consolidated audit summary.

==================================================
STEP 1 — FULL AUDIT FIRST
==================================================

Before changing code, audit the complete Qur’an player / reader system and summarize:

1. Entry points
- all pages, routes, widgets, controllers, services, repositories, providers, and models involved in Qur’an reading and playback
- identify the real entry file(s), likely including quran_reader_page.dart and related files

2. Playback architecture
- where play/pause/resume is handled
- where seek is handled
- where position/state streams are listened to
- where current ayah is determined
- where current word is determined
- where reciter changes are handled
- where playback speed is handled
- where background playback/media session is handled
- how audio orchestration works across reader/player surfaces

3. Highlighting / sync architecture
- how currently playing ayah is highlighted
- how word highlighting works
- what timing/alignment data exists
- how active ayah index is mapped from playback position
- whether there are race conditions, stale provider state, or UI rebuild issues
- whether the highlight system is local widget state, provider state, or controller-driven

4. Reader controls / viewing features
- arabic visibility
- translation visibility
- transliteration visibility
- font sizing if present
- theme / reading mode settings if present
- scrolling / auto-scroll / follow mode behavior

5. Study and utility features
- notes
- bookmarks
- favorites
- memorization helpers
- reveal / hide modes
- repeat / loop modes
- continue reading / continue listening
- download / offline support
- reciter selection
- last read / session recovery

6. State management / architecture quality
- what is page-owned vs controller-owned vs provider-owned
- whether quran_reader_page.dart is overloaded
- where subscriptions are created/disposed
- whether state is duplicated in multiple places
- whether multiple playback state sources can drift out of sync

7. Test coverage
- identify all relevant existing tests
- identify what is already covered
- identify what is missing, especially around:
  - pause/play
  - highlight sync
  - active ayah UI update
  - reciter switching
  - continue listening
  - transport controls

==================================================
STEP 2 — PRODUCE FEATURE INVENTORY
==================================================

After the audit, create a clean feature inventory with these categories:

A. Fully implemented and working
B. Implemented but buggy
C. Partially implemented / weakly surfaced
D. Present in architecture but not fully exposed in UI
E. Missing entirely

At minimum, evaluate these feature areas:

Playback / transport
- play
- pause
- resume
- stop
- seek
- skip +15 / -15
- next ayah
- previous ayah
- next surah
- previous surah
- play from tapped ayah
- repeat ayah
- repeat range
- repeat surah
- playback speed
- background playback

Reader sync / display
- currently playing ayah highlight
- current word highlight
- active ayah auto-scroll
- follow mode toggle
- visible currently playing indicator
- translation sync with playback

Continuity / session
- continue reading
- continue listening
- persist last surah/ayah
- resume from previous position
- mini player / persistent playback entrypoint if any

Study / learning
- notes
- bookmarks
- memorization mode
- reveal modes
- tafsir/reference hooks if any
- favorites / review lists

Offline / downloads
- surah download
- download status UI
- offline playback
- missing audio handling
- recovery from incomplete downloads

Reciter / audio management
- reciter switching
- reciter persistence
- handling if reciter assets unavailable
- playback state after switching reciter

==================================================
STEP 3 — INVESTIGATE THE KNOWN BUGS
==================================================

Investigate and identify root causes for at least these known issues:

1. Cannot pause playback
Check for:
- UI action not wired
- pause command sent but ignored
- state stream not updating UI after pause
- audio handler / service conflict
- multiple playback controllers fighting each other
- immediate auto-resume caused by another listener
- play/pause button reading stale state
- background and foreground playback states diverging

2. Current ayah highlight not showing
Check for:
- playback position not mapped to ayah correctly
- alignment/timing data not loaded
- provider not notifying listeners
- widget rebuild issue
- wrong ayah key/index mapping
- highlight hidden behind current settings
- active ayah state being reset during scroll/rebuild
- highlight driven by a different controller than playback

3. Highlight sync inconsistent or late
Check for:
- time-to-ayah mapping issues
- off-by-one errors
- race conditions in stream listeners
- debounce/throttle issues
- missing fallback when timing data is absent
- UI state lag because of nested local state

Also investigate adjacent bug risks:
- play from tapped ayah not setting active highlight immediately
- reciter switch resets highlight incorrectly
- seek updates playback but not active ayah
- background resume returns with stale highlighted ayah
- auto-scroll jumps to wrong place or fights user scrolling

==================================================
STEP 4 — TRACE THE REAL CONTROL FLOW
==================================================

Map the real end-to-end control flow for:

- tapping play
- tapping pause
- tapping an ayah to play
- changing reciter
- receiving playback position updates
- calculating current ayah
- updating current word
- rebuilding the UI highlight
- persisting session state
- restoring session state on reopen

Document where state originates, where it transforms, and where it is rendered.

Call out any duplicate state ownership or conflicting subscriptions.

==================================================
STEP 5 — FIX THE BUGS SAFELY
==================================================

After the audit and root-cause analysis, fix the real bugs safely.

Priority order:
1. pause/play correctness
2. current ayah highlight correctness
3. highlight sync correctness
4. transport state consistency
5. stability of reader/player updates

Implementation rules:
- make targeted changes first
- extract logic out of quran_reader_page.dart only where it clearly improves safety/maintainability
- do not rewrite the whole feature
- centralize state only where duplication is causing real bugs
- ensure pause/play/highlight state uses a single reliable source of truth where practical
- make UI react correctly to audio state changes
- ensure highlight updates whether playback was started from:
  - play button
  - tapped ayah
  - restored session
  - background resume
  - seek

==================================================
STEP 6 — HARDEN THE HIGHLIGHT SYSTEM
==================================================

Stabilize the highlighting system.

Requirements:
- currently playing ayah must always be visually obvious
- if word-level timing exists, word highlighting should work
- if word-level timing does not exist, ayah-level highlight must still work reliably
- seeking must update active ayah
- tapping an ayah to play should immediately reflect visually
- pause should preserve the last active ayah highlight state appropriately
- resume should continue correctly
- highlight state should not disappear on harmless rebuilds
- highlight state should not rely on fragile widget-local assumptions

If helpful, create a clearer active playback state model for:
- current surah
- current ayah
- current word
- playback status
- source of playback session
- highlight readiness

==================================================
STEP 7 — REVIEW UI SURFACING
==================================================

Audit whether important existing player capabilities are hidden or weakly surfaced.

Without overbuilding, identify whether the UI should better expose:
- pause/play state
- active ayah indicator
- transport controls
- continue listening
- repeat controls
- reciter state
- download status
- follow mode / auto-scroll toggle

If a small safe UI improvement is needed to make a working feature usable, include it.

==================================================
STEP 8 — TESTING
==================================================

Add/update tests to cover the repaired behavior.

At minimum add or improve coverage for:
- play then pause updates state correctly
- pause does not auto-resume unexpectedly
- tapping ayah starts playback and updates active ayah highlight
- playback position updates active ayah highlight
- seek updates active ayah
- reciter switch does not break current player state
- restored session can resume with correct highlight
- UI renders currently playing ayah visibly when playback is active

Prefer widget/integration-style harness coverage where helpful, not only tiny unit tests.

==================================================
STEP 9 — ANALYZER / CLEANUP
==================================================

After changes:
- run analyzer on all touched files
- fix warnings/errors where reasonable
- remove only truly obsolete duplicated logic
- keep naming clean
- keep ownership boundaries clear
- keep subscriptions/disposal safe
- do not weaken existing working features

==================================================
STEP 10 — FINAL DELIVERABLE
==================================================

At the end, provide:

1. Audit summary before changes
2. Full feature inventory grouped by:
- fully implemented and working
- implemented but buggy
- partial
- architecture-only / weakly surfaced
- missing

3. Root cause findings for:
- pause bug
- current ayah highlight bug
- highlight sync bug

4. Files changed
5. What was fixed
6. What remains partially implemented
7. What architectural risks still remain
8. What tests were added/updated
9. Recommended next phase

==================================================
FINAL AUDIT AT THE VERY END
==================================================

At the very end, provide one consolidated audit summary of:
- all Qur’an player functions currently in place
- all repaired bugs
- all remaining gaps
- whether quran_reader_page.dart is still too heavy
- what should be extracted next
- what should be built next as Phase 2 for the Qur’an player

Do not go haywire.
Do not delete or remove working logic for no reason.
Audit first, understand the real system, then stabilize it carefully.

===== END PROMPT =====
