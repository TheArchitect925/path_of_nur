# Hadith Reader + Connections Audit Enhancement Backlog

Date: 2026-04-10
Scope: Audit follow-up options for Hadith reader parity, canonical topic ownership, and Qur'an/Hadith/Dua/Learn connections.

## High Priority
- Canonicalize Qur'an-to-Hadith graph links onto `HadithEntry.id` instead of legacy `hadith_curriculum` lesson ids.
- Add normalized Hadith source fields for canonical book, chapter, and hadith reference/number.
- Add a canonical Hadith reader metadata block with narrator, grade, source URL, and future collection/chapter navigation slots.
- Decide one canonical Hadith concept system for public discovery: source book structure + app themes + curated tags, while demoting overlapping legacy lesson taxonomies.

## Medium Priority
- Add explicit Hadith-to-Dua connection fields or a shared editorial link bundle model.
- Extend the shared related-content system to support Dua nodes if cross-domain recommendations should include duas.
- Add a canonical relation-type vocabulary for cross-domain links such as `explains`, `reinforces`, `related_practice`, `related_dua`, and `same_theme`.
- Prepare a Hadith search metadata layer that indexes translation, Arabic matn, narrator, grade, source collection, and tags.

## Later / Nice to Have
- Reader parity polish with save/share/copy actions and compact related-content previews.
- Hadith collection landing pages for trusted source books after chapter metadata exists.
- Cross-domain “All” discovery mode once canonical ids and relation types are stable.
- In-reader related Qur'an and Dua modules once the graph is no longer split across legacy ids.
