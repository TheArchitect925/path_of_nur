# Quran Audio Source + Bismillah Backlog

1. Manually verify EveryAyah surah-start files for each supported reciter, especially `001001`, `002001`, and `009001`.
2. Decide whether product should continue reusing Fatihah `1:1` as the canonical Bismillah pre-roll source or ship a true dedicated Bismillah clip.
3. Extend source metadata so `sourceAware` mode can safely distinguish:
   - Fatihah in-sequence Bismillah
   - non-Fatihah surah-start embedded Bismillah
   - Surah 9 no-Bismillah behavior
4. Port the canonical Bismillah-first orchestrator pattern to tvOS if tvOS remains an active Qur'an playback surface.
5. Decide whether reciter sample preview should stay outside the canonical recitation pipeline or move behind a dedicated preview adapter.
6. Add integration tests for route autoplay, bookmark-to-reader continuation, and global resume after app restart once the recitation-session restore story is finalized.
