# Qur'an Search Type Selector Follow-Ups

Date: 2026-04-10

Potential next enhancements after the Phase 11 selector pass:

1. Remember the user’s preferred `/quran/search` mode locally so frequent searchers can reopen into `Text`, `Theme`, or `Surah` without changing the canonical default of `All`.
2. Add small result-source helper copy in `All` mode, especially if future product QA shows users need clearer distinction between theme results and topic/knowledge results.
3. Consider whether saved searches on `/quran/search` should later preserve search type in addition to query and text field filter, while keeping reader-search recents uncluttered.
4. If topic-mode usage grows, extract the current topic-result builder into a shared provider so `/quran/search` and `/quran/knowledge-search` can share more ranking logic without merging routes.
5. Evaluate whether a lightweight selector variant belongs in the reader’s whole-Qur’an search sheet later, but only if it can stay bounded and avoid reintroducing the earlier sheet lifecycle issues.
