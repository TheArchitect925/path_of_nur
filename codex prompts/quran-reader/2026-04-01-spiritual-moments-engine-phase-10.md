# Phase 10 — Spiritual Moments Engine (Time-Based Ayah Surfacing, Prayer-Context Recommendations, Friday / Ramadan / Night Reflections)

PRIMARY OBJECTIVE === BUILDING SPIRITUAL MOMENTS ENGINE FOR PATH OF NUR

GOAL
- Build a calm, respectful, time-aware system that helps Path of Nūr surface the right spiritual content at the right moment.
- Reuse the existing ayah explanation, action, recommendation, prayer, Ocean Drops, and journey systems.
- Keep everything deterministic, local-first, privacy-respecting, and non-intrusive.

KEY MOMENT TYPES
- Fajr / morning
- Sunrise reflection
- Dhuhr pause
- Asr reset
- Maghrib gratitude
- Isha wind-down
- Sleep reflection
- Post-prayer
- Friday
- Ramadan
- Tahajjud / quiet night
- Kids daily moment

IMPLEMENTATION REQUIREMENTS
- Add domain models for spiritual moments, context, recommendation, and bundles.
- Build a transparent moment-selection engine that uses time, prayer context, day context, freshness/cooldown logic, and kids/adult mode.
- Add calm UI surfaces on Home, Qur'an front door, prayer surface, reader, and kids-safe flow where appropriate.
- Add localized reason labels such as morning, post-prayer, Friday, Ramadan, and night reflections.
- Preserve explanation/action/Ocean systems without turning the feature into spammy notifications or a rewards funnel.

VALIDATION
- Confirm time/prayer/day selection works.
- Confirm Home/prayer/Qur'an surfaces render without clutter.
- Confirm Friday-aware behavior works.
- Confirm Ramadan-aware hooks are safely integrated or future-ready.
- Confirm kids moments remain child-safe.
- Confirm cooldown/freshness logic works.
- Confirm analyzer passes.
