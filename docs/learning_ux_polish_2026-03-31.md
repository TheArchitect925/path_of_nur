# Learning UX Polish — 2026-03-31

## Summary

This pass improves the feel of the Learn experience without changing route ownership, canonical domain boundaries, or the underlying guided-path architecture.

The focus was:

- clearer next-step guidance
- calmer visible progress
- more responsive completion feedback
- a more organized Explore surface
- stronger Kids discoverability on the main Learn landing

## Progression Clarity

### Continue Your Journey

The guided-path continue card on `/learn` now shows:

- the active path name
- the current step label
- the current step title and subtitle
- a lightweight progress bar
- explicit numeric progress

This makes the primary resume action clearer without adding dashboard noise.

### Path Overview

The guided path detail screen now shows:

- a top progress bar
- completion percentage and step count
- a highlighted current step summary
- stronger visual emphasis for the active next step
- dimmed completed steps

## Path UX Improvements

- Path cards on `/learn` now show visible progress bars.
- Active paths receive subtle emphasis through scale, border, and shadow.
- Each path card now surfaces the next step title when the path is still in progress.
- The guided path detail page now gives a clearer `Start Path` / `Continue` / `Mark step complete` flow.

## Completion State Behavior

### Step Completion

- Marking a step complete now shows immediate lightweight confirmation.
- When completion unlocks another step from the path summary area, the user sees the next step title and can open it directly from the snackbar.

### Path Completion

- Completing the final step now shows a calm completion message rather than leaving the user at a dead end.
- Existing reward logic remains intact and was not expanded into a louder gamification layer.

## Explore Improvements

The `/learn` secondary Explore surface now has clearer grouping:

- Quick access
- Support and saved spaces
- Search results

This reduces the “dumping ground” feeling while preserving the same underlying destinations and search behavior.

## Kids Discoverability

The Kids discovery card on the main Learn landing now has:

- a clearer featured label
- a warmer helper line for parents and families
- retained direct entry points to Kids Qur'an, Kids Games, and Kids Stories

Kids remains discoverable without fragmenting the simplified main island model.

## Visual Hierarchy And Spacing

- Added lightweight progress bars instead of heavier dashboard widgets.
- Increased clarity between section headers and supporting cards.
- Improved step-state hierarchy through opacity, border emphasis, and quiet accent color usage.
- Kept card density restrained to preserve breathing room.

## Localization Impact

New landing/path UX keys were added for:

- current-step labeling
- step-count progress text
- completion and next-step snackbar messaging
- Explore grouping headers
- Kids featured helper copy

All new user-facing strings were routed through the existing localization system.

## Performance Notes

- Animations remain lightweight and implicit (`AnimatedContainer`, `AnimatedOpacity`, `AnimatedScale`).
- No new heavy state loops or nested async builders were introduced.
- Progress indicators are derived from existing provider state.
- Search/index behavior was preserved instead of rebuilt.

## Risks

- Some non-English locales still use English fallback values for the new Phase 5 strings.
- Completion remains intentionally pragmatic in V1 and still relies on explicit marking in places where automatic completion would be brittle.

## Follow-Up Ideas

- add gentle auto-scroll to the current step after marking completion
- add richer path completion surfaces with reflection prompts
- improve Explore with richer grouped destination summaries
- add optional “resume last opened step” hints for non-guided learning flows
