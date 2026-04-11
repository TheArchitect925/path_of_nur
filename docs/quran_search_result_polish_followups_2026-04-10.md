# Quran Search Result Polish Follow-ups

Date: 2026-04-10
Task: Phase 6 result polish

## Recommended next enhancement options

- Add optional match-field chips on compact Qur'an preview sections only when QA confirms they help more than they clutter.
- Add in-card snippet highlighting for the result title when the matched field is `surah` and the query is a surah-number search.
- Consider a tiny `/quran/search` route-state sync for filter changes so copied links preserve the active field filter after the user changes it on-page.
- Evaluate whether the full search surface should later expose a small `matched in` sort preference or keep the current unified relevance ordering.
- If future morphology/root-search work is approved, keep it as a clearly separate field/filter mode rather than altering the current deterministic literal-field result expectations.

## Guardrails

- Keep `QuranRepository.search(...)` as the only canonical search owner.
- Keep the current result metadata additive rather than creating a second search-result model.
- Keep `/quran/search` as the only rich filter surface.
- Keep Home, Qur'an hub, and Read Qur'an compact results lightweight.
- Keep `/quran/knowledge-search` separate.
