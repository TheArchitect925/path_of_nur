# Hadith Reader Access Audit Backlog

Date: 2026-04-11

## Enhancement options

1. Add a dedicated hadith reader mode with previous/next entry controls, a compact metadata strip, and optional section collapse for meaning, lessons, reflection, and related content.
2. Convert theme and collection detail surfaces from eager `Column` rendering to lazy list/sliver rendering with sticky filter chips and sort options.
3. Split large theme/collection surfaces into overview plus grouped sublists by source, subcategory, or chapter instead of one long flat card list.
4. Add route-level entry context like `from=theme`, `from=collection`, or `from=sourceChapter` so the reader can offer a relevant “continue browsing” rail.
5. Add per-surface result counts, sort controls, and “jump to source/category” chips on theme and collection pages before opening the full reader.
6. Consider a single canonical browse owner for large hadith corpora that combines source, category, subcategory, and grade filters instead of separating discovery across theme, collection, and source pages.
7. Add focused tests around large-list performance and browse-state continuity once lazy rendering or grouped navigation is introduced.
