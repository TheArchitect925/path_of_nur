# Reader Search Exact-Query Highlighting Hotfix

Observed issue:
- when searching `father`, the reader highlighted many unrelated words instead of only the searched term
- the reader also visually treated Arabic and transliteration like active matches even when the search originated from translation

Required fix:
1. Reader highlighting must be exact-query-driven
2. Use matched-field context
3. Keep display vs highlight separate
4. Keep highlighting deterministic
5. Validate with `father` on `2:233`

Implementation intent:
- do not use broad ranking/support tokens for reader highlighting
- highlight only the actual user query terms/phrase for the active matched field
- if the result matched `translation`, highlight only translation by default
- if the result matched `transliteration`, highlight only transliteration by default
- if the result matched `arabic`, highlight only Arabic by default
