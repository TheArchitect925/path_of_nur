# Quran Summary Phase 5 Enhancement Backlog

Date: 2026-03-31
Area: Qur'an thematic discovery / browse by topic

## Recommended Next Enhancements

- Add localized editorial copy for the new theme registry in priority languages instead of English fallback in all locale files.
- Expand the normalized theme registry with a few carefully reviewed secondary themes such as trust in Allah, sincerity, remembrance, and self-purification.
- Add a small “related themes” recommendation strip on Surah Summary Detail so theme exploration works in both directions.
- Deep-link notable ayah references from theme detail into a lightweight ayah context viewer before the reader when users want extra framing.
- Add curated featured-theme rotation logic so the topic landing page can highlight a changing set of themes without changing the registry structure.
- Surface theme discovery in shared Qur'an search suggestions more prominently for queries like “Musa”, “patience”, or “mercy”.
- Add optional Arabic helper labels for selected flagship themes where it improves readability without clutter.
- Introduce widget tests for the theme landing and theme detail states, especially no-results and missing-theme edge cases.
- Run a focused tvOS parity review for mirrored Qur'an hub surfacing if the Qur'an landing experience is being aligned across platforms.
- Prepare a scholar-review pass for theme overview text and theme-to-surah mappings before expanding the taxonomy further.

## Notes

- This phase intentionally reused the existing canonical `/quran/topics` route family instead of creating a second topic-discovery route stack.
- The current theme registry is curated and intentionally limited to avoid noisy tag sprawl.
- Search/indexing now benefits from the new resolved theme aliases, related prophets/events, and related surah names without adding a parallel search system.
