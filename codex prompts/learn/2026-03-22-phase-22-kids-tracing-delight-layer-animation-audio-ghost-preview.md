===== PHASE 22 PROMPT — KIDS TRACING DELIGHT LAYER (ANIMATION, AUDIO, GHOST-STROKE PREVIEW) =====

PRIMARY OBJECTIVE === BUILDING A DELIGHTFUL KIDS TRACING EXPERIENCE WITH SOFT ANIMATIONS, AUDIO FEEDBACK, AND GHOST-STROKE GUIDANCE ON TOP OF THE EXISTING TRACING SYSTEM

You are working in the existing Flutter codebase for Path of Nūr.

This phase enhances the Kids Arabic tracing experience with polish and engagement. DO NOT change the core tracing logic. DO NOT introduce strict scoring.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Preserve tracing engine behavior
- Preserve progression and XP logic
- Keep UX calm and child-friendly
- Avoid loud or distracting effects
- Reuse existing assets where possible
- No destructive changes

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Add soft completion animations
2. Add optional audio feedback
3. Add ghost-stroke preview
4. Improve completion moment flow

--------------------------------------------------
A. AUDIT CURRENT COMPLETION FLOW
--------------------------------------------------

Inspect:
- tracing completion trigger
- current success UI
- existing glow/feedback
- timing of transitions

Identify where to insert animation/audio safely.

--------------------------------------------------
B. ADD COMPLETION ANIMATION
--------------------------------------------------

Enhance success state with:
- soft glow expansion
- subtle sparkle or halo effect

Requirements:
- smooth animation
- not distracting
- fits kids theme
- short duration

Use:
- AnimatedOpacity / AnimatedScale / custom painter animation

--------------------------------------------------
C. ADD AUDIO FEEDBACK
--------------------------------------------------

Add:
- soft success sound
- optional letter pronunciation

Requirements:
- short, gentle sound
- not loud or repetitive
- optional toggle if settings exist

Reuse:
- existing audio system if available

--------------------------------------------------
D. GHOST-STROKE PREVIEW
--------------------------------------------------

Add faint animated guide showing how to trace letter.

Requirements:
- optional (toggle or auto-show after inactivity)
- subtle opacity
- non-blocking
- follows actual vector path

Do NOT:
- enforce stroke order
- force user to follow it

--------------------------------------------------
E. IMPROVE COMPLETION FLOW TIMING
--------------------------------------------------

Refine sequence:

1. completion detected
2. short pause
3. animation + sound
4. action buttons appear

Ensure:
- no abrupt transitions
- smooth UX

--------------------------------------------------
F. KEEP UX CLEAN
--------------------------------------------------

Ensure:
- no clutter
- no overlapping UI
- actions remain clear
- tracing area remains focus

--------------------------------------------------
G. DATA SAFETY
--------------------------------------------------

Preserve:
- tracing state
- XP logic
- progress

No changes to data model.

--------------------------------------------------
H. TESTING
--------------------------------------------------

Test:
- animation triggers correctly
- audio plays once
- ghost preview renders
- no performance issues
- no regression in tracing
- UX remains smooth

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

1. Files changed
2. Animation implementation
3. Audio integration summary
4. Ghost preview implementation
5. UX flow summary
6. Validation results
7. FINAL AUDIT

--------------------------------------------------
SUCCESS CRITERIA
--------------------------------------------------

- tracing completion feels rewarding
- animations are smooth and subtle
- audio enhances experience without noise
- ghost stroke helps learning
- no regression introduced
- kids experience feels engaging and polished

--------------------------------------------------

“And We have certainly made the Qur’an easy for remembrance.” — Qur’an 54:17

===== END PHASE 22 PROMPT =====
