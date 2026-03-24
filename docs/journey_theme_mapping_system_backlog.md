# Journey ↔ Theme Mapping System Backlog

## Enhancement options

1. Expand the curated mapping set into a second wave only where Journey lesson content already carries explicit Qur'anic anchors, especially `duas-daily-life`, `seerah-madinah-society`, and selected `journey-quran` stages.
2. Add lightweight path suggestions on theme detail pages when a mapped Journey stage has a clearly matching Qur'an learning path, starting with gratitude and patience.
3. Decide whether the reader detail sheet should name the exact Journey angle for mapped links, such as patience, gratitude, or Hijrah, instead of the current generic Journey explanation.
4. Add one small widget test for `/quran/topics/:topicId` so related Journey tiles remain visible and route-safe if the theme detail layout changes later.
5. Revisit whether `character-ikhlas` should gain a Qur'anic theme mapping only after a dedicated sincerity theme exists in the curated Qur'an thematic map.

## Deferred notes

- This pass intentionally avoided broad lesson-stage auto-mapping and kept the bridge limited to explicit, high-signal Journey themes.
- No new search/index owner was added; if Journey ↔ Theme discovery later needs search support, the new mapping model is simple enough to expose through shared indexing without redesigning the route structure.
