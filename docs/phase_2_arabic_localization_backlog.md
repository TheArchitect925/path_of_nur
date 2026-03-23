# Phase 2 Arabic Localization Backlog

## Enhancement Options

- Run a native-speaker Arabic QA pass on the highest-traffic screens first: Home, Prayer, Qur'an, Learn, Journey, Kids, and Settings.
- Review the remaining intentionally identical strings and separate true Arabic/scriptural content from English fallback copy that still deserves manual Arabic refinement.
- Add an automated localization QA check for ICU placeholders referenced only in plural headers so metadata validation reports fewer false positives.
- Audit Arabic line length and overflow on narrow mobile layouts, especially for cards, chips, and bottom-nav labels.
- Create a small Islamic terminology lock list for Arabic so future translation passes keep terms like `القرآن`, `الصلاة`, `الذكر`, `الحديث`, `سورة`, `آية`, `الدعاء`, and `الوضوء` fully consistent.
- Add a follow-up human-edit pass for low-signal machine-translated strings to improve tone without changing structure or placeholders.
