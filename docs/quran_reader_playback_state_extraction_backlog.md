# Qur'an Reader Playback State Extraction Backlog

Date: 2026-03-24

## Enhancement Options

- Move the now-playing label construction out of [quran_reader_playback_controller.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/application/quran_reader_playback_controller.dart) and into a localized presentation mapper so the shared controller stops owning any user-facing copy.
- Extract word-timing lifecycle coordination from [quran_reader_page.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/presentation/quran_reader_page.dart) into a dedicated reader word-sync coordinator that consumes the normalized playback state.
- Add a dedicated `QuranReaderPlaybackState` widget harness around the real [quran_reader_page.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/presentation/quran_reader_page.dart) with a fake player backend, not only the lightweight card/ayah harness added in this pass.
- Add focused reciter-switch regression tests around [quran_player_controller.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/application/quran_player_controller.dart) for paused-state preservation, failed source preparation, and session persistence.
- Introduce a shared controller-owned transport capability model for next/previous surah and repeat readiness so the reader UI can stop calculating transport affordances locally.
- Audit the watch/tvOS Qur'an playback consumers against [quran_reader_playback_state.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/application/quran_reader_playback_state.dart) and the new controller contract before mirrored playback work continues.
