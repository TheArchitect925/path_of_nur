===== PHASE 25 PROMPT — KIDS ARABIC READING MODE (WORD CARDS + AUDIO) =====

PRIMARY OBJECTIVE === BUILDING A KIDS ARABIC READING MODE WITH WORD CARDS, TAP-TO-HEAR AUDIO, AND SIMPLE RECOGNITION FLOW

You are working in the existing Flutter codebase for Path of Nūr.

This phase builds on top of the existing Kids Arabic tracing and word system. DO NOT rebuild tracing. DO NOT introduce strict testing or grading. This phase focuses on recognition and confidence.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Preserve existing Kids Arabic systems
- Keep UX simple and child-friendly
- No scoring or pressure-based UI
- Reuse audio systems if available
- No destructive changes

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Create a Kids Arabic Reading Mode
2. Implement word-card UI
3. Add tap-to-hear pronunciation
4. Enable simple navigation (next/previous)
5. Keep experience calm and repeatable

--------------------------------------------------
A. AUDIT CURRENT SYSTEM
--------------------------------------------------

Inspect:
- word tracing system
- existing word dataset
- any audio support in the app
- Kids Arabic routing and pages

Identify:
- which words can be reused
- what audio sources exist (if any)
- best place to integrate reading mode

--------------------------------------------------
B. BUILD WORD CARD UI
--------------------------------------------------

Each card should show:
- Arabic word (primary)
- optional transliteration
- optional simple meaning

Requirements:
- clean layout
- centered word
- large readable font
- child-friendly design

--------------------------------------------------
C. TAP-TO-HEAR AUDIO
--------------------------------------------------

Add audio playback:

- tap word → play pronunciation
- allow replay

Requirements:
- quick response
- no delay-heavy loading
- safe fallback if audio missing

Reuse:
- existing audio system if available

--------------------------------------------------
D. NAVIGATION FLOW
--------------------------------------------------

Allow:
- next word
- previous word
- swipe or button navigation

Requirements:
- smooth transitions
- no dead ends
- no confusion

--------------------------------------------------
E. KEEP EXPERIENCE CALM
--------------------------------------------------

Ensure:
- no “correct/incorrect”
- no pressure
- no timers
- no scoring

Goal:
- repetition and familiarity

--------------------------------------------------
F. OPTIONAL LIGHT POLISH
--------------------------------------------------

If safe:
- subtle card animation
- highlight when audio plays
- gentle feedback on tap

--------------------------------------------------
G. DATA SAFETY
--------------------------------------------------

Preserve:
- word data
- tracing progress
- XP system
- lesson structure

--------------------------------------------------
H. TESTING
--------------------------------------------------

Test:
- word cards render correctly
- audio plays on tap
- navigation works
- no regressions

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

1. Files changed
2. Reading mode summary
3. Word card implementation
4. Audio integration summary
5. Navigation summary
6. Data safety summary
7. Validation results
8. FINAL AUDIT

--------------------------------------------------
SUCCESS CRITERIA
--------------------------------------------------

- Kids Arabic has a reading mode
- words are displayed clearly
- audio works reliably
- navigation is smooth
- experience is calm and engaging
- no regressions introduced

--------------------------------------------------

“And We have certainly made the Qur’an easy for remembrance.” — Qur’an 54:17

===== END PHASE 25 PROMPT =====
