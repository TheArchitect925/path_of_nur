# User Prompt

===== PHASE 6 PROMPT — FOCUS RECITATION MODE V1 =====

PRIMARY OBJECTIVE === BUILDING FOCUS RECITATION MODE

You are working inside the existing Flutter codebase for Path of Nūr.

The Qur’an player controls regression has already been fixed.
The canonical player runtime is already restored and must remain canonical.

This phase is to build V1 of a new dedicated Qur’an listening experience:

FOCUS RECITATION MODE

This is a full-screen, ayah-by-ayah, distraction-free recitation surface that follows the currently playing ayah and shows only the Qur’anic content plus minimal transport controls.

This is NOT a new playback engine.
This is NOT a new parallel player stack.
This is a new presentation mode built on top of the existing canonical Qur’an playback/runtime architecture.

==================================================
CRITICAL RULES
==================================================

1. DO NOT create a second playback stack.
2. DO NOT replace or bypass the canonical player runtime.
3. DO NOT rebuild the audio engine.
4. DO NOT break:
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
5. DO NOT clutter this mode with reader chrome, tafsir cards, extra widgets, or unrelated UI.
6. Keep this production-ready, calm, and minimal.
7. End with a full Codex audit summary.

==================================================
CURRENT CANONICAL FOUNDATION
==================================================

These remain canonical and must stay canonical:
- quran_player_controller.dart → engine owner
- quran_reader_playback_controller.dart → UI-facing state owner
- quran_playback_orchestrator.dart → session/queue logic
- quran_audio_repository.dart → reciters, sources, downloads
- quran_providers.dart → provider entry and persistence

The new mode must read from and dispatch actions through the existing runtime.

==================================================
PHASE GOAL
==================================================

Build V1 of Focus Recitation Mode.

When the user enters this mode:
- the screen becomes a full-screen ayah-by-ayah recitation surface
- the currently playing ayah is shown prominently
- the screen advances as playback moves to the next ayah
- the page shows nothing unnecessary
- the user may optionally show:
  - translation
  - transliteration

This is a presence-focused listening mode.
It should feel calm, immersive, clean, and Qur’an-first.

==================================================
V1 EXPERIENCE REQUIREMENTS
==================================================

Focus Recitation Mode must provide:

1. FULL-SCREEN AYAH SURFACE
- show the current ayah prominently
- Arabic text is the primary content
- current surah and ayah reference should be visible in a subtle, elegant way
- optionally show reciter name in a small unobtrusive way

2. AYAH-BY-AYAH ADVANCE
- as playback advances, the displayed ayah updates
- it must stay in sync with the canonical playback state
- no second timing engine
- no page-local playback logic hacks

3. OPTIONAL CONTENT TOGGLES
Allow the user to choose:
- show translation: ON/OFF
- show transliteration: ON/OFF

V1 must support these combinations:
- Arabic only
- Arabic + translation
- Arabic + transliteration
- Arabic + translation + transliteration

4. MINIMAL CONTROLS
Provide only essential controls, such as:
- play/pause
- previous ayah
- next ayah
- exit Focus Recitation Mode

Optional if already easy and clean:
- stop
- open main/full player

Do NOT add excessive controls.

==================================================
PRODUCT / UX INTENT
==================================================

This mode is for:
- immersive listening
- reflection
- ayah-by-ayah following
- calmer recitation focus
- optional support for non-Arabic readers through translation/transliteration

This mode is NOT:
- a replacement for the normal reader
- a cluttered study page
- a full tafsir/notes screen
- a generic music player

It should feel like:
- one ayah
- one moment
- one calm screen

==================================================
SCREEN LAYOUT DIRECTION
==================================================

V1 recommended layout:

TOP AREA
- Surah name
- Ayah number/reference
- optional reciter name in subtle style
- exit button

MAIN AREA
- large Arabic ayah text centered or vertically balanced
- optional translation below
- optional transliteration below
- generous spacing
- premium readable typography
- strong contrast and accessibility

BOTTOM AREA
- minimal player controls:
  - previous ayah
  - play/pause
  - next ayah
  - optional settings/toggle entry point

Keep the layout spacious and elegant.
Do not crowd the screen.

==================================================
ARCHITECTURE REQUIREMENTS
==================================================

Build this as a new presentation surface only.

It must:
- subscribe to canonical playback state
- read active surah
- read active ayah
- read playback status
- read ayah content
- react to existing player transitions
- dispatch actions through the canonical controller

Do NOT:
- create a new playback controller
- create a new ayah timing engine
- duplicate playback state locally
- fork the player architecture

If a new route/page/widget is needed, that is fine.
But it must stay presentation-only.

==================================================
SETTINGS / STATE REQUIREMENTS
==================================================

Add V1 settings for Focus Recitation Mode visibility options:

Required:
- showTranslation
- showTransliteration

Decide the cleanest storage strategy.

Preferred:
- persist these mode preferences so the user’s last choice is remembered

If there is already a suitable settings path under existing Qur’an audio/reader preferences, extend it safely.
If not, add the smallest clean persisted setting contract needed.

Do not create messy one-off local state if persistence is simple and safe to support.

==================================================
ENTRY POINTS
==================================================

V1 should be entered from the existing Qur’an audio experience.

Preferred entry point:
- from the full-screen player, add a clean action such as:
  - Enter Focus Mode
  OR
  - Focus Recitation Mode

Optional secondary entry point if clean:
- from the reader/player controls surface

Do not scatter too many entry points in V1.

==================================================
SYNC BEHAVIOR
==================================================

The screen must stay aligned with the active playback ayah.

Requirements:
- when playback advances, displayed ayah updates
- when user taps next/previous ayah, display updates accordingly
- when user pauses, the same ayah remains shown
- when user exits the mode, playback continues or pauses exactly according to the existing canonical player behavior
- tap-to-jump and other existing canonical interactions must remain compatible

If timing metadata is still approximate in some cases, use the current canonical playback/highlight state as the display source of truth.

==================================================
VISUAL / MOTION GUIDELINES
==================================================

Keep this mode calm.

V1 motion:
- simple fade or subtle content transition only if already easy and safe
- no flashy animations
- no noisy motion
- no dramatic page effects

If transition animation risks destabilizing sync, keep V1 static and stable.

==================================================
ACCESSIBILITY / READABILITY
==================================================

Ensure:
- text is readable
- spacing is generous
- layout works on common phone sizes
- translation/transliteration do not overpower Arabic
- high contrast is preserved
- long ayahs still render gracefully

Handle long content carefully:
- scroll only if necessary
- preserve calm reading experience
- avoid broken overflow or cramped text

==================================================
FILE PRIORITIES
==================================================

Build through the existing runtime, and likely add new presentation files.

Potential touch points:
- quran_player_controller.dart
- quran_reader_playback_controller.dart
- quran_providers.dart
- full-screen player surface where the entry point is added
- any existing playback presentation widgets

Likely new files:
- a dedicated Focus Recitation Mode page/widget
- minimal settings/toggle widget if needed

Do not move major logic into quran_reader_page.dart unless absolutely necessary.
Keep the mode surface isolated and clean.

==================================================
TESTING REQUIREMENTS
==================================================

Add or update focused tests for:
1. entering Focus Recitation Mode from the player
2. current ayah displays correctly
3. ayah updates as playback advances
4. translation toggle works
5. transliteration toggle works
6. combinations render correctly:
   - Arabic only
   - Arabic + translation
   - Arabic + transliteration
   - Arabic + translation + transliteration
7. previous/next ayah controls dispatch through canonical controller
8. exiting the mode does not break playback
9. no second playback stack introduced
10. persisted toggle state works if implemented

Run:
- flutter gen-l10n if needed
- focused flutter analyze
- focused widget tests
- focused playback/player integration tests as needed

==================================================
WHAT NOT TO DO IN THIS PHASE
==================================================

Do NOT:
- add memorization loop mode yet
- add sleep timer yet
- add watch-specific UI yet
- add offline diagnostics yet
- add tafsir/study overlays yet
- add too many controls
- rebuild the main reader
- rebuild the full-screen player
- create a separate audio session

This is V1 only:
clean, minimal, immersive, synced.

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

3. FOCUS RECITATION MODE RESULT
State clearly:
- how the mode is entered
- what it shows
- how ayah sync works
- what controls are available

4. TOGGLE / PREFERENCE RESULT
State clearly:
- whether translation visibility is persisted
- whether transliteration visibility is persisted
- where the settings live

5. CANONICAL ARCHITECTURE STATUS
Confirm that:
- no second playback stack was created
- canonical runtime remains the source of truth

6. VALIDATION
State what tests/analyze/gen-l10n were run

7. DEFERRED ITEMS
What belongs in V2, such as:
- fade/slide transitions
- repeat ayah
- sleep timer
- keep screen awake
- memorization mode entry
- landscape/tablet polish

8. FINAL CODEX AUDIT
End with:
- what was completed
- what remains
- what cleanup is safe if any
- what next phase should be

==================================================
NEXT PHASE RECOMMENDATION
==================================================

After this phase, recommend the best follow-up from:
- Focus Recitation Mode V2 polish
- preload / buffering improvements
- offline diagnostics + repair UX
- memorization loop foundations
- shell/home continue-listening expansion

IMPORTANT PRODUCT INTENT
This mode should feel like a dedicated recitation companion:
- calm
- full-screen
- ayah-by-ayah
- Arabic first
- translation/transliteration optional
- minimal controls
- canonical-runtime-driven
