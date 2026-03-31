# Localization Phase 7 Enhancement Backlog

Date: 2026-03-31

## High-value next improvements

- Continue the FAQ localization pass into seeded dataset labels and category metadata so category titles, subtitles, and difficulty-adjacent copy do not rely on English-first seed values.
- Review whether FAQ related-topic chips should later map through shared glossary or learn-taxonomy metadata for stronger multilingual consistency and discoverability.
- Continue the Dua locale cleanup across the remaining non-English locales, especially any same-as-English helper keys that are still safe to translate without touching seeded supplication content.
- Add a lightweight regression check for FAQ hardcoded strings so future empty states, badges, and filter labels stay inside the generated ARB flow.
- Run manual RTL and large-text QA on FAQ search results, category chips, and detail badges after the later localization phases land.
