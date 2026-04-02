# ===== PHASE X PROMPT phase 3 — MAIN QURAN READER EXPLANATION UI INTEGRATION =====

PRIMARY OBJECTIVE === BUILDING MAIN QURAN READER EXPLANATION UI INTEGRATION

You are working in the existing Flutter codebase for Path of Nūr.

Always ensure the system is not going haywire and removing deleting records for no reason.

Instead of only doing a v1 or placeholder let’s always build out everything into a production ready product.

===== QURAN EXPLANATION SOURCE & VALIDATION RULE =====

All Qur’an explanation content MUST follow authentic tafsir methodology.

When generating explanation content:

1. Determine the meaning using:
   - Qur’an (cross-referenced ayahs)
   - authentic tafsir grounding (e.g., Ibn Kathir-level understanding)
   - widely accepted interpretations from mainstream Sunni scholarship

2. Then simplify into Path of Nūr language:
   - simple
   - standard
   - kids

3. STRICT RULES:
   - Do NOT copy tafsir text directly
   - Do NOT invent interpretations
   - Do NOT introduce speculative or modern reinterpretations without grounding
   - If meaning is unclear or disputed, keep explanation general and safe

4. PRIORITY:
   - accuracy over creativity
   - clarity over depth
   - simplicity without distortion

5. If uncertain:
   - fallback to a safe, widely accepted general meaning
   - never guess or over-interpret

===== END =====

At the very end, audit everything and provide one full summary.

TASK TYPE
Production-ready UI integration of the new ayah explanation system into the existing main Qur’an reader.

GOAL
Integrate the new explanation system into the canonical main Qur’an reader so users can:
- keep using the existing reader modes
- enable or disable ayah explanations
- choose explanation detail level
- see explanation content inside the reader without clutter
- experience explanation rendering that adapts to the current reader mode

IMPORTANT PRODUCT DIRECTION
The explanation system must feel like a natural reader layer, not a separate detached feature.

The reader should remain:
- calm
- clean
- premium
- easy to scan
- not overloaded

EXECUTION RULES
1. Audit first before editing.
2. Confirm the canonical main reader ownership before changes.
3. Reuse the explanation repository/provider/settings system.
4. Keep all existing reader features intact.
5. Preserve localization.
6. Do not clutter the ayah cards.
7. Do not create visual competition with playback, memorization, or existing Learn More surfaces.
8. Run analyzer on changed files and summarize results.

AUDIT REQUIREMENTS

A. Identify:
- reader settings location
- ayah card rendering
- Learn More / insights rendering
- best insertion point for explanation UI

B. Decide rendering strategy:
- inline under ayah (preferred)
- or expandable section

IMPLEMENTATION REQUIREMENTS

C. Add explanation controls to settings:
- explanation detail selector
- persisted using existing settings system

D. Add explanation UI:
- compact, calm, secondary to Qur’an text
- consistent with glass/parchment style

E. Mode-aware behavior:

Reading:
- minimal, compact

Reflection:
- explanation + reflection prompt

Study:
- full explanation + key lessons

Memorization:
- hidden or minimized

Theme:
- coexist with theme chips

F. Expansion:
- support “read more” if needed
- keep UX simple

G. Reflection + lessons:
- show appropriately per mode

H. Fallback:
- never show empty UI
- always degrade gracefully

I. Preserve:
- playback
- memorization
- notes
- bookmarks
- insights

J. Localization:
- all new UI strings must be localized

VALIDATION
1. Settings persist
2. Explanation renders correctly
3. Modes behave correctly
4. No regressions
5. Analyzer passes

DELIVERABLES
- audit summary
- files changed
- integration details
- fallback logic
- analyzer results

===== END =====
