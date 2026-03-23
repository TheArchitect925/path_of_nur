# Qur'an Reader Player Audit Backlog

Last updated: 2026-03-22

## Audit-derived enhancement options

1. Move reader-owned playback session UI state into a dedicated player view-model layer so the reader page stops carrying orchestration, scrolling, and sync concerns together.
2. Add true widget/integration playback tests around `QuranReaderPage` itself with a fake player so play, pause, seek, resume, and track transitions are exercised beyond scan tests.
3. Add explicit previous/next ayah controls, or formally document that the product intentionally limits transport controls to seek and tap-to-jump.
4. Add a user-facing auto-scroll/follow-playback toggle because auto-follow exists today but cannot be disabled when someone wants to read independently while listening.
5. Clarify the product boundary between reading, listening, memorization, and study inside the reader so the settings/actions panel feels less overloaded.
6. Tighten localization on the reader settings surface; several visible control labels and helper lines still use hardcoded English.
7. Decide whether looped range playback should remain a manual batch flow or become a first-class repeat mode owned by the controller instead of the page.
8. Add a clearer paused-state visual treatment for the active ayah so the user can tell which ayah is current without implying audio is still playing.
9. Audit offline/audio-download UX for cancellation, partial progress recovery, and reciter-specific storage visibility before expanding download behavior.
10. Consolidate mirrored tvOS/mobile Qur'an playback ownership further so future highlight and transport changes reuse the same controller contract where practical.
