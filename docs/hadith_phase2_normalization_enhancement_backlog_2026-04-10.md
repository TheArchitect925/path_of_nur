# Hadith Phase 2 Normalization Enhancement Backlog

Date: 2026-04-10
Scope: Follow-up options after canonical Hadith source/book/chapter/reference normalization.

## Next likely build items
- Surface narrator, structured source citation, and standardized grade metadata on the Hadith detail page.
- Add canonical source-book and chapter browse providers once the product is ready to expose book-aware browsing.
- Migrate Qur'an graph Hadith links from legacy curriculum ids onto canonical `HadithEntry.id` plus normalized source references.
- Add structured Hadith search/filter metadata for collection, grade, narrator, tags, and hadith number once search work begins.

## Reader parity follow-ups
- Add save/share/copy actions to the Hadith detail page.
- Add a calm citation block that can show single-source and multi-source references cleanly.
- Add room for future chapter and adjacent-hadith navigation without redesigning the page shell yet.

## Data foundation follow-ups
- Decide whether multi-source references should later become first-class per-source reference objects instead of one shared display string plus normalized helpers.
- Decide whether some collection-specific references like `Book 47, Hadith 8` should later expose a richer section model when a broader corpus is added.
- Decide whether provenance should later distinguish seeded imports from manual editorial overrides at a more detailed revision level.
