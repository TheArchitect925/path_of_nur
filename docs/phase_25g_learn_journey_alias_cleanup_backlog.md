# Phase 25G Enhancement Backlog

Date: 2026-03-23

## Safe follow-up enhancements

1. Audit remaining `learnLegacy` references in `LearningJourneyRegistry`, lesson metadata, and hidden Learn catalog items so compatibility-only legacy routes stop leaking into any future surfaced discovery.
2. Decide whether `/learn/legacy` should later redirect to `/learn`, resolve to a contained state, or remain reachable only as an archived compatibility surface.
3. Add one focused widget test for `GrowthHabitsPage` shortcut actions so canonical `growthStatisticsPage` remains the visible destination instead of drifting back to the tracking alias.
4. Decide whether reminder payload normalization should eventually rewrite stored legacy Journey/Growth routes to canonical `/journey/*` values at ingest time instead of preserving legacy strings after decode.
5. Audit any remaining assistant/profile/home quick actions or menus for compatibility route names and switch them to canonical Journey/Learn targets where safe.
