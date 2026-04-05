# UI Surface Consistency Backlog — 2026-04-02

## Enhancement options

1. Extract a shared warm feature-chip helper for non-sacred chips used in Home, Salah, Learn, and settings so page code stops rebuilding pill decoration by hand.
2. Add a shared sacred panel helper for devotional headers that combine a Dense Sanctuary surface with internal spacing/divider rules.
3. Create a tiny `surface_audit.dart` lint-style script or grep checklist for `BoxDecoration` owners in `lib/features/*/presentation` so future passes can catch drift faster.
4. Consolidate Home hero sub-panels into shared wrappers and shared content colors to reduce hardcoded text color drift.
5. Consolidate Salah tracker/support chips into shared Frosted Glass pills with accent-only overrides.
6. Review `app_scaffold.dart` and bottom navigation decoration so shell chrome follows the same centralized material recipes as content cards.
7. If the Home comparison surfaces are no longer useful, archive and remove the preview-only glass comparison code in a dedicated cleanup pass.
