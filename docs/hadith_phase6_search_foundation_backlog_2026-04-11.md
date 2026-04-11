# Hadith Phase 6 Search Foundation Backlog

## Enhancement Options

1. Add recent searches and lightweight saved-search memory for Hadith search, reusing the calmer persistence patterns already used on the Qur’an side without creating a second search owner.
2. Add source-book and category quick-pick chips above the Hadith search results list so users can enter high-signal searches even before typing.
3. Add optional grade filtering as a visible secondary control only if product QA confirms it helps users more than it adds surface complexity.
4. Add a dedicated result-section grouping mode for `Source`, `Category`, and `Text` matches if QA shows the current single result stream feels too flat.
5. Add a tiny “open in reader” continuity handoff from future Hadith search results back into saved-reader state once in-reader search or reading history becomes a priority.
6. Add a relation-aware future “All” mode that can surface connected Qur’an, Dua, and Learn content from the canonical editorial relation layer without merging that logic into the core Hadith result engine.
7. Add stronger Arabic normalization QA cases and benchmark transliteration matching on the current verified Hadith set before broadening search marketing claims.
8. Add a small validator test that checks every canonical Hadith search result still routes through `hadithLessonDetail` and never resolves non-public entries after future dataset changes.
