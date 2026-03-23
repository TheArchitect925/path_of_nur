# Navigation Fix Planning Backlog

Date: 2026-03-22

Purpose:
- Hold enhancement options that came out of the controlled navigation fix-planning pass.
- This is not the implementation plan. It is a follow-on idea list for review.

Enhancement options:
- Add a compact route-truth doc that separates canonical routes, compatibility aliases, and temporary aliases in one table.
- Add widget or integration tests for all top-level hub cards so label-to-destination regressions are caught automatically.
- Add a route-name lint or CI check for undefined `pushNamed` / `goNamed` usages so missing-route bugs like `quranReflections` cannot ship.
- Add deep-link coverage tests for `pathofnur://prayer`, `pathofnur://dhikr`, `pathofnur://garden`, and key Qur'an flows.
- Add a small navigation telemetry layer to measure which legacy aliases are still used before trimming them.
- Add a canonical kids-home decision doc before any child-flow cleanup so kids routing is approved once and reused everywhere.
- Add a Journey terminal-page review so Garden, Stats, and other progression surfaces all have consistent onward actions.
- Add a Learn front-door approval note that explicitly selects one canonical entry between landing, journey hub, and legacy surfaces.
- Add a dedicated Kids Fun Learning explorer route if product later wants that broad subcategory to become a first-class kids hub instead of a scoped filtered Learn page.
- Add a small regression suite for Learn subcategory wrappers so routes like `/learn/kids/games`, `/learn/kids/arabic-learning`, and `/learn/kids/fun-learning` cannot silently drift back to generic parent scaffolds.
- Add broader Kids Learning island coverage so newer entries like Prophet Stories and future kids-specific hubs cannot silently fall back to the generic mixed story library or the parent Kids Learning scaffold.
- Add a focused follow-up pass for non-island system rows so intentional settings-style disclosures stay documented while remaining card-like rows continue moving toward the no-arrow rule.
- Add a shared card-entry test suite that covers Learn, Qur'an, and Growth destination cards so disclosure icons cannot be reintroduced silently in new hub surfaces.
- Audit remaining secondary discovery pages like Life, World, Hadith, and Baby Names for older `ListTile` chevrons once product confirms those rows should follow the same container-first design rule.
