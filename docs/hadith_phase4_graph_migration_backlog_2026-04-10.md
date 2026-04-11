# Hadith Phase 4 Graph Migration Backlog

Date: 2026-04-10

## Enhancement Options

- Add a small editorial mapping registry for Qur’an ↔ Hadith relationships so future additions live in one dedicated file rather than inside the graph data builder.
- Introduce a focused integrity test that checks every `QuranReference.relatedHadithIds` value resolves to a public `HadithEntry` and fails fast when future seeds drift.
- Add reverse-lookup helpers for “related Qur’an references for Hadith” on top of the now-canonical `HadithEntry.id` graph identity.
- Prepare Phase 5 relation types so future Qur’an ↔ Hadith links can distinguish `supports`, `explains`, `same_theme`, and `practice_follow_up`.
- Consider migrating Qur’an theme seed `relatedHadithIds` onto a shared curated link index once the broader cross-domain editorial graph work starts.
