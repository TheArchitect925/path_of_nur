# Qur'an Reader Full-Screen Player Backlog

Date: 2026-03-25

## Completed In This Session

- Added a full-screen player entry point directly inside the surah reader playback controls.
- The reader now opens the existing expanded Qur'an player sheet instead of creating a second player surface.

## Enhancement Options

- If the controls row becomes crowded on smaller phones, move the new full-screen action into a compact overflow menu inside the reader playback card.
- Add a route-level regression test that opens the full-screen sheet from the real surah reader page, not just the shared controls harness.
