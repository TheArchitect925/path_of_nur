# Phase 25F Enhancement Backlog

Date: 2026-03-23

## Safe follow-up enhancements

1. Add a dedicated `QuranReflectionsPage` widget test that verifies the new Learn Notes and Journal onward actions remain present and correctly routed.
2. Decide whether Learn Notes Browse should include Qur’an reflections as first-class browse items, or stay intentionally limited to Qur’an notes plus journal entries.
3. Add delete/archive behavior to journal detail only after product approval, keeping the new `/journal/entry/:entryId` route canonical for drill-in.
4. Add a small “related writing surfaces” explainer on Learn Notes if user testing still shows confusion between saved Qur’an reflections and personal journal entries.
5. Replace the new English-fallback ARB entries from this pass with real non-English translations.
6. Consider a dedicated Journal detail route test for linked Qur’an reference tapping once a stable reader harness is available.
7. If product wants stronger cohesion later, add optional “send to journal” or “open in notes” actions from Qur’an Reflections note-edit flows without merging the underlying stores.
