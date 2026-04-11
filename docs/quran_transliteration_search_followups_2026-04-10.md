# Quran Transliteration Search Follow-ups

Date: 2026-04-10

## Saved enhancement options

- Add a small build-time generation script so future transliteration dataset refreshes can be reproduced intentionally instead of editing the generated local data file by hand.
- Consider exposing a lightweight search-result subtitle hint when a hit was driven primarily by transliteration rather than translation, if product ever wants clearer search explainability.
- For future Arabic search, add a dedicated Arabic field scorer with token-aware ranking instead of trying to reuse the transliteration heuristics.
- If the repo later adopts a prebuilt search artifact, bundle transliteration-normalized compact forms into that same artifact so canonical ranking remains unified.
