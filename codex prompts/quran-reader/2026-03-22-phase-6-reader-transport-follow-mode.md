===== PHASE 6 PROMPT — QUR’AN READER TRANSPORT CONTROLS AND FOLLOW MODE =====

PRIMARY OBJECTIVE === BUILDING QUR’AN READER TRANSPORT CONTROLS AND FOLLOW MODE

You are working in the existing Flutter codebase for Path of Nūr.

This is a targeted production-ready enhancement phase built on top of the existing Qur’an reader. DO NOT rebuild the reader. DO NOT remove working features. Build safely on top of the current implementation.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Preserve existing playback, highlighting, reciter switching, downloads, bookmarks, notes, memorization helpers, continue/resume behavior, and offline-first behavior
- Do not remove or rewrite working logic unless strictly necessary
- Do not delete user data, progress, or session state
- Keep scope limited to this phase
- No giant UI redesign in this phase
- Make the new controls feel native to the current reader, not bolted on
- Reuse the extracted playback/state architecture from the prior phase where possible
- Do not introduce unnecessary package churn
- At the end, provide a concise audit summary

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Add explicit transport controls to the Qur’an reader:
   - Previous ayah
   - Next ayah
   - Restart current ayah

2. Add follow mode / auto-scroll toggle:
   - user can turn follow on or off
   - preserve current expected reading/listening flow
   - prevent forced scrolling when follow is off

3. Clean up playback behavior so transport actions, highlighting, and scroll behavior remain synchronized

4. Make repeat/replay behavior clearer where needed without a full repeat-system redesign

5. Keep the reader stable and ready for future mode cleanup

--------------------------------------------------
A. AUDIT (MANDATORY FIRST STEP)
--------------------------------------------------

Audit the current reader and playback implementation before editing.

Inspect:
- current playback controls in the reader
- current highlight synchronization flow
- current active ayah source of truth
- current scrolling/follow behavior
- any current repeat/replay behavior
- memorization mode interactions with playback
- session restore behavior when playback resumes
- reader layout constraints and available UI space for controls

Audit questions:
- What controls already exist?
- Is restart current ayah already possible indirectly?
- What state/action hooks already exist from the extracted playback layer?
- What happens today when the active ayah changes?
- Is auto-follow already always on, partially on, or mixed into page logic?
- What should happen when the user manually scrolls away while listening?
- How does memorization mode currently interact with playback targeting?

--------------------------------------------------
B. ADD TRANSPORT CONTROLS
--------------------------------------------------

Implement explicit reader transport controls for:

- Previous ayah
- Next ayah
- Restart current ayah

Requirements:
- Controls must be wired to the centralized playback state/controller layer, not page-local ad hoc logic
- Actions must update playback target cleanly
- Active ayah highlighting must remain correct
- Scroll/follow behavior must remain consistent with the current follow setting
- Session state should remain resume-safe after transport actions
- Do not break reciter selection or downloaded audio usage

Behavior expectations:
- Previous ayah:
  - go to the prior ayah in the current surah
  - if already at the first ayah, handle gracefully
  - optionally stay within current surah unless cross-surah stepping is already supported cleanly
- Next ayah:
  - go to the next ayah in the current surah
  - if already at the last ayah, handle gracefully
  - do not invent broken cross-surah behavior if not already supported
- Restart ayah:
  - restart the current ayah from the beginning
  - do not accidentally reset the whole surah
  - make replay behavior explicit and reliable

If cross-surah transport is already supported in a clean, existing pathway, preserve or reuse it. If not, keep this phase scoped to stable same-surah transport only.

--------------------------------------------------
C. FOLLOW MODE / AUTO-SCROLL TOGGLE
--------------------------------------------------

Add a clear user-facing toggle for Follow Mode / Auto-Scroll.

Goal:
- when follow is ON, reader follows the active ayah during playback
- when follow is OFF, playback continues but the page does not forcibly jump/scroll to follow the ayah

Requirements:
- preserve current default behavior if that is the safer UX for existing users
- avoid jittery or over-aggressive scrolling
- avoid constant fight between user manual scroll and playback-driven auto-scroll
- keep the toggle discoverable but not visually noisy

Expected behavior:
- Follow ON:
  - active ayah stays in view during playback where practical
  - smooth scrolling only when needed
- Follow OFF:
  - playback and highlighting continue
  - user can explore the page freely without forced repositioning
- If user manually scrolls while Follow ON:
  - decide on a stable behavior based on the current implementation, for example:
    - either keep follow on and resume gentle following on next ayah change
    - or temporarily suspend until re-enabled
  - whichever approach is chosen, keep it simple, stable, and explain it in the final summary

Persist follow preference if there is already a settings/state pattern that supports it cleanly. If not, add lightweight persistence only if it fits the existing architecture safely.

--------------------------------------------------
D. KEEP HIGHLIGHTING AND PLAYBACK SYNCHRONIZED
--------------------------------------------------

Do not regress highlighting.

Ensure that after transport actions:
- active ayah updates correctly
- ayah highlight remains synchronized with playback
- restart ayah does not desync the highlight
- next/previous ayah actions do not leave stale UI state behind

If there are competing sources of truth for active ayah or scroll target, clean them up safely.

--------------------------------------------------
E. CLARIFY REPLAY / REPEAT BEHAVIOR
--------------------------------------------------

Without redesigning the full repeat system, ensure the new controls behave clearly.

Requirements:
- restart ayah should be a first-class explicit action
- do not rely on confusing hidden behaviors like forcing start=end unless that already exists internally and is safely abstracted
- if repeat/loop state exists, transport actions should interact with it predictably
- do not do a full repeat-system overhaul in this phase

If needed, add a small internal cleanup so replaying the current ayah is distinct from loop/range behavior.

--------------------------------------------------
F. MEMORIZATION MODE SAFETY
--------------------------------------------------

Memorization helpers already exist. Do not break them.

Audit and preserve:
- memorization playback targeting
- any repeat behavior specific to memorization
- any hidden/partial ayah states if present
- any special flow for reciting/repeating a selected ayah or range

Requirements:
- transport controls should behave safely if user is in memorization-related context
- if transport should be limited or behave differently in memorization context, keep that explicit and stable
- do not force a full memorization redesign in this phase

--------------------------------------------------
G. READER UI INTEGRATION
--------------------------------------------------

Integrate the new controls cleanly into the existing reader UI.

Requirements:
- maintain current visual language of the reader
- avoid clutter
- do not create a giant expanded control bar unless it clearly fits the existing design
- controls should feel intentionally placed near playback controls
- follow toggle should be accessible but not dominant

Prefer:
- compact, readable, touch-friendly controls
- clear iconography and labels where needed
- layout that works on smaller screens

Do not redesign the entire player or settings panel in this phase.

--------------------------------------------------
H. SESSION / RESUME SAFETY
--------------------------------------------------

Ensure new controls do not weaken session restore.

Requirements:
- after previous/next/restart actions, resume state should still point to the right place
- follow mode preference should not corrupt session restore
- playback position/session metadata should remain coherent
- re-entering the reader should not create broken state due to transport actions

--------------------------------------------------
I. TESTING
--------------------------------------------------

Add or update meaningful tests for:

- previous ayah action
- next ayah action
- restart current ayah action
- active ayah state updates after transport
- highlight remains synchronized after transport
- follow mode on/off behavior
- user manual scroll does not cause broken follow behavior
- resume/session state remains valid after transport actions
- memorization context does not regress

Do not add fake tests. Add real regression protection.

Run analyzer/tests for changed areas and report clearly.

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

1. Files changed
2. Audit findings
   - what existed before
   - what was missing
   - any notable architectural constraints
3. Transport controls summary
   - how previous/next/restart were implemented
   - same-surah vs cross-surah behavior
4. Follow mode summary
   - how toggle works
   - whether it persists
   - how manual scroll interaction is handled
5. Playback/highlight synchronization summary
6. Memorization safety summary
7. Validation
   - analyzer/tests run
   - results
8. FINAL AUDIT
   - what was completed
   - regressions found/fixed
   - what remains for future phases
   - any technical debt intentionally left for later

--------------------------------------------------
SUCCESS CRITERIA
--------------------------------------------------

- Reader has explicit Previous Ayah control
- Reader has explicit Next Ayah control
- Reader has explicit Restart Ayah control
- Follow Mode / Auto-Scroll toggle exists
- Playback remains synchronized with highlighting
- Manual reading is possible without forced scroll when Follow is off
- Memorization helpers still work
- Resume/session behavior still works
- No regression in reciter switching, downloads, bookmarks, notes, or playback stability

--------------------------------------------------
DO NOT DO IN THIS PHASE
--------------------------------------------------

Do not:
- rebuild the reader UI from scratch
- add a global mini-player
- add sleep timer
- do a giant mode redesign
- overhaul the full repeat/loop system
- move unrelated controls around the app
- redesign Qur’an home
- break memorization flows
- add speculative features not needed for this phase

Stay focused on transport controls, follow mode, and safe synchronization.

--------------------------------------------------

“And We have certainly made the Qur’an easy for remembrance, so is there any who will remember?” — Qur’an 54:17

===== END PHASE 6 PROMPT =====
