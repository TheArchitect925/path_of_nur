===== PHASE 7 PROMPT — FOCUS RECITATION MODE V2 =====

PRIMARY OBJECTIVE === BUILDING FOCUS RECITATION MODE

You are working inside the existing Flutter codebase for Path of Nūr.

Focus Recitation Mode V1 already exists.
This phase is to build V2 polish and depth on top of the existing canonical Qur’an player/runtime.

This is NOT a new player.
This is NOT a second playback stack.
This is NOT a rebuild of the reader.

This is an enhancement phase for the dedicated immersive ayah-by-ayah recitation experience.

==================================================
CRITICAL RULES
==================================================

1. DO NOT create a second playback stack.
2. DO NOT replace or bypass the canonical player runtime.
3. DO NOT break:
   - mini player
   - full player
   - Follow Ayah Mode
   - continue listening
   - tap-to-jump
   - background/native media path
   - reciter system
   - downloads/source resolution
   - persistence keys:
     - learn.quran.audioSettings
     - learn.quran.recitationSession
     - learn.quran.listeningStats
     - learn.quran.followPlayback
4. DO NOT clutter Focus Recitation Mode with study-page chrome, tafsir panels, notes surfaces, or unrelated widgets.
5. Keep this production-ready, calm, minimal, and premium.
6. End with a full Codex audit summary.

==================================================
CURRENT BASELINE
==================================================

Already completed and must remain intact:
- canonical player runtime preserved
- mini player above navigator
- full-screen player
- ayah-aware playback state
- precision timing polish
- continue listening
- controller-owned tap-to-jump
- background/native media path
- Focus Recitation Mode V1
- translation / transliteration visibility options in Focus Mode

Canonical foundation remains:
- quran_player_controller.dart → engine owner
- quran_reader_playback_controller.dart → UI-facing state owner
- quran_playback_orchestrator.dart → session/queue logic
- quran_audio_repository.dart → reciters, sources, downloads
- quran_providers.dart → provider entry and persistence

==================================================
PHASE GOAL
==================================================

Build Focus Recitation Mode V2.

V2 should deepen the immersive experience while staying architecture-safe.

This phase should add:
1. subtle ayah transition polish
2. keep-screen-awake option
3. repeat current ayah
4. sleep timer
5. memorization-mode-ready entry point / hook
6. layout/readability polish for long ayahs and different screen sizes

This mode should feel calmer, richer, and more intentional without becoming crowded.

==================================================
A. SUBTLE AYAH TRANSITION POLISH
==================================================

Improve how Focus Recitation Mode transitions from one ayah to the next.

Requirements:
- keep transitions subtle and calm
- no flashy animations
- no heavy motion
- preserve sync with the canonical playback/highlight state
- do not introduce a second timing engine

Preferred V2 behavior:
- a gentle fade between ayah updates
OR
- a very subtle content transition
only if it remains stable and does not destabilize sync

If animation risks desync or visual weirdness:
- keep it static and stable
- prioritize correctness over decoration

Must handle:
- next ayah during normal playback
- user-driven previous/next ayah
- pause state
- restart/repeat current ayah

==================================================
B. KEEP SCREEN AWAKE OPTION
==================================================

Add a Focus Recitation Mode setting:

Keep Screen Awake

Requirements:
- user can enable or disable it
- should apply only while in Focus Recitation Mode
- should not globally alter app behavior
- if ON, screen should remain awake while user is in this mode
- if OFF, normal device behavior applies

Persist preference if cleanly possible.

Preferred:
- store in a clean persisted preference path related to Focus Mode or reader/player settings
- if an existing settings structure can safely hold this, extend it
- otherwise add the smallest clean persisted setting needed

Do not create messy temporary logic.

==================================================
C. REPEAT CURRENT AYAH
==================================================

Add a Focus Recitation Mode V2 control:

Repeat Current Ayah

Requirements:
- when enabled, the currently active ayah repeats instead of advancing
- use the canonical playback path
- no side-channel playback loop engine
- current ayah display remains stable while repeating
- exiting repeat returns to normal sequential behavior

Important:
- build this cleanly as a transport/playback mode state, not as a hacked local UI loop
- make sure repeat does not break highlight state, follow behavior, or resume session integrity

V2 scope:
- only repeat the current ayah
- DO NOT implement ayah range repeat yet
- DO NOT implement memorization sequence logic yet

Persist only if it is safe and intentional.
If not, keep it session-scoped and document that clearly.

==================================================
D. SLEEP TIMER
==================================================

Add a simple sleep timer to Focus Recitation Mode.

Requirements:
- user can select a timer duration
- when timer completes, playback pauses or stops cleanly through the canonical controller
- UI should show that a timer is active
- user must be able to cancel the timer

Keep V2 simple.
Suggested timer options:
- 5 min
- 10 min
- 15 min
- 30 min
- end of current ayah (optional only if already easy and clean)

Do not overengineer.
No complex schedules.
No cross-app scheduling.
No background task maze.

If the app goes backgrounded while timer runs, keep behavior aligned with the existing canonical playback/runtime constraints and document any platform limits clearly.

==================================================
E. MEMORIZATION MODE ENTRY HOOK
==================================================

Do NOT build full memorization mode in this phase.

Instead:
- add a clean entry point or structural hook from Focus Recitation Mode for a future memorization mode
- for example:
  - a placeholder action route
  - a clearly named button hidden behind a small menu
  - a clean architecture hook in the mode surface

This must be production-safe and not dead-broken.
If the actual memorization mode route does not exist yet, keep the hook internal or clearly defer it without exposing broken UX.

The goal is to shape the surface so V3 or a future phase can naturally extend into:
- repeat ayah
- slower review
- ayah-by-ayah learning
- memorization flow

==================================================
F. LAYOUT / READABILITY POLISH
==================================================

Improve the Focus Recitation Mode layout for:
- long ayahs
- translation on/off combinations
- transliteration on/off combinations
- smaller phone screens
- large phones
- accessibility/readability

Requirements:
- Arabic remains primary
- translation and transliteration remain clearly secondary
- spacing remains generous
- no overflow or cramped layouts
- long content should still feel elegant
- scroll only if truly needed
- preserve a calm visual hierarchy

Consider:
- balanced vertical layout
- dynamic spacing
- content container constraints
- graceful handling of very long ayahs

==================================================
G. CONTROLS / INTERACTION POLISH
==================================================

V2 controls should remain minimal but more refined.

Core controls allowed:
- previous ayah
- play/pause
- next ayah
- exit
- translation toggle
- transliteration toggle
- repeat current ayah toggle
- sleep timer entry
- keep-screen-awake toggle

Optional if already clean:
- auto-hide controls after a short delay
- tap once to reveal controls again

Only implement auto-hide if it is stable and does not reduce usability.
Do not introduce buggy gesture conflicts.

==================================================
H. ARCHITECTURE REQUIREMENTS
==================================================

Everything must continue to flow through the canonical runtime.

Repeat, sleep timer, and other V2 actions must dispatch through:
- quran_player_controller.dart
- quran_reader_playback_controller.dart
- quran_providers.dart
or another appropriate existing canonical layer

Do NOT:
- create a local playback state machine inside Focus Recitation Mode
- create local-only repeat logic that fights the engine
- duplicate active ayah state
- create a parallel timer controller that bypasses playback state

If helper classes are needed, place them in the correct layer.

==================================================
I. PERSISTENCE / SETTINGS REQUIREMENTS
==================================================

Handle the following carefully:

Potential persisted V2 preferences:
- showTranslation
- showTransliteration
- keepScreenAwake

Potential session-scoped or persisted state:
- repeatCurrentAyah
- sleepTimer active state (likely session-scoped)

Choose the cleanest, safest model and document it clearly.

Do not break existing persistence keys:
- learn.quran.audioSettings
- learn.quran.recitationSession
- learn.quran.listeningStats
- learn.quran.followPlayback

If new keys/settings are added:
- keep them cleanly named
- keep them scoped logically
- do not create random one-off storage clutter

==================================================
J. ENTRY POINT / NAVIGATION
==================================================

Keep V1 entry intact.
From the existing player/full-screen audio surface, user should still be able to enter Focus Recitation Mode.

V2 may add:
- a small settings menu within Focus Mode
OR
- a subtle controls/settings affordance

Do not scatter too many entry points across the app in this phase.

==================================================
K. TESTING REQUIREMENTS
==================================================

Add or update focused tests for:
1. Focus Mode still enters correctly
2. ayah updates still stay synced during transition polish
3. translation toggle still works
4. transliteration toggle still works
5. repeat current ayah works through canonical transport
6. repeat current ayah does not advance unexpectedly
7. sleep timer starts, counts down logically, and pauses/stops playback correctly
8. sleep timer cancel works
9. keep-screen-awake toggle applies correctly in Focus Mode
10. long ayah layout does not break
11. no second playback stack introduced
12. exiting Focus Mode does not break playback state

Run:
- flutter gen-l10n if needed
- focused flutter analyze
- focused widget tests
- focused player/controller tests as needed

==================================================
L. FILE PRIORITIES
==================================================

Likely touch points:
- Focus Recitation Mode page/widget(s)
- quran_player_controller.dart
- quran_reader_playback_controller.dart
- quran_providers.dart
- existing full player entry point
- any minimal settings/control widgets needed for Focus Mode

Only touch broader surfaces if needed.
Do not spread this phase across unrelated pages.

==================================================
M. WHAT NOT TO DO IN THIS PHASE
==================================================

Do NOT:
- build full memorization mode yet
- build ayah range repeat yet
- build offline diagnostics yet
- build watch-specific UI yet
- build shell/home Focus Mode entry sprawl
- add tafsir/study/commentary overlays
- create a second playback engine
- overcomplicate sleep timer scheduling

This is V2 polish and extension only.

==================================================
DELIVERABLES
==================================================

At the end provide:

1. IMPLEMENTATION SUMMARY
- what was built
- what was reused
- what was newly added

2. FILES CHANGED
- added
- modified
- removed

3. FOCUS RECITATION MODE V2 RESULT
State clearly:
- what new capabilities were added
- how transitions behave
- what controls/settings are available now

4. SETTINGS / PERSISTENCE RESULT
State clearly:
- which preferences persist
- which states are session-only
- where they live

5. REPEAT CURRENT AYAH RESULT
State clearly:
- how it works
- how it interacts with normal playback
- any limitations

6. SLEEP TIMER RESULT
State clearly:
- what timer options exist
- how it behaves when completed
- how cancel works
- any platform/runtime limitations

7. KEEP-SCREEN-AWAKE RESULT
State clearly:
- how it behaves
- whether it persists

8. CANONICAL ARCHITECTURE STATUS
Confirm that:
- no second playback stack was created
- canonical runtime remains the source of truth

9. VALIDATION
State what tests/analyze/gen-l10n were run

10. DEFERRED ITEMS
What belongs in V3 or later, such as:
- ayah range repeat
- full memorization mode
- more advanced transition styles
- sleep timer end-of-ayah option if deferred
- landscape/tablet deep polish

11. FINAL CODEX AUDIT
End with:
- what was completed
- what remains
- what cleanup is safe if any
- what next phase should be

==================================================
NEXT PHASE RECOMMENDATION
==================================================

After this phase, recommend the best next follow-up from:
- Focus Recitation Mode V3
- memorization loop foundations
- preload / buffering improvements
- offline diagnostics + repair UX
- shell/home continue-listening expansion

IMPORTANT PRODUCT INTENT
Focus Recitation Mode V2 should feel:
- calmer
- richer
- more immersive
- still minimal
- still Qur’an-first
- still architecture-safe
