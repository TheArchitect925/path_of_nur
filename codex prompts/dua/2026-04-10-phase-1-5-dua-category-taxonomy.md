# Phase 1.5 Duas QA Run - categories

Upgrade the dua dataset from single-bucket classification to a clean `primaryCategory` + `secondaryCategories` model.

Target files:
- `lib/features/learn/dua/data/dua_seed_data.dart`
- directly related dua domain/model/repository/provider files only if required by the schema migration

Constraints:
- audit first
- preserve existing app behavior as much as possible
- do not rewrite dua wording/source content in this phase unless a tiny schema-safe adjustment is absolutely required
- keep one canonical dua entry and let classification make it discoverable in multiple contexts
- avoid overengineering enum complexity if the current codebase uses string-based dataset values
- if compatibility is needed, prefer a safe adapter so the current UI does not break

Primary goal:
- introduce `primaryCategory: String`
- introduce `secondaryCategories: List<String>`
- improve retrieval correctness and discoverability without duplicating entries

Validation goals:
- all duas have a primary category
- no duplicates introduced
- existing category-based UI still works or has been safely adapted
- analyzer passes on changed Flutter files
