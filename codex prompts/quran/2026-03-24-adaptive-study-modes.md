# Phase Prompt — Adaptive Study Modes

## Primary Objective
Build lightweight adaptive study modes for the existing Qur'an reader in Path of Nūr.

## Product Goal
Let the shared reader adapt to user intent without rebuilding it:
- Reading mode
- Reflection mode
- Study mode
- Memorization mode
- Theme-focused mode

The reader should stay calm, preserve playback/notes/bookmarks/enrichment/memorization, and adapt emphasis rather than architecture.

## Execution Rules
1. Audit first before editing.
2. Do not create separate duplicate reader pages for each mode.
3. Prefer one shared reader with light mode-aware behavior.
4. Do not overload users with too many controls.
5. Keep reading first, then enrich according to mode.
6. Reuse existing enrichment, memorization, and contextual entry systems.
7. Preserve localization readiness.
8. Run analyzer and relevant tests at the end.
9. Provide a full audit summary at the end.

## Implementation Scope

### A. Audit current reader behavior first
Inspect:
- `quran_reader_page.dart`
- reader entry points and route parameters
- enrichment presentation
- memorization/review entry behavior
- Journey/contextual entry behavior
- any settings or user preference structures that may already support display mode differences

Determine:
- what already changes based on entry context
- what parts of the reader are currently static
- what can safely become mode-aware without architectural churn

### B. Define a lightweight study mode model
Support a small mode model such as:
- `reading`
- `reflection`
- `study`
- `memorization`
- `theme`

This model should stay lightweight and safe to pass via route parameters or entry-state.

### C. Add clean mode entry patterns
Support safe entry patterns such as:
- existing reader route + query/state parameters
- Journey opens in `theme` mode
- Memorization review opens in `memorization` mode
- Standard open uses `reading` mode
- Surah study opens in `study` mode

### D. Make the reader mode-aware
Adjust emphasis, not capabilities:
- Reading mode: calmer defaults
- Reflection mode: meaning/reflection cues more visible
- Study mode: Learn More and surah insights more prominent
- Memorization mode: reduced clutter, repetition prioritized
- Theme mode: relevant theme emphasized

### E. Add one safe way for users to switch modes
Add a lightweight user control such as a small selector/menu.

### F. Respect current features across modes
Playback, notes, bookmarks, memorization, surah insights, references, and Journey contextual entry must remain intact.

### G. Improve contextual messaging
Use subtle cues such as:
- Reading mode
- Study mode
- Memorization mode
- Theme: Patience

### H. Optional lightweight persistence
Only if safe and useful.

### I. Add focused tests and validation
Run:
- `flutter analyze`
- relevant focused tests

## Validation
After implementation:
1. reader still works correctly
2. each mode feels meaningfully distinct
3. reading mode stays calm
4. study mode surfaces learning better
5. memorization mode supports review cleanly
6. theme mode supports contextual learning
7. mode switching/entry is clear and stable
8. no routing or playback regressions are introduced
9. `flutter analyze` passes
10. relevant tests pass
11. localization remains valid
