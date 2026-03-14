Qur'an Teacher Asset Pipeline

Folders expected by the teaching feature:

- `assets/audio/quran_teacher/letters/`
- `assets/audio/quran_teacher/letter_shapes/`
- `assets/audio/quran_teacher/harakat/`
- `assets/audio/quran_teacher/long_vowels/`
- `assets/audio/quran_teacher/words/`
- `assets/audio/quran_teacher/phrases/`
- `assets/audio/quran_teacher/rules/`
- `assets/audio/quran_teacher/tajweed/`
- `assets/audio/quran_teacher/listen_only/`
- `assets/audio/quran_teacher/surahs/`
- `assets/images/quran_teacher/visual_mode/letters/`
- `assets/images/quran_teacher/visual_mode/words/`
- `assets/images/quran_teacher/visual_mode/phrases/`
- `assets/images/quran_teacher/placeholders/`

Recommended naming:

- letters: `alif.mp3`, `ba.mp3`, `taa_heavy.mp3`
- harakat: `ba_fatha.mp3`, `ta_kasra.mp3`
- words: `rabb.mp3`, `rahmah.mp3`, `maa.mp3`
- phrases: `bismillah.mp3`, `alhamdulillah.mp3`
- surahs: `surah_001_ayah_001.mp3`
- visuals: `alif_apple.png`, `ba_ball.png`, `maa_water.png`

When adding a real asset:

1. Drop the file into the matching folder.
2. Keep the filename stable and file-safe.
3. If needed, add or update the manifest entry in:
   - `lib/features/learn/quran_teaching/data/quran_teacher_audio_manifest.dart`
   - `lib/features/learn/quran_teaching/data/quran_teacher_visual_manifest.dart`
   - `lib/features/learn/quran_teaching/data/quran_teacher_listen_only_manifest.dart`
4. If a lesson item already has a direct asset path, keep that path aligned with the file.

Missing files are handled gracefully by the teaching UI and fall back to disabled audio controls or icon placeholders.
