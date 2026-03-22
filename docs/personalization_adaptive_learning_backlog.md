# Personalization + Adaptive Learning Backlog

Date: 2026-03-21

## Recommended Enhancements

- Add per-category transparency chips on the Daily Knowledge Challenge Hub once a shared localized category-label helper exists across all game types.
- Add lightweight “recently improving” and “needs reinforcement” history snapshots so the adaptive profile can show trend direction, not just current strength.
- Add adapter-level result reporting hooks for future engines so adaptive scoring can respond to each completed session immediately instead of only deriving from persisted progress snapshots.
- Add widget tests around Daily Hub adaptive messaging and confirm that personalized daily cards remain stable after app restarts.
- Add opt-in profile surfaces under Settings or Journey only if product wants users to inspect or reset learning adaptation explicitly.
- Revisit scoring weights after more seeded content exists for each category so difficulty comfort is calibrated against a larger pool.

## Safe Next Steps

- keep personalization deterministic and local-first
- avoid hidden difficulty spikes larger than a small band shift
- preserve canonical Qur'an and Hadith data selection rules while biasing only among already valid puzzles
