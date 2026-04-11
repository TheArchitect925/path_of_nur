# Dua Phase 1.5 Taxonomy Enhancements

Date: 2026-04-10

Potential next enhancements after the Phase 1.5 migration:

1. Add a dedicated dua taxonomy browse mode that exposes `primaryCategory` and `secondaryCategories` directly instead of relying only on the legacy hub buckets.
2. Add localized labels/descriptions for primary and secondary taxonomy terms if they start surfacing in visible chips or sections.
3. Add a repository helper for "discover by category" that unions primary and secondary matches and powers future widgets/orchestration cleanly.
4. Review morning/evening items one by one and split mixed `morning_evening` ownership more precisely where the source context is clearly one-sided.
5. Add focused taxonomy QA for edge cases like `guidance`, `akhirah`, `gratitude`, and `faith`, where the current mapping is intentionally conservative.
6. Introduce small dataset-level tests for taxonomy completeness:
   - every item has non-empty `primaryCategory`
   - no duplicate secondary categories
   - no secondary category duplicates the primary category
7. Revisit the legacy top-level category labels later so the visible dua hub can evolve away from the old seven-bucket structure without breaking search/history continuity.
