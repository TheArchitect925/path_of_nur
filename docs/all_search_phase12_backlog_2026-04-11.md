# Phase 12 All Search Follow-Up

Date: 2026-04-11

## Recommended next enhancements

1. Add tiny per-domain result counts or “more results” summaries inside `/search` if product QA says the current grouped sections need a little more orientation.
2. Extend the current light relation preview support beyond Qur’an results so the strongest Hadith and Dua hits can show one calm related chip without turning the page into a recommendation wall.
3. Consider one shared “open domain search” action row near the empty state so users can jump directly into Qur’an, Hadith, Dua, or Learn search from `/search` when they want deeper filtering.
4. Replace the new non-English English-fallback All Search strings with real translations during the next localization pass.
5. Add widget coverage for “View all in <domain>” handoffs once product confirms the current routing copy and grouping labels are final.

## Guardrails to keep

- Keep federated search thin. It should continue calling domain-owned search/index providers rather than absorbing domain logic.
- Keep Hadith results on the verified public subset only.
- Keep grouped domain sections visible so trust and content type remain obvious.
- Keep relation-aware augmentation lightweight and deterministic.
