# Qur'an Mini Player Simplification Backlog

Date: 2026-03-26

## Recommended Enhancements

- Add a subtle collapsed-to-expanded motion polish pass so the shell dock and fullscreen sheet feel more connected without increasing visual weight.
- Evaluate whether the compact single-line label should auto-hide when playback is idle-but-resumable, keeping only progress and controls for an even lighter dock.
- Consider adding a tiny buffered-progress track if the canonical runtime exposes stable buffered state without extra provider churn.
- Audit couch-distance readability for the compact label on smaller devices to confirm it still earns its space.
- Revisit the shell dock width on extra-small phones so the progress bar remains visually useful above the bottom navigation.
- Add one focused golden or screenshot test for the compact dock if the team wants visual regression protection beyond current widget behavior coverage.

## Notes

- This pass intentionally kept advanced transport and richer playback detail in the fullscreen player surfaces.
- No playback-runtime ownership, persistence keys, source resolution, reciter logic, or follow-mode runtime behavior was changed.
