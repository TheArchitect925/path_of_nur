# Phase 8 — Add Current Surah vs Whole Qur'an Toggle to In-Reader Search

Primary objective:
- extend the Qur'an reader search sheet so users can search either the current surah or the whole Qur'an without leaving the reader flow

Requirements:
- keep one canonical Qur'an search owner
- keep one normalization path
- keep one exact-ayah navigation path
- do not build a parallel global search engine just for the reader
- preserve the recent reader-search sheet stability fixes

Implementation notes:
- add a compact scope selector with `Current Surah` and `Whole Qur'an`
- preserve current-surah highlighting and next/previous behavior
- in whole-Qur'an mode, reuse the canonical repository-backed search path
- show compact whole-Qur'an results inside the bounded sheet
- preserve query and match-field context when jumping from the reader sheet into another ayah
