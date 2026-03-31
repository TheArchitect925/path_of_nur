# PHASE X PROMPT — QURAN MINI PLAYER SIMPLIFICATION + FULLSCREEN-FIRST CONTROLS

PRIMARY OBJECTIVE === BUILDING QURAN PLAYER UI SIMPLIFICATION

You are working inside the existing Flutter codebase for Path of Nūr.

The Qur’an player currently works, but the compact player surface is too large and cluttered.
We want to simplify it so the reader remains the priority.

This phase is a UI/UX refinement pass.
Do NOT rebuild the playback engine.
Do NOT create a second playback stack.
Do NOT change the canonical player/runtime ownership.

CRITICAL RULES

1. Preserve the canonical playback runtime.
2. Do NOT create a second playback stack.
3. Do NOT break:
   - mini player playback behavior
   - full-screen player behavior
   - Follow Ayah Mode
   - continue listening
   - tap-to-jump
   - background/native media path
   - reciter system
   - downloads/source resolution
   - persistence keys
4. Keep the reader page focused on verses.
5. Move complexity OUT of the compact player, not into the reader.
6. End with a full Codex audit summary.

PHASE GOAL

Simplify the compact Qur’an player so it becomes a minimal reader companion.

New compact player goals:
- smaller visual footprint
- less clutter
- reader-first design
- only essential controls visible
- clear fullscreen entry point

The compact player should feel like a subtle playback dock, not a full transport panel.

TARGET MINI PLAYER DESIGN

The compact player should show ONLY:

1. Play / Pause icon
2. Thin progress bar
3. Fullscreen / expand icon

Optional:
- a very small single-line surah/ayah label only if it still feels clean and does not increase height too much

The compact player should NOT show:
- next ayah
- previous ayah
- next surah
- previous surah
- stop
- reciter controls
- large text blocks
- repeated metadata rows
- extra action clutter

The compact player must be visually smaller than the current version.

FULLSCREEN PLAYER RESPONSIBILITY

Move advanced controls emphasis to the fullscreen player.

The fullscreen player should remain the place for:
- previous/next ayah
- previous/next surah
- stop
- reciter controls
- follow mode controls
- richer playback details
- any secondary playback settings

The fullscreen player should be the main control surface.
The mini player should be the lightweight access surface.

UX / LAYOUT REQUIREMENTS

Mini player:
- compact height
- above bottom navigator
- does not obstruct verse reading
- calm and premium
- visually light
- easy to tap

Preferred layout direction:
- left: play/pause icon
- center: thin progress bar
- right: fullscreen/expand icon

Optional tiny metadata:
- place above or within the bar only if it stays extremely compact

If metadata makes the mini player feel busy, remove it.

INTERACTION REQUIREMENTS

Mini player must support:
- tap play/pause
- tap fullscreen/expand
- progress indicator updates correctly during playback

Do NOT overload the mini player with extra gestures unless already stable.
If tapping the body opens fullscreen and remains clean, that is acceptable, but the explicit fullscreen icon should still exist.

AUDIT-FIRST REQUIREMENT

Before changing the UI, audit the current compact player surface and identify:
- which widgets currently make it too tall or cluttered
- which controls can be safely removed from the mini player
- what should remain only in fullscreen player
- whether any callbacks are duplicated between mini and fullscreen surfaces
- whether metadata can be reduced without losing important context

Then implement the simplified version.

FILES TO PRIORITIZE

Likely touch points:
- quran_playback_controls_card.dart
- quran_expanded_player_sheet.dart
- app_scaffold.dart
- any mini player container/widget used by the reader shell
- any related player presentation widgets

Only touch controllers/providers if needed for surface cleanup.
This phase should primarily be presentation-layer work.

TESTING REQUIREMENTS

Add or update focused tests for:
1. mini player still renders correctly
2. play/pause still works from mini player
3. progress bar still updates
4. fullscreen button opens the expanded player
5. removed controls no longer appear in mini player
6. fullscreen player still contains advanced controls
7. no playback regression introduced by the UI simplification

Run:
- flutter analyze on changed files
- focused widget tests for mini/fullscreen player surfaces

DELIVERABLES

At the end provide:

1. AUDIT FINDINGS
- what made the old mini player too large/cluttered
- what was removed from the compact surface
- what remained in fullscreen only

2. FILES CHANGED
- added
- modified
- removed

3. MINI PLAYER RESULT
- exact controls now shown
- whether metadata remains
- how the compact height/footprint improved

4. FULLSCREEN PLAYER RESULT
- which controls remain there
- whether anything moved from mini player to fullscreen emphasis

5. VALIDATION
- analyze run
- tests run

6. FINAL CODEX AUDIT
End with:
- what was simplified
- whether any further player polish is still recommended

IMPORTANT PRODUCT INTENT
The compact Qur’an player should feel like:
- a subtle reader companion
- minimal
- calm
- small
- useful without competing with the verses
