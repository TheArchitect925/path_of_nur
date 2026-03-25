===== PHASE 5 PROMPT — PRELOAD / BUFFERING IMPROVEMENTS + SEAMLESS AYAH CONTINUITY =====

PRIMARY OBJECTIVE === BUILDING QURAN AUDIO PLAYER

You are working inside the existing Flutter codebase for Path of Nūr.

This phase builds on the already-restored and already-polished canonical Qur’an runtime.

Previous phases already completed and must remain intact:
- canonical player runtime preserved
- mini player above navigator
- full-screen player
- ayah-aware playback state
- follow mode on by default
- precision timing polish
- continue listening in reader
- controller-owned tap-to-jump
- background/native media path preserved

This phase is NOT a rebuild.
This phase is about improving playback continuity, preload behavior, and buffering resilience so the listening experience feels smoother and more dependable.

==================================================
CRITICAL RULES
==================================================

1. DO NOT create a second playback stack.
2. DO NOT replace the canonical runtime.
3. DO NOT regress mini player, full player, follow mode, continue listening, or tap-to-jump.
4. DO NOT break persistence keys:
   - learn.quran.audioSettings
   - learn.quran.recitationSession
   - learn.quran.listeningStats
   - learn.quran.followPlayback
5. DO NOT break reciter contracts, source resolution, or downloads.
6. DO NOT break just_audio_background/native media behavior.
7. DO NOT push more playback complexity into quran_reader_page.dart.
8. DO NOT add memorization loops, watch UX, or offline diagnostics in this phase.
9. Build production-ready continuity behavior, not fake loading tricks.
10. End with a full Codex audit summary.

==================================================
PHASE GOAL
==================================================

Make Qur’an playback feel smoother between ayahs and more resilient under real-world conditions.

Main goals:
1. PRELOAD / PREBUFFER NEXT AYAH OR NEXT PLAYBACK UNIT
2. REDUCE AUDIBLE GAPS BETWEEN AYAHS
3. IMPROVE BUFFERING / RECOVERY UX
4. HANDLE WEAK METADATA / SOURCE LATENCY MORE GRACEFULLY
5. PREPARE THE ARCHITECTURE FOR LATER OFFLINE DIAGNOSTICS AND MEMORIZATION MODES

This should feel like a refinement of the existing canonical runtime, not a new subsystem.

==================================================
A. PRELOAD / PREBUFFER STRATEGY
==================================================

Audit the current ayah transition path first.

Then improve preload behavior through the canonical player/orchestrator/repository path.

Goals:
- preload the next ayah or next playback unit where safe
- reduce dead air between ayah transitions
- reduce latency after tap-to-jump
- reduce delays after next ayah / next surah actions
- make transitions feel more intentional and less “fetch then wait”

Requirements:
- use the existing canonical stack
- do not add a parallel preload engine
- if there is an existing queue/preparation path in quran_playback_orchestrator.dart, extend it rather than bypassing it
- preserve repository ownership for local/remote source resolution
- document whether preload is done:
  - by ayah
  - by prepared source chain
  - by cached metadata/session prep
  - or another clean architecture-safe mechanism

Important:
Preloading must not create runaway memory use, duplicate requests, or broken reciter/source state.

==================================================
B. BUFFERING / STALL RESILIENCE
==================================================

Improve behavior when playback stalls, buffers, or transitions slowly.

Goals:
- clearer buffering state during transitions
- less confusing frozen-highlight behavior
- smoother recovery when source load is slow
- stronger confidence in playback progression

Use and extend existing resilience contracts where appropriate, especially:
- quran_audio_resilience.dart
- quran_player_controller.dart
- quran_reader_playback_controller.dart

Improve:
- buffering detection
- transition-state exposure
- recovery from slow source start
- visual state when active ayah is known but audio is still preparing
- controller behavior during quick successive user actions

Do not add noisy or cluttered UI.
Keep the reader calm.

==================================================
C. SEAMLESS AYAH CONTINUITY
==================================================

Improve the felt continuity between ayahs.

Goals:
- less silence between ayahs where feasible
- smoother handoff from one ayah to the next
- avoid double-transition or flash states
- keep highlight and follow mode believable during handoff

Requirements:
- transition to the next ayah should feel deliberate and stable
- if exact seamlessness is limited by metadata/source layout, improve as much as safely possible and clearly document remaining limitations
- make sure timing polish from the previous phase is not regressed

Consider:
- precomputed next ayah preparation
- transition state that bridges between “current ayah ending” and “next ayah starting”
- suppressing jittery UI changes during micro-buffer windows

==================================================
D. TAP-TO-JUMP LATENCY POLISH
==================================================

Tap-to-jump already works.
Now make it feel faster and cleaner.

Goals:
- reduce perceived delay after ayah tap
- show stable interim state while the jump is preparing
- minimize flicker of visual state
- keep failure fallback authoritative and calm

Requirements:
- preserve canonical controller-owned jump behavior
- keep page-local fallback logic out of the reader page
- if preload or preparatory resolution can help common jump paths, do it cleanly

==================================================
E. BUFFERING / LOADING UX POLISH
==================================================

Improve user-facing loading behavior without making the UI busy.

Potential areas:
- mini player status
- full-screen player status
- reader inline status for transition/buffering
- continue-listening resume startup state

Requirements:
- clearly distinguish:
  - paused
  - playing
  - buffering
  - preparing next ayah
  - source error
- avoid generic music-player styling
- keep visual language calm and Path of Nūr appropriate

Do not overdesign.
This is subtle UX polish.

==================================================
F. ARCHITECTURE GUARDRAILS
==================================================

Keep these ownership rules intact:

ENGINE:
- quran_player_controller.dart

UI-FACING PLAYBACK STATE:
- quran_reader_playback_controller.dart

SESSION / PREPARATION LOGIC:
- quran_playback_orchestrator.dart

DATA / SOURCE RESOLUTION / DOWNLOADS:
- quran_audio_repository.dart

PROVIDERS / PERSISTENCE ENTRY:
- quran_providers.dart

If preload/buffering improvements require new helpers, place them in the correct layer.
Do not place them in quran_reader_page.dart.

==================================================
G. TARGETED PAGE THINNING
==================================================

Continue to avoid page-bound playback behavior.

If this phase needs any additional extraction from quran_reader_page.dart, only extract what directly improves:
- buffering state display
- follow-mode continuity during preload/transition
- jump/preparing visual flow

Do not do a broad UI rewrite.

==================================================
H. CONTRACT SAFETY
==================================================

Must preserve:
- learn.quran.audioSettings
- learn.quran.recitationSession
- learn.quran.listeningStats
- learn.quran.followPlayback

Must preserve:
- reciter system
- source resolution
- local/remote playback contracts
- downloads
- background/native media path
- watch contract
- live activity contract

If watch/live activity transport metadata needs minor alignment because of new continuity states, keep changes minimal and backward-safe.

==================================================
I. TESTING
==================================================

Reuse and extend existing tests.

Add or update focused tests for:
1. next ayah preload/preparation behavior
2. reduced transition-gap behavior where testable
3. buffering state transitions
4. stalled-to-recovered playback behavior
5. tap-to-jump preparation/latency behavior
6. no duplicate source load storms
7. preserved highlight timing behavior during buffering
8. follow mode stability during transition windows
9. preserved continue-listening behavior
10. no second playback stack introduced

Run:
- flutter gen-l10n if needed
- focused flutter analyze
- focused playback/reader/scaffold tests

==================================================
J. FILE PRIORITIES
==================================================

Prioritize working in:
- quran_player_controller.dart
- quran_reader_playback_controller.dart
- quran_playback_orchestrator.dart
- quran_audio_repository.dart
- quran_audio_resilience.dart
- quran_providers.dart

Touch UI only as needed:
- quran_reader_page.dart
- quran_playback_controls_card.dart
- quran_expanded_player_sheet.dart
- quran_continue_listening_card.dart
- app_scaffold.dart

Touch these only if required for transport/background continuity alignment:
- main.dart
- quran_live_activity_service.dart
- watch_quran_audio_contract.dart

==================================================
K. WHAT NOT TO DO
==================================================

Do NOT:
- build offline health diagnostics yet
- build repair-download UI yet
- build memorization loops yet
- build watch-specific player UX yet
- add heavy analytics
- replace the canonical player engine
- introduce page-local preload hacks
- create fake preload illusions that do not reflect real state

==================================================
L. DELIVERABLES
==================================================

At the end provide:

1. IMPLEMENTATION SUMMARY
- what continuity/buffering improvements were added
- what was reused
- what was refactored

2. FILES CHANGED
- added
- modified
- removed

3. PRELOAD RESULT
State clearly:
- what is preloaded or pre-prepared
- when preload happens
- how duplicate work is avoided
- any limits

4. BUFFERING RESULT
State clearly:
- what buffering/stall behavior improved
- how recovery works
- how UI state reflects it

5. AYAH CONTINUITY RESULT
State clearly:
- how transitions between ayahs improved
- what still remains approximate or source-limited

6. TAP-TO-JUMP POLISH RESULT
State clearly:
- what became faster/smoother
- what fallback behavior remains

7. CONTRACTS PRESERVED
Confirm status of:
- audioSettings
- recitationSession
- listeningStats
- followPlayback
- downloads/source resolution
- background/native path
- watch contract
- live activity contract

8. DEFERRED ITEMS
What still belongs in later phases and why.

9. FINAL CODEX AUDIT
End with:
- what was completed
- what remains
- what cleanup is now safe
- what the next best phase should be

==================================================
M. NEXT PHASE RECOMMENDATION
==================================================

After this phase, recommend the best follow-up from:
- offline diagnostics + repair UX
- memorization loop foundations
- shell/home continue-listening expansion
- live activity/watch transport polish
- deeper reciter timing calibration
- final extraction of remaining reader-page playback helpers

IMPORTANT PRODUCT INTENT
This is a listening continuity and resilience phase.

The result should feel:
- smoother
- calmer
- less fragile
- less delayed
- more trustworthy
- still architecture-safe
