===== PHASE 27 PROMPT — KIDS ARABIC AUDIO LEARNING LAYER (PRONUNCIATION + REPEAT MODE) =====

PRIMARY OBJECTIVE === BUILDING A KIDS ARABIC AUDIO LEARNING LAYER WITH LETTER AND WORD PRONUNCIATION, TAP-TO-HEAR, AND REPEAT-AFTER-ME FLOW

You are working in the existing Flutter codebase for Path of Nūr.

This phase adds audio-based learning on top of tracing, reading, and review systems. DO NOT introduce voice recording or pronunciation scoring. Focus on listening and repetition.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Preserve all existing tracing, reading, and review systems
- Keep UX calm and child-friendly
- Do not introduce pressure or scoring
- Reuse existing audio system if available
- No destructive changes

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Add letter pronunciation audio
2. Add word pronunciation audio
3. Implement tap-to-hear across relevant screens
4. Add repeat-after-me interaction flow
5. Optionally add autoplay for learning reinforcement

--------------------------------------------------
A. AUDIT AUDIO CAPABILITY
--------------------------------------------------

Inspect:
- existing audio playback systems
- any Qur’an audio infrastructure
- asset handling for sound files
- current Kids Arabic pages

Identify:
- best reusable audio player
- asset format and structure

--------------------------------------------------
B. ADD LETTER PRONUNCIATION
--------------------------------------------------

For each letter:
- add audio file or mapping
- tap letter → play sound

Requirements:
- fast playback
- no lag
- safe fallback if missing

--------------------------------------------------
C. ADD WORD PRONUNCIATION
--------------------------------------------------

For each word:
- tap → play pronunciation

Requirements:
- reuse word dataset
- ensure audio matches word

--------------------------------------------------
D. TAP-TO-HEAR INTEGRATION
--------------------------------------------------

Enable tap-to-hear in:
- tracing page
- reading mode
- word cards

Requirements:
- consistent behavior
- visual feedback on tap

--------------------------------------------------
E. REPEAT-AFTER-ME FLOW
--------------------------------------------------

Implement simple guided repetition:

Flow:
1. play audio
2. pause briefly
3. allow replay

Requirements:
- no recording
- no scoring
- optional replay button

--------------------------------------------------
F. OPTIONAL AUTOPLAY
--------------------------------------------------

If safe:

- auto-play audio when:
  - opening a new letter
  - opening a new word

Requirements:
- subtle
- not repetitive
- allow replay manually

--------------------------------------------------
G. UX FEEDBACK
--------------------------------------------------

Add:
- highlight on audio play
- subtle animation (pulse/glow)

No clutter.

--------------------------------------------------
H. DATA SAFETY
--------------------------------------------------

Preserve:
- all progress
- tracing data
- XP system
- lesson flow

--------------------------------------------------
I. TESTING
--------------------------------------------------

Test:
- audio plays correctly
- tap works everywhere
- no crashes if audio missing
- repeat works
- no regression in UI

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

1. Files changed
2. Audio integration summary
3. Letter audio mapping
4. Word audio mapping
5. UX behavior summary
6. Validation results
7. FINAL AUDIT

--------------------------------------------------
SUCCESS CRITERIA
--------------------------------------------------

- letters have working audio
- words have working audio
- tap-to-hear works across screens
- repeat flow is smooth
- no regressions introduced
- kids experience becomes more immersive

--------------------------------------------------

“And We have certainly made the Qur’an easy for remembrance.” — Qur’an 54:17

===== END PHASE 27 PROMPT =====
