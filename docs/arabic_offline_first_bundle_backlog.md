# Arabic Offline-First Bundle Backlog

1. Decide whether the strongest shared Arabic letter assets should ship as a guaranteed bundled starter pack, since the current manifest still points to many `quran_teacher` audio files that are not checked into this repo snapshot.
2. Add one focused widget test for the adult Arabic landing page so future offline warmup changes cannot silently break section startup.
3. Consider exposing a small internal debug summary of bundled Arabic audio availability to make future asset-pack QA faster without surfacing technical details to learners.
4. Run on-device airplane-mode QA for Kids Arabic home, adult Qur'anic Arabic, beginner words, mini phrases, and Qur’an Readiness to confirm first-play behavior and fallback timing on real hardware.
5. Decide whether shared Arabic offline warmup should later include one tiny persisted “already warmed this launch” guard if real-device profiling shows repeated landing-page prewarm work is measurable.
