# Hadith Search Polish Backlog

Date: 2026-04-11

## Best next enhancements

- Add optional subcategory suggestion chips when the query is empty, using the existing canonical taxonomy rather than new ad hoc strings.
- Add a tiny persisted “last used filter” preference if product QA says it helps repeated source/category search sessions.
- Consider source-aware result grouping that can collapse very large `Riyad as-Salihin` result sets without changing the canonical search owner.
- Add richer source/reference highlighting inside metadata chips only if it stays calm and does not make cards noisy.
- Add recent-search removal tests for the clear-all action in addition to the rerun path now covered.
- When cross-domain search is introduced later, keep Hadith recents local and layer “All” recents separately rather than merging behaviors.

## Notes

- This phase intentionally did not change search ownership, result routing, or trust gating.
- Search still resolves only through the canonical public verified Hadith subset.
