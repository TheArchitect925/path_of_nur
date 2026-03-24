===== PHASE 38 PROMPT — SHARED GENTLE REVIEW LAYER (KIDS + ADULT ARABIC) =====

PRIMARY OBJECTIVE === BUILDING A SHARED, CALM REVIEW LAYER THAT SUGGESTS WHAT TO REVISIT (LETTERS, WORDS, PHRASES) FOR BOTH KIDS AND ADULT ARABIC LEARNING WITHOUT PRESSURE OR STRICT SCORING

You are working in the existing Flutter codebase for Path of Nūr.

This phase builds on top of:
- shared Arabic alphabet foundation
- shared positional-form foundation
- shared audio manifest
- shared words/phrases foundation
- Kids tracing / reading / review systems
- Adult alphabet / words / reading-helper systems
- unified continuity/resume layer (Phase 37)

DO NOT rebuild existing systems. DO NOT introduce strict testing or grading. Build safely on top of the current implementation.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Preserve tracing, reading, audio, progress, routing, and shared foundations
- Keep UX calm, encouraging, and child/parent-friendly
- No strict scoring, timers, or pressure mechanics
- Use existing progress signals (started/completed/last-opened) where possible
- Avoid duplicating logic across pages—centralize review decisions
- No destructive migrations
- Run analyzer/tests and summarize results

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Create a shared “review suggestion” layer used by both Kids and Adults

2. Surface gentle review suggestions such as:
   - unfinished items
   - recently learned items
   - items worth revisiting

3. Integrate review with the unified Continue Arabic Learning flow

4. Keep presentation distinct:
   - Kids = simpler, more guided
   - Adults = cleaner, more direct

--------------------------------------------------
A. AUDIT CURRENT REVIEW SIGNALS
--------------------------------------------------

Inspect:
- kids_arabic_progress_provider.dart
- adult Arabic progress/state (letters/words)
- last-opened / last-completed data
- any existing “retry”, “practice again”, or review affordances
- continuity layer outputs (resume/continue)

Identify what signals are already available:
- started but not completed
- completed items
- last practiced timestamp (if present)
- explicit retries (if tracked)

--------------------------------------------------
B. DEFINE A SIMPLE SHARED REVIEW MODEL
--------------------------------------------------

Create a shared review model that classifies candidates into:
- RESUME (unfinished)
- REVIEW (completed but good to revisit)
- CONTINUE (next in sequence)

Keep logic simple and deterministic. Examples:
- If unfinished exists → RESUME
- Else if recently completed → REVIEW
- Else → CONTINUE

Do NOT build a full spaced-repetition engine.

--------------------------------------------------
C. BUILD A CENTRAL REVIEW SERVICE / PROVIDER
--------------------------------------------------

Create a shared review service that:
- reads shared foundations + progress
- returns a small set of suggested items (1–3 max)
- outputs intent + target (letter/word/phrase + route params)

Requirements:
- single source of truth
- no page-local re-implementation
- mode-aware (kids/adult) without mixing UIs

--------------------------------------------------
D. SURFACE REVIEW IN UI (KIDS + ADULTS)
--------------------------------------------------

Integrate review suggestions into:
- Continue Arabic Learning (primary)
- Secondary “Review” section (optional)

Kids presentation:
- simple cards like “Review Ba”
- friendly tone

Adult presentation:
- clean chips/cards like “Review recent letters”

Requirements:
- avoid clutter
- one primary CTA + optional secondary
- no duplicate competing sections

--------------------------------------------------
E. LINK REVIEW TO CORRECT DESTINATIONS
--------------------------------------------------

Ensure tapping a review item:
- routes to the correct mode (kids/adult)
- opens the right activity (tracing/reading/helper)
- respects shared canonical ids

No cross-mode leaks.

--------------------------------------------------
F. HANDLE EMPTY / FIRST-TIME STATES
--------------------------------------------------

Cases:
- no progress → show Start Arabic
- everything completed → suggest gentle review or “Continue reading”
- sparse data → default to next-in-sequence

Ensure calm, helpful copy and no dead states.

--------------------------------------------------
G. KEEP SHARED FOUNDATIONS INTEGRITY
--------------------------------------------------

Use:
- canonical letter ids
- shared words/phrases ids
- shared audio where relevant

No duplicated datasets.

--------------------------------------------------
H. LIGHTWEIGHT COPY / UX POLISH
--------------------------------------------------

Check:
- clear CTA wording (Continue / Review)
- consistent labels across Kids and Adults
- no disclosure arrows on cards/containers if that rule is enforced
- subtle visual distinction between resume vs review vs continue

--------------------------------------------------
I. DATA SAFETY
--------------------------------------------------

Preserve:
- all progress
- XP integrity
- routing and lesson state
- shared foundations

No destructive changes. No duplicate reward triggers.

--------------------------------------------------
J. TESTING
--------------------------------------------------

Add/update tests for:
- review service returns correct intent (RESUME/REVIEW/CONTINUE)
- Kids routing targets are correct
- Adult routing targets are correct
- empty/first-time states handled
- no regressions in tracing/reading flows

Run analyzer/tests and report.

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

1. Files changed
2. Audit findings (available signals, gaps)
3. Shared review model summary
4. Review service summary (inputs/outputs)
5. UI integration summary (Kids vs Adults)
6. Routing summary
7. Data safety summary
8. Validation results
9. FINAL AUDIT

--------------------------------------------------
SUCCESS CRITERIA
--------------------------------------------------

- One shared review layer powers both Kids and Adults
- Users see clear, calm suggestions of what to revisit
- Resume/Review/Continue are distinguished simply
- No duplicate or conflicting “continue” sections
- No regressions introduced into existing flows
- Arabic learning feels continuous and supportive

--------------------------------------------------
DO NOT DO IN THIS PHASE
--------------------------------------------------

Do not:
- build a complex spaced-repetition system
- introduce scoring/timers/pressure
- duplicate logic across pages
- break canonical ids or routing
- redesign the entire Learn hub

Stay focused on a gentle, shared review layer.

--------------------------------------------------

“And say, ‘My Lord, increase me in knowledge.’” — Qur’an 20:114

===== END PHASE 38 PROMPT =====
