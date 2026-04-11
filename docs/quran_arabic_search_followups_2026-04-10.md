# Quran Arabic Search Follow-ups

Date: 2026-04-10
Task: Phase 5 Arabic search hardening

## Recommended next enhancement options

- Add light-touch result-match hints in the existing Qur'an search cards so we can indicate Arabic, translation, or transliteration matches without redesigning the surface.
- Add a small search filter row on `/quran/search` for `All`, `Translation`, `Arabic`, and `Transliteration` once product QA confirms that mixed-field results need faster narrowing.
- Add optional in-result Arabic phrase highlighting if it can reuse the current card layout without introducing noisy styling.
- Evaluate a tiny stopword-aware ranking adjustment for very broad Arabic tokens such as `الله` so shorter exact-field hits can surface a bit more predictably.
- Explore a safe V2 morphology/root backlog only if we can keep it clearly separate from the current deterministic literal-field search.

## Guardrails for future work

- Keep `QuranRepository.search(...)` as the only canonical Qur'an field search owner.
- Keep `/quran/search` as the canonical full Qur'an text-search surface.
- Keep `/quran/knowledge-search` separate from field search.
- Do not block reader startup on any search index or Arabic-processing work.
- Do not overload transliteration heuristics to simulate Arabic morphology.
