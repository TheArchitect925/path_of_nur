# Dua Phase 1.75 Orchestration Metadata Enhancements

Date: 2026-04-10

Suggested next steps after metadata groundwork:

1. Build a read-only dua orchestration selector service that scores candidates from the new metadata without changing the existing dua hub UI.
2. Add small dataset tests for metadata coverage and integrity:
   - every item has `surfaceEligibility`
   - `priorityScore` stays within `1..10`
   - no context list contains duplicates
3. Review the `situationContexts` coverage, which is intentionally broad in this pass, and trim any entries that feel too generic once real orchestration consumers are introduced.
4. Add a dedicated metadata override table for the handful of nuanced Qur'anic duas that could surface differently in widgets versus in-app recommendation cards.
5. Revisit the `watch` and `home_widget` eligibility once actual compact-surface copy limits are known.
6. Consider adding a `concisePrompt` or `widgetSnippet` field later for compact surfaces instead of overloading full translations.
7. Align future dua orchestration with Ramadan, weather, and prayer-state app services so runtime selectors can use these metadata fields cleanly.
