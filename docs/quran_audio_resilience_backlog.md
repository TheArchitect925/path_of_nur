# Qur'an Audio Resilience Backlog

1. Add a route-backed retry harness that exercises a real source failure, visible retry action, and successful recovery on the reader route.
2. Run real-device QA for corrupt local files, airplane-mode streaming failure, buffering timeout, and mid-play reciter switching on signed iOS and Android builds.
3. Decide whether to expose a user-facing downloaded-vs-streaming preference once the current fallback behavior is validated on device.
4. Cache recent bad-source outcomes per ayah/reciter so adjacent ayah and adjacent surah transport do not keep retrying the same known-bad source path in a tight loop.
5. Review watch and tvOS Qur'an playback consumers against the new source, failure, buffering, and retry contract so mirrored playback surfaces do not assume playback is only idle, paused, or playing.
