# Quran Audio Function Disable Backlog

Date: 2026-03-24

## Enhancement options

- Add a temporary internal-only restore flag so the new rebuilt Qur'an audio stack can be reintroduced behind one shared gate instead of re-patching surfaces individually.
- Remove the now-unused Qur'an playback runtime files and tests in a dedicated cleanup/archive pass once the replacement architecture is ready.
- Add a concise non-audio reader status note in the Qur'an hub if product wants to acknowledge that listening is temporarily unavailable.
- Review watch-companion Qur'an audio contract files before the rebuild so the replacement playback stack does not inherit stale assumptions.
