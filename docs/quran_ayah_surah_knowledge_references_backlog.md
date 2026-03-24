# Qur'an Ayah + Surah Knowledge References Backlog

## Safe follow-up options

- Add a small localized category cue on ayah chips so users can distinguish Hadith, Character, Signs, Prophets, and Paths without adding another card layer.
- Expand curated `quran_reference_graph_data.dart` coverage for more ayahs that already have strong owner surfaces, especially where current coverage is thin but clearly mappable.
- Broaden `seeded_quran_surah_insights_data.dart` beyond the current starter surahs with the same curated, route-backed approach.
- Audit `QuranReferenceViewer` related journey/path copy so it reads more clearly as Qur'an learning paths rather than generic journeys.
- Add a focused widget test for the reader’s ayah card to ensure low-signal keyword-only chips do not return.
- Consider a long-press or bottom-sheet entry from ayah chips when users need one more line of context before leaving the reader.

## Out of scope for this pass

- Full mass auto-linking across all ayahs
- Rebuilding the Qur'an reader layout
- Adding a new search system
- Expanding into journaling or note-linked enrichment flows
