# Qur'anic Verse Interaction Global Rule Backlog

1. Add a subtle selected-ayah emphasis state inside `QuranReaderPage` for deep-linked opens so the target verse remains obvious after the scroll lands.
2. Audit the remaining direct `quranReader` route calls and migrate any other structured Qur'an-reference surfaces onto `QuranReferenceLinkTile` where they still render custom verse-link UI.
3. Add widget tests for `QuranReferenceLinkTile` and `QuranReferenceChip` covering tap-to-reader behavior and long-press viewer access on the chip variant.
