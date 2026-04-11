# Hadith Nawawi + Riyad Expansion Backlog

Date: 2026-04-11

## High-signal next enhancements

- Add a curated grade-resolution review pass for the excluded `40 Nawawi` and `Riyad as-Salihin` records that currently fail `missing_grade` or `unverified_source`, using trusted source-page citations only.
- Do a second-pass recovery sweep over the remaining `155` excluded records, but only for entries where an explicit source-page grade or trustworthy source-citation cue can be confirmed beyond the current importer heuristics.
- Prioritize manual verification for the remaining excluded `40 Hadith an-Nawawi` entries first, since that set is small and high-value for the public corpus.
- Split `Riyad as-Salihin` chapter metadata into a cleaner canonical book/chapter editorial layer so future source-book browse feels intentional rather than scraper-shaped.
- Add a pipeline-side duplicate-review report that groups by canonical source reference plus normalized translation to make intentional reuses easier to confirm.
- Add a small maintained source-alias registry for citation variants like `At-Tirmidhi`, `Tirmidhi`, `Abu Dawud`, and `Imam Malik` so future imports normalize more consistently.
- Add CI coverage for the collection import + build + inventory chain so corpus regressions fail before merge.
- Enrich the new collections with carefully reviewed Qur'an links only where there is a strong explicit thematic basis already grounded in the app’s canonical relation model.
- Expand the same pipeline next with another trusted subset rather than a broad corpus dump; strongest candidates are `Riyad` completion hardening, then `Bulugh al-Maram`, then a carefully reviewed `Musnad Ahmad` subset.

## Notes

- This phase intentionally kept trust rules tight, so many imported entries remain staged in raw/editorial inputs without entering the public runtime corpus yet.
- Runtime Hadith ownership remains unchanged: only verified entries from the generated canonical dataset reach the app.
