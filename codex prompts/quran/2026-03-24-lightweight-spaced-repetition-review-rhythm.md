# Phase Prompt — Lightweight Spaced Repetition + Review Rhythm

## Primary Objective
Build a lightweight spaced repetition and review rhythm layer for the existing Qur'an memorization flow in Path of Nūr.

## Product Goal
Help users:
- remember what they memorized
- revisit at the right time
- stay consistent without pressure
- build retention through calm repetition

The system should feel gentle, optional, and integrated into the current memorization + understanding flow.

## Execution Rules
1. Audit current memorization + review flows first.
2. Do not build a complex spaced repetition algorithm.
3. Do not introduce rigid schedules or pressure.
4. Keep everything lightweight and optional.
5. Reuse existing persistence systems.
6. Do not disrupt reader behavior.
7. Keep UX calm and minimal.
8. Run analyzer and tests at the end.
9. Provide a full summary at the end.

## Implementation Scope

### A. Audit current memorization and review system
Inspect:
- memorization marking logic
- review list implementation
- stored metadata for memorized ayahs
- persistence models
- reader entry behavior for memorization

### B. Add lightweight review metadata
Extend memorization data with minimal fields such as:
- last reviewed timestamp
- review count
- optional familiarity/difficulty signal
- optional next suggested review timestamp

### C. Introduce gentle review suggestions
Add simple, predictable groupings such as:
- Review today
- Recently added
- Needs revision

### D. Improve review list UX
Enhance the memorization/review surface with sections like:
- Continue review
- Review today
- Recently memorized
- All memorized

### E. Optional subtle entry point
Only if clearly safe and calm.

### F. Improve reader entry from review
Open directly to the ayah and optionally show simple review context such as:
- last reviewed
- review count

### G. Keep memorization + understanding connected
Meaning, themes, and light study links should remain available.

### H. Optional one-tap reviewed action
Allow fast metadata updates without overcomplication.

### I. Do not overbuild
No flashcards, strict streaks, SM-2, or heavy gamification.

### J. Validation
Run:
- `flutter analyze`
- relevant focused tests
