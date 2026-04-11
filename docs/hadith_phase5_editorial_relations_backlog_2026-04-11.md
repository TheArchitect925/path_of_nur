# Hadith Phase 5 Editorial Relations Backlog

Date: 2026-04-11
Primary area: Canonical cross-domain editorial relation model

## Enhancement options

1. Add a small, dedicated relation presentation widget that can show domain cue, relation type, and quiet editorial note without reusing the fuzzier contextual section styling.
2. Surface canonical editorial relations on the Qur’an reader side next, starting with related Hadith and related Dua where the new stable ids are already available.
3. Add reverse lookup helpers by relation type and domain pair so future Hadith search and “All” discovery can filter canonical relations without rebuilding provider logic.
4. Migrate the legacy cross-domain maps in [`learn_unified_provider.dart`](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/shared/application/learn_unified_provider.dart) onto the new relation layer once product owners confirm the intended replacement scope.
5. Add a lightweight validator that fails when seeded editorial relations reference unknown route targets, missing content ids, or non-public Hadith ids.
6. Expand the explicit seeded editorial relation set slowly with source-reviewed Hadith ↔ Dua and Hadith ↔ Learn follow-up links instead of relying on broad theme similarity.
7. Introduce optional relation-priority metadata so future reader surfaces can prefer one or two strongest editorial links before showing larger related-content lists.

## Recommended next step

Phase 6 should build the Hadith search foundation on top of:
- canonical Hadith ids
- normalized source metadata
- canonical Hadith taxonomy
- the new editorial relation layer for future connected-result surfacing
