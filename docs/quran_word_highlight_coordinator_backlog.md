# Qur'an Reader Word-Highlight Coordinator Backlog

## Enhancements

- Extract the remaining follow-mode and auto-scroll reactions from [quran_reader_page.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/presentation/quran_reader_page.dart) into a dedicated reader-page coordination layer so the page becomes more purely presentational.
- Add one explicit degraded-state widget test proving that ayah-level highlight remains visually strong when word timing is unavailable for the active reciter/ayah.
- Add one fuller route-harness case that taps a real ayah play control once a stable finder/test key contract exists for the visible ayah cards without relying on brittle widget-tree assumptions.
- Review watch/tvOS Qur'an playback consumers against [quran_reader_playback_controller.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/application/quran_reader_playback_controller.dart) and [quran_word_highlight_coordinator.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/application/quran_word_highlight_coordinator.dart) so mirrored playback surfaces do not reintroduce page-owned active-ayah or active-word drift.
- Decide whether word-highlight timing readiness should surface a small non-intrusive reader hint for QA/debug builds only, or remain fully silent in production when timing data is missing.
