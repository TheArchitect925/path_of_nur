# Qur'an Reader Follow-Mode Backlog

Date: 2026-03-24

Enhancement options from the follow-mode and route-harness pass:

- Extract the remaining reader scroll/follow presentation details out of [quran_reader_page.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/presentation/quran_reader_page.dart) so the route no longer owns the final scroll execution guard logic.
- Add a real route-level harness step that taps the visible follow toggle itself, not only the suspended-state recovery action, once that control has a stable UI seam.
- Add one device-focused QA pass for long surahs, large text, and reduced-motion settings so the new follow suspension/recovery behavior stays calm on slower layouts.
- Review watch/tvOS Qur'an playback consumers against the shared playback, word-highlight, and follow-mode contracts before mirrored reader work expands on those platforms.
- Consider a lightweight non-intrusive “following current ayah” indicator only if on-device QA shows users do not understand why auto-scroll resumed after tapping an ayah.
