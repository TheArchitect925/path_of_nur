# Qur'an Reader Playback Fix Enhancement Backlog

1. Manually verify the EveryAyah reciter source behavior for non-Fatihah `XXX001.mp3` files so `includesBismillahAtSurahStarts` and `surah9HasNoBismillahIntroInSource` can move from inferred policy handling to confirmed source metadata.
2. Add a controller-level playback test around optional Bismillah pre-roll failure so the non-blocking fallback remains protected if the audio layer changes again.
3. Run real-device Qur'an reader QA on iOS for fresh play, mid-surah resume, ayah-tap playback, and Surah At-Tawbah start to confirm the fixed policy matches user-visible recitation expectations.
