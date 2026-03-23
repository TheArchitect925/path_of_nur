===== PHASE 18 PROMPT — KIDS ARABIC LETTER TRACING SYSTEM (REAL INTERACTIVE ENGINE) =====

PRIMARY OBJECTIVE === BUILDING A REAL KIDS ARABIC LETTER TRACING SYSTEM WITH VECTOR OUTLINES, TOUCH TRACING, COLOR SELECTION, RESET, AND SIMPLE COMPLETION FEEDBACK

You are working in the existing Flutter codebase for Path of Nūr.

This is a production feature. DO NOT fake tracing. DO NOT use static images. This must be a real interactive tracing system.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Fix root cause of current broken tracing feature
- Do NOT layer hacks on top of broken implementation
- Use vector/path-based tracing (NOT images)
- Keep V1 simple and kid-friendly
- No strict scoring or handwriting recognition
- Reuse kids UI system and XP hooks where safe
- No destructive changes
- Analyzer must pass

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Fix current broken tracing feature
2. Build real tracing system using vector outlines
3. Add touch-based tracing interaction
4. Add color picker
5. Add reset functionality
6. Add simple completion feedback
7. Start with Alif, Ba, Meem only

--------------------------------------------------
A. AUDIT CURRENT TRACING FEATURE
--------------------------------------------------

- Locate current "Trace Together" implementation
- Identify root issue:
  - gesture handling?
  - rendering?
  - missing path data?
  - canvas repaint issue?
  - broken layering?

Fix the ROOT cause.

--------------------------------------------------
B. CREATE LETTER OUTLINE SYSTEM
--------------------------------------------------

Create structured letter model:

- id
- name
- vector path

Implement for:
- Alif
- Ba
- Meem

Render outline:
- faint
- clear
- child-friendly

--------------------------------------------------
C. BUILD TRACING ENGINE
--------------------------------------------------

Use:
- CustomPainter
- GestureDetector / Pointer tracking

Implement:
- smooth drawing path
- finger tracking
- repaint correctly

--------------------------------------------------
D. RENDER LAYERS
--------------------------------------------------

1. Background
2. Letter outline
3. User stroke
4. Completion state

--------------------------------------------------
E. COLOR PICKER
--------------------------------------------------

- simple preset colors
- child-friendly
- updates stroke color

--------------------------------------------------
F. RESET FUNCTION
--------------------------------------------------

- clears all strokes
- resets state cleanly

--------------------------------------------------
G. COMPLETION FEEDBACK
--------------------------------------------------

- simple threshold logic
- no strict scoring

Example:
- if enough drawing → success

On success:
- show celebration
- trigger XP if available

--------------------------------------------------
H. ROLLOUT STRATEGY
--------------------------------------------------

Only implement:
- Alif
- Ba
- Meem

Design system so more letters can be added easily later.

--------------------------------------------------
I. CLEANUP
--------------------------------------------------

- remove broken tracing logic
- remove fake overlays
- clean naming

--------------------------------------------------
VALIDATION
--------------------------------------------------

Confirm:
- tracing works smoothly
- outline is visible
- stroke follows finger
- colors work
- reset works
- completion triggers
- no crashes
- analyzer passes

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

1. Files changed
2. Root cause of old tracing issue
3. How outlines are stored
4. How tracing is implemented
5. Color system
6. Letters implemented
7. Any follow-ups

--------------------------------------------------

“And We have certainly made the Qur’an easy for remembrance.” — Qur’an 54:17

===== END PHASE 18 PROMPT =====
