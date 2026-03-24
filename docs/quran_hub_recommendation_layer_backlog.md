# Qur'an Hub Recommendation Layer Backlog

## Enhancement options

1. Add one lightweight recent-theme recommendation when a user leaves a Qur'an topic detail page, but only if it does not displace stronger daily/path/review signals.
2. Consider a tiny dismiss-for-today state for fallback recommendations if QA shows repeat visits feel too static.
3. Evaluate whether the main `/quran` hub should later surface a small “why this is recommended” info affordance, or keep the current inline reason-only presentation.
4. Expand stable fallback theme rotation beyond `gratitude` only if a second or third curated fallback topic is clearly higher quality than a single steady default.
5. Consider one Learn-side mirrored recommendation preview only after the `/quran` hub section proves useful without adding noise.

## Deferred checks

1. Run on-device QA for small screens, large text, and VoiceOver/TalkBack on the new recommendation section.
2. Review whether recommendation rows need stronger tap-target contrast in kids mode, even though the owner remains the adult/main Qur'an hub.
3. Decide whether recent surah continuation should later prefer explicit last-opened ayah context from richer reader telemetry instead of the current continue summary.
