# Quran Playback Enhancement Backlog

1. Move the remaining reader-owned playback execution steps behind a fuller `QuranPlayerController` so the page stops touching `AudioPlayer` for start flows at all.
2. Add widget/integration coverage for route autoplay, resume card playback, and global shell resume after pause.
3. Audit tvOS Qur'an playback entry points and route them through the same Bismillah-first policy if tvOS remains on the shared mobile playback model.
4. Decide whether loop-mode should become a true range playlist instead of the current per-ayah restart behavior.
5. Localize the remaining hardcoded reader settings copy around audio, sources, and live sync beta labels.
6. If product later needs a non-default Bismillah policy, expose the new canonical `alwaysPrependBismillah` setting through one owned config surface instead of reintroducing per-screen mode toggles.
