# Quran Audio Player Rebuild Backlog

Date: 2026-03-24

## Recommended Phases

### Phase 3: Foundation Playback Engine
- restore the feature flag only after the controller path is verified
- keep `quran_player_controller.dart` as the single engine owner
- verify load, play, pause, seek, completion, disposal, and resume
- preserve stored reciter, session, and audio settings keys

### Phase 4: Player State Controller and Minimal Reader Surface
- reconnect `quran_reader_playback_controller.dart` as the canonical UI state
- restore minimal reader playback UI
- keep the page thin and move any remaining transport logic out of `quran_reader_page.dart`
- validate buffering, failure, and ended states

### Phase 5: Reciter System and Source Resolution
- restore reciter switch UX
- reuse `quran_audio_repository.dart`
- reuse source fallback and resilience models
- verify local-download vs remote-stream behavior

### Phase 6: Surah Playback UI and Transport
- restore previous/next behavior
- restore progress bar and timing labels
- validate adjacent-surah behavior and restart logic
- keep the design calm and non-music-player-like

### Phase 7: Ayah Sync and Reader Coordination
- reconnect ayah-aware playback hooks
- preserve word-highlight and follow-mode coordinators
- keep sync ownership out of the page layer
- verify active ayah identity and scroll coordination

### Phase 8: Downloads and Continue Listening
- restore download/remove-download UI
- restore continue-recitation and continue-listening entry points
- restore shell mini-player only after shared state is stable

### Phase 9: Platform Integration
- re-verify `just_audio_background`
- reattach lock-screen/notification semantics if still desired
- review watch companion contract
- review iOS live-activity integration

### Phase 10: Cleanup and Archive
- archive and remove obsolete page-local playback logic
- remove stale hidden branches
- keep one canonical playback path only
- refresh tests, docs, and continuity notes

## Enhancement Options

- Keep refining ayah timing thresholds per reciter family where precise metadata still feels slightly early or late.
- Add richer resume controls such as “resume from ayah” vs “resume from surah” in the shell and Qur'an hub, not only inside the reader.
- Add per-reciter preload tuning once real-device profiling shows which reciters still transition more slowly than others.
- Add explicit per-surah offline health diagnostics for corrupt/incomplete downloads.
- Add deeper lock-screen and car/Bluetooth transport verification once the mobile timing layer is stable.
- Add a watch-specific availability phase only after the mobile player is stable again.
